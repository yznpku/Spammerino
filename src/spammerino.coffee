Spammerino = window.Spammerino ?= {}
MutationObserver = window.MutationObserver or window.WebKitMutationObserver;
observerConfig = { childList: true, subtree: true }

spamButtonHtml = '<div class="spam-button"><img /></div>'
pendingMessagePanelHtml = '<div class="pending-message-panel"><div class="pending-message"><p>MESSAGE PENDING</p><p>DUE TO</p><p class="pending-reason"></p></div><div class="circle"><div class="glow"></div><p class="pending-time">5</p></div><div class="close-button"><img></div></div>'

new Promise $('document').ready
.then ->
  observer = new MutationObserver (mutations) ->
    for mutation in mutations
      for node in mutation.addedNodes
        switch
          when Spammerino.site.isValidChatLine node
            if Spammerino.config['repeat-button-toggle']
              insertSpamButton node
            currentUser = Spammerino.site.currentUser()
            message = Spammerino.site.spamMessage node
            if currentUser == message.from
              Spammerino.last2ndMessage = Spammerino.lastMessage
              Spammerino.lastMessage = message

          when Spammerino.site.isAdminChatLine node
            message = Spammerino.site.spamMessage(node).message
            if Spammerino.config['pending-message-toggle']
              switch
                when message.match Spammerino.site.slowModeRejectionRegex
                  if Spammerino.config['pending-message-slow-mode-toggle']
                    time = parseInt(message.match(Spammerino.site.slowModeRejectionRegex)[1]) + 1
                    schedulePendingMessage Spammerino.lastMessage.message, 'SLOW MODE', time
                when message == Spammerino.site.identicalMessageRejection
                  if Spammerino.config['pending-message-identical-message-toggle'] and Spammerino.last2ndMessage?
                    switch Spammerino.config['pending-message-identical-message']
                      when 'wait'
                        time = 31 - Math.floor (Spammerino.lastMessage.date - Spammerino.last2ndMessage.date) / 1000
                        schedulePendingMessage Spammerino.lastMessage.message, 'IDENTICAL MESSAGE', time
                      when 'modify'
                        schedulePendingMessage randomizeMessage(Spammerino.lastMessage.message, '\u200B\u200C\u180E'), 'IDENTICAL MESSAGE', 2
                when message == Spammerino.site.sendingTooFastRejection
                  if Spammerino.config['pending-message-sending-too-fast-toggle']
                    schedulePendingMessage Spammerino.lastMessage.message, 'SENDING TOO FAST', 2
                when message == Spammerino.site.r9kRejection
                  if Spammerino.config['pending-message-r9k-toggle']
                    schedulePendingMessage randomizeMessage(Spammerino.lastMessage.message, 'bcdfhIklnrstvxz0123456789'), 'R9K MODE', 2
                when message.match Spammerino.site.timeoutRejectionRegex
                  if Spammerino.config['pending-message-timeout-toggle']
                    time = parseInt(message.match(Spammerino.site.timeoutRejectionRegex)[1]) + 1
                    schedulePendingMessage Spammerino.lastMessage.message, 'TIMEOUT', time

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

          when Spammerino.site.isChatInterface node
            insertPendingMessagePanel node

  observer.observe $('body')[0], observerConfig

messageActionHandler = (message, action) ->
  switch action
    when 'send'
      Spammerino.site.chatInputArea().focus().val(message).blur()
      setTimeout (-> Spammerino.site.chatSendButton().click()), 0
    when 'copy'
      Spammerino.copyToClipboard message
    when 'overwrite'
      Spammerino.site.chatInputArea().focus().val(message + ' ').blur().focus()
    when 'append'
      currentString = Spammerino.site.chatInputArea().val()
      currentString += ' ' if currentString and not currentString.endsWith ' '
      Spammerino.site.chatInputArea().focus().val(currentString + message + ' ').blur().focus()

insertSpamButton = (parent) ->
  spamButton = $.parseHTML(spamButtonHtml)[0]
  $(parent).append spamButton
  $(spamButton).children().attr 'src', Spammerino.buttonImageSrc

installSpamButtonActions = (parent) ->
  $(parent).on 'click', '.spam-button', (e) ->
    removePendingMessage()
    message = Spammerino.site.spamMessage(@parentNode).message
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
  $('.chat-messages .tse-scroll-content').unbind 'scroll mousewheel wheel DOMMouseScroll mousedown', orignalEventListener

  # Add a class to disable 'More messages below.' message mouse event capturing
  $('.chat-room').addClass 'spammerino-global-hover-pin'

insertPendingMessagePanel = (chatInterface) ->
  panel = $.parseHTML(pendingMessagePanelHtml)[0]
  $(panel).find('.close-button img').attr 'src', Spammerino.closeButtonImageSrc
  $(panel).find('.close-button').click -> removePendingMessage()
  $(chatInterface).append panel
  panel.setAttribute 'hidden', ''

schedulePendingMessage = (message, reason, time) ->
  if Spammerino.pendingTimer?.running
    Spammerino.pendingTimer.stop()
  $('.pending-message-panel .pending-reason').text reason
  $('.pending-message-panel').removeAttr 'hidden'
  Spammerino.site.chatInputArea().attr 'disabled', ''
  Spammerino.pendingTimer = new Spammerino.Countdown time * 1000, 1000, ->
    messageActionHandler message, 'send'
    removePendingMessage()
  , ->
    $('.pending-message-panel .pending-time').text time.toString()
    time -= 1

removePendingMessage = ->
  if Spammerino.pendingTimer?.running
    Spammerino.pendingTimer.stop()
  $('.pending-message-panel').attr 'hidden', ''
  Spammerino.site.chatInputArea().removeAttr 'disabled'

randomizedMessageRegex = /^\u00AD.+?\u00AD\s+(.+)$/
randomizePrefix = (charset) ->
  (charset[Math.floor(Math.random() * charset.length)] for i in [0...2]).join ''
randomizeMessage = (message, charset) ->
  match = message.match randomizedMessageRegex
  if match
    '\u00AD' + randomizePrefix(charset) + '\u00AD ' + match[1]
  else
    '\u00AD' + randomizePrefix(charset) + '\u00AD ' + message
