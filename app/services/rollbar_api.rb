module RollbarApi
  require 'uri'
  require 'net/http'

  def self.request(endpoint, access_token=nil)
    access_token ||= "cd51498b7deb4d7db2abb1e258388973"
    url = URI("https://api.rollbar.com/api/1/#{endpoint}?access_token=#{access_token}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'

    JSON.parse http.request(request).read_body
  end

  class Project
    def self.all
      projects = RollbarApi::request('projects')
      projects['result']
    end

    def self.find(project_id)
      project = RollbarApi::request("project/#{project_id}")
      project['result']
    end

    def self.access_token(project_id)
      tokens = RollbarApi::request("project/#{project_id}/access_tokens")
      token = tokens['result'].select { |t| t['name'] == 'read' }.first
      token['access_token']
    end
  end

  class Report
    def self.top_active_items(token)
      report = RollbarApi::request("reports/top_active_items", token)
      report['result']
    end

    def self.occurrence_counts(token)
      report = RollbarApi::request("reports/occurrence_counts", token)
      report['result']
    end

    def self.activated_counts(token)
      report = RollbarApi::request("reports/activated_counts", token)
      report['result']
    end
  end

  class Item
    def self.all(token)
      items = RollbarApi::request('items', token)
      items['result']
    end

    def self.find(item_id, token)
      item = RollbarApi::request("item/#{item_id}", token)
      item['result']
    end
  end

  class Occurrance
    def self.all(token)
      occurrances = RollbarApi::request('instances', token)
      occurrances['result']
    end
  end
end
