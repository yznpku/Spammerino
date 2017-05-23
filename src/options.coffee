storage = chrome.storage.sync
storage ?= chrome.storage.local
Spammerino = window.Spammerino ?= {}

createOptionNode = (option, parent, depth) ->
  $newNode = $ "<div id='#{option.id}' class='item item-#{depth}'></div>"
  $optionLine = $ "<div class='option-line'></div>"
  $newNode.append $optionLine

  if option.toggle?
    checkbox = $ "<input type='checkbox' id='#{option.id}-toggle'>"
    checkbox.prop 'checked', Spammerino.config["#{option.id}-toggle"]
    $optionLine.append checkbox
    $optionLine.append $ "<label for='#{option.id}-toggle'>#{option.name}</label>"
  else
    $optionLine.append $ "<label>#{option.name}</label>"

  if option.options?
    switch option.options.type
      when 'select'
        $select = $ "<select id='#{option.id}' class='option'></select>"
        for selectOption in option.options.select
          $select.append $ "<option value='#{selectOption.id}'>#{selectOption.name}</option>"
        $optionLine.append $select

  if option.children?
    for suboption in option.children
      createOptionNode suboption, $newNode, depth + 1
  parent.append $newNode

new Promise (success) ->
  Spammerino.initConfig success
.then ->
  new Promise $(document).ready
.then ->
  for option in Spammerino.configDef
    createOptionNode option, $('#options-root'), 0
  $('#save-button').click ->
    $(@).addClass 'save-success'
    $(@).text 'Saved'
  $('#save-button').mouseout ->
    $(@).removeClass 'save-success'
    $(@).text 'Save'
