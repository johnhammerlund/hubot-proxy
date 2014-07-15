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
  }
module.exports = MyProxyConfig
```

Where `adapter` provides the underlying hubot adapter to proxy and `events` defines actions for observed adapter events.

Currently supported events:

- shouldSend
- willSend
- didSend
- shouldEmote
- willEmote
- didEmote
- shouldReply
- willReply
- didReply
- shouldTopic
- willTopic
- didTopic
- shouldPlay
- willPlay
- didPlay
- shouldReceive
- willReceive
- didReceive
- willLaunch
- didLaunch
- willExit
- didExit
