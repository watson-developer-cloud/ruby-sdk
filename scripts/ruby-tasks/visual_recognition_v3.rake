# frozen_string_literal: true

task default: %w[visual_recognition]

desc "Run patches for visual recognition"
task :visual_recognition, [:path] do |_t, args|
  Rake::Task["visual_recognition:patch_create_classifier"].invoke(args[:path])
  Rake::Task["visual_recognition:patch_update_classifier"].invoke(args[:path])
end

namespace :visual_recognition do
  desc "Patch the create_classifier function"
  task :patch_create_classifier, [:path] do |_t, args|
    temp = File.read(args[:path] + "/visual_recognition_v3.rb")
    create_classifier = File.read(Dir.getwd + "/visual_recognition_v3/create_classifier.rb")
    temp = temp.sub(/(^\s*?##\n\s*?# @!method create_classifier\(.*?\n\s*?end\n($|#))/m, create_classifier)
    unless temp.nil?
      puts "Patch the visual recognition3 - create_classifier function"
      File.open(args[:path] + "/visual_recognition_v3.rb", "w") do |file|
        file.write(temp)
      end
    end
  end

  desc "Patch the update_classifier function"
  task :patch_update_classifier, [:path] do |_t, args|
    temp = File.read(args[:path] + "/visual_recognition_v3.rb")
    update_classifier = File.read(Dir.getwd + "/visual_recognition_v3/update_classifier.rb")
    temp = temp.sub(/(^\s*?##\n\s*?# @!method update_classifier\(.*?\n\s*?end\n($|#))/m, update_classifier)
    unless temp.nil?
      puts "Patch the visual recognition3 - update_classifier function"
      File.open(args[:path] + "/visual_recognition_v3.rb", "w") do |file|
        file.write(temp)
      end
    end
  end
end
