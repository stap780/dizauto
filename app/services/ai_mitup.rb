# frozen_string_literal: true

# AiMitup < ApplicationService
class AiMitup < ApplicationService

  attr_reader :api_url, :api_key, :content, :task_id

  def initialize
    @api_url = Mitupai.first&.api_url
    @api_key = Mitupai.first&.api_key
    @task_id = nil
    @content = nil
  end

  def get_task_id(prompt, model = 'gpt-4o-mini', temperature = '0.9', top_p = '0.5')
    data = {
      "ai": {
        "model": model,
        "temperature": temperature.to_i,
        "top_p": top_p.to_i
      },
      "content": prompt
    }
    RestClient.post(@api_url, data.to_json, headers) { |response, request, result, &block|
      case response.code
      when 200
        r_data = JSON.parse(response.body)
        @task_id = r_data['task_id']
        r_data # we only need clear request data
      when 400
        puts "Bad request 400 => #{response.body}"
        JSON.parse(response.body.force_encoding('UTF-8'))
      when 429
        JSON.parse(response.body.force_encoding('UTF-8'))
      else
        response.return!(&block)
      end
    }
  end

  def get_content(task_id)
    base_url = "https://ai.mitup.ru/api/v2/status/#{task_id}"
    RestClient.get( base_url, headers) { |response, request, result, &block|
      case response.code
      when 200
        r_data = JSON.parse(response.body)
        @content = r_data['contents']['text']
        r_data # we only need clear request data
      when 400
        puts "Bad request 400 => #{response.body}"
      else
        response.return!(&block)
      end
    }
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json'
    }
  end

end