Spammerino
===

This browser extension provides several handy tweaks to improve your Twitch chat efficiency.

Features
---

* **The repeat button**: Add a button after each message in twitch chat. Click it and you'll send the exact same message to the chat.
* **Message hover-pin**: Messages from the chat history are rarely expected to keep scrolling under your cursor. Spammerino auto locks the chat history for you whenever you hover over the chat history area.
* **Chat History Emote Clicking**: In most cases, the emote you want to send is already present in the chat history. Instead of typing the emote or finding it in the emote menu, you can now grab that emote directly from chat history by simply clicking it.
* **Rejected Messages Resending**: Sometimes your attempt to send a message may fail due to various reasons, such as slow mode, r9k mode, or your message is identical to the previous one within 30 seconds. To successfully send your message, you either have to wait or modify the message, and then resend it. Spammerino will do this (wait/modification + resend) for you automatically.
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

* **Important message area**: Messages that you consider important (e.g. from channel host, verified users or your friends) will be displayed in a special reserved area to prevent them from being overwhelmed.
* **Recommended message**: We will analyze on the fly what most people are talking about. See whether you want to say the same thing!
* **Message archive**: Save some messages for later usage.
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
