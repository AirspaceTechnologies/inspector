class Slack  
  class << self
    def notify!(message)
      client.post do |request|
        request.url ENV['HOOK_URI']
        request.headers['Content-Type'] = 'application/json'
        request.body = payload(message).to_json
      end
    end
    
    private

    def payload(message)
      { text: message }
    end    

    def client
      @client ||= Faraday.new(url: ENV['HOOK_HOST'])
    end
  end  
end