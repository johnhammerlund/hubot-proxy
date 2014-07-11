{Adapter} = require 'hubot'
path = require 'path'
fs = require 'fs'
config = null

CONFIG_FILE_NAME = 'adapterEventsConfig'

HUBOT_DEFAULT_ADAPTERS = [
  'campfire'
  'shell'
]

class EventHooks extends Adapter
  # An adapter is a specific interface to a chat source for robots.
  #
  # robot - A Robot instance.
  constructor: (@robot) ->
    rootDir = path.dirname(require.main.filename)
    configFilePath = path.relative(__dirname, path.join(rootDir, CONFIG_FILE_NAME + '.coffee'))
    if not fs.existsSync configFilePath
      configFilePath = path.relative(__dirname, path.join(rootDir, CONFIG_FILE_NAME + '.js'))
    if not fs.existsSync configFilePath
      throw new Error("#CONFIG_FILE_NAME must be in the root directory of the application.")
    config = require configFilePath
    try {
      adapterPath = if config.adapter in HUBOT_DEFAULT_ADAPTERS
        "#{path}/#{config.adapter}"
      else
        "hubot-#{config.adapter}"
      @adapter = require(adapterPath).use @
    } catch(err) {
      throw new Error("#CONFIG_FILE_NAME must have a valid adapter.")
    }

  # Public: Raw method for sending data back to the chat source. Extend this.
  #
  # envelope - A Object with message, room and user details.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (envelope, strings...) ->
    if not config.events.shouldSend or config.events.shouldSend(envelope, strings...)
      config.events.willSend?(envelope, strings...)
      @adapter.send?(envelope, strings...)
      config.events.didSend?(envelope, strings...)

  # Public: Raw method for sending emote data back to the chat source.
  # Defaults as an alias for send
  #
  # envelope - A Object with message, room and user details.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  emote: (envelope, strings...) ->
    if not config.events.shouldEmote or config.events.shouldEmote(envelope, strings...)
      config.events.willEmote?(envelope, strings...)
      @adapter.emote?(envelope, strings...)
      config.events.didEmote?(envelope, strings...)

  # Public: Raw method for building a reply and sending it back to the chat
  # source. Extend this.
  #
  # envelope - A Object with message, room and user details.
  # strings  - One or more Strings for each reply to send.
  #
  # Returns nothing.
  reply: (envelope, strings...) ->
    if not config.events.shouldReply or config.events.shouldReply(envelope, strings...)
      config.events.willReply?(envelope, strings...)
      @adapter.reply?(envelope, strings...)
      config.events.didReply?(envelope, strings...)

  # Public: Raw method for setting a topic on the chat source. Extend this.
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  topic: (envelope, strings...) ->
    if not config.events.shouldTopic or config.events.shouldTopic(envelope, strings...)
      config.events.willTopic?(envelope, strings...)
      @adapter.topic?(envelope, strings...)
      config.events.didTopic?(envelope, strings...)

  # Public: Raw method for playing a sound in the chat source. Extend this.
  #
  # envelope - A Object with message, room and user details.
  # strings  - One or more strings for each play message to send.
  #
  # Returns nothing
  play: (envelope, strings...) ->
    if not config.events.shouldPlay or config.events.shouldPlay(envelope, strings...)
      config.events.willPlay?(envelope, strings...)
      @adapter.play?(envelope, strings...)
      config.events.didPlay?(envelope, strings...)

  # Public: Raw method for invoking the bot to run. Extend this.
  #
  # Returns nothing.
  run: ->
    config.events.willLaunch?()
    @adapter.run()
    config.events.didLaunch?()

  # Public: Raw method for shutting the bot down. Extend this.
  #
  # Returns nothing.
  close: ->
    config.events.willExit?()
    @adapter.close()
    config.events.didExit?()

  # Public: Dispatch a received message to the robot.
  #
  # Returns nothing.
  receive: (message) ->
    if not config.events.shouldReceive or config.events.shouldReceive message
      config.events.willReceive?(message)
      @adapter.receive message
      config.events.didReceive?(message)

  # Public: Get an Array of User objects stored in the brain.
  #
  # Returns an Array of User objects.
  users: ->
    @adapter.users()

  # Public: Get a User object given a unique identifier.
  #
  # Returns a User instance of the specified user.
  userForId: (id, options) ->
    @adapter.userForId id, options

  # Public: Get a User object given a name.
  #
  # Returns a User instance for the user with the specified name.
  userForName: (name) ->
    @adapter.userForName name

  # Public: Get all users whose names match fuzzyName. Currently, match
  # means 'starts with', but this could be extended to match initials,
  # nicknames, etc.
  #
  # Returns an Array of User instances matching the fuzzy name.
  usersForRawFuzzyName: (fuzzyName) ->
    @adapter.usersForRawFuzzyName fuzzyName

  # Public: If fuzzyName is an exact match for a user, returns an array with
  # just that user. Otherwise, returns an array of all users for which
  # fuzzyName is a raw fuzzy match (see usersForRawFuzzyName).
  #
  # Returns an Array of User instances matching the fuzzy name.
  usersForFuzzyName: (fuzzyName) ->
    @adapter.usersForFuzzyName fuzzyName

  # Public: Creates a scoped http client with chainable methods for
  # modifying the request. This doesn't actually make a request though.
  # Once your request is assembled, you can call `get()`/`post()`/etc to
  # send the request.
  #
  # Returns a ScopedClient instance.
  http: (url) ->
    @adapter.http url

module.exports = EventHooks