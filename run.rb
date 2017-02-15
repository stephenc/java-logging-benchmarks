#!/usr/bin/env ruby

require 'find'
require 'fileutils'

benchmarks = Find.find(File.dirname(__FILE__)).select { |p| /.*\/benchmarks.jar$/ =~ p }

FileUtils.mkpath 'results'
FileUtils.mkpath 'work'
benchmarks.each do |benchmark|
  type = benchmark.gsub(/.*\/([^\/]*)\/[^\/]*\/target\/benchmarks.jar$/, '\1')
  framework = benchmark.gsub(/.*\/[^\/]*\/([^\/]*)\/target\/benchmarks.jar$/, '\1')
  puts "Starting " + framework + " with format " + type + "..."
  system 'java -jar "'+benchmark+'" -bm sample -tu ns -o results/'+framework+'_'+type+'.txt -rf csv -rff results/' + framework + "_" + type + ".csv " + ARGV.join(" ")
  File.readlines('results/' + framework + '_' + type + '.csv').drop(1).each { |l| puts "    " + l }
  puts
end

puts "Summary"
puts "======="
puts
benchmarks.each do |benchmark|
  type = benchmark.gsub(/.*\/([^\/]*)\/[^\/]*\/target\/benchmarks.jar$/, '\1')
  framework = benchmark.gsub(/.*\/[^\/]*\/([^\/]*)\/target\/benchmarks.jar$/, '\1')
  File.readlines('results/' + framework + '_' + type + '.csv').drop(1).each { |l| puts l }
end
