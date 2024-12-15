TODO: EN
## Module `newScroll.lua`

The `newScroll.lua` module provides functionality for creating and configuring scrollable views in your project. It can be placed anywhere in your project and imported using `require` to access its methods.

```lua
local newScroll = require("newScroll")
```

---

## Creating a Scroll

### Method `newScroll`
This method creates a scroll object (table) that can be customized using parameters. It accepts a parameter table.

### Available Parameters
| Parameter             | Description                                                                                  | Type                          |
|-----------------------|----------------------------------------------------------------------------------------------|-------------------------------|
| `width`, `height`     | Sets the dimensions of the visible scroll area.                                              | Number                        |
| `x`, `y`              | Coordinates defining the scroll's position.                                                  | Number                        |
| `typeScroll`          | Scroll type: `"vertical"`, `"horizontal"`, or any other value for custom behavior.            | String                        |
| `effect` *(not working)* | Edge effect type: `nil`, `"bounce"`, `"scalePadding"`, `"scaleObjects"`, `"scaleAll"`.        | String or `nil`               |
| `friction`            | Friction value, affecting the inertia decay of the scroll.                                   | Number                        |
| `padding`             | Padding between objects inside the scroll (works if `isOrder = true`).                       | Number                        |
| `isLocked`            | Locks the scroll if set to `true`.                                                           | Boolean                       |
| `isOrder`             | Automatically arranges objects if set to `true` (works with specific `typeScroll` values).   | Boolean                       |
| `isScrollBar`         | Shows a scrollbar during scrolling if set to `true`.                                         | Boolean                       |
| `speedAnimation`      | Speed of animations, including showing/hiding the scrollbar.                                 | Number                        |
| `scrollBarWidth`      | Width of the scrollbar.                                                                      | Number                        |
| `scrollBarRounded`    | Corner radius of the scrollbar.                                                              | Number                        |
| `scrollBarColorBG`    | Background color of the scrollbar. Formats: `{gray}`, `{gray, alpha}`, `{r, g, b}`, `{r, g, b, alpha}`. | Table         |
| `scrollBarColorSlider`| Color of the scrollbar slider. Formats similar to `scrollBarColorBG`.                        | Table                         |

---

### Example Usage
```lua
local newScroll = require("newScroll")

local myScroll = newScroll({
    width = 300,
    height = 400,
    x = 50,
    y = 50,
    typeScroll = "vertical",
    isScrollBar = true
})

-- Changing parameters
myScroll.y = 300

-- Viewing parameters
local jp = require("json").prettify
print(jp(myScroll.path))
```

---

## Scroll Object Methods

### `insert`
Adds an object to the scroll.  
Signatures:  
1. `myScroll:insert(obj)`  
2. `myScroll:insert(index, obj)`

| Parameter | Description                                    | Type               |
|-----------|-----------------------------------------------|--------------------|
| `obj`     | Solar2D object to add.                        | Solar2D object     |
| `index`   | Index specifying the insertion position.      | Number (optional)  |

#### Example:
```lua
local rect1 = display.newRect(0, 0, 200, 100)
local rect2 = display.newRect(0, 0, 200, 100)

myScroll:insert(rect2)
myScroll:insert(1, rect1)
```

---

### `remove`
Removes an object from the scroll.  
Signature: `myScroll:remove(obj)`

| Parameter | Description                                    | Type              |
|-----------|-----------------------------------------------|-------------------|
| `obj`     | Solar2D object to remove.                     | Solar2D object    |

#### Example:
```lua
myScroll:remove(rect1)
```

---

### `takeFocus`
Sets focus on the scroll for event handling.  
Signature: `myScroll:takeFocus(event)`

| Parameter | Description                                    | Type              |
|-----------|-----------------------------------------------|-------------------|
| `event`   | Event table (listener event).                 | Table             |

---

### `getContentPosition`
Returns the current position of the scroll content: `x`, `y`.

---

### `scrollToPosition`
Moves the scroll content to a specified position with animation.  
Signature: `myScroll:scrollToPosition(params)`

| Parameter      | Description                                    | Type              |
|----------------|-----------------------------------------------|-------------------|
| `x`, `y`       | Final coordinates for movement.               | Number            |
| `time`         | Duration of the animation in milliseconds.     | Number            |
| `transition`   | Animation type (`easing` function).            | Function          |
| `onComplete`   | Function called after animation completion.    | Function          |

#### Example:
```lua
myScroll:scrollToPosition({
    y = 200,
    time = 1000,
    transition = easing.outQuad,
    onComplete = function()
        print("Movement complete!")
    end
})
```

---

### `setScrollBarColorBG`
Sets the background color of the scrollbar.  
Signature: `myScroll:setScrollBarColorBG(gray, alpha)`  
or `myScroll:setScrollBarColorBG(r, g, b, alpha)`

#### Example:
```lua
myScroll:setScrollBarColorBG(0.3, 0.6, 0.2)
```

---

### `setScrollBarColorSlider`
Sets the slider color of the scrollbar.  
Signature: `myScroll:setScrollBarColorSlider(gray, alpha)`  
or `myScroll:setScrollBarColorSlider(r, g, b, alpha)`

#### Example:
```lua
myScroll:setScrollBarColorSlider(0.7, 0.9, 0.6)
```

---

## Recommendations
- Change scroll parameters via the root table, e.g., `myScroll.y`.
- Use the `path` property to view nested parameters.

---

---
# RU

## Модуль `newScroll.lua`

Модуль `newScroll.lua` предоставляет функциональность для создания и настройки скролла в вашем проекте. Его можно разместить в любом месте проекта и подключить через `require`, чтобы использовать его методы.

```lua
local newScroll = require("newScroll")
```

---

## Создание скролла

### Метод `newScroll`
Метод создает объект скролла (таблицу), который можно настроить с помощью параметров. Метод принимает таблицу параметров.

### Доступные параметры
| Параметр              | Описание                                                                                      | Тип                          |
|-----------------------|-----------------------------------------------------------------------------------------------|-----------------------------|
| `width`, `height`     | Устанавливают размеры видимой части скролла.                                                  | Число                       |
| `x`, `y`              | Координаты, задающие позицию скролла.                                                         | Число                       |
| `typeScroll`          | Тип скролла: `"vertical"`, `"horizontal"` или любой другой тип для произвольного поведения.    | Строка                      |
| `effect` *(не работает)* | Тип эффекта при достижении границ: `nil`, `"bounce"`, `"scalePadding"`, `"scaleObjects"`, `"scaleAll"`. | Строка или `nil`           |
| `friction`            | Значение трения, влияющее на затухание инерции.                                               | Число                       |
| `padding`             | Отступ между объектами внутри скролла (работает при `isOrder = true`).                        | Число                       |
| `isLocked`            | Блокировка скроллинга (`true` блокирует).                                                     | Логическое значение         |
| `isOrder`             | Упорядочивание объектов (`true` включает упорядочивание, работает с определенными типами).    | Логическое значение         |
| `isScrollBar`         | Показывает скроллбар во время прокрутки (`true` включает).                                    | Логическое значение         |
| `speedAnimation`      | Скорость анимаций, включая появление/скрытие скроллбара.                                       | Число                       |
| `scrollBarWidth`      | Толщина скроллбара.                                                                           | Число                       |
| `scrollBarRounded`    | Радиус закругления углов скроллбара.                                                          | Число                       |
| `scrollBarColorBG`    | Цвет фона скроллбара. Формат: `{gray}`, `{gray, alpha}`, `{r, g, b}`, `{r, g, b, alpha}`.     | Таблица                     |
| `scrollBarColorSlider`| Цвет ползунка скроллбара. Формат аналогичен `scrollBarColorBG`.                               | Таблица                     |

---

### Пример использования
```lua
local newScroll = require("newScroll")

local myScroll = newScroll({
    width = 300,
    height = 400,
    x = 50,
    y = 50,
    typeScroll = "vertical",
    isScrollBar = true
})

-- Изменение параметров
myScroll.y = 300

-- Просмотр параметров
local jp = require("json").prettify
print(jp(myScroll.path))
```

---

## Методы объекта скролла

### `insert`
Добавляет объект в скролл.  
Сигнатуры:  
1. `myScroll:insert(obj)`  
2. `myScroll:insert(index, obj)`

| Параметр | Описание                                    | Тип               |
|----------|---------------------------------------------|------------------|
| `obj`    | Solar2D-объект для добавления.              | Solar2D-объект  |
| `index`  | Индекс, указывающий позицию добавления.     | Число (опционально) |

#### Пример:
```lua
local rect1 = display.newRect(0, 0, 200, 100)
local rect2 = display.newRect(0, 0, 200, 100)

myScroll:insert(rect2)
myScroll:insert(1, rect1)
```

---

### `remove`
Удаляет объект из скролла.  
Сигнатура: `myScroll:remove(obj)`

| Параметр | Описание                                    | Тип              |
|----------|---------------------------------------------|------------------|
| `obj`    | Solar2D-объект для удаления.                | Solar2D-объект  |

#### Пример:
```lua
myScroll:remove(rect1)
```

---

### `takeFocus`
Устанавливает фокус на скролл для обработки событий.  
Сигнатура: `myScroll:takeFocus(event)`

| Параметр | Описание                                    | Тип              |
|----------|---------------------------------------------|------------------|
| `event`  | Таблица события (эвента).                   | Таблица          |

---

### `getContentPosition`
Возвращает текущую позицию содержимого скролла: `x`, `y`.

---

### `scrollToPosition`
Перемещает содержимое скролла к заданной позиции с анимацией.  
Сигнатура: `myScroll:scrollToPosition(params)`

| Параметр      | Описание                                    | Тип              |
|---------------|---------------------------------------------|------------------|
| `x`, `y`      | Конечные координаты перемещения.            | Число            |
| `time`        | Время анимации в миллисекундах.             | Число            |
| `transition`  | Тип анимации (`easing`-функция).            | Функция          |
| `onComplete`  | Функция, вызываемая после завершения анимации. | Функция          |

#### Пример:
```lua
myScroll:scrollToPosition({
    y = 200,
    time = 1000,
    transition = easing.outQuad,
    onComplete = function()
        print("Перемещение завершено!")
    end
})
```

---

### `setScrollBarColorBG`
Устанавливает цвет фона скроллбара.  
Сигнатура: `myScroll:setScrollBarColorBG(gray, alpha)`  
или `myScroll:setScrollBarColorBG(r, g, b, alpha)`

#### Пример:
```lua
myScroll:setScrollBarColorBG(0.3, 0.6, 0.2)
```

---

### `setScrollBarColorSlider`
Устанавливает цвет ползунка скроллбара.  
Сигнатура: `myScroll:setScrollBarColorSlider(gray, alpha)`  
или `myScroll:setScrollBarColorSlider(r, g, b, alpha)`

#### Пример:
```lua
myScroll:setScrollBarColorSlider(0.7, 0.9, 0.6)
```

---

## Рекомендации
- Изменяйте параметры скролла через корневую таблицу, например, `myScroll.y`.
- Для просмотра вложенных параметров используйте свойство `path`.

--- 
