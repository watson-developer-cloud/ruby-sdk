require("watson_apis/speech_to_text_v1")
require("watson_apis/recognize_callback")

speech_to_text = WatsonAPIs::SpeechToTextV1.new(
  # username: "YOUR SERVICE USERNAME",
  # password: "YOUR SERVICE PASSWORD"
  iam_api_key: "IAM API KEY"
)

p speech_to_text.list_models.body

p speech_to_text.get_model(model_id: "en-US_BroadbandModel").body

File.open(Dir.getwd + "/resources/speech.wav") do |audio_file|
  recognition = speech_to_text.recognize(
    audio: audio_file,
    content_type: "audio/wav",
    timestamps: true,
    word_confidence: true
  ).body
  p recognition
end

# Example using websockets
class MyRecognizeCallback < WatsonAPIs::RecognizeCallback
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
