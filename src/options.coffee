storage = chrome.storage.sync
storage ?= chrome.storage.local
Spammerino = window.Spammerino ?= {}

initNodes = ->
  for option in Spammerino.configDef
    createOptionNode option, $('#options-root'), 0

createOptionNode = (option, parent, depth) ->
  $newNode = $ "<div id='#{option.id}' class='item item-#{depth}'></div>"
  $optionLine = $ "<div class='option-line'></div>"
  $newNode.append $optionLine

  if option.toggle?
    checkbox = $ "<input type='checkbox' id='#{option.id}-toggle' class='input'>"
    $optionLine.append checkbox
    $optionLine.append $ "<label for='#{option.id}-toggle'>#{option.name}</label>"
  else
    $optionLine.append $ "<label>#{option.name}</label>"

  if option.options?
    switch option.options.type
      when 'select'
        $select = $ "<select id='#{option.id}' class='input input-inline'></select>"
        for selectOption in option.options.select
          $select.append $ "<option value='#{selectOption.id}'>#{selectOption.name}</option>"
        $optionLine.append $select

  if option.children?
    for suboption in option.children
      createOptionNode suboption, $newNode, depth + 1
  parent.append $newNode

setConfigOnPage = (config) ->
  for element in $('.input').toArray()
    switch element.tagName
      when 'INPUT'
        element.checked = config[element.id] if config[element.id]?
      when 'SELECT'
        element.value = config[element.id] if config[element.id]?

getConfigOnPage = ->
  result = {}
  for element in $('.input').toArray()
    switch element.tagName
      when 'INPUT'
        result[element.id] = element.checked
      when 'SELECT'
        result[element.id] = element.value
  result

saveOptions = ->
  storage.set getConfigOnPage()

resetToDefault = ->
  defaultConfig = {}
  for k, v of Spammerino.configList
    defaultConfig[k] = v.default
  setConfigOnPage defaultConfig

new Promise (success) ->
  Spammerino.initConfig success
.then ->
  new Promise $(document).ready
.then ->
  initNodes()
  setConfigOnPage Spammerino.config

  $('#default-button').click ->
    resetToDefault()

  $('#save-button').click ->
    $(@).addClass 'save-success'
    $(@).text 'Saved'
    saveOptions()
  $('#save-button').mouseout ->
    $(@).removeClass 'save-success'
    $(@).text 'Save'
