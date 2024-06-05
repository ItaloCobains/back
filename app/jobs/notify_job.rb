class NotifyJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    HTTParty.post('https://util.devi.tools/api/v1/notify')
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end
end
