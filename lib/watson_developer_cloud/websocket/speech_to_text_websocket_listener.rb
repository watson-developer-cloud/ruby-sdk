# frozen_string_literal: true

require("eventmachine")
require("faye/websocket")
require("json")

ONE_KB = 1024
TIMEOUT_PREFIX = "No speech detected for"
CLOSE_SIGNAL = 1000
TEN_MILLISECONDS = 0.01

# Class for interacting with the WebSocket API
class WebSocketClient
  def initialize(audio: nil, chunk_data:, options:, recognize_callback:, url:, headers:)
    @audio = audio
    @options = options
    @callback = recognize_callback
    @bytes_sent = 0
    @headers = headers
    @is_listening = false
    @url = url
    @timer = nil
    @chunk_data = chunk_data
    @mic_running = false
    @data_size = audio.nil? ? 0 : @audio.size
    @queue = Queue.new
  end

  def start
    on_open = lambda do |_event|
      @client.send(build_start_message(options: @options))
      @mic_running = true if @chunk_data
      send_audio(data: @audio)
    end

    on_message = lambda do |event|
      json_object = JSON.parse(event.data)
      if json_object.key?("error")
        error = json_object["error"]
        if error.start_with?(TIMEOUT_PREFIX)
          @callback.on_inactivity_timeout(error: error)
        else
          @callback.on_error(error: error)
        end
      elsif json_object.key?("state")
        if !@is_listening
          @is_listening = true
        else
          @client.send(build_close_message)
          @callback.on_transcription_complete
          @client.close(CLOSE_SIGNAL)
        end
      elsif json_object.key?("results") || json_object.key?("speaker_labels")
        hypothesis = ""
        unless json_object["results"].nil?
          hypothesis = json_object.dig("results", 0, "alternatives", 0, "transcript")
          b_final = json_object.dig("results", 0, "final")
          transcripts = extract_transcripts(alternatives: json_object.dig("results", 0, "alternatives"))

          @callback.on_hypothesis(hypothesis: hypothesis) if b_final

          @callback.on_transcription(transcript: transcripts)
          @callback.on_data(data: json_object)
        end
      end
    end

    on_close = lambda do |_event|
      @client = nil
      EM.stop_event_loop
      Thread.exit
    end

    on_error = lambda do |event|
      p event.message
    end

    EM.run do
      @client = Faye::WebSocket::Client.new(@url, nil, headers: @headers)
      @client.onclose = on_close
      @client.onerror = on_error
      @client.onmessage = on_message
      @client.onopen = on_open
      @client.add_listener(Faye::WebSocket::API::Event.create("open"))
      @client.add_listener(Faye::WebSocket::API::Event.create("message"))
      @client.add_listener(Faye::WebSocket::API::Event.create("close"))
    end
  end

  def on_connect(_response)
    @callback.on_connected
  end

  def build_start_message(options:)
    options["action"] = "start"
    options.to_json
  end

  def build_close_message
    { "action" => "close" }.to_json
  end

  def send_audio(data:)
    if @chunk_data
      if @mic_running
        @queue.empty? ? send_chunk(chunk: nil, final: false) : send_chunk(chunk: @queue.pop(true), final: false)
        @timer = EventMachine::Timer.new(TEN_MILLISECONDS) do
          send_audio(data: data)
        end
      else
        if @queue.length == 1 && !@mic_running
          send_chunk(chunk: @queue.pop(true), final: true)
          @queue.close
          @timer.cancel if @timer.respond_to?(:cancel)
          return
        end
        send_chunk(chunk: @queue.pop(true), final: false) unless @queue.empty?
        @timer = EventMachine::Timer.new(TEN_MILLISECONDS) { send_audio(data: data) } unless @queue.empty? && !@mic_running
      end
    else
      if @bytes_sent + ONE_KB >= @data_size
        if @data_size > @bytes_sent
          send_chunk(chunk: data.read(ONE_KB), final: true)
          @timer.cancel if @timer.respond_to?(:cancel)
          return
        end
        @timer.cancel if @timer.respond_to?(:cancel)
      end
      send_chunk(chunk: data.read(ONE_KB), final: false)
      @timer = EventMachine::Timer.new(TEN_MILLISECONDS) do
        send_audio(data: data)
      end
    end
  end

  def extract_transcripts(alternatives:)
    transcripts = []
    unless alternatives.nil?
      alternatives.each do |alternative|
        transcript = {}
        transcript["confidence"] = alternative["confidence"] if alternative.key?("confidence")
        transcript["transcript"] = alternative["transcript"]
        transcripts << transcript
      end
    end
    transcripts
  end

  def add_audio_chunk(chunk:)
    @data_size += chunk.size
    @queue << chunk
  end

  def stop_audio
    @mic_running = false
  end

  private

  def send_chunk(chunk:, final: false)
    return if chunk.nil?
    @bytes_sent += chunk.size
    @client.send(chunk.bytes)
    @client.send({ "action" => "stop" }.to_json) if final
    @timer.cancel if @timer.respond_to?(:cancel) && final
  end
end
