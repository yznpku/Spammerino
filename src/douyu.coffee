Spammerino = window.Spammerino ?= {}
Spammerino.site =
  buttonImage: chrome.extension.getURL 'image/logo16.png'

  isValidChatLine: (element) ->
    $(element).is('.jschartli') and $(element).find('span.text-cont').size()

  spamMessage: (button) ->
    message = $(button).parent().find('.span.text-cont')[0]
    message.textContent

  chatInputArea: ->
    $('#js-send-msg textarea')

  chatSendButton: ->
    $('#js-send-msg .b-btn')
