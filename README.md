# Scripts
Useful Scripts

## Maintenance

Schedule maintenance scripts on a Mac with `launchd`. Copy the desired `plist` configuration to `~/Library/LaunchAgents/` and register it with the following command.

```
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.myscript.plist
```

### Homebrew Updates

`brew-update-upgrade.sh` runs `brew update && brew upgrade -y`. It requires homebrew to be installed and is used in a nightly job to keep hombrew installed apps updated. Run it manually with `./brew-update-upgrade.sh`.

## Personal Services

See [above](#maintenance) for how to register these services

### llama.cpp

[llama.cpp](https://github.com/ggml-org/llama.cpp) is a powerful, locally-hosted llm that can be used when you don't want to upload your content to a public AI tool. Use this `plist` file as a baseline to configure running the agent automatically on system startup.

This configuration can also be tested through `./run-llama-server.sh`. Just make sure to download the model first

```
llama-cli -hf unsloth/Qwen3.5-9B-GGUF:Q5_K_M
```

- `-ngl 99` (Number of GPU Layers): Setting this to a high number forces llama.cpp to offload all model layers to your M5 GPU. This gives you lightning-fast tokens-per-second instead of relying on the slower CPU.
- `-c 8192` (Context Window): Sets the memory context limit to 8K tokens. This gives the model plenty of room to digest long code scripts and error logs without overflowing your 16GB RAM buffer.
- `-t 6` (Threads): Pins the execution to 6 threads. The M5 base chip features a mix of performance and efficiency cores; mapping to 6 threads balances peak execution speed while preventing your fanless Air from building up heat too quickly.
- `-fa` (Flash Attention): Enables high-performance attention kernels. This significantly reduces overall memory usage and speeds up processing time when throwing large chunks of code into the prompt.
