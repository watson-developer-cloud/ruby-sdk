# frozen_string_literal: true

task default: %w[speech_to_text]

desc "Run patches for speech to text"
task :speech_to_text, [:path] do |_t, args|
  Rake::Task["speech_to_text:patch_recognize_using_websocket"].invoke(args[:path])
end

namespace :speech_to_text do
  desc "Patch the recognize_using_websocket function"
  task :patch_recognize_using_websocket, [:path] do |_t, args|
    temp = File.read(args[:path] + "/speech_to_text_v1.rb")
    recognize_using_websocket = File.read(Dir.getwd + "/speech_to_text_v1/recognize_using_websocket.rb")
    temp = temp.sub(/(^\s*?##\n\s*?# @!method recognize\(.*?\n\s*?end\n($|\s*?#*?))/m) { |match| match + recognize_using_websocket }
    unless temp.nil?
      puts "Patch the speech to text - recognize_using_websocket function"
      File.open(args[:path] + "/speech_to_text_v1.rb", "w") do |file|
        file.write(temp)
      end
    end
  end
end
