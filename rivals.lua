local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Esp = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Vernignik/esp/refs/heads/main/lua"))()
local Aim = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Vernignik/aim1/refs/heads/main/aim.lua"))()

-- Создание основного окна
local Window = Fluent:CreateWindow({
    Title = "Rivals┃rewardehub ",
    SubTitle = "1.0.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",  -- Тема по умолчанию
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Вкладки
local Tabs = {
    Aim = Window:AddTab({ Title = "Aim", Icon = "target" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Вкладка Aim
do

    Tabs.Aim:AddParagraph({
        Title = "ВАЖНО",
        Content = "Перед тем как включатm SilentAim Советуеться поменять значение FOV.\nИначе будет баг!"
    })

    -- Переключатель для Aim
    local AimToggle = Tabs.Aim:AddToggle("AimEnabled", { 
        Title = "SilentAim", 
        Default = false 
    })

    AimToggle:OnChanged(function()
        if AimToggle.Value then
            _G.LockCameraEnabled = true
            _G.AutoClickEnabled = true
        else
            _G.LockCameraEnabled = false
            _G.AutoClickEnabled = false
        end
    end)

    -- Переключатель для FOV
    local FovToggle = Tabs.Aim:AddToggle("FovEnabled", { 
        Title = "FOV", 
        Default = false 
    })

    FovToggle:OnChanged(function()
        if FovToggle.Value then
            _G.CircleVisible = true
        else
            _G.CircleVisible = false
        end
    end)

    -- Colorpicker для FOV
    local FovColorPicker = Tabs.Aim:AddColorpicker("FovColor", {
        Title = "Цвет FOV",
        Default = Color3.fromRGB(255, 255, 255) -- Белый по умолчанию
    })

    FovColorPicker:OnChanged(function()
        local newColor1 = FovColorPicker.Value
        _G.CircleColor = newColor1   -- Применяем новый цвет для fov
        print("Цвет FOV изменён на:", newColor1)
    end)

    -- Ползунок для регулировки FOV
    local FovSlider = Tabs.Aim:AddSlider("FovSlider", {
        Title = "FOV Size",
        Description = "Ползунок изменения FOV",
        Default = 100,
        Min = 10,
        Max = 1000,
        Rounding = 1,
    })

    FovSlider:OnChanged(function()
        local fovValue = FovSlider.Value
        _G.CircleRadius = fovValue
        print("Размер FOV установлен на:", fovValue)
    end)
end

-- Вкладка ESP
do
    -- Переключатель для Box
    local BoxToggle = Tabs.ESP:AddToggle("BoxEnabled", { 
        Title = "Box", 
        Default = false 
    })

    BoxToggle:OnChanged(function()
        if BoxToggle.Value then
            Esp.Box = true
        else
            Esp.Box = false
        end
    end)

    -- Переключатель для Name
    local NameToggle = Tabs.ESP:AddToggle("NameEnabled", { 
        Title = "Name", 
        Default = false 
    })

    NameToggle:OnChanged(function()
        if NameToggle.Value then
            Esp.Names = true
        else
            Esp.Names = false
        end
    end)

    -- Один общий Colorpicker для изменения цвета для всех элементов ESP (Box и Name)
    local ESPColorPicker = Tabs.ESP:AddColorpicker("ESPColor", {
        Title = "Цвет ESP",
        Default = Color3.fromRGB(255, 255, 255) -- Белый по умолчанию
    })

    ESPColorPicker:OnChanged(function()
        local newColor = ESPColorPicker.Value
        Esp.BoxColor = newColor   -- Применяем новый цвет для Box
        Esp.NamesColor = newColor -- Применяем новый цвет для Name
        print("Цвет ESP изменён на:", newColor)
    end)
end

-- Вкладка Settings
do
    -- Настройки для работы с конфигами
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings() -- Игнорируем настройки темы в конфигурациях
    SaveManager:SetFolder("FluentScriptHub") -- Папка для сохранения конфигураций
    SaveManager:BuildConfigSection(Tabs.Settings) -- Раздел для работы с конфигами

    InterfaceManager:SetFolder("FluentScriptHub")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
end

-- Открыть первую вкладку по умолчанию
Window:SelectTab(1)

Fluent:Notify({
    Title = "Rivals┃rewardehub",
    Content = "Скрипт успешно запущен!",
    Duration = 8
})

-- Загрузка автоконфига (если установлен)
SaveManager:LoadAutoloadConfig()
