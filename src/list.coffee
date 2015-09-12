

class List
  constructor: (@robot) ->
    @store = null
    @statusThreshold = 3 # number of status to keep in memory
    @actionThreshold = 5 # number of actions to keep in memory

    loadStore = =>
      @store = @robot.brain.data.stalkers_notes || {};
      @robot.logger.debug "Stalkers Notes Loaded: " + JSON.stringify(@store, null, 2)
    @robot.brain.on "loaded", loadStore
    loadStore()

  getUser: (name) ->
    user = @store[name]
    if user is undefined
      user = {
        name: null
        lastStatus: null
        lastAction: null
        lastUpdate: null
        following: false
        stati: []
        actions: []
      }
      @store[name] = user
      user.name = name
    user

  follow: (name) ->
    user = @getUser(name)
    user.following = true
    user.following

  following: (name) ->
    user = @getUser(name)
    user.following

  saveStatus: (name, status) ->
    user = @getUser(name)
    user.stati.unshift status
    user.lastStatus = status
    user.lastUpdate = new Date()

    if user.stati.length > @statusThreshold
      user.stati.pop()
    @robot.brain.save()

  saveAction: (name, command) ->
    user = @getUser(name)
    user.actions.unshift command
    user.lastAction = command
    user.lastUpdate = new Date()

    if user.actions.length > @actionThreshold
      user.actions.pop()

module.exports = List
