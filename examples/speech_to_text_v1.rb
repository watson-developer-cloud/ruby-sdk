# frozen_string_literal: true

require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

speech_to_text = IBMWatson::SpeechToTextV1.new(
  authenticator: authenticator
)
speech_to_text.service_url = "{service_url}"

puts JSON.pretty_generate(speech_to_text.list_models.result)

puts JSON.pretty_generate(speech_to_text.get_model(model_id: "en-US_BroadbandModel").result)

File.open(Dir.getwd + "/resources/speech.wav") do |audio_file|
  recognition = speech_to_text.recognize(
    audio: audio_file,
    content_type: "audio/wav",
    timestamps: true,
    word_confidence: true
  ).result
  puts JSON.pretty_generate(recognition)
end

# Example using websockets
class MyRecognizeCallback < IBMWatson::RecognizeCallback
  def initialize
    super
  end

  def on_transcription(transcript:)
    puts JSON.pretty_generate(transcript)
  end

  def on_connected
    puts "Connection was successful"
  end

  def on_error(error:)
    puts "Error received: #{error}"
  end

  def on_inactivity_timeout(error:)
    puts "Inactivity timeout: #{error}"
  end

  def on_listening
    puts "Service is listening"
  end

  def on_transcription_complete
    puts "Transcription completed"
  end

  def on_hypothesis(hypothesis:)
    puts hypothesis.to_s
  end

  def on_data(data:)
    puts data.to_s
  end
end

mycallback = MyRecognizeCallback.new
File.open(Dir.getwd + "/resources/speech.wav") do |audio_file|
  speech_to_text.recognize_using_websocket(
    audio: audio_file,
    recognize_callback: mycallback,
    content_type: "audio/wav"
  ).start
end

# Example using websockets and a pseudo audio stream
# The websocket method has the ability to accept audio in chunks
# This example uses chunks of an audio file to simulate an audio stream, such as a microphone
speech = speech_to_text.recognize_using_websocket(
  chunk_data: true, # Tell the websocket object that audio will be given in chunks
  recognize_callback: mycallback,
  interim_results: true,
  inactivity_timeout: 3,
  content_type: "audio/wav"
)
audio_file = File.open(Dir.getwd + "/resources/speech.wav")
Thread.new do
  until audio_file.eof?
    chunk = audio_file.read(1024)
    speech.add_audio_chunk(chunk: chunk)
  end
  sleep(1)
  speech.stop_audio # Tell the websocket object that no more audio will be added
end
thr = Thread.new { speech.start }
thr.join

# Example using websockets using multiple threads for two audio files
# Make sure you create two wrappers of service and then start the threads
speech = speech_to_text.recognize_using_websocket(
  audio: File.open(Dir.getwd + "/resources/speech.wav"),
  recognize_callback: MyRecognizeCallback.new,
  interim_results: true,
  timestamps: true,
  max_alternatives: 2,
  word_alternatives_threshold: 0.5,
  content_type: "audio/wav"
)

speech_with_pause = speech_to_text.recognize_using_websocket(
  audio: File.open(Dir.getwd + "/resources/sound-with-pause.wav"),
  recognize_callback: MyRecognizeCallback.new,
  interim_results: true,
  timestamps: true,
  max_alternatives: 2,
  word_alternatives_threshold: 0.5,
  content_type: "audio/wav"
)

main_thread = Thread.new { speech.start }
another_thread = Thread.new { speech_with_pause.start }

main_thread.join
another_thread.join
