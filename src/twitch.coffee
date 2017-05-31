Spammerino = window.Spammerino ?= {}
Spammerino.site =
  isValidChatLine: (element) ->
    $(element).is '.chat-line:not(.admin):not(.special-message):not(.notification)'

  isChatMessagesRoot: (element) ->
    $(element).is '.chat-messages'

  spamMessage: (button) ->
    message = $(button).parent().find('.message')[0]
    if $(message).attr('data-raw')?
      decodeURIComponent $(message).attr('data-raw')
    else
      spamMessageTokensFromNode message
        .filter (token) -> token.length
        .join ' '

  chatScrollArea: ->
    $('.chat-messages .tse-scroll-content')

  chatInputArea: ->
    $('.chat-input textarea')

  chatSendButton: ->
    $('.js-chat-buttons__submit')

spamMessageTokensFromNode = (node) ->
  switch node.nodeType
    when Node.ELEMENT_NODE
      if $(node).children('img').size()
        [$(node).find('img').attr 'alt']
      else
        [].concat (spamMessageTokensFromNode child for child in $(node).contents())...
    when Node.TEXT_NODE
      [node.textContent.trim()]
