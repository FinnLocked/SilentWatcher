<div align="center">

![FinnLocked Banner](https://finnlocked.com/assets/img/ForumBanner.png)

# FinnLocked

### FiveM Resources, Systems & Server Solutions

[Website](https://finnlocked.com/) • [Documentation](https://docs.finnlocked.com/) • [Store](https://store.finnlocked.com/) • [Discord](https://finnlocked.com/discord)

<img src="https://img.shields.io/github/release/FinnLocked/SilentWatcher.png">
<img src="https://img.shields.io/github/last-commit/FinnLocked/SilentWatcher">
<img src="https://img.shields.io/github/license/FinnLocked/SilentWatcher.png">
<a href="https://ko-fi.com/finnlocked/tip" target="_blank" title="Buy me a Coffee"><img src="https://img.shields.io/badge/Buy me a Coffee-FF5E5B?logo=ko-fi&logoColor=white"></a>
<a href="https://finnlocked.com/discord" target="_blank" title="Join our Discord"><img alt="Discord Status" src="https://discordapp.com/api/guilds/1535286481869078540/widget.png"></a>

</div>

---

# SilentWatcher

SilentWatcher is a Discord logging resource for FiveM servers.

It can log important server activity such as player joins, disconnects, chat messages, deaths, explosions, resource events, and custom events to Discord webhooks.

SilentWatcher is the modern continuation of **JD_logs**, now maintained and developed under the **FinnLocked** name.

## Features

- Discord webhook logging
- Player join, leave, chat, death, explosion, shooting, and resource logs
- Custom client-side and server-side log exports
- Logs with zero, one, or two players
- Configurable channels, embeds, identifiers, and webhooks
- Localisation through JSON files
- Batched log sending to reduce Discord webhook rate-limit issues
- Optional screenshot logging support
- Improved server-side logging flow for better reliability and security

> [!TIP]
> Use server-side logs whenever possible. Server-side events are more secure because players cannot block or stop them in the same way as client-side events.

## Documentation

Full installation, configuration, localisation, and export documentation is available here:

- [SilentWatcher Documentation](https://docs.finnlocked.com/silentwatcher)
- [Requirements](https://docs.finnlocked.com/silentwatcher/requirements)
- [Installation](https://docs.finnlocked.com/silentwatcher/installation)
- [Configuration and Localisation](https://docs.finnlocked.com/silentwatcher/locals)
- [Custom Logs Without Players](https://docs.finnlocked.com/silentwatcher/no-player-export)
- [One Player Export](https://docs.finnlocked.com/silentwatcher/one-player-export)
- [Two Player Export](https://docs.finnlocked.com/silentwatcher/two-player-export)

## Quick install

1. Place `SilentWatcher` in your server resources folder.
2. Configure your Discord webhooks.
3. Add the resource to `server.cfg`.

```cfg
ensure SilentWatcher
```

For full installation instructions, see the [SilentWatcher documentation](https://docs.finnlocked.com/silentwatcher).

## Support

- [Documentation](https://docs.finnlocked.com/)
- [FinnLocked Store](https://store.finnlocked.com/)
- [Customer Portal](https://portal.finnlocked.com/)
- [Discord](https://finnlocked.com/discord)

> [!WARNING]
> Keep credentials private
> Never share Discord webhook URLs, database passwords, API keys, Steam Web API keys, Discord bot tokens, or licence keys in public messages, screenshots, or support requests.

---

<div align="center">
<br>

[Website](https://finnlocked.com) • [Resource Documentation](https://docs.finnlocked.com/RESOURCE-SLUG) • [Store](https://store.finnlocked.com/) • [Discord](https://finnlocked.com/discord)


[![Discord](https://img.shields.io/badge/Join%20our%20Discord-5865F2?logo=discord&logoColor=white)](https://finnlocked.com/discord)
[![Ko-Fi](https://img.shields.io/badge/Buy%20me%20a%20Coffee-FF5E5B?logo=ko-fi&logoColor=white)](ko-fi.com/finnlocked/tip)



<img src="https://finnlocked.com/assets/img/FinnLocked_storeTitle.png" width="150px;">

</div>