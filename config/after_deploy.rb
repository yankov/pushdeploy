#!/usr/bin/env ruby

#
# This script is launched by post-receive hook when push is completed.
# The general purpose of this script is to run bundler, migration and
# other commands that you want to launch after deployment.
#

require 'pushdeploy'

PushDeploy.new(ARGV) do
    bundle   
    migrate   
    run "touch /tmp/restart.txt" 
end
