class Slack
  Subject = Struct.new(:title, :link, :body)

  class << self
    def notify!(subjects)
      client.post do |request|
        request.url ENV['HOOK_URI']
        request.headers['Content-Type'] = 'application/json'
        request.body = payload(subjects).to_json
      end
    end
    
    private

    def payload(subjects)
      { attachments: subjects.map { |subject| as_attachment(subject) } }
    end

    def as_attachment(subject)
      {
        fallback: subject.title,
        title: subject.title,
        title_link: subject.link,
        text: subject.body
      }
    end

    def client
      @client ||= Faraday.new(url: ENV['HOOK_HOST'])
    end
  end  
end
