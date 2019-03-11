# frozen_string_literal: true

# Module for the Watson APIs
module IBMWatson
  require_relative("./ibm_watson/personality_insights_v3.rb")
  require_relative("./ibm_watson/tone_analyzer_v3.rb")
  require_relative("./ibm_watson/assistant_v1.rb")
  require_relative("./ibm_watson/assistant_v2.rb")
  require_relative("./ibm_watson/text_to_speech_v1.rb")
  require_relative("./ibm_watson/discovery_v1.rb")
  require_relative("./ibm_watson/natural_language_understanding_v1.rb")
  require_relative("./ibm_watson/speech_to_text_v1.rb")
  require_relative("./ibm_watson/visual_recognition_v3.rb")
  require_relative("./ibm_watson/natural_language_classifier_v1.rb")
  require_relative("./ibm_watson/language_translator_v3.rb")
  require_relative("./ibm_watson/compare_comply_v1.rb")
  require_relative("./ibm_watson/websocket/recognize_callback.rb")
  require_relative("./ibm_watson/common.rb")
end
