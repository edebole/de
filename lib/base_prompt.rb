class BasePrompt
  class Error < StandardError; end
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment

  def send_request
    token = ENV.fetch("OPENAI_ACCESS_TOKEN") { raise "Missing required environment variable: OPENAI_ACCESS_TOKEN" }
    client = OpenAI::Client.new(access_token: token)
    client.chat(parameters: chat_completion_request)
  end

  def chat
    send_request.dig("choices", 0, "message", "content")
  end

  def chat_completion_request
    build_request_body(:model, :messages, :temperature, :response_format)
  end

  def configuration
    raise NotImplementedError, "Subclasses must implement #configuration"
  end

  def client
    token = ENV.fetch("OPENAI_ACCESS_TOKEN") { raise "Missing required environment variable: OPENAI_ACCESS_TOKEN" }
    @client ||= OpenAI::Client.new(access_token: token)
  end

  private

  def build_request_body(*keys)
    body = configuration.slice(*keys)
    if keys.include?(:body)
      extra = configuration.slice(:method, :url, :custom_id)
      { **extra, body: body }
    else
      body
    end
  end
end
