Spammerino = window.Spammerino ?= {}

injectFunction = (f) ->
  injectCode '(' + f + ')()'

injectCode = (code) ->
  script = document.createElement 'script'
  script.textContent = code
  (document.head||document.documentElement).appendChild script
  script.remove()

injectFile = (fileName) ->
  script = document.createElement 'script'
  script.src = chrome.extension.getURL fileName
  script.onload = -> @remove()
  (document.head || document.documentElement).appendChild script

new Promise (success) ->
  Spammerino.initConfig success
.then ->
  Object.assign Spammerino,
    buttonImageSrc: chrome.extension.getURL 'image/logo16.png'
    closeButtonImageSrc: chrome.extension.getURL 'image/cross.png'
  injectCode 'window.Spammerino = ' + JSON.stringify Spammerino
  injectFile 'js/clipboard.js'
  injectFile 'js/countdown.js'
  injectFile 'js/twitch.js'
  injectFile 'js/spammerino.js'
