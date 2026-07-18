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

- Create other widgets:
    - Lock Screen
    - Clock/Calendar
    - Notification styling
    - Workspace switching/display
    - Audio Display (and switching?)
    - System stats menu?