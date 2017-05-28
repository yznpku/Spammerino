storage = chrome.storage.sync
storage ?= chrome.storage.local
Spammerino = window.Spammerino ?= {}

Object.assign Spammerino,

  initConfig: (success) ->
    getConfigList = (node) ->
      configList = {}
      if node.toggle?
        configList["#{node.id}-toggle"] =
          type: 'toggle'
          default: node.toggle.default
      if node.options?
        configList[node.id] =
          type: node.options.type
          default: node.options.default
        switch node.options.type
          when 'select'
            configList[node.id].select = (i.id for i in node.options.select)
      if node.children?
        Object.assign configList, (getConfigList child for child in node.children)...
      configList

    isValidConfigValue = (id, value) ->
      return false if id not of configList
      switch configList[id].type
        when 'toggle'
          typeof(value) == 'boolean'
        when 'select'
          value in configList[id].select

    configDef = null
    configList = null
    config = {}

    new Promise (success) ->
      $.get (chrome.extension.getURL 'config.json'), '', success
    .then (data) ->
      configDef = JSON.parse data
      configList = Object.assign (getConfigList item for item in configDef)...
      new Promise (success) -> storage.get null, success
    .then (storageItems) ->
      for k, v of configList
        config[k] = v.default
        config[k] = storageItems[k] if storageItems[k]? and isValidConfigValue k, storageItems[k]
      storage.set config
      Object.assign Spammerino,
        configDef: configDef
        configList: configList
        config: config
      success()
