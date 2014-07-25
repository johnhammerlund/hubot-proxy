hubot-proxy
=================

A hubot adapter event listener that sits inbetween hubot and the desired hubot adapter.

The proxied events are dispatched to a config object that behaves like an adapter observer.  To use this adapter, you need to include this in the base directory for the node application/package as `adapter-proxy-config.coffee` or `adapter-proxy-config.js`.

A simple example:

```coffee
class MyProxyConfig
  adapter: "campfire"

  events: {
    shouldSend: (adapter, envelope, strings...) ->
      if somethingIsWrong
        false
      true
    
    willSend: (adapter, envelope, strings...) ->
      #do stuff before the message is sent
      ...
    ...
    
    stringsForSend: (adapter, envelope, originalStrings...) ->
      #Modify messages that hubot responds with
      return originalStrings.map((obj) -> obj.toLowerCase())
  }
module.exports = MyProxyConfig
```

Where `adapter` provides the underlying hubot adapter to proxy and `events` defines actions for observed adapter events.

Currently supported events:

- shouldSend
- willSend
- stringsForSend
- didSend
- shouldEmote
- willEmote
- stringsForEmote
- didEmote
- shouldReply
- willReply
- stringsForReply
- didReply
- shouldTopic
- willTopic
- stringsForTopic
- didTopic
- shouldPlay
- willPlay
- stringsForPlay
- didPlay
- shouldReceive
- willReceive
- didReceive
- willLaunch
- didLaunch
- willExit
- didExit
