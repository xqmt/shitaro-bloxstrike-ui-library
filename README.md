# Shitaro Bloxstrike UI

UI-библиотека из [Bloxstrike-версии Shitaro](https://github.com/Unwalker1337/shitaro-bloxstrike-crack-last). Вынесена из модуля `D.d` в отдельный файл: окно, вкладки, страницы, контролы, настройки меню и конфиги.

Это другая версия интерфейса, со своим API. Здесь используются `page`, `values`, `colorpicker` и общий реестр `flags`. В коде нет Luraph VM или проверки ключа.

## Пример

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Unwalker1337/shitaro-bloxstrike-ui-library/main/example.lua"))()
```

**Insert** скрывает окно, **F6** переключает `enabled` в примере. Слева находятся контролы, справа — их текущие значения. На странице `appearance` можно поменять цвета, а во вкладке `settings` — открыть настройки меню и конфиги.

Пример работает только с интерфейсом. Конфиги и служебные файлы складываются в отдельную папку `shitaro-bloxstrike-ui-demo`. Две кнопки для снимка значений используют память и не требуют файлового API.

## Подключение

```lua
local ui = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Unwalker1337/shitaro-bloxstrike-ui-library/main/Library.lua"
))()

local window = ui:window({
    title = "my menu",
    script = "demo",
    folder = "my-ui-configs",
    key = "Insert",
    size = {800, 480},
    font = false,
})

local tab = window:tab({name = "main", icon = "misc"})
local page = tab:page("general")
local section = page:section({name = "options", side = "left"})

section:toggle({
    name = "enabled",
    flag = "main.enabled",
    default = false,
    cb = function(value)
        print("enabled:", value)
    end,
})
```

Если файл лежит в workspace executor:

```lua
local ui = loadstring(readfile("Library.lua"))()
```

## Файлы

| Файл | Содержимое |
| --- | --- |
| [Library.lua](Library.lua) | Самостоятельный модуль библиотеки |
| [example.lua](example.lua) | Пример с callbacks, темой и настройками |
| [docs/API.md](docs/API.md) | Справочник по методам и параметрам |

Библиотека рассчитана на Roblox с executor. Для файловых конфигов нужны его функции работы с workspace. Иконки используют Roblox assets; пользовательские шрифты могут загружаться отдельно. В примере стоит `font = false`, поэтому используются встроенные шрифты.

При выделении модуля сохранён его исходный код. Добавлены небольшие fallback-функции для `cloneref`, `getgenv`, `gethui`, алиасы HTTP-запросов и локальный Base64 для экспорта share-строк. Остальные модули Bloxstrike в библиотеку не входят.

Исходник и пример проверяются компилятором Luau. Полный интерактивный запуск этой отдельной сборки в Roblox пока не проверен.
