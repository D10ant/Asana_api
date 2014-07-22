require 'rubygems'
require 'JSON'
require 'net/https'

class Asana

  attr_accessor :workspace_id, :assignee, :name

  def initialize(api_key)
    @api_key = api_key
  end

  def get_tasks
    @uri = URI.parse("https://app.asana.com/api/1.0/tasks")
    @http_method = 'Get'
    send_request
  end

  def get_project_tasks(project_id)
    @uri = URI.parse("https://app.asana.com/api/1.0/projects/#{project_id}/tasks")
    @http_method = 'Get'
    send_request
  end

  def get_projects
    @uri = URI.parse("https://app.asana.com/api/1.0/workspaces/#{self.workspace_id}/projects")
    @http_method = 'Get'
    send_request
  end

  private

  def send_request
    build_request
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res = http.start { |http| http.request(@req) }
    res
  end

  def build_request
    header = {
      "Content-Type" => "application/json"
    }

    if (@http_method == 'Get')
      @req = Net::HTTP::Get.new(@uri.path, header)
    else
      @req = New::HTTP::Post.new(@uri.path, header)
    end

    @req.basic_auth(@api_key, '')
    @req.body = {
      "data" => {
        "workspace" => self.workspace_id,
        "name" => self.name,
        "assignee" => self.assignee
      }
    }.to_json()
  end

end
