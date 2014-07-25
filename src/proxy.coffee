{Adapter} = require 'hubot'
path = require 'path'
fs = require 'fs'

CONFIG_FILE_NAME = 'adapter-proxy-config'

HUBOT_DEFAULT_ADAPTERS = [
  'campfire'
  'shell'
]

class AdapterProxy extends Adapter
  # This adapter acts as a proxy between hubot and the real adapter.
  # For full documentation on how to use this proxy, check out the wiki.
  
  constructor: (@robot) ->
    configFilePath = path.join(process.env.PWD, CONFIG_FILE_NAME + '.coffee')
    if not fs.existsSync configFilePath
      configFilePath = path.join(process.env.PWD, CONFIG_FILE_NAME + '.js')
    if not fs.existsSync configFilePath
      throw new Error("#{CONFIG_FILE_NAME} must be in the root of the node project.")
    AdapterProxyConfig = require configFilePath
    @config = new AdapterProxyConfig
    adapterPath = if @config.adapter in HUBOT_DEFAULT_ADAPTERS
      "#{path}/#{@config.adapter}"
    else
      "hubot-#{@config.adapter}"
    @adapter = require(adapterPath).use @
    @adapter.robot = @robot

  # Overridden
  send: (envelope, strings...) ->
    stringsForSend = @config.events.stringsForSend?(@adapter, envelope, strings...) || strings
    if not @config.events.shouldSend or @config.events.shouldSend(@adapter, envelope, stringsForSend...)
      @config.events.willSend?(@adapter, envelope, stringsForSend...)
      @adapter.send?(envelope, stringsForSend...)
      @config.events.didSend?(@adapter, envelope, stringsForSend...)

  # Overridden
  emote: (envelope, strings...) ->
    stringsForEmote = @config.events.stringsForEmote?(@adapter, envelope, strings...) || strings
    if not @config.events.shouldEmote or @config.events.shouldEmote(@adapter, envelope, stringsForEmote...)
      @config.events.willEmote?(@adapter, envelope, stringsForEmote...)
      @adapter.emote?(envelope, stringsForEmote...)
      @config.events.didEmote?(@adapter, envelope, stringsForEmote...)

  # Overridden
  reply: (envelope, strings...) ->
    stringsForReply = @config.events.stringsForReply?(@adapter, envelope, strings...) || strings
    if not @config.events.shouldReply or @config.events.shouldReply(@adapter, envelope, stringsForReply...)
      @config.events.willReply?(@adapter, envelope, stringsForReply...)
      @adapter.reply?(envelope, stringsForReply...)
      @config.events.didReply?(@adapter, envelope, stringsForReply...)

  # Overridden
  topic: (envelope, strings...) ->
    stringsForTopic = @config.events.stringsForTopic?(@adapter, envelope, strings...) || strings
    if not @config.events.shouldTopic or @config.events.shouldTopic(@adapter, envelope, stringsForTopic...)
      @config.events.willTopic?(@adapter, envelope, stringsForTopic...)
      @adapter.topic?(envelope, stringsForTopic...)
      @config.events.didTopic?(@adapter, envelope, stringsForTopic...)

  # Overridden
  play: (envelope, strings...) ->
    stringsForPlay = @config.events.stringsForPlay?(@adapter, envelope, strings...) || strings
    if not @config.events.shouldPlay or @config.events.shouldPlay(@adapter, envelope, stringsForPlay...)
      @config.events.willPlay?(@adapter, envelope, stringsForPlay...)
      @adapter.play?(envelope, stringsForPlay...)
      @config.events.didPlay?(@adapter, envelope, stringsForPlay...)

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
  new AdapterProxy robot