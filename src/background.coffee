sites = [
	{ id: 'twitch', pattern: /:\/\/www\.twitch\.tv/i }
]

chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
	site = sites.find (x) -> tab.url.match x.pattern
	chrome.pageAction.show tabId if site?