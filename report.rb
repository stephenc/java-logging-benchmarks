#!/usr/bin/env ruby

require 'find'
require 'fileutils'

benchmarks = Find.find(File.dirname(__FILE__)).select { |p| /.*\/results\/.*.txt$/ =~ p }

puts "Summary"
puts "======="
puts
benchmarks.each do |benchmark|
  threads = benchmark.gsub(/.*\/([^\/]*)\/results\/[^\/]*.csv/, '\1')
  File.readlines(benchmark).drop(1).each { |l| puts "t=" + threads + " " + l }
end
