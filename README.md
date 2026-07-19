# Bebop

A Cowboy Bebop title sequence inspired Quickshell.

## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config

## TODOs
- Set up correctly for multiple monitors
- Find a better sans-serif font for shutdown menu background text
- Juice up background text in shutdown menu till it looks right
    - Note that low blurMax and high blurMultiplier makes an interesting effect
- Consider if there is a more flexible way to position shutdown menu background text
    - i.e. a way bound by screen edge rather than x/y??
- "Destroy" shutdown menu background text
    - Can be done with shader effect onto MultiEffect maskSource or a shader
    - I learned via experimentation that mask images get stretched so they don't work great
- Check and reduce memory usage, use LazyLoaders and such
- Better system for Taskbar/other SVG creation
    - What I have right now could be more flexible and also look better
    - QtQuick.Shapes to draw shapes directly??
- Finish larger widgets and menus (see below)

## Plans

### Always-On Widgets
This is largely based on my personal taste. Undecided where these will be placed
- **Date and Time**:
    - Unsure on appearance
    - Functionality done
- **Notifications**: These just need to be styled appropriately
    - Not started
- **Current Workspace Number**: Not sure what the cleanest way to have this is
    - Unsure on appearance
    - Functionality done
- **Volume Percent**: Optionally, what's currently playing
    - Unsure on appearance
    - Functionality done

### Submenu/New Layer Widgets
These things need dedicated menus or layers.
- **App Launcher**:
    - May use one of those scrolling text sections, but not sure if this is functional enough
    - Not started
- **Lock Screen**:
    - Considering one of the sections with black bars against bright background and yellow text in rectangles
    - Not started
- **Calendar**:
    - Section from opening with colored squares may look very nice
- **Audio Control/Setup**: Popup menu to control which devices used, etc. would be cool.
    - Unsure on appearance yet
    - Not started
- **System Stats**: CPU/RAM etc
    - Unsure on appearance yet
    - Not started
- **Theming Menu**: Wallpaper, colors, options
    - Control of settings from GUI
    - Not started
- **Shutdown Menu**:
    - Inspired by the episode title shot from the opening
    - Mostly done, but needs additional juice

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!