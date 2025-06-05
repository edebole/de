class SiteScraper < BaseScraper
  MAIN_SELECTOR = "#content-wrapper".freeze
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36".freeze
  TIMEOUT = 120_000

  def run(browser)
    urls.each do |url|
      context = browser.new_context(userAgent: USER_AGENT)
      page = context.new_page
      log "Go to page #{url}"
      page.goto(url, waitUntil: "domcontentloaded", timeout: TIMEOUT)

      log "Waiting for selector #{MAIN_SELECTOR}"
      page.wait_for_selector(MAIN_SELECTOR, timeout: TIMEOUT)
      log "Processing data..."

      data = page.locator(MAIN_SELECTOR)&.text_content

      log "Sending data to OpenAI..."
      prompt = ExtractionPrompt.new(content: data)
      ai_extract_data_result = prompt.chat

      log "Parsing response..."
      ai_response = JSON.parse(ai_extract_data_result)

      log "Extracted data:\n#{JSON.pretty_generate(ai_response)}"

      log "Closing page #{url}..."

      yield ai_response if block_given?

      sleep(0.5 + rand(0.5) + rand(0.5))
    rescue => e
      log "Failed to process #{url}: #{e.message}"
      next
    ensure
      page.close
    end
  end

  def urls
    path = 'urls.csv'
    File.readlines(path, chomp: true)
  end
end

