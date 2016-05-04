module RollbarIntegration

  class Project
    require 'uri'
    require 'net/http'

    def self.api_call endpoint, access_token=nil
      access_token ||= "cd51498b7deb4d7db2abb1e258388973"
      url = URI("https://api.rollbar.com/api/1/#{endpoint}?access_token=#{access_token}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["cache-control"] = 'no-cache'

      response = http.request(request)
      r = response.read_body
      JSON.parse r
    end

    def self.all
      projects = api_call 'projects'
      projects['result']
    end

    def self.where project_id
      project = api_call("project/#{project_id}")
      project['result']
    end

    def access_token project_id
      tokens = api_call "project/#{project_id}/access_tokens"
      token = tokens['result'].select { |t| t['name'] == 'read' }.first
      token['access_token']
    end

    def top_active_items project_id
      token = access_token(project_id)
      api_call("reports/top_active_items", "#{token}")
    end
  end
end
