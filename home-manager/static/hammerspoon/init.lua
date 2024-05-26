---@diagnostic disable-next-line: undefined-global
hs = hs
---@diagnostic disable-next-line: undefined-global
spoon = spoon

hs.loadSpoon("WindowHalfsAndThirds")
hs.loadSpoon("WindowScreenLeftAndRight")

local function focusAppOnPrimaryScreen(appName)
    return function()
        local app = hs.application.get(appName) or hs.application.launchOrFocus(appName)
        if not app then return end

        app:activate(true)
    end
end

spoon.WindowHalfsAndThirds:bindHotkeys({
    left_half   = { {"ctrl", "option"}, "Left" },
    right_half   = { {"ctrl", "option"}, "Right" },
    top_half   = { {"ctrl", "option"}, "Up" },
    bottom_half   = { {"ctrl", "option"}, "Down" },
    top_left = { {"ctrl", "option"}, "q" },
    top_right = { {"ctrl", "option"}, "w" },
    bottom_left = { {"ctrl", "option"}, "a" },
    bottom_right = { {"ctrl", "option"}, "s" },
    center = { {"ctrl", "option"}, "z" },
    max = { {"ctrl", "option"}, "return" },
})

spoon.WindowScreenLeftAndRight:bindHotkeys({
    screen_left = { {"ctrl", "option", "cmd"}, "left" },
    screen_right = { {"ctrl", "option", "cmd"}, "right" },
})

hs.hotkey.bind({ "option" }, "1", focusAppOnPrimaryScreen("Cursor"))
hs.hotkey.bind({ "option" }, "2", focusAppOnPrimaryScreen("Arc"))
hs.hotkey.bind({ "option" }, "3", focusAppOnPrimaryScreen("WezTerm"))
hs.hotkey.bind({ "option" }, "4", focusAppOnPrimaryScreen("Obsidian"))
hs.hotkey.bind({ "option" }, "5", focusAppOnPrimaryScreen("Slack"))
