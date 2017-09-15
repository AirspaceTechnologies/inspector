#!/usr/bin/env ruby

require_relative 'boot'

spec_results = File.read(ARGV[0])
result_json = JSON.parse(spec_results)
failures = result_json['examples'].select { |example| example['status'] == 'failed' }
failures.each { |failure| SpecFailure.save_from_example(failure) }
flakes = SpecFailure.where('sightings > ?', ENV['MAX_SIGHTINGS']).to_a
flakes.each { |flake| Slack.notify!(flake.to_s) }