Spammerino = window.Spammerino ?= {}
MutationObserver = window.MutationObserver or window.WebKitMutationObserver;
observerConfig = { childList: true, subtree: true }

spamButtonHtml = '<div class="spam-button"><img /></div>'

new Promise $('document').ready
.then ->
  observer = new MutationObserver (mutations) ->
    for mutation in mutations
      for node in mutation.addedNodes
        switch
          when Spammerino.site.isValidChatLine node
            if Spammerino.config['repeat-button-toggle']
              insertSpamButton node

          when Spammerino.site.isChatMessagesRoot node
            if Spammerino.config['hover-pin-toggle']
              switch Spammerino.config['hover-pin']
                when 'individual'
                  installIndividualHoverPin node
                when 'global'
                  installGlobalHoverPin()
            if Spammerino.config['hover-highlight-toggle']
              $('.chat-room').addClass 'spammerino-highlight'
            installSpamButtonActions node
            replaceEmoteClickActions node

  observer.observe $('body')[0], observerConfig

messageActionHandler = (message, action) ->
  switch action
    when 'send'
      Spammerino.site.chatInputArea().focus().val(message).blur()
      Spammerino.site.chatSendButton().click()
    when 'copy'
      Spammerino.copyToClipboard message
    when 'overwrite'
      Spammerino.site.chatInputArea().focus().val(message).blur().focus()
    when 'append'
      currentString = Spammerino.site.chatInputArea().val()
      currentString += ' ' if not currentString.endsWith ' '
      Spammerino.site.chatInputArea().focus().val(currentString + message).blur().focus()

insertSpamButton = (parent) ->
  spamButton = $.parseHTML(spamButtonHtml)[0]
  $(parent).append spamButton
  $(spamButton).children().attr 'src', Spammerino.buttonImageSrc

installSpamButtonActions = (parent) ->
  $(parent).on 'click', '.spam-button', (e) ->
    message = Spammerino.site.spamMessage @
    switch
      when e.shiftKey
        if Spammerino.config['repeat-button-shift-click-toggle']
          messageActionHandler message, Spammerino.config['repeat-button-shift-click']
      else
        if Spammerino.config['repeat-button-click-toggle']
          messageActionHandler message, Spammerino.config['repeat-button-click']

replaceEmoteClickActions = (parent) ->
  $(parent).on 'click', 'img.emoticon', (e) ->
    emote = $(@).attr 'alt'
    switch
      when e.shiftKey
        if Spammerino.config['chat-emote-shift-click-toggle']
          messageActionHandler emote, Spammerino.config['chat-emote-shift-click']
      else
        if Spammerino.config['chat-emote-click-toggle']
          messageActionHandler emote, Spammerino.config['chat-emote-click']

wheelHandler = (event) ->
  scroll = Spammerino.site.chatScrollArea().scrollTop();
  Spammerino.site.chatScrollArea().scrollTop(scroll - event.originalEvent.wheelDeltaY);

installIndividualHoverPin = (parent) ->
  $(parent).on 'mousewheel', '.chat-line', wheelHandler

  $(parent).on 'mouseenter', '.chat-line', ->
    $chatLine = $(@)
    offset_left = $chatLine.offset().left - parseInt($chatLine.css('marginLeft'), 10);
    offset_top = $chatLine.offset().top - parseInt($chatLine.css('marginTop'), 10);
    width = $chatLine.outerWidth()

    $('<div class="temp-spacing" style="height: ' + $chatLine.outerHeight() + 'px"></div>').insertBefore $chatLine
    $('<div class="temp-spacing"></div>').insertBefore $chatLine

    $chatLine.css
      position: 'fixed'
      left: offset_left
      top: offset_top
      width: width
      'z-index': 1

  $(parent).on 'mouseleave', '.chat-line', ->
    $chatLine = $(@)
    $chatLine.siblings('.temp-spacing').remove()
    $chatLine.css
      position: ''
      top: ''
      left: ''
      width: ''
      'z-index': ''

installGlobalHoverPin = ->
  # Handle mouse events to modify 'stuckToBottom' property
  emberComponent = window.App.__container__.lookup('-view-registry:main')[$('.chat-room').children()[0].id]
  $('.chat-messages').mouseenter ->
    emberComponent._setStuckToBottom false
  $('.chat-messages').mousemove ->
    if emberComponent.stuckToBottom
      emberComponent._setStuckToBottom false
  $('.chat-messages').mouseleave ->
    emberComponent._setStuckToBottom true
    emberComponent._scrollToBottom()

  # Remove original mousewheel event listeners
  orignalEventListener = $._data($(".chat-messages .tse-scroll-content")[0], "events").wheel[0].handler
  $('.chat-messages .tse-scroll-content').unbind 'scroll mousewheel wheel DOMMouseScroll', orignalEventListener

  # Add a class to disable 'More messages below.' message mouse event capturing
  $('.chat-room').addClass 'spammerino-global-hover-pin'
