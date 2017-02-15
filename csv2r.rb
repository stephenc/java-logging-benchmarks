#!/usr/bin/env ruby

require 'find'
require 'fileutils'


benchNames = {
    "Benchmark.javautil" => "Java Utils",
    "Benchmark.log4j___" => "Log4J",
    "Benchmark.log4ju__" => "Log4J: unbuffered",
    "Benchmark.log4jsyn" => "Log4J: synchronous",
    "Benchmark.log4jlmx" => "Log4J: LMAX",
    "Benchmark.logback_" => "Logback",
    "Benchmark.logbacku" => "Logback: unbuffered",
    "Benchmark.logbacka" => "Logback: asynchronous",
    "Benchmark.strawman" => "Strawman",
    "Benchmark.nothing_" => "Strawman: no-op",
    "Benchmark.vollog__" => "Strawman: volatile",
    "Benchmark.finallog" => "Strawman: final",
    "Benchmark.staticf_" => "Strawman: static final",
    "Benchmark.cachelog" => "Strawman: cacheline pad",
    "Benchmark.vcachlog" => "Strawman: volatile cacheline pad",
    "Benchmark.field___" => "Strawman: field (shared instance ref)",
    "Benchmark.field2__" => "Strawman: field (new instance ref)",
    "Aflush_rk.asynclog" => "Strawman: async+flush",
    "Asyncmark.asynclog" => "Strawman: async",
    "CharAt_rk.strawman" => "Strawman: charAt",
    "Flush__rk.synclog_" => "Strawman: flush",
    "NoBufmark.nobufman" => "Strawman: unbuffered"
}

benchPriority = [
    "Benchmark.javautil",
    "Benchmark.log4j___",
    "Benchmark.logback_",
    "Benchmark.strawman",
    "Benchmark.log4ju__",
    "Benchmark.log4jsyn",
    "Benchmark.log4jlmx",
    "Benchmark.logbacks",
    "Benchmark.logbacku",
    "Benchmark.nothing_",
    "Benchmark.vollog__",
    "Benchmark.finallog",
    "Benchmark.staticf_",
    "Benchmark.cachelog",
    "Benchmark.vcachlog",
    "Benchmark.field___",
    "Benchmark.field2__",
    "Aflush_rk.asynclog",
    "Asyncmark.asynclog",
    "CharAt_rk.strawman",
    "Flush__rk.synclog_",
    "NoBufmark.nobufman"
]

threadValues = []
results = {}
benchmarks = Find.find(File.dirname(__FILE__)).select { |p| /[.]\/results\/.*_t[0-9][0-9]*[.]sample[.]csv$/ =~ p }
benchmarks.each do |benchmark|
  threads = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]sample[.]csv$/, '\3')
  framework = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]sample[.]csv$/, '\1')
  format = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]sample[.]csv$/, '\2')
  File.readlines(benchmark).drop(1).each do |l|
    unless /·p"/.match(l)
      result = results[format] || {}
      parse = /"([^"]*)","[^"]*",([0-9]*),([0-9.]*),([0-9.]*),([0-9.]*|NaN),"[^"]*"/.match(l)
      bench = parse[1].sub(/:.*$/, '')
      bench = bench.sub(/me\.justpitch\.loggingbenchmarks\.Logging/, '')
      bench = bench.sub(/Log_........Style/, '')
      benchResult = result[bench] || {}
      benchResult[parse[2]] = parse[4]
      result[bench] = benchResult
      results[format] = result
      threadValues = threadValues << parse[2] unless threadValues.include?(parse[2])
      benchPriority << bench unless benchPriority.include?(bench)
    end
  end
end
results.each do |format, result|
  File.open(format+".sample.dat", 'w') do |file|
    file.write('"Threads","Benchmark","Time"' + "\n")
    benchPriority.each do |k|
      v = result[k]
      if v
        threadValues.each do |thread|
          file.write(thread)
          file.write(',"')
          file.write(benchNames[k] || k)
          file.write('",')
          file.write(v[thread]) if v[thread]
          file.write("\n")
        end
      end
    end
  end
end
threadValues = []
results = {}
benchmarks = Find.find(File.dirname(__FILE__)).select { |p| /[.]\/results\/.*_t[0-9][0-9]*[.]thrpt[.]csv$/ =~ p }
benchmarks.each do |benchmark|
  threads = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]thrpt[.]csv$/, '\3')
  framework = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]thrpt[.]csv$/, '\1')
  format = benchmark.gsub(/[.]\/results\/([^\/_][^\/_]*)_([^\/][^\/]*)_t([0-9][0-9]*)[.]thrpt[.]csv$/, '\2')

  File.readlines(benchmark).drop(1).each do |l|
    result = results[format] || {}
    parse = /"([^"]*)","[^"]*",([0-9]*),([0-9.]*),([0-9.]*),([0-9.]*|NaN),"[^"]*"/.match(l)
    bench = parse[1].sub(/:.*$/, '')
    bench = bench.sub(/me\.justpitch\.loggingbenchmarks\.Logging/, '')
    bench = bench.sub(/Log_........Style/, '')
    benchResult = result[bench] || {}
    benchResult[parse[2]] = parse[4]
    result[bench] = benchResult
    results[format] = result
    threadValues = threadValues << parse[2] unless threadValues.include?(parse[2])
    benchPriority << bench unless benchPriority.include?(bench)
  end
end
results.each do |format, result|
  File.open(format+".thrpt.dat", 'w') do |file|
    file.write('"Threads","Benchmark","Score"' + "\n")
    benchPriority.each do |k|
      v = result[k]
      if v
        threadValues.each do |thread|
          file.write(thread)
          file.write(',"')
          file.write(benchNames[k] || k)
          file.write('",')
          file.write(v[thread]) if v[thread]
          file.write("\n")
        end
      end
    end
  end
end
