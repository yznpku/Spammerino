Spammerino = window.Spammerino ?= {}
site = window.spammerinoSiteHandler
MutationObserver = window.MutationObserver or window.WebKitMutationObserver;
observerConfig = { childList: true, subtree: true }

spamButtonHtml = '<div class="spam-button"><img /></div>'

new Promise (success) ->
  Spammerino.initConfig success
.then ->
  new Promise $('document').ready
.then ->
  observer = new MutationObserver (mutations) ->
    for mutation in mutations
      for node in mutation.addedNodes
        switch
          when site.isValidChatLine node
            if Spammerino.config['repeat-button-toggle']
              insertSpamButton node
            if Spammerino.config['hover-pin-toggle'] and Spammerino.config['hover-pin'] == 'individual'
              installIndividualHoverPin node

          when site.isChatMessagesRoot node
            if Spammerino.config['hover-pin-toggle'] and Spammerino.config['hover-pin'] == 'global'
              installGlobalHoverPin()
            if Spammerino.config['hover-highlight-toggle']
              $('.chat-room').addClass 'spammerino-highlight'

  observer.observe $('body')[0], observerConfig

spamButtonHandler = (message, action) ->
  switch action
    when 'send'
      site.chatInputArea().focus().val(message).blur()
      site.chatSendButton().click()
    when 'copy'
      Spammerino.copyToClipboard message
    when 'overwrite'
      site.chatInputArea().focus().val(message)
    when 'append'
      currentString = site.chatInputArea().val()
      currentString += ' ' if not currentString.endsWith ' '
      site.chatInputArea().focus().val(currentString + message)

insertSpamButton = (parent) ->
  spamButton = $.parseHTML(spamButtonHtml)[0]
  $(parent).append spamButton
  $(spamButton).children().attr 'src', site.buttonImage

  $(spamButton).click (e) ->
    message = site.spamMessage @
    switch
      when e.shiftKey
        if Spammerino.config['repeat-button-shift-click-toggle']
          spamButtonHandler message, Spammerino.config['repeat-button-shift-click']
      else
        if Spammerino.config['repeat-button-click-toggle']
          spamButtonHandler message, Spammerino.config['repeat-button-click']

wheelHandler = (event) ->
  scroll = site.chatScrollArea().scrollTop();
  site.chatScrollArea().scrollTop(scroll - event.originalEvent.wheelDeltaY);

installIndividualHoverPin = (chatLine) ->
  $chatLine = $(chatLine)

  $chatLine.mouseenter ->
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
    $chatLine.bind 'mousewheel', wheelHandler

  $chatLine.mouseleave ->
    $chatLine.siblings('.temp-spacing').remove()
    $chatLine.css
      position: ''
      top: ''
      left: ''
      width: ''
      'z-index': ''
    $chatLine.unbind 'mousewheel', wheelHandler

installGlobalHoverPin = ->
  injectedFunction = ->
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

  # Inject the script above
  script = document.createElement('script')
  script.textContent = '(' + injectedFunction + ')()'
  (document.head||document.documentElement).appendChild(script)
  script.remove()
