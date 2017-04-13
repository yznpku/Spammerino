site = window.spammerinoSiteHandler
MutationObserver = window.MutationObserver or window.WebKitMutationObserver;
observerConfig = { childList: true, subtree: true }

spamButtonHtml = '<div class="spam-button"><img /></div>'

$('document').ready ->
  observer = new MutationObserver (mutations) ->
    for mutation in mutations
      for node in mutation.addedNodes
        if site.isValidChatLine node
          insertSpamButton node
          installHoverPin node

  observer.observe $('body')[0], observerConfig

insertSpamButton = (parent) ->
  spamButton = $.parseHTML(spamButtonHtml)[0]
  $(parent).append spamButton
  $(spamButton).children().attr 'src', site.buttonImage

  $(spamButton).click ->
    spamMessage = site.spamMessage @
    site.chatInputArea().focus().val(spamMessage).blur()
    site.chatSendButton().click()

wheelHandler = (event) ->
  scroll = site.chatScrollArea().scrollTop();
  site.chatScrollArea().scrollTop(scroll - event.originalEvent.wheelDeltaY);

installHoverPin = (chatLine) ->
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


