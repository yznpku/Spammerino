Spammerino = window.Spammerino ?= {}
Spammerino.Countdown = class
  constructor: (timeout, interval, onTimeout, onInterval) ->
    @running = true
    @intervalTimer = setInterval onInterval, interval
    @timeoutTimer = setTimeout =>
      onTimeout()
      clearInterval @intervalTimer
      @running = false
    , timeout
    onInterval()

  stop: ->
    clearInterval @intervalTimer
    clearTimeout @timeoutTimer
    @running = false
