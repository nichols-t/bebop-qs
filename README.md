# Bebop

> 3, 2, 1, let's jam!

A Cowboy Bebop title sequence inspired Quickshell.


https://github.com/user-attachments/assets/e1b1cf52-3f87-4895-87bc-8731d256383f


## Using
1. Use this repo as your quickshell directory
2. Symlink the `quickshell.lua` file into your hyprland config directory and `require` it from your config


## Contributing
If you'd like to contribute please note the following:
1. I do not like LLMs and I would prefer not to accept contributions that used them in any capacity
    1. (Yes, this means I hand-type the formatting below)
2. I started this project for my own learning and experience, but I also use it on my computers. So if there's a decision to be made I'm going to prioritize what makes sense for my own personal usage.
    1. This being said I'm still open to ideas! Particularly in order to make this more compatible with different systems

## TODOs
- **[GENERAL] Pass on TODOs, comments, etc for cleanup**
    - Check for bad practices, better opportunities for abstraction, etc.
- **[DESIGN] "Blur Layers" to help control resource usage/clamp things/uniform look**
    - This means I need to decide whether or not I actually want blur as well
- **[DESIGN] Make different colors for different system info details screens**
- **[DESIGN] Add flavor text around lock screen background**
- **[DESIGN] Tweak and unify color palettes better**
    - This could involve some math so that I can set a more limited palette and then lighten/darken it
- **[DESIGN] Consider hover effect for icons**
    - Colorize with a themed color?
- **[DESIGN] Consider alternate ideas for notification design**
    - I'm not super satisfied with what I landed on for these
- **[DESIGN] Reconsider icon designs for BT/Network and "bebopify" if possible**
    - Check title sequence again, see if this can help inform the designs a little more, or if the basic ones I have are good enough.

## Improvement Ideas
- **[FEATURE] Audio Settings Rate control (when Quickshell 0.31 is available)**
- **[FEATURE] Network Settings Control**: Add controls for connect/disconnect/etc. to network settings
- **[FEATURE] Bluetooth Settings Control**: Adds controls for bluetooth pairing/dc/etc. to bluetooth settings
- **[ERGONOMICS] Theme Control**: A menu for editing theme colors, maybe
    - The `Theme` singleton I used for audio settings is probably useful here?
    - Tried using some `Settings` stuff but it's not working for me, so maybe some other time
- **[DESIGN] Improve randomness in app launcher font size**
    - Could be a "bias" instead of uniform random
- **[FEATURE] Lock Screen**: Add support for fingerprint login via PAM.
    - see https://github.com/end-4/dots-hyprland/pull/2308/changes, but this is slop so who knows
- **[ERGONOMICS] Shutdown Menu**:
    - Consider how clickable space is laid out for each item and possibly adjust it
        - Delaunay Triangulation (Voronoi) (see [this implementation](https://github.com/mapbox/delaunator)) would be an interesting thing for this
- **[FEATURE] VPN Detector/icon for network**

## Random Notes
- Must check "Flatten Clip" in Inkscape for holes to render properly when exported
- When using `Loader`s, make sure to test re-opening after loading the first time
    - had a nasty freeze in audio settings come up from this

## Acknowledgements, Inspirations
- Cowboy Bebop, obviously

For particular "how do I do *xyz* in quickshell, I tended to look at
- [Linux Antiquity](https://github.com/diinki/linux-antiquity/tree/main/configs/quickshell)
- [Persona 3 Quickshell](https://github.com/Yujonpradhananga/Persona-Quickshell)

For examples. So thanks to the creators of these projects!
