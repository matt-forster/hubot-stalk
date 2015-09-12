chai = require 'chai'
sinon = require 'sinon'
List = require '../src/list'
chai.use require 'sinon-chai'

expect = chai.expect
robotStub = {}

describe 'Stalkers Notes', ->
  list = {}

  beforeEach ->
    robotStub =
      brain:
        data: { }
        on: ->
        emit: ->
        save: ->
      logger:
        debug: (text) ->
    list = new List(robotStub)

  it 'should load a user that hasnt been set yet', ->
    user = list.getUser('matt')
    expect(user.name).to.equal('matt')

  it 'should setup the user and add a status', ->
    user = list.saveStatus('matt', 'test!')
    expect(user.stati.length).to.equal(1)
    expect(user.stati[0]).to.equal('test!')
    expect(user.lastStatus).to.equal('test!')
    expect(user.lastUpdate).to.be.an.instanceOf(Date)

  it 'should set the users last action', ->
    command = {
      action: 'deploy'
      args: 'api on staging'
    }
    user = list.saveAction('matt', command)
    expect(user.actions.length).to.equal(1)
    expect(user.actions[0]).to.eql(command)
    expect(user.lastAction).to.eql(command)
    expect(user.lastUpdate).to.be.an.instanceOf(Date)

  it 'should keep only the threshold for status', ->
    list.saveStatus('matt', 'test!')
    list.saveStatus('matt', 'out to lunch')
    list.saveStatus('matt', 'important meeting')
    user = list.saveStatus('matt', 'free to talk')
    expect(user.stati.length).to.equal(3)

  it 'should only keep the threshold for actions', ->
    command = {
      action: 'deploy'
      args: 'api on staging'
    }
    list.saveAction('matt', command)
    list.saveAction('matt', command)
    list.saveAction('matt', command)
    list.saveAction('matt', command)
    list.saveAction('matt', command)
    user = list.saveAction('matt', command)
    expect(user.actions.length).to.equal(5)

  it 'should report if following', ->
    expect(list.following('matt')).to.equal(false)
    list.follow('matt')
    expect(list.following('matt')).to.equal(true)
