class List

  @robot = null
  @store = null

  constructor: (@robot) ->
    store = robot.brain.stalkers_notes || {}

  @save: (user, status) ->
    store[user] = status

  @get: () =>
    store

  @getUser: (user) =>
    store[user]
