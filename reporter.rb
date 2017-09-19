#!/usr/bin/env ruby

require_relative 'boot'

report = Report.new
report.write!
report.close
