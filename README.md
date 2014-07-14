hubot-proxy
=================

A hubot adapter event listener that sits inbetween hubot and the desired hubot adapter.

I'll make this prettier and easier to understand in the near future. Basically, just add a config file to the root of the module called event-hooks-config.coffee/.js and configure it as such:

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
