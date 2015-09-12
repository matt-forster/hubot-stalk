

class List
  @template =
    name: null
    lastStatus: null
    lastAction: null
    lastUpdate: null
    following: false
    stati: []
    actions: []

  @robot = null
  @store = null
  @statusThreshold = 3 # number of status to keep in memory
  @actionThreshold = 5 # number of actions to keep in memory

  constructor: (@robot) ->
    loadStore = =>
      @store = @robot.brain.data.stalkers_notes || {};
      @robot.logger.debug "Stalkers Notes Loaded: " + JSON.stringify(@store, null, 2)
    @robot.brain.on "loaded", loadStore

  follow: (user) ->
    @store[user].following = true

  following: (user) ->
    @store[user].following

  saveStatus: (user, status) ->
    user = @store[user]
    @robot.logger.debug user
    if not user
      @store[user] = @template
      user = @store[user]

    @robot.logger.debug user
    user.stati.unshift status
    user.lastStatus = status
    user.lastUpdate = new Date()

    if user.stati.length > @statusThreshold
      user.stati.pop

  saveAction: (user, command, args) ->
    user = @store[user]
    if not user
      @store[user] = @template
      user = @store[user]

    action = {
      action: command
      args: args
    }

    user.actions.unshift action
    user.lastAction = action
    user.lastUpdate = new Date()

    if user.actions.length > @actionThreshold
      user.actions.pop

  get: (user) =>
    if user
      @store[user]
    else
      false

module.exports = List
