# Description
#   Hubot knows what your team is doing.
#
# Configuration:
#
# Commands:
#   status <status> : Set your status
#   notes on <name> : See hals notes on that person
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Matt Forster[@autovance]

List = require('./list')

possibleCommands = ['deploy', 'deploys', 'notes on', 'whats']

module.exports = (robot) ->
  list = new List(robot)

  robot.respond /status (.+)/i, (res) ->
    [full, status] = res.match
    from = res.message.user.name.toLowerCase()
    list.saveStatus(from, status)
    res.send "#{from}: I set your status to: #{status}"

  robot.respond /whats (\w) up to/i, (res) ->
    [full, name] = res.match
    from = res.message.user.name.toLowerCase()
    notes = list.get(name)
    message = "#{from}: #{name} told me that they are: #{notes.lastStatus}\n"
    message += "Their last command was: #{notes.lastCommand}\n"
    message += "I last heard from them on #{notes.lastUpdate}"
    res.send message

  robot.respond /notes on ([\w'@.-:]*)/i, (res) ->
    [full, name] = res.match
    from = res.message.user.name.toLowerCase()
    notes = list.get(name)

    if not notes
      res.send "I got nuthin on #{name} chief!"
      return

    message =  "#{from}: heres what I got for #{name}: \n"
    message += "Last Status: #{notes.lastStatus}\n"
    message += "Last Action: #{notes.lastAction}\n"
    message += "last heard from: #{notes.lastUpdate}"
    message += "Status: \n"
    message += "----------------------------------------\n"
    for status in notes.stati
      message += "\t#{status}\n"
    message += "Actions\n"
    message += "----------------------------------------\n"
    for action in notes.actions
      message += "\t#{action.command}: #{action.args}\n"

    res.send message

  # Save actions
  robot.hear ///
    ^
    (\w)
    \s*
    (\s[\w'@.-:]*)
  ///i, (res) ->
    [full, command, args] = res.match
    from = res.message.user.name.toLowerCase()

    if command not in possibleCommands
      return

    list.saveAction(from, command, args);
