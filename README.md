Spammerino
=== 

This extension enables you to repeat any Twitch chat messages with one simple click.

There are also other QoL tweaks to Twitch chat. See the feature list below for details.

Features
---

* **The repeat button**: Add a button after each message in twitch chat. Click it and you'll send the exact same message to the chat.
* **Message hover-pin**: Locking down a message for copy-pasting (as well as clicking our brand new button) is no easy task especially when the traffic of the chat is high. Worry no more! Now when you hover a message, it will remain its position for the rest of its life (or, of course, until you decide to let go). Do whatever you want to that message!

Compatibility
---

This extension is tested to be compatible with BetterTTV and TwitchFullscreenPlus. In theory, it should be compatible with most other extensions. If you are experiencing compatibility issues, please use the bug tracker.

Dev Plan
---

The following features are in the plan. Keep an eye on the updates!

* **Recommended spam**: We will analyze on the fly what most people are talking about. See whether you want to say the same thing!
* **Spam archive**: Save some messages for later usage.
* **R9k bypass**: Let's make this useless feature more useless. Kappa.
* **Support more sites other than Twitch**.
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