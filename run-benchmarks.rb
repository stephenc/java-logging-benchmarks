#!/usr/bin/env ruby

require 'find'
require 'fileutils'

processor_count = case RbConfig::CONFIG['host_os']
                    when /darwin9/
                      `hwprefs cpu_count`.to_i
                    when /darwin/
                      ((`which hwprefs` != '') ? `hwprefs thread_count` : `sysctl -n hw.ncpu`).to_i
                    when /linux/
                      `cat /proc/cpuinfo | grep processor | wc -l`.to_i
                    when /freebsd/
                      `sysctl -n hw.ncpu`.to_i
                    when /mswin|mingw/
                      require 'win32ole'
                      wmi = WIN32OLE.connect("winmgmts://")
                      cpu = wmi.ExecQuery("select NumberOfCores from Win32_Processor") # TODO count hyper-threaded in this
                      cpu.to_enum.first.NumberOfCores
                  end

# we want powers of two up to the number of cores on the system
threads = []
i = 1
while i <= processor_count do
  threads << i
  i = i * 2
end

# if there are more than 8 cores, get some additional data points
i = 12
while i <= processor_count do
  threads << i
  i = i * 2
end
threads << processor_count
threads.sort!.uniq!

benchmarks = Find.find(File.dirname(__FILE__)).select { |p| /.*\/benchmarks.jar$/ =~ p }
Find.find(File.dirname(__FILE__)).select { |p| /java[0-9]*[.]log([.][0-9]*)?/ =~ p }.each { |p| File.delete(p) }

threads.each do |thread_count|
  FileUtils.mkpath 'results'
  benchmarks.each do |benchmark|
    type = benchmark.gsub(/.*\/([^\/]*)\/[^\/]*\/target\/benchmarks.jar$/, '\1')
    framework = benchmark.gsub(/.*\/[^\/]*\/([^\/]*)\/target\/benchmarks.jar$/, '\1')
    puts "Starting " + framework + " with format " + type + " and " + thread_count.to_s+ " threads..."
    basename = 'results/'+framework+'_'+type+'_t'+thread_count.to_s
    system 'java -jar "'+benchmark+'" -bm sample -tu ns -o '+basename+'.sample.txt -rf csv -rff '+basename+'.sample.csv -t ' + thread_count.to_s + ' ' + ARGV.join(" ")
    Find.find(File.dirname(__FILE__)).select { |p| /java[0-9]*[.]log([.][0-9]*)?/ =~ p }.each { |p| File.delete(p) }
    File.readlines(basename + '.sample.csv').drop(1).each { |l| puts "    " + l }
    system 'java -jar "'+benchmark+'" -bm thrpt -o '+basename+'.thrpt.txt -rf csv -rff '+basename+'.thrpt.csv -t ' + thread_count.to_s + ' ' + ARGV.join(" ")
    Find.find(File.dirname(__FILE__)).select { |p| /java[0-9]*[.]log([.][0-9]*)?/ =~ p }.each { |p| File.delete(p) }
    File.readlines(basename + '.thrpt.csv').drop(1).each { |l| puts "    " + l }
    puts
  end

end

puts "Summary"
puts "======="
puts
threads.each do |thread_count|
  benchmarks.each do |benchmark|
  type = benchmark.gsub(/.*\/([^\/]*)\/[^\/]*\/target\/benchmarks.jar$/, '\1')
  framework = benchmark.gsub(/.*\/[^\/]*\/([^\/]*)\/target\/benchmarks.jar$/, '\1')
  File.readlines('results/' + framework + '_' + type + '_t'+thread_count.to_s+'.sample.csv').drop(1).each { |l| puts l }
  end
end
threads.each do |thread_count|
  benchmarks.each do |benchmark|
  type = benchmark.gsub(/.*\/([^\/]*)\/[^\/]*\/target\/benchmarks.jar$/, '\1')
  framework = benchmark.gsub(/.*\/[^\/]*\/([^\/]*)\/target\/benchmarks.jar$/, '\1')
  File.readlines('results/' + framework + '_' + type + '_t'+thread_count.to_s+'.thrpt.csv').drop(1).each { |l| puts l }
  end
end

