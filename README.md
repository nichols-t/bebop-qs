# Bebop

> 3, 2, 1, let's jam!

A Cowboy Bebop title sequence inspired Quickshell.

<img width="3840" height="2160" alt="2026-07-23-195802_hyprshot" src="https://github.com/user-attachments/assets/5bbd9d55-9105-4c53-af70-2063ff1df9aa" />

## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config

## TODOs
- Look at "Rule of 3" for how often I'm using particular design elements to make things feel cohesive
- Bluetooth Indicator for taskbar
- Find a better serif font for shutdown menu background text
- Make system info more robust/flexible across different hardware/installed tools to read it
    - This has been modularized, but a "fallback" system would still be neat for max compatibility
- Juice up background text in shutdown menu till it looks right
    - Note that low blurMax and high blurMultiplier makes an interesting effect
    - May be good to set "blur layers" in config and use those to calculate blur elements less manually
    - Set an `anchor` and `x/y` or centerIn and `vertical/horizontalCenterOffset`
- Consider if `ListView` is better semantics for arrow key behavior
- Consider if there's a better multi-monitor IPC solution than what I did
- "Destroy" shutdown menu background text
    - Can be done with shader effect onto MultiEffect maskSource or a shader
    - I learned via experimentation that mask images get stretched so they don't work great
- Check and reduce memory usage, use LazyLoaders and such
- Finish larger widgets and menus (see below)

## Plans

### Always-On Widgets
This is largely based on my personal taste. Undecided where these will be placed, but probably top taskbar.
- **Date and Time**:
    - Prototype done, but it's kinda boring. Need to see if there's something better to do here.
- **Notifications**: These just need to be styled appropriately
    - Prototype is done, will keep unless I think of something better.
- **Current Workspace Number**: Not sure what the cleanest way to have this is
    - Prototype is done, I think I like it until I have a better idea
- **Volume Percent**: Optionally, what's currently playing
    - Prototype is done, need to evaluate how much I like it
        - Maybe consider a "slider" version or something?
    - Functionality done

### Submenu/New Layer Widgets
These things need dedicated menus or layers.
- **App Launcher**:
    - May use one of those scrolling text sections, but not sure if this is functional enough
    - Not started
- **Lock Screen**:
    - Password login (`pam`) and basic styling done
    - see https://github.com/end-4/dots-hyprland/pull/2308/changes for fingerprint
        - but this is slop so who knows
- **Calendar**:
    - Section from opening with colored squares
    - Basic `.ics` using `khal` done
    - Some additional style juice, plus a single-day subpage are all that's needed.
- **Audio Control/Setup**: Popup menu to control which devices used, etc. would be cool.
    - Unsure on appearance yet
    - Not started
- **System Stats**: CPU/RAM etc
    - Essentially done, but more stats for certain things would be nice
- **Theming Menu**: Wallpaper, colors, options
    - Control of settings from GUI
    - Not started
- **Shutdown Menu**:
    - Inspired by the episode title shot from the opening
    - Mostly done, but needs some additional juice to finish it up

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)
For examples. So thanks to the creators of these projects!
