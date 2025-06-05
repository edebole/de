class BaseScraper
  PLAYWRIGHT_BIN = "./node_modules/.bin/playwright".freeze
  attr_reader :output_path

  def initialize(output_path: "output.jsonl")
    @output_path = output_path
  end

  def export_to_json!
    Playwright.create(playwright_cli_executable_path: PLAYWRIGHT_BIN) do |pw|
      pw.chromium.launch(headless: true) do |browser|
        File.open(output_path, "a") do |file|
          run(browser) do |data|
            file.puts(data.to_json) if data.present?
          end
        end
        browser.close 
      end
    end
  end

  def run(browser)
    raise NotImplementedError, "Subclasses must implement `extract_and_process`"
  end

  def urls
    raise NotImplementedError, "Subclasses must implement `urls`"
  end
end
