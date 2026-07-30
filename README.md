# Bebop

> 3, 2, 1, let's jam!

A Cowboy Bebop title sequence inspired Quickshell.

<img width="3840" height="2160" alt="2026-07-23-195802_hyprshot" src="https://github.com/user-attachments/assets/5bbd9d55-9105-4c53-af70-2063ff1df9aa" />

## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config

## TODOs
- **[BUG] Sub-menu IDs**: Check if I'm still opening any windows by implicitly relying on the ID. I think I fixed this, but need to check.
- **[DESIGN] Rule of 3**: Check how often I use design elements to see if I can increase cohesiveness
- **Taskbar**:
    - **[FEATURE] Bluetooth indicator and control**
- **[ERGONOMICS] SysInfo**: Make "fallback" system for modules that allows `Config` to specify a list of how things should be read
- **[FEATURE] SystemInfo Screen**: Add details section for power and network
- **[ERGONOMICS] Shutdown Menu**:
    - Consider if `ListView` is better semantics for arrow key behavior
    - Additionally, consider how clickable space is laid out for each item and possibly adjust it
- **All Screens**: Consider how to "juice" the appearance appropriately:
    - **[DESIGN] Shaders** to modify certain elements' appearance
    - **[DESIGN] Additional elements** to fill empty space
    - **[ERGONOMICS] Config blur layers** so things are less magic-numbery
    - **[OPTIMIZATION] Loaders**: Use loaders to make sure ongoing resource usage is minimized
- **[FEATURE] Audio Control**: Create menu for toggling of audio settings
- **[FEATURE] Network Control**: Create a control screen for network status, Wi-Fi etc.
- **[BUG] App Launcher**: Had an issue crashing when I was loading all other Desktop app entries and typing quickly. Look into fixing this so it can be juiced better.
- **[FEATURE] Lock Screen**: Add support for fingerprint login via PAM.
    - see https://github.com/end-4/dots-hyprland/pull/2308/changes, but this is slop so who knows
- **[ERGONOMICS] Theme Control**: A menu for editing theme colors, maybe

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!
