# Bebop

A Cowboy Bebop title sequence inspired Quickshell.

## TODOs
- Figure out how to disable hyprland zoom-in on creation (for shutdown menu)
    - probably a windowrule I can set with Lua or something
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

## Plans

### Always-On Widgets
This is largely based on my personal taste. Undecided where these will be placed
- **Date and Time**
- **Notifications**: These just need to be styled appropriately
- **Current Workspace Number**: Not sure what the cleanest way to have this is
- **Volume Percent**: Optionally, what's currently playing

### Submenu/New Layer Widgets
These things need dedicated menus or layers.
- **App Launcher**: Considering doing something fun with one of those scrolling text sections
- **Lock Screen**: Considering one of the sections with black bars against bright background and yellow text in rectangles
- **Calendar**: Section from opening with colored squares may look very nice
- **Audio Control/Setup**: To control which output device is used, etc
- **System Stats**: CPU/RAM etc. Not sure what this will look like yet
- **Theming Menu**: Wallpaper, colors, options

- Create other widgets:
    - Lock Screen
    - Clock/Calendar
    - Notification styling
    - Workspace switching/display
    - Audio Display (and switching?)
    - System stats menu?


## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!