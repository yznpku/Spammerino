Spammerino = window.Spammerino ?= {}
Spammerino.site =
  isValidChatLine: (element) ->
    $(element).is '.chat-line:not(.admin):not(.special-message):not(.notification)'

  isAdminChatLine: (element) ->
    $(element).is '.chat-line.admin'

  isChatMessagesRoot: (element) ->
    $(element).is '.chat-messages'

  isChatInterface: (element) ->
    $(element).is '.chat-interface'

  spamMessage: (chatLine) ->
    window.App.__container__.lookup('-view-registry:main')[chatLine.id].msgObject

  chatScrollArea: ->
    $('.chat-messages .tse-scroll-content')

  chatInputArea: ->
    $('.chat-input textarea')

  chatSendButton: ->
    $('.js-chat-buttons__submit')

  currentUser: ->
    window.App.__container__.lookup('-view-registry:main')[$('.chat-display')[0].id].currentUserNick

  slowModeRejectionRegex: /This room is in slow mode and you are sending messages too quickly\. You will be able to talk again in (\d+) seconds\./
  identicalMessageRejection: 'Your message was not sent because it is identical to the previous one you sent, less than 30 seconds ago.'
  sendingTooFastRejection: 'Your message was not sent because you are sending messages too quickly.'
