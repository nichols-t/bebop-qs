# Bebop

> 3, 2, 1, let's jam!

A Cowboy Bebop title sequence inspired Quickshell.

<img width="3840" height="2160" alt="2026-07-23-195802_hyprshot" src="https://github.com/user-attachments/assets/5bbd9d55-9105-4c53-af70-2063ff1df9aa" />

## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config

## TODOs
- **[BUG] Sub-menu IDs**: Check if I'm still opening any windows by implicitly relying on the ID. I think I fixed this, but need to check.
- **Taskbar**:
    - **[FEATURE] Bluetooth indicator**
    - **[BUG] Properly center/margin items for all possible states**
- **[ERGONOMICS] SysInfo**: Make "fallback" system for modules that allows `Config` to specify a list of how things should be read
- **[FEATURE] SystemInfo Screen**: Add details section for power and network
- **[ERGONOMICS] Shutdown Menu**:
    - Consider if `ListView` is better semantics for arrow key behavior
    - Additionally, consider how clickable space is laid out for each item and possibly adjust it
        - Delaunay Triangulation (Voronoi) (see [this implementation](https://github.com/mapbox/delaunator)) would be an interesting thing for this
- **All Screens**:
    - **[DESIGN] Shaders** to modify certain elements' appearance
    - **[DESIGN] Additional elements** to fill empty space
    - **[ERGONOMICS] Config blur layers** so things are less magic-numbery
    - **[OPTIMIZATION] Loaders**: Use loaders to make sure ongoing resource usage is minimized
- **[FEATURE] Audio Control**: Create menu for toggling of audio settings
    - Started, but needs some work on controls, etc and SVGs
- **[FEATURE] Network Control**: Create a control screen for network status, Wi-Fi etc.
    - Started, but no controls yet
- **[FEATURE] Bluetooth Control**: Create a control screen for bluetooth pairing/dc/etc.
    - Not started
- **[FEATURE] Lock Screen**: Add support for fingerprint login via PAM.
    - see https://github.com/end-4/dots-hyprland/pull/2308/changes, but this is slop so who knows
- **[ERGONOMICS] Theme Control**: A menu for editing theme colors, maybe

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!
