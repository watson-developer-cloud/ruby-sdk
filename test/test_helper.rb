# frozen_string_literal: true

require("simplecov")
require("codecov")

if ENV["COVERAGE"]
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV["CI"]
  unless SimpleCov.running
    SimpleCov.start do
      add_filter "/test/"
      add_filter do |src_file|
        File.basename(src_file.filename) == "version.rb"
      end

      add_group "lib", "/lib/"
      command_name "Minitest"
    end
  end
end

require("minitest/autorun")
require_relative("./../lib/watson_apis.rb")
