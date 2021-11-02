# # define paths and filenames
# deploy_to = "/var/www/pope"
# rails_root = "#{deploy_to}/current"
# pid_file = "#{deploy_to}/shared/pids/unicorn.pid"
# socket_file= "#{deploy_to}/shared/unicorn.sock"
# log_file = "#{rails_root}/log/unicorn.log"
# err_log = "#{rails_root}/log/unicorn_error.log"
# old_pid = pid_file + '.oldbin'
#
# timeout 30
# worker_processes 4 # increase or decrease
# listen socket_file, :backlog => 1024
#
# pid pid_file
# stderr_path err_log
# stdout_path log_file
#
# # make forks faster
# preload_app true
#
# # make sure that Bundler finds the Gemfile
# before_exec do |server|
#   ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
# end
#
# before_fork do |server, worker|
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.connection.disconnect!
#
#   # zero downtime deploy magic:
#   # if unicorn is already running, ask it to start a new process and quit.
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end
#
# after_fork do |server, worker|
#
#   # re-establish activerecord connections.
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.establish_connection
# end
#

# ------------------------------------------------------------------------------
# Sample rails 3 config
# ------------------------------------------------------------------------------

# Set your full path to application.
app_name = "pupca"
app_path = "/var/www/#{app_name}/current"

# Set unicorn options
worker_processes 3
preload_app true
timeout 180
listen "/var/www/sockets/#{app_name}/#{app_name}.sock", :backlog => 64
#listen 8080, :tcp_nopush => true

# Spawn unicorn master worker for user apps (group: apps)
user 'pupca', 'pupca'

# Fill path to your app
working_directory app_path

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'
#rails_env = 'development'
# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
end

before_fork do |server, worker|
  # ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
#
# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection
# end