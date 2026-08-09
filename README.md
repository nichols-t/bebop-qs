# Bebop

> 3, 2, 1, let's jam!

A Cowboy Bebop title sequence inspired Quickshell.

<img width="3840" height="2160" alt="image" src="https://github.com/user-attachments/assets/7e19db16-ad04-4192-a6a1-fcb5c241018a" />

## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config


## Contributing
If you'd like to contribute please note the following:
1. I do not like LLMs and I would prefer not to accept contributions that used them in any capacity
2. I started this project for my own learning and experience, but I also use it on my computers. So if there's a decision to be made I'm going to do what makes sense for my own personal usage.
    1. This being said I'm still open to ideas! Particularly in order to make this more compatible with different systems

## TODOs
- **Taskbar**:
    - **[FEATURE] Bluetooth indicator**
- **[ERGONOMICS] SysInfo**: Make "fallback" system for modules that allows `Config` to specify a list of how things should be read
- **[FEATURE] SystemInfo Screen**: Add details section for power and network
- **[ERGONOMICS] Shutdown Menu**:
    - Additionally, consider how clickable space is laid out for each item and possibly adjust it
        - Delaunay Triangulation (Voronoi) (see [this implementation](https://github.com/mapbox/delaunator)) would be an interesting thing for this
- **All Screens**:
    - **[DESIGN] Shaders** to modify certain elements' appearance
    - **[DESIGN] Additional elements** to fill empty space
    - **[ERGONOMICS] Config blur layers** so things are less magic-numbery
    - **[OPTIMIZATION] Loaders**: Use loaders to make sure ongoing resource usage is minimized
- **[FEATURE] Audio Control**: Create menu for toggling of audio settings
    - Needs some additional controls
- **[FEATURE] Network Control**: Create a control screen for network status, Wi-Fi etc.
    - Started but only displays existing connections
- **[FEATURE] Bluetooth Control**: Create a control screen for bluetooth pairing/dc/etc.
    - Started but only displays existing connections
- **[FEATURE] Lock Screen**: Add support for fingerprint login via PAM.
    - see https://github.com/end-4/dots-hyprland/pull/2308/changes, but this is slop so who knows
- **[ERGONOMICS] Theme Control**: A menu for editing theme colors, maybe

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!
