require "./limer/*"
require "failure"

module Limer
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
  USAGE   = <<-U
    usage: limer [COMMAND] [NAME]

    commands:
      start         starts the timer with the provided name
      stop          stops the timer with the provided name
      reset         resets the timer with the provided name
      view          views the timer with the provided name
      watch         watches the timer with the provided name
      list          list all timers
  U

  enum Command
    Help
    Start
    Stop
    Reset
    View
    Watch
    List
  end
end

l = Limer::Cli.new
l.parse_command
l.parse_name
l.run
