

class List
  constructor: (@robot) ->
    @template = {
      name: null
      lastStatus: null
      lastAction: null
      lastUpdate: null
      following: false
      stati: []
      actions: []
    }

    @store = null
    @statusThreshold = 3 # number of status to keep in memory
    @actionThreshold = 5 # number of actions to keep in memory

    loadStore = =>
      @store = @robot.brain.data.stalkers_notes || {};
      @robot.logger.debug "Stalkers Notes Loaded: " + JSON.stringify(@store, null, 2)
    @robot.brain.on "loaded", loadStore
    loadStore()

  getUser: (name) ->
    user = @store[user]
    if user is undefined
      user = @store[user] = @template
      user.name = name
    user

  follow: (user) ->
    user = @getUser(user)
    user.following = true
    user.following

  following: (user) ->
    user = @getUser(user)
    user.following

  saveStatus: (user, status) ->
    user = @getUser(user)
    user.stati.unshift status
    user.lastStatus = status
    user.lastUpdate = new Date()

    if user.stati.length > @statusThreshold
      user.stati.pop()
    user

  saveAction: (user, command) ->
    user = @getUser(user)
    user.actions.unshift command
    user.lastAction = command
    user.lastUpdate = new Date()

    if user.actions.length > @actionThreshold
      user.actions.pop()
    user

module.exports = List
