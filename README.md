Spammerino
===

This extension enables you to repeat any Twitch chat messages with one simple click.

There are also other QoL tweaks to Twitch chat. See the feature list below for details.

Features
---

* **The repeat button**: Add a button after each message in twitch chat. Click it and you'll send the exact same message to the chat.
* **Message hover-pin**: Messages from the chat history are rarely expected to keep scrolling under your cursor. Spammerino auto locks the chat history for you whenever you hover over the chat history area.
* **Chat History Emote Clicking**: In most cases, the emote you want to send is already present in the chat history. Instead of typing the emote or finding it in the emote menu, you can now grab that emote directly from chat history.
* **Customization**: All features above can be disabled or customized in the options menu.

Installation
---

Download from [Chrome web store](https://chrome.google.com/webstore/detail/mmfojmapmifacojoajmmcdhfapoagfho) or build from source (see below).

Compatibility
---

This extension is tested to be compatible with BetterTTV and TwitchFullscreenPlus. In theory, it should be compatible with most other extensions. If you are experiencing compatibility issues, please use the bug tracker.

Dev Plan
---

The following features are in the plan. Keep an eye on the updates!

* **Recommended spam**: We will analyze on the fly what most people are talking about. See whether you want to say the same thing!
* **Spam archive**: Save some messages for later usage.
* **R9k bypass**: Let's make this useless feature more useless. Kappa.
* **Support other browsers other than Chrome**.

How to build
---

1. Install [Node.js](https://nodejs.org/)
2. Install CoffeeScript
```
npm install --global coffee-script
```
3. Compile
```
coffee --compile --output js src
```

Contribution
---

Please do! You can refer to the dev plan above and the bug tracker to find out what we are currently working on.
