require './asana.rb'

#Set constants for Asana API Key
#and workspace to query
API_KEY = ''
WORKSPACE_ID = ''

#Set hash for storing projects and their tasks
tasks = Hash.new

#Create new asana object
#and assign it a workspace_id
a = Asana.new(API_KEY)
a.workspace_id = WORKSPACE_ID

#Get projects in workspace and parse into hash
projects = JSON.parse(a.get_projects.body)

#loop through hash and get tasks for each project
#store tasks in 'tasks' hash.
projects['data'].each do | project |
  puts project['id']
  tasks[project['name']] = JSON.parse(a.get_project_tasks(project['id']).body)
end
