Spammerino = window.Spammerino ?= {}
Spammerino.site =
  isValidChatLine: (element) ->
    $(element).is '.chat-line:not(.admin):not(.special-message):not(.notification)'

  isChatMessagesRoot: (element) ->
    $(element).is '.chat-messages'

  spamMessage: (button) ->
    window.App.__container__.lookup('-view-registry:main')[button.parentNode.id].msgObject.message

  chatScrollArea: ->
    $('.chat-messages .tse-scroll-content')

  chatInputArea: ->
    $('.chat-input textarea')

  chatSendButton: ->
    $('.js-chat-buttons__submit')
