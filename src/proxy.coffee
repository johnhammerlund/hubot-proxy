{Adapter} = require 'hubot'
path = require 'path'
fs = require 'fs'

CONFIG_FILE_NAME = 'event-hooks-config'

HUBOT_DEFAULT_ADAPTERS = [
  'campfire'
  'shell'
]

class EventHooks extends Adapter
  # This adapter acts as a proxy between hubot and the real adapter.
  # For full documentation on how to use this proxy, check out the wiki.
  
  constructor: (@robot) ->
    configFilePath = path.join(process.env.PWD, CONFIG_FILE_NAME + '.coffee')
    if not fs.existsSync configFilePath
      configFilePath = path.join(process.env.PWD, CONFIG_FILE_NAME + '.js')
    if not fs.existsSync configFilePath
      throw new Error("#{CONFIG_FILE_NAME} must be in the root of the node project.")
    HooksConfig = require configFilePath
    @config = new HooksConfig
    adapterPath = if @config.adapter in HUBOT_DEFAULT_ADAPTERS
      "#{path}/#{@config.adapter}"
    else
      "hubot-#{@config.adapter}"
    @adapter = require(adapterPath).use @
    @adapter.robot = @robot

  # Overridden
  send: (envelope, strings...) ->
    if not @config.events.shouldSend or @config.events.shouldSend(@adapter, envelope, strings...)
      @config.events.willSend?(@adapter, envelope, strings...)
      @adapter.send?(envelope, strings...)
      @config.events.didSend?(@adapter, envelope, strings...)

  # Overridden
  emote: (envelope, strings...) ->
    if not @config.events.shouldEmote or @config.events.shouldEmote(@adapter, envelope, strings...)
      @config.events.willEmote?(@adapter, envelope, strings...)
      @adapter.emote?(envelope, strings...)
      @config.events.didEmote?(@adapter, envelope, strings...)

  # Overridden
  reply: (envelope, strings...) ->
    if not @config.events.shouldReply or @config.events.shouldReply(@adapter, envelope, strings...)
      @config.events.willReply?(@adapter, envelope, strings...)
      @adapter.reply?(envelope, strings...)
      @config.events.didReply?(@adapter, envelope, strings...)

  # Overridden
  topic: (envelope, strings...) ->
    if not @config.events.shouldTopic or @config.events.shouldTopic(@adapter, envelope, strings...)
      @config.events.willTopic?(@adapter, envelope, strings...)
      @adapter.topic?(envelope, strings...)
      @config.events.didTopic?(@adapter, envelope, strings...)

  # Overridden
  play: (envelope, strings...) ->
    if not @config.events.shouldPlay or @config.events.shouldPlay(@adapter, envelope, strings...)
      @config.events.willPlay?(@adapter, envelope, strings...)
      @adapter.play?(envelope, strings...)
      @config.events.didPlay?(@adapter, envelope, strings...)

  # Overridden
  run: ->
    @config.events.willLaunch?(@adapter)
    @adapter.run()
    @emit 'connected'
    @config.events.didLaunch?(@adapter)

  # Overridden
  close: ->
    @config.events.willExit?(@adapter)
    @adapter.close()
    @config.events.didExit?(@adapter)

  # Overridden
  receive: (message) ->
    console.log message
    if not @config.events.shouldReceive or @config.events.shouldReceive(@adapter, message)
      @config.events.willReceive?(@adapter, message)
      @adapter.receive message
      @config.events.didReceive?(@adapter, message)

  # Overridden
  users: ->
    @adapter.users()

  # Overridden
  userForId: (id, options) ->
    @adapter.userForId id, options

  # Overridden
  userForName: (name) ->
    @adapter.userForName name

  # Overridden
  usersForRawFuzzyName: (fuzzyName) ->
    @adapter.usersForRawFuzzyName fuzzyName

  # Overridden
  usersForFuzzyName: (fuzzyName) ->
    @adapter.usersForFuzzyName fuzzyName

  # Overridden
  http: (url) ->
    @adapter.http url

exports.use = (robot) ->
  new EventHooks robot