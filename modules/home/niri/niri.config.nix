{monitors, wallpaperPath, pkgs, ...}: ''

output "DP-1" {
    scale 1.0
    transform "normal"
    mode "1920x1080@60.00"
    position x=0 y=1080
}
output "HDMI-A-1" {
	scale 1.0
	transform "normal"
	mode "2580x1080@60.00"
	position x=0 y=0
}

layout {
    focus-ring {
        width 2

        active-color "#7fc8ff"
        inactive-color "#505050"

        active-gradient from="#80c8ff" to="#bbddff" angle=45

        inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }

    border {
        width 1
        active-color "#ffc87f"
        inactive-color "#505050"

        active-gradient from="#ffbb66" to="#ffc880" angle=45 relative-to="workspace-view"
        inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667

        // Fixed sets the width in logical pixels exactly.
        // fixed 1920
    }

    default-column-width { proportion 0.5; }
    gaps 4

    struts {
        // left 64
        // right 64
        // top 64
        // bottom 64
    }

    center-focused-column "never"
}

spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${wallpaperPath}"

// You can override environment variables for processes spawned by niri.
environment {
    // Set a variable like this:
    // QT_QPA_PLATFORM "wayland"

    // Remove a variable by using null as the value:
    // DISPLAY null
}

cursor {
    // Change the theme and size of the cursor as well as set the
    // `XCURSOR_THEME` and `XCURSOR_SIZE` env variables.
    // xcursor-theme "default"
    // xcursor-size 24
}

// Uncomment this line to ask the clients to omit their client-side decorations if possible.
// If the client will specifically ask for CSD, the request will be honored.
// Additionally, clients will be informed that they are tiled, removing some rounded corners.
prefer-no-csd

// You can change the path where screenshots are saved.
// A ~ at the front will be expanded to the home directory.
// The path is formatted with strftime(3) to give you the screenshot date and time.
screenshot-path "~/Pictures/Screenshot from %Y-%m-%d %H-%M-%S.png"

// You can also set this to null to disable saving screenshots to disk.
// screenshot-path null

// Settings for the "Important Hotkeys" overlay.
hotkey-overlay {
    // Uncomment this line if you don't want to see the hotkey help at niri startup.
    // skip-at-startup
}

// Animation settings.
animations {
    // Uncomment to turn off all animations.
    // off

    // Slow down all animations by this factor. Values below 1 speed them up instead.
    // slowdown 3.0

    // You can configure all individual animations.
    // Available settings are the same for all of them:
    // - off disables the animation.
    // - duration-ms sets the duration of the animation in milliseconds.
    // - curve sets the easing curve. Currently, available curves
    //   are "ease-out-cubic" and "ease-out-expo".

    // Animation when switching workspaces up and down,
    // including after the touchpad gesture.
    workspace-switch {
        // off
        // duration-ms 250
        // curve "ease-out-cubic"
    }

    // All horizontal camera view movement:
    // - When a window off-screen is focused and the camera scrolls to it.
    // - When a new window appears off-screen and the camera scrolls to it.
    // - When a window resizes bigger and the camera scrolls to show it in full.
    // - And so on.
    horizontal-view-movement {
        // off
        // duration-ms 250
        // curve "ease-out-cubic"
    }

    // Window opening animation. Note that this one has different defaults.
    window-open {
        // off
        // duration-ms 150
        // curve "ease-out-expo"
    }

    // Config parse error and new default config creation notification
    // open/close animation.
    config-notification-open-close {
        // off
        // duration-ms 250
        // curve "ease-out-cubic"
    }
}

// Window rules let you adjust behavior for individual windows.
// They are processed in order of appearance in this file.
// (This example rule is commented out with a "/-" in front.)
/-window-rule {
    // Match directives control which windows this rule will apply to.
    // You can match by app-id and by title.
    // The window must match all properties of the match directive.
    match app-id="org.myapp.MyApp" title="My Cool App"

    // There can be multiple match directives. A window must match any one
    // of the rule's match directives.
    //
    // If there are no match directives, any window will match the rule.
    match title="Second App"

    // You can also add exclude directives which have the same properties.
    // If a window matches any exclude directive, it won't match this rule.
    //
    // Both app-id and title are regular expressions.
    // Raw KDL strings are helpful here.
    exclude app-id=r#"\.unwanted\."#

    // Here are the properties that you can set on a window rule.
    // You can override the default column width.
    default-column-width { proportion 0.75; }

    // You can set the output that this window will initially open on.
    // If such an output does not exist, it will open on the currently
    // focused output as usual.
    open-on-output "eDP-1"

    // Make this window open as a maximized column.
    open-maximized true

    // Make this window open fullscreen.
    open-fullscreen true
    // You can also set this to false to prevent a window from opening fullscreen.
    // open-fullscreen false
}

// Here's a useful example. Work around WezTerm's initial configure bug
// by setting an empty default-column-width.
window-rule {
    // This regular expression is intentionally made as specific as possible,
    // since this is the default config, and we want no false positives.
    // You can get away with just app-id="wezterm" if you want.
    // The regular expression can match anywhere in the string.
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}

binds {
    // Keys consist of modifiers separated by + signs, followed by an XKB key name
    // in the end. To find an XKB name for a particular key, you may use a program
    // like wev.
    //
    // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
    // when running as a winit window.
    //
    // Most actions that you can bind here can also be invoked programmatically with
    // `niri msg action do-something`.

    // Mod-Shift-/, which is usually the same as Mod-?,
    // shows a list of important hotkeys.
    Alt+Shift+Semicolon { show-hotkey-overlay; }

    // Suggested binds for running programs: terminal, app launcher, screen locker.
    Alt+T { spawn "kitty"; }
    Alt+P { spawn "rofi -show run -show-icons"; }
    Alt+Backspace { spawn "rofi -show power-menu -modi power-menu:rofi-powermenu"; }

    // You can also use a shell:
    // Mod+T { spawn "bash" "-c" "notify-send hello && exec alacritty"; }

    // Example volume keys mappings for PipeWire & WirePlumber.
    XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
    XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }

    Alt+Q { close-window; }

    Alt+H     { focus-column-left; }
    Alt+J     { focus-window-down; }
    Alt+K     { focus-window-up; }
    Alt+L     { focus-column-right; }

    Alt+Shift+H     { move-column-left; }
    Alt+Shift+J     { move-window-down; }
    Alt+Shift+K     { move-window-up; }
    Alt+Shift+L     { move-column-right; }

    // Alternative commands that move across workspaces when reaching
    // the first or last window in a column.
    Alt+U     { focus-monitor-down; }
    Alt+I     { focus-monitor-up; }

    Alt+Shift+U     { move-column-to-monitor-down; }
    Alt+Shift+I     { move-column-to-monitor-up; }

    Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
    // ...

    // And you can also move a whole workspace to another monitor:
    // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
    // ...

    Mod+Page_Down      { focus-workspace-down; }
    Mod+Page_Up        { focus-workspace-up; }
    Mod+U              { focus-workspace-down; }
    Mod+I              { focus-workspace-up; }
    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
    Mod+Ctrl+U         { move-column-to-workspace-down; }
    Mod+Ctrl+I         { move-column-to-workspace-up; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
    // ...

    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
    Mod+Shift+U         { move-workspace-down; }
    Mod+Shift+I         { move-workspace-up; }

    // You can refer to workspaces by index. However, keep in mind that
    // niri is a dynamic workspace system, so these commands are kind of
    // "best effort". Trying to refer to a workspace index bigger than
    // the current workspace count will instead refer to the bottommost
    // (empty) workspace.
    //
    // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
    // will all refer to the 3rd workspace.
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }
    Mod+Ctrl+1 { move-column-to-workspace 1; }
    Mod+Ctrl+2 { move-column-to-workspace 2; }
    Mod+Ctrl+3 { move-column-to-workspace 3; }
    Mod+Ctrl+4 { move-column-to-workspace 4; }
    Mod+Ctrl+5 { move-column-to-workspace 5; }
    Mod+Ctrl+6 { move-column-to-workspace 6; }
    Mod+Ctrl+7 { move-column-to-workspace 7; }
    Mod+Ctrl+8 { move-column-to-workspace 8; }
    Mod+Ctrl+9 { move-column-to-workspace 9; }

    // Alternatively, there are commands to move just a single window:
    // Mod+Ctrl+1 { move-window-to-workspace 1; }

    Mod+Comma  { consume-window-into-column; }
    Mod+Period { expel-window-from-column; }

    // There are also commands that consume or expel a single window to the side.
    // Mod+BracketLeft  { consume-or-expel-window-left; }
    // Mod+BracketRight { consume-or-expel-window-right; }

    Mod+R { switch-preset-column-width; }
    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }
    Mod+C { center-column; }

    // Finer width adjustments.
    // This command can also:
    // * set width in pixels: "1000"
    // * adjust width in pixels: "-5" or "+5"
    // * set width as a percentage of screen width: "25%"
    // * adjust width as a percentage of screen width: "-10%" or "+10%"
    // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
    // set-column-width "100" will make the column occupy 200 physical screen pixels.
    Mod+Minus { set-column-width "-10%"; }
    Mod+Equal { set-column-width "+10%"; }

    // Finer height adjustments when in column with other windows.
    Mod+Shift+Minus { set-window-height "-10%"; }
    Mod+Shift+Equal { set-window-height "+10%"; }

    // Actions to switch layouts.
    // Note: if you uncomment these, make sure you do NOT have
    // a matching layout switch hotkey configured in xkb options above.
    // Having both at once on the same hotkey will break the switching,
    // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
    // Mod+Space       { switch-layout "next"; }
    // Mod+Shift+Space { switch-layout "prev"; }

    Print { screenshot; }
    Ctrl+Print { screenshot-screen; }
    Alt+Print { screenshot-window; }

    // The quit action will show a confirmation dialog to avoid accidental exits.
    // If you want to skip the confirmation dialog, set the flag like so:
    // Mod+Shift+E { quit skip-confirmation=true; }
    Mod+Shift+E { quit; }

    Mod+Shift+P { power-off-monitors; }

    // This debug bind will tint all surfaces green, unless they are being
    // directly scanned out. It's therefore useful to check if direct scanout
    // is working.
    // Mod+Shift+Ctrl+T { toggle-debug-tint; }
}

// Settings for debugging. Not meant for normal use.
// These can change or stop working at any point with little notice.
''
