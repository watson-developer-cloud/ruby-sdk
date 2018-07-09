# frozen_string_literal: true

require("ibm_watson/speech_to_text_v1")
require("ibm_watson/recognize_callback")

# If using IAM
speech_to_text = IBMWatson::SpeechToTextV1.new(
  iam_api_key: "IAM API KEY"
)

# If you have username & password in your credentials use:
# speech_to_text = IBMWatson::SpeechToTextV1.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD"
# )

p speech_to_text.list_models.result

p speech_to_text.get_model(model_id: "en-US_BroadbandModel").result

File.open(Dir.getwd + "/resources/speech.wav") do |audio_file|
  recognition = speech_to_text.recognize(
    audio: audio_file,
    content_type: "audio/wav",
    timestamps: true,
    word_confidence: true
  ).result
  p recognition
end

# Example using websockets
class MyRecognizeCallback < IBMWatson::RecognizeCallback
  def initialize
    super
  end

  def on_transcription(transcript:)
    puts transcript
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
  speech_to_text.recognize_with_websocket(
    audio: audio_file,
    recognize_callback: mycallback
  ).start
end

# Example using websockets and a pseudo audio stream
# The websocket method has the ability to accept audio in chunks
# This example uses chunks of an audio file to simulate an audio stream, such as a microphone
speech = speech_to_text.recognize_with_websocket(
  chunk_data: true, # Tell the websocket object that audio will be given in chunks
  recognize_callback: mycallback,
  interim_results: true,
  inactivity_timeout: 3
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
