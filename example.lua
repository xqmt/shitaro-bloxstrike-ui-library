local environment = (getgenv or getfenv)()
local previous = environment.shitaro_bloxstrike_ui_demo

if previous and type(previous.unload) == "function" then
    previous:unload()
end

local ui = loadstring(game:HttpGet(
    "loadstring(game:HttpGet("https://raw.githubusercontent.com/Unwalker1337/shitaro-bloxstrike-ui-library/main/example.lua"))()"
))()

environment.shitaro_bloxstrike_ui_demo = ui
ui:onunload(function()
    if environment.shitaro_bloxstrike_ui_demo == ui then
        environment.shitaro_bloxstrike_ui_demo = nil
    end
end)

local window = ui:window({
    title = "shitaro ui",
    script = "interface demo",
    folder = "shitaro-bloxstrike-ui-demo",
    key = "Insert",
    size = {820, 500},
    font = false,
})

local demo = window:tab({name = "demo", icon = "misc"})
local page = demo:page("controls", {cols = 2})
local controlsSection = page:section({name = "controls", side = "left"})
local previewSection = page:section({name = "current values", side = "right"})
local preview = previewSection:label({text = "", bright = true})

local state = {
    enabled = false,
    amount = 35,
    mode = "balanced",
    panels = {"status", "events"},
    nickname = "guest",
}

local function summary()
    return string.format(
        "enabled: %s\namount: %d%%\nmode: %s\npanels: %s\nname: %s",
        tostring(state.enabled), state.amount, state.mode,
        table.concat(state.panels, ", "), state.nickname
    )
end

local function refresh()
    preview:settext(summary())
end

local controls = {}

controls.enabled = controlsSection:toggle({
    name = "enabled",
    flag = "demo.enabled",
    default = state.enabled,
    cb = function(value)
        state.enabled = value
        refresh()
    end,
})

controls.amount = controlsSection:slider({
    name = "amount",
    flag = "demo.amount",
    min = 0,
    max = 100,
    default = state.amount,
    suffix = "%",
    cb = function(value)
        state.amount = value
        refresh()
    end,
})

controls.mode = controlsSection:dropdown({
    name = "mode",
    flag = "demo.mode",
    values = {"quiet", "balanced", "verbose"},
    default = state.mode,
    cb = function(value)
        state.mode = value
        refresh()
    end,
})

controls.panels = controlsSection:dropdown({
    name = "panels",
    flag = "demo.panels",
    values = {"status", "events", "details", "history"},
    multi = true,
    default = state.panels,
    cb = function(values)
        state.panels = values
        refresh()
    end,
})

controls.nickname = controlsSection:input({
    name = "name",
    flag = "demo.nickname",
    default = state.nickname,
    placeholder = "your name",
    max = 24,
    cb = function(value)
        state.nickname = value
        refresh()
    end,
})

controlsSection:keybind({
    name = "toggle demo",
    flag = "demo.shortcut",
    default = "F6",
    onpress = function()
        controls.enabled:set(not ui:get("demo.enabled"))
    end,
})

controlsSection:button({
    name = "reset values",
    style = "primary",
    cb = function()
        ui:set("demo.enabled", false)
        ui:set("demo.amount", 35)
        ui:set("demo.mode", "balanced")
        ui:set("demo.panels", {"status", "events"})
        ui:set("demo.nickname", "guest")
    end,
})

previewSection:button({
    name = "notification",
    cb = function()
        ui:notify("hello, " .. state.nickname, "ok", 3)
    end,
})

-- Снимок хранится в памяти, файловые функции для него не нужны.
local snapshot

previewSection:button({
    name = "remember values",
    cb = function()
        snapshot = ui:export()
        ui:notify(snapshot and "snapshot saved" or "could not export settings", snapshot and "ok" or "bad")
    end,
})

previewSection:button({
    name = "restore values",
    cb = function()
        if not snapshot then
            ui:notify("save a snapshot first", "warn")
            return
        end
        local restored = ui:import(snapshot)
        ui:notify(restored and "snapshot restored" or "could not read snapshot", restored and "ok" or "bad")
    end,
})

local appearance = demo:page("appearance", {cols = 2})
local colors = appearance:section({name = "theme", side = "left"})

for _,key in ipairs({"acc", "bg", "txt", "dim"}) do
    local colorKey = key
    colors:colorpicker({
        name = colorKey,
        flag = "demo.theme." .. colorKey,
        default = ui.thm[colorKey],
        cb = function(color)
            ui:settheme(colorKey, color)
        end,
    })
end

appearance:section({name = "notes", side = "right"}):label({
    text = "Colors are regular controls too. Their flags are saved in the same config as the other values.",
})

local settings = window:tab({name = "settings", icon = "sliders"})
settings:page("menu"):settings()
settings:page("configs"):configs()

local actions = settings:page("session"):section({name = "session"})
actions:button({
    name = "unload",
    style = "danger",
    cb = function()
        ui:unload()
    end,
})

refresh()
