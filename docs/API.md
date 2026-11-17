# API

`ui` — таблица, которую возвращает `Library.lua`. Методы вызываются через `:`, поля опций пишутся строчными буквами. Для callbacks можно использовать `cb` или `callback`.

## Окно

```lua
local window = ui:window({
    title = "my menu",
    script = "demo",
    folder = "my-ui-configs",
    key = "Insert",
    size = {800, 480},
    font = false,
    spectators = false,
})
```

| Поле | Назначение |
| --- | --- |
| `title` | Название окна, по умолчанию `polar` |
| `script` | Название для watermark; без него берётся `title` |
| `folder` | Папка конфигов, настроек, шрифтов и оформления; по умолчанию `polar` |
| `key` | Клавиша меню: имя или `Enum.KeyCode`; по умолчанию `Insert` |
| `size` | Массив `{ширина, высота}`, по умолчанию `{780, 470}` |
| `font` | `false` оставляет встроенные шрифты; иначе библиотека может загрузить пользовательский шрифт |
| `spectators` | Включает поддержку списка наблюдателей |
| `logo` | Пользовательское изображение логотипа |

Размер ограничивается минимумом `680 × 400`. Сохранённые настройки меню могут переопределить начальные размер и клавишу.

```lua
ui:toggle(false)
ui:toggle(true)
ui:toggle()
```

При создании окна библиотека выгружает предыдущую копию из `getgenv().polar_lib`. После `unload` для нового интерфейса загрузи модуль заново.

## Вкладки, страницы, секции

```lua
local tab = window:tab({name = "main", icon = "misc"})
local page = tab:page("general", {cols = 2})
local left = page:section({name = "options", side = "left"})
local right = page:section({name = "preview", side = "right"})
```

`cols` принимает число от 1 до 4. `side` — номер колонки, `"left"`, `"right"` или `"center"`. На странице с тремя или четырьмя колонками `"right"` означает последнюю колонку.

Короткая запись `tab:section(...)` создаёт секцию на первой странице. Чтобы не зависеть от её названия, в больших меню лучше хранить ссылку на `page`.

```lua
tab:show(1)
tab:show(2)
```

Строковые варианты тоже поддерживаются: `window:tab("main")`, `page:section("options")`.

## Значения и flags

```lua
local enabled = left:toggle({
    name = "enabled",
    flag = "main.enabled",
    default = false,
    cb = function(value)
        print(value)
    end,
})

print(enabled:get())
print(ui:get("main.enabled"))

ui:set("main.enabled", true)
local sameControl = ui:el("main.enabled")
```

`ui.flags` хранит текущие значения зарегистрированных контролов, `ui.fl` — сами контролы. Для работы с ними удобнее `get`, `set` и `el`.

Callbacks запускаются через `task.spawn`. Начальное значение заносится в `flags` при создании контрола, но callback от этого сам по себе не вызывается. Если нужна первоначальная синхронизация своей логики, можно вызвать `control:fire()` после создания.

У контролов с временной привязкой `get()` возвращает базовое значение, а `eff()` — действующее с учётом привязки. Именно действующее значение передаётся в callback и `ui.flags`.

## Toggle и slider

```lua
local enabled = left:toggle({
    name = "enabled",
    flag = "main.enabled",
    default = false,
    cb = function(value) print(value) end,
})

local amount = left:slider({
    name = "amount",
    flag = "main.amount",
    min = 0,
    max = 100,
    default = 35,
    suffix = "%",
    cb = function(value) print(value) end,
})

enabled:set(true)
amount:set(60)
amount:set(35, true)
```

Второй аргумент `set` у этих контролов отключает callback для этого изменения. Для дробного слайдера задай `dec` или `decimals`, например `dec = 2`; `step` можно указать отдельно. Без него шаг равен `10 ^ -dec`.

Значение слайдера ограничивается диапазоном и округляется к шагу.

## Dropdown

Одиночный выбор:

```lua
local mode = left:dropdown({
    name = "mode",
    flag = "main.mode",
    values = {"quiet", "balanced", "verbose"},
    default = "balanced",
    cb = function(value) print(value) end,
})

mode:set("quiet")
mode:setvalues({"quiet", "balanced"})
```

Несколько пунктов:

```lua
local panels = left:dropdown({
    name = "panels",
    flag = "main.panels",
    values = {"status", "events", "details"},
    multi = true,
    default = {"status", "events"},
    cb = function(values)
        print(table.concat(values, ", "))
    end,
})

panels:set({"details", "status"})
print(panels:has("status"))
print(panels:none())
```

В этой версии поле списка называется `values`; `options` — его алиас. При `multi = true` начальный выбор, `set`, `get` и callback используют массив значений. Порядок выбора приводится к порядку списка.

`none = true` разрешает отсутствие начального выбора у одиночного списка. `min1 = true` не даёт снять последний выбранный пункт при ручном множественном выборе.

## Colorpicker

```lua
local accent = left:colorpicker({
    name = "accent",
    flag = "main.accent",
    default = Color3.fromRGB(200, 148, 232),
    alpha = 1,
    cb = function(color, alpha)
        print(color, alpha)
    end,
})

accent:set(Color3.fromRGB(120, 190, 255), 0.8)
accent:set(Color3.fromRGB(200, 148, 232), 1, true)
```

`set` принимает `Color3`, alpha и необязательный признак отключения callback. `get()` возвращает цвет; alpha доступна в callback, поле контрола `a` и `ui.flags[flag .. "_a"]`.

Цвет можно прикрепить к существующему toggle:

```lua
enabled:color({
    flag = "main.enabled_color",
    default = Color3.fromRGB(200, 148, 232),
    alpha = 0.8,
})
```

## Keybind

```lua
left:keybind({
    name = "toggle enabled",
    flag = "main.shortcut",
    default = "F6",
    onpress = function(keyName)
        enabled:set(not ui:get("main.enabled"))
    end,
    onrelease = function(keyName)
        print("released", keyName)
    end,
    cb = function(keyName)
        print("binding changed", keyName)
    end,
})
```

`cb` сообщает об изменении привязки. Для нажатия и отпускания есть отдельные `onpress` и `onrelease`. Начальный ключ может быть строкой или `Enum.KeyCode`; для последующих изменений используй `control:setkey("F7")`. `control:down()` проверяет текущее нажатие.

`control:setkey(nil)` убирает привязку, если не задано `nonone = true`.

## Input, button, label

```lua
local name = left:input({
    name = "name",
    flag = "main.name",
    default = "guest",
    placeholder = "your name",
    max = 24,
    cb = function(text) print(text) end,
})

local status = right:label({text = "waiting", bright = true})
local button = left:button({
    name = "update status",
    style = "primary",
    cb = function()
        status:settext("hello, " .. name:get())
    end,
})

name:set("player")
name:set("guest", true)
button:press()
```

У input поле `placeholder` задаёт подсказку, `max` ограничивает программно установленную строку, а `live = true` включает callback при изменении текста. `focus()` ставит курсор в поле.

Стили кнопок: `ghost`, `primary`, `danger`. `button:press()` вызывает callback. Подпись кнопки и текст label меняются через `settext`.

Label принимает и строку: `right:label("text")`. Параметры `bright`, `center`, `rich` управляют яркостью, выравниванием и RichText.

## Темы и уведомления

```lua
ui:settheme("acc", Color3.fromRGB(120, 190, 255))
ui:settheme("bg", Color3.fromRGB(9, 10, 14))
ui:notify("settings saved", "ok", 3)
ui:notify("nothing selected", "warn")
ui:notify("could not load config", "bad")
```

Тема находится в `ui.thm`. Её ключи: `win`, `bg`, `pop`, `hud`, `txt`, `sub`, `dim`, `faint`, `knob`, `acc`, `ink`, `ok`, `bad`, `warn`. Для изменения интерфейса используй `settheme(key, Color3)`.

Уведомления принимают текст, тип и время в секундах. Время по умолчанию — 4 секунды. Цвета темы удобно привязывать к `colorpicker` с явными flags, чтобы они восстанавливались через его callback при загрузке конфига.

## Конфиги

Снимок без записи файлов:

```lua
local saved = ui:export()
if saved then
    local restored = ui:import(saved)
    print(restored)
end
```

`export()` возвращает JSON-строку или `nil`, `import(string)` — признак успешного применения. `share()` возвращает Base64-представление экспорта, которое также принимает `import`. Это формат переноса настроек; сам вызов `share()` ничего не публикует.

Файловые операции:

```lua
ui:create("default")
ui:save("default")
ui:load("default")

for _,config in ipairs(ui:list()) do
    print(config.name, config.modified)
end

ui:rename("default", "backup")
ui:delete("backup")
```

`create`, `save`, `load` и `rename` возвращают boolean. `list` возвращает записи с полями `name` и `modified`. `current()` возвращает имя текущего конфига. У `delete` нет возвращаемого признака успеха.

Создание, сохранение и удаление требуют файловых функций executor. Папка задаётся через `window({folder = ...})`. При загрузке конфига callbacks могут выполняться для восстановления состояния твоего скрипта.

Готовые панели:

```lua
local settings = window:tab({name = "settings", icon = "sliders"})
settings:page("menu"):settings()
settings:page("configs"):configs()
```

Для обмена конфигами через свой сервер окно принимает `share = {put = ..., get = ...}`. Без этих обработчиков можно пользоваться локальными файлами и экспортом строк. Подключение серверного API исходного скрипта в отдельный модуль не переносилось.

## Завершение работы

```lua
ui:onunload(function()
    print("interface closed")
end)

ui:unload()
```

`onunload` регистрирует собственную очистку, `unload` закрывает интерфейс и его обработчики. Пример хранит свою копию в `getgenv().shitaro_bloxstrike_ui_demo` и выгружает её при повторном запуске.
