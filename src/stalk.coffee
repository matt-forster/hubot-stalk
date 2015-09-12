# Description
#   Hubot knows what your team is doing.
#
# Configuration:
#
# Commands:
#   [stalk] hubot status <status> : Set your status
#   [stalk] hubot notes <name> : See what hubot has on somebody
#   [stalk] hubot upto <name> : See what hubot thinks somebody is up to
#
# Notes:
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

  robot.respond /upto ([\w'@.-:]*)/i, (res) ->
    [full, name] = res.match
    from = res.message.user.name.toLowerCase()
    notes = list.getUser(name)

    if not notes.lastStatus
      res.send "I got nuthin on #{name} chief!"
      return

    message = "#{name}: #{notes.lastStatus}\n"
    res.send message

  robot.respond /notes ([\w'@.-:]*)/i, (res) ->
    [full, name] = res.match
    from = res.message.user.name.toLowerCase()
    notes = list.getUser(name)

    if not notes.lastStatus
      res.send "I got nuthin on #{name} chief!"
      return

    message =  "#{from}: heres what I got for #{name}: \n"
    message += "Last Status: #{notes.lastStatus}\n"
    message += "Last Action: #{notes.lastAction}\n"
    message += "Last heard from: #{notes.lastUpdate}\n"
    message += "Recent Status': \n"
    message += "----------------------------------------\n"
    for status in notes.stati
      message += "\t#{status}\n"
    message += "Recent Actions\n"
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
    [full, action, args] = res.match
    from = res.message.user.name.toLowerCase()

    if command not in possibleCommands
      return

    command = {
      action: action,
      args: args
    }

    if list.following(from)
      list.saveAction(from, command);
