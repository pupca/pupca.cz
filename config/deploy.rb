require 'capistrano_colors'

capistrano_color_matchers = [
  { :match => /command finished/,       :color => :hide,      :prio => 10 },
  { :match => /executing command/,      :color => :blue,      :prio => 10, :attribute => :underscore },
  { :match => /^transaction: commit$/,  :color => :magenta,   :prio => 10, :attribute => :blink },
  { :match => /git/,                    :color => :white,     :prio => 20, :attribute => :reverse },
]

colorize( capistrano_color_matchers )

# set :whenever_environment, "production"
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"
set :application, "pupca"

set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :scm, :git
set :repository, "ssh://pupca.cz/git/pupca.git"
set :user,        "pupca"
set :keep_releases, 5

set :rvm_ruby_string, "1.9.3@pupca"
set :rvm_type, :user
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :unicorn_env, "production"
set :app_env, "production"

server "pupca.cz", :app, :web, :db, :primary => true

after  'deploy',         'deploy:cleanup'


require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano-unicorn"


