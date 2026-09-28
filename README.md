# Scripts
Useful Scripts

## Maintenance

Schedule maintenance scripts on a Mac with `launchd`. Copy the desired `plist` configuration to `~/Library/LaunchAgents/` and register it with the following command.

```
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.myscript.plist
```

### Homebrew Updates

`brew-update-upgrade.sh` runs `brew update && brew upgrade -y`. It requires homebrew to be installed and is used in a nightly job to keep hombrew installed apps updated. Run it manually with `./brew-update-upgrade.sh`.
