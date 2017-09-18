#!/usr/bin/env ruby

require_relative 'boot'

spec_results = File.read(ARGV[0])
result_json = JSON.parse(spec_results)
failures = result_json['examples'].select { |example| example['status'] == 'failed' }
spec_run = SpecRun.create!
failures.each { |failure| SpecFailure.create_from_example!(failure, spec_run) }
