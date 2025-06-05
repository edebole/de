class ExtractionPrompt < BasePrompt
  MAX_TOKENS = 1000.freeze

  attribute :content

  def configuration
    {
      method: "POST",
      url: "/v1/chat/completions",
      model: "gpt-4.1-nano",
      temperature: 0.2,
      messages: [
        system_message,
        user_message(content)
      ]
    }
  end

  def user_message(content)
    {role: "user", content: content}
  end

  def system_message
    msg = <<~MSG
      You are an expert data extractor. From the provided text, identify and extract information about the latest ruby release using the following strict JSON structure:
      ```json
      {
        version: "number version",
        release_date: ""
      }
      ```
      Extract values exactly as they appear.
      If a value is not present in the text, leave it as an empty string ("") or empty array ([]) as appropriate.
      Do not make up or infer any information. Only use data explicitly mentioned in the source text.
      Your output must be a valid JSON object only — no explanations or comments.
    MSG
    {role: "system", content: msg}
  end
end
