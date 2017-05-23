storage = chrome.storage.sync
storage ?= chrome.storage.local
Spammerino = window.Spammerino ?= {}

Object.assign Spammerino,

  initConfig: (success) ->
    getDefaultConfig = (node) ->
      defaultConfig = {}
      if node.toggle?
        defaultConfig["#{node.id}-toggle"] = node.toggle.default
      if node.options?
        defaultConfig[node.id] = node.options.default
      if node.children?
        Object.assign defaultConfig, (getDefaultConfig child for child in node.children)...
      defaultConfig

    configDef = null
    defaultConfig = null
    config = null

    new Promise (success) ->
      $.get (chrome.extension.getURL 'config.json'), '', success
    .then (data) ->
      configDef = JSON.parse data
      defaultConfig = Object.assign (getDefaultConfig item for item in configDef)...
      new Promise (success) -> storage.get null, success
    .then (storageItems) ->
      config = Object.assign {}, defaultConfig, storageItems
      storage.set config
      Object.assign Spammerino,
        configDef: configDef
        defaultConfig: defaultConfig
        config: config
      success()
