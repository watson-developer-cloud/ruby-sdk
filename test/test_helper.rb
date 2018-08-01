# frozen_string_literal: true

require("simplecov")
require("codecov")
require("minitest/reporters")

if ENV["COVERAGE"]
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::HtmlReporter.new] if ENV["CI"].nil?
  Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new) if ENV["CI"]
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV["CI"]
  unless SimpleCov.running
    SimpleCov.start do
      add_filter "/test/"
      add_filter do |src_file|
        File.basename(src_file.filename) == "version.rb"
      end

      command_name "Minitest"
    end
  end
end

require("minitest/autorun")
require_relative("./../lib/ibm_watson.rb")
