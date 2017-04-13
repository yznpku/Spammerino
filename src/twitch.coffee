window.spammerinoSiteHandler =

  buttonImage: chrome.extension.getURL 'image/logo16.png'

  isValidChatLine: (element) ->
    $(element).is '.chat-line:not(.admin):not(.special-message):not(.notification)'

  spamMessage: (button) ->
    message = $(button).parent().find('.message')[0]
    if $(message).attr('data-raw')?
      decodeURIComponent $(message).attr('data-raw')
    else
      tokens = $(message).contents().map (i, element) ->
        switch element.nodeType
          when Node.ELEMENT_NODE
            $(element).find('img').attr 'alt'
          when Node.TEXT_NODE
            element.textContent.trim()
      tokens = tokens.get().filter (e) -> e.length
      tokens.join ' '

  chatInputArea: ->
    $('.chat-input textarea')

  chatSendButton: ->
    $('.js-chat-buttons__submit')