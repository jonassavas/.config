-- ============================================================================
-- MONITORS
-- ============================================================================
local toggle_monitors = require("./scripts/toggle-monitors")

hl.monitor({
    output = "DP-2",
    mode = "1920x1080@144",
    position = "-1920x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@60",
    position = "1920x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-2",
		--mode = "2560x1440@120", 
		mode = "3840x2160@60",
		position = "0x-2160",
    disabled = false,
		scale = 1,
})


-- ============================================================================
-- NVIDIA
-- ============================================================================

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
-- hl.env("NVD_BACKEND", "direct")


-- ============================================================================
-- DEBUG
-- ============================================================================

hl.config({
    debug = {
        full_cm_proto = true,
    },
})


-- ============================================================================
-- AUTOSTART
-- ============================================================================

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/xdg-portal-hyprland")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,gpg")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("~/.config/hypr/scripts/apply-wallpapers.sh")

    -- Sleep so tray icons have time to appear in Waybar.
    hl.exec_cmd("sleep 3 && blueman-applet")
    hl.exec_cmd("sleep 3 && nm-applet --indicator")
    hl.exec_cmd("sleep 3 && keepassxc --minimized")

    -- Initial monitor state.
    hl.exec_cmd('sh -c \'echo "multi" > ~/.config/hypr/monitor_state\'')
end)


-- ============================================================================
-- INPUT
-- ============================================================================

hl.config({
    input = {
        kb_layout = "us,se",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:alt_space_toggle",
        kb_rules = "",

        follow_mouse = 1,

        touchpad = {
            natural_scroll = false,
        },

        accel_profile = "flat",
        sensitivity = 0,
    },
})


-- ============================================================================
-- GENERAL
-- ============================================================================

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,

        col = {
            active_border = "rgb(cdd6f4)",
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    misc = {
        disable_hyprland_logo = true,
        vrr = 0,
    },

    cursor = {
        no_hardware_cursors = true,
    },
})


-- ============================================================================
-- DECORATION
-- ============================================================================

hl.config({
    decoration = {
        rounding = 5,

        blur = {
            enabled = true,
            size = 7,
            passes = 4,
            new_optimizations = true,
        },

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
})


-- ============================================================================
-- ANIMATIONS
-- ============================================================================

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = {
        { 0.10, 0.90 },
        { 0.10, 1.05 },
    },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 10,
    bezier = "myBezier",
    style = "slide",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 7,
    bezier = "myBezier",
    style = "slide",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 7,
    bezier = "default",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "default",
})


-- ============================================================================
-- LAYOUTS
-- ============================================================================

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "slave",
    },
})


-- ============================================================================
-- WINDOW RULES
-- ============================================================================

-- Steam .exe windows
hl.window_rule({
    match = {
        title = "^(.*%.exe)$",
    },
    float = true,
})

-- Steam app windows
hl.window_rule({
    match = {
        title = "^(steam_app_.*)$",
    },
    float = true,
})

-- Steam Proton
hl.window_rule({
    match = {
        title = "^(steam_proton)$",
    },
    float = true,
})


-- Kitty transparency
hl.window_rule({
    match = {
        class = "^(kitty)$",
    },
    opacity = "0.8 0.8",
})

-- Kitty update window animation
hl.window_rule({
    match = {
        class = "^(kitty)$",
        title = "^(update%-sys)$",
    },
    animation = "popin",
})


-- Thunar
hl.window_rule({
    match = {
        class = "^(thunar)$",
    },
    animation = "popin",
})

hl.window_rule({
    match = {
        class = "^(thunar)$",
    },
    opacity = "0.8 0.8",
})


-- VSCodium
hl.window_rule({
    match = {
        class = "^(VSCodium)$",
    },
    opacity = "0.8 0.8",
})


-- Chromium
hl.window_rule({
    match = {
        class = "^(chromium)$",
    },
    animation = "popin",
})


-- Wofi
hl.window_rule({
    match = {
        class = "^(wofi)$",
    },
    animation = "slide",
})

hl.window_rule({
    match = {
        class = "^(wofi)$",
        title = "^(clippick)$",
    },
    move = { "100%-433", 53 },
})


-- ============================================================================
-- KEYBINDS
-- ============================================================================

local mainMod = "SUPER"


-- Terminal
hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd("kitty")
)


-- Close active window
-- IMPORTANT: old `killactive` means close, not force-kill.
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)


-- Lock screen
hl.bind(
    mainMod .. " + ALT + Home",
    hl.dsp.exec_cmd("swaylock")
)


-- Logout menu
hl.bind(
    mainMod .. " + CTRL + ALT + Home",
    hl.dsp.exec_cmd("wlogout --protocol layer-shell")
)


-- Exit Hyprland
hl.bind(
    mainMod .. " + CTRL + SHIFT + ALT + Home",
    hl.dsp.exit()
)


-- File manager
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd("thunar")
)


-- Toggle floating
hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({ action = "toggle" })
)


-- Wofi launcher
hl.bind(
    mainMod .. " + SPACE",
    hl.dsp.exec_cmd("pkill -x wofi; wofi")
)


-- Dwindle pseudotile
hl.bind(
    mainMod .. " + P",
    hl.dsp.window.pseudo()
)


-- Toggle split
hl.bind(
    mainMod .. " + I",
    hl.dsp.layout("togglesplit")
)


-- Swap split
hl.bind(
    mainMod .. " + O",
    hl.dsp.layout("swapsplit")
)


-- Screenshot
hl.bind(
    mainMod .. " + S",
    hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -')
)


-- Fullscreen
hl.bind(
    mainMod .. " + F",
    hl.dsp.window.fullscreen()
)


-- Toggle Waybar
hl.bind(
    mainMod .. " + B",
    hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")
)


-- ============================================================================
-- SPECIAL / MINIMIZED WORKSPACE
-- ============================================================================

hl.bind(
    mainMod .. " + SHIFT + Z",
    hl.dsp.window.move({
        workspace = "special:minimized",
        follow = false,
    })
)

hl.bind(
    mainMod .. " + Z",
    hl.dsp.workspace.toggle_special("minimized")
)


-- ============================================================================
-- MONITOR SCRIPTS
-- ============================================================================

hl.bind(
    mainMod .. " + CTRL + ALT + T",
    toggle_monitors
)

hl.bind(
    mainMod .. " + CTRL + ALT + R",
    hl.dsp.exec_cmd("~/.config/hypr/scripts/tv-resolution-toggle.sh")
)


-- ============================================================================
-- MOVE FOCUS
-- ============================================================================

hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({ direction = "down" })
)


-- Vim-style focus movement
hl.bind(
    mainMod .. " + H",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(
    mainMod .. " + L",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(
    mainMod .. " + K",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(
    mainMod .. " + J",
    hl.dsp.focus({ direction = "down" })
)


-- ============================================================================
-- MOVE WINDOWS BETWEEN MONITORS
-- ============================================================================

hl.bind(
    mainMod .. " + SHIFT + H",
    hl.dsp.window.move({ monitor = "l" })
)

hl.bind(
    mainMod .. " + SHIFT + L",
    hl.dsp.window.move({ monitor = "r" })
)

hl.bind(
    mainMod .. " + SHIFT + K",
    hl.dsp.window.move({ monitor = "u" })
)

hl.bind(
    mainMod .. " + SHIFT + J",
    hl.dsp.window.move({ monitor = "d" })
)


-- ============================================================================
-- WORKSPACE SWITCHING
-- ============================================================================

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))


-- ============================================================================
-- MOVE ACTIVE WINDOW TO WORKSPACE
-- ============================================================================

hl.bind(
    mainMod .. " + SHIFT + 1",
    hl.dsp.window.move({ workspace = "1" })
)

hl.bind(
    mainMod .. " + SHIFT + 2",
    hl.dsp.window.move({ workspace = "2" })
)

hl.bind(
    mainMod .. " + SHIFT + 3",
    hl.dsp.window.move({ workspace = "3" })
)

hl.bind(
    mainMod .. " + SHIFT + 4",
    hl.dsp.window.move({ workspace = "4" })
)

hl.bind(
    mainMod .. " + SHIFT + 5",
    hl.dsp.window.move({ workspace = "5" })
)

hl.bind(
    mainMod .. " + SHIFT + 6",
    hl.dsp.window.move({ workspace = "6" })
)

hl.bind(
    mainMod .. " + SHIFT + 7",
    hl.dsp.window.move({ workspace = "7" })
)

hl.bind(
    mainMod .. " + SHIFT + 8",
    hl.dsp.window.move({ workspace = "8" })
)

hl.bind(
    mainMod .. " + SHIFT + 9",
    hl.dsp.window.move({ workspace = "9" })
)

hl.bind(
    mainMod .. " + SHIFT + 0",
    hl.dsp.window.move({ workspace = "10" })
)


-- ============================================================================
-- SCROLL THROUGH WORKSPACES
-- ============================================================================

hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)


-- ============================================================================
-- HYPRSUNSET / BLUE LIGHT
-- ============================================================================

hl.bind(
    "SUPER + Page_Down",
    hl.dsp.exec_cmd("hyprctl hyprsunset temperature 2000")
)

hl.bind(
    "SUPER + Page_Up",
    hl.dsp.exec_cmd("hyprctl hyprsunset identity")
)


-- ============================================================================
-- MOUSE WINDOW MOVE / RESIZE
-- ============================================================================

hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)


-- ============================================================================
-- MEDIA KEYS
-- ============================================================================

-- Volume / brightness / launcher.
-- `bindle` = repeating + works while locked.
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("vol --up"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("vol --down"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("bri --up"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("bri --down"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86Search",
    hl.dsp.exec_cmd("launchpad"),
    { repeating = true, locked = true }
)


-- Volume using wpctl.
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)


-- Media playback.
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)
