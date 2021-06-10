require "lib.moonloader" -- подключение библиотеки
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
local dlstatus = require('moonloader').download_status
local se = require 'lib.samp.events'
local ids = -1
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tag = "[My First Script]:" -- локальная переменная
local label = 0
local main_color = 0x5A90CE
local main_color_text = "{5A90CE}"
local white_color = "{FFFFFF}"
local arr_cheat = {"30 Aimbot", "30 WallHack", "10 Spread", "15 auto+c", "30 Saim", "30 DMG", "10 ews", "10 Provo na SK", "10 Fly", "20 AirBreak", "15 Flycar", "10 Speedhack"}

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)


update_state = false -- Если переменная == true, значит начнётся обновление.
update_found = false -- Если будет true, будет доступна команда /update.

local script_vers = 1.1
local script_vers_text = "v1.1" -- Название нашей версии. В будущем будем её выводить ползователю.

local update_url = 'https://raw.githubusercontent.com/ValeriiVavilin/ghelp/main/update.ini' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://raw.githubusercontent.com/ValeriiVavilin/ghelp/main/Ghelper.lua' -- Путь скрипту.
local script_path = thisScript().path


-- чекбоксы
    local checked_NakNumber        = imgui.ImInt(1)
--

-- радиокнопки
    local checked_band        = imgui.ImInt(1)

    local checked_jail        = imgui.ImInt(1)
  
--

--комбобоксы
    local combo_select         =imgui.ImInt(0)
--

local sw, sh = getScreenResolution()

function SetStyle()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    imgui.GetStyle().WindowPadding = imgui.ImVec2(8, 8)
    imgui.GetStyle().WindowRounding = 0.5
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 3)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(4, 4)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().IndentSpacing = 9.0
    imgui.GetStyle().ScrollbarSize = 17.0
    imgui.GetStyle().ScrollbarRounding = 16.0
    imgui.GetStyle().GrabMinSize = 7.0
    imgui.GetStyle().GrabRounding = 15.0
    imgui.GetStyle().ChildWindowRounding = 10.0
    imgui.GetStyle().FrameRounding = 7.0

    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)-- (0.1, 0.9, 0.1, 1.0)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
end
SetStyle()

function check_update() -- Создаём функцию которая будет проверять наличие обновлений при запуске скрипта.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Сверяем версию в скрипте и в ini файле на github
                sampAddChatMessage("{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}/update что-бы обновить", 0xFF0000) -- Сообщаем о новой версии.
                update_found = true -- если обновление найдено, ставим переменной значение true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end


    check_update()

    if update_found then -- Если найдено обновление, регистрируем команду /update.
        sampRegisterChatCommand('update' function()  -- Если пользователь напишет команду, начнётся обновление.
            update_state = true -- Если человек пропишет /update, скрипт обновится.
        end)
    else
        sampAddChatMessage('{FFFFFF}Нету доступных обновлений!')
    end


    sampRegisterChatCommand("imgui", cmd_imgui)
    sampRegisterChatCommand("check", cmd_check)
    sampRegisterChatCommand("1", cmd_1)
	sampRegisterChatCommand("2", cmd_2)
	sampRegisterChatCommand("3", cmd_3)
	sampRegisterChatCommand("clans", cmd_clans)
    sampRegisterChatCommand("grul", cmd_grul)

    thread = lua_thread.create_suspended(thread_ghetto)

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(rid)

    imgui.Process = false
    --sampAddChatMessage("Скрипт imgui перезагружен", -1)

    while true do
        wait(0)

        if update_state then -- Если человек напишет /update и обновлени есть, начнётся скаачивание скрипта.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                end
            end)
            break
        end

        if isKeyJustPressed(VK_F3) then
            cmd_imgui()
        end
        if isKeyJustPressed(VK_F4) then
            cmd_check()
        end

        if main_window_state.v == false then
            imgui.Process = false
        end
        -- Блок выполняющийся бесконечно (пока самп активен)

    end
end

function se.onTogglePlayerSpectating(state)
    if state then
        specc = true
    else
        specc = false
    end
end

function se.onSpectatePlayer(id, type)
    if specc then
        ids = id
    end
end

function cmd_imgui(arg)
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function cmd_check(arg)
    sampAddChatMessage(checked_band.v, -1)
end

function imgui.OnDrawFrame()
    imgui.SwitchContext()
    local colors = imgui.GetStyle().Colors;
    local icol = imgui.Col
    local ImVec4 = imgui.ImVec4

    imgui.GetStyle().WindowPadding = imgui.ImVec2(10, 10)
    imgui.GetStyle().WindowRounding = 10.0
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 4)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(4, 4)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().IndentSpacing = 9.0
    imgui.GetStyle().ScrollbarSize = 17.0
    imgui.GetStyle().ScrollbarRounding = 20.0
    imgui.GetStyle().GrabMinSize = 7.0
    imgui.GetStyle().GrabRounding = 20.0
    imgui.GetStyle().ChildWindowRounding = 6.0
    imgui.GetStyle().FrameRounding = 20.0

    colors[icol.Text]                   = ImVec4(0.11, 0.11, 0.11, 1.00);
    colors[icol.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00);
    colors[icol.WindowBg]               = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[icol.ChildWindowBg]          = ImVec4(0.13, 0.13, 0.13, 1.00);
    colors[icol.PopupBg]                = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.Border]                 = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.BorderShadow]           = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.FrameBg]                = ImVec4(0.26, 0.46, 0.82, 0.59);
    colors[icol.FrameBgHovered]         = ImVec4(0.26, 0.46, 0.82, 0.88);
    colors[icol.FrameBgActive]          = ImVec4(0.28, 0.53, 1.00, 1.00);
    colors[icol.TitleBg]                = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.TitleBgActive]          = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.TitleBgCollapsed]       = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.MenuBarBg]              = ImVec4(0.26, 0.46, 0.82, 0.75);
    colors[icol.ScrollbarBg]            = ImVec4(0.11, 0.11, 0.11, 1.00);
    colors[icol.ScrollbarGrab]          = ImVec4(0.26, 0.46, 0.82, 0.68);
    colors[icol.ScrollbarGrabHovered]   = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.ScrollbarGrabActive]    = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.ComboBg]                = ImVec4(0.26, 0.46, 0.82, 0.79);
    colors[icol.CheckMark]              = ImVec4(0.000, 0.000, 0.000, 1.000)
    colors[icol.SliderGrab]             = ImVec4(0.263, 0.459, 0.824, 1.000)
    colors[icol.SliderGrabActive]       = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[icol.Button]                 = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.ButtonHovered]          = ImVec4(0.26, 0.46, 0.82, 0.59);
    colors[icol.ButtonActive]           = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.Header]                 = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.HeaderHovered]          = ImVec4(0.26, 0.46, 0.82, 0.74);
    colors[icol.HeaderActive]           = ImVec4(0.26, 0.46, 0.82, 1.00);
    colors[icol.Separator]              = ImVec4(0.37, 0.37, 0.37, 1.00);
    colors[icol.SeparatorHovered]       = ImVec4(0.60, 0.60, 0.70, 1.00);
    colors[icol.SeparatorActive]        = ImVec4(0.70, 0.70, 0.90, 1.00);
    colors[icol.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[icol.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60);
    colors[icol.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90);
    colors[icol.CloseButton]            = ImVec4(0.90, 0.90, 0.90, 1.00);
    colors[icol.CloseButtonHovered]     = ImVec4(0.50, 0.50, 0.50, 0.60);
    colors[icol.CloseButtonActive]      = ImVec4(0.35, 0.35, 0.35, 1.00);
    colors[icol.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[icol.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[icol.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[icol.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00);
    colors[icol.TextSelectedBg]         = ImVec4(0.00, 0.00, 1.00, 0.35);
    colors[icol.ModalWindowDarkening]   = ImVec4(0.20, 0.20, 0.20, 0.35);
    if not main_window_state.v then
        imgui.Process = false
    end
    
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(500, 320), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

        imgui.Begin("Ghetto Helper", main_window_state) -- название окна

        imgui.RadioButton(u8"Грув", checked_band, 2)            -- название круга, переменная,
        imgui.SameLine()
        imgui.RadioButton(u8"Баллас", checked_band, 3)            -- название круга, переменная,
        imgui.SameLine()
        imgui.RadioButton(u8"Вагос", checked_band, 4)            -- название круга, переменная,
        imgui.SameLine()
        imgui.RadioButton(u8"Ацтек", checked_band, 5)            -- название круга, переменная,

        imgui.Separator()

        imgui.RadioButton(u8"Наказание 1/3", checked_NakNumber, 2)            -- название квадрата, переменная.
        imgui.RadioButton(u8"Наказание 2/3", checked_NakNumber, 3)            -- название квадрата, переменная.
        imgui.RadioButton(u8"Наказание 3/3", checked_NakNumber, 4)            -- название квадрата, переменная.

        imgui.Separator()

        imgui.RadioButton(u8"Jail", checked_jail, 2)            -- название квадрата, переменная.
        imgui.RadioButton(u8"Ban", checked_jail, 4)


        imgui.Combo(u8"Причина", combo_select, arr_cheat, #arr_cheat)




        if imgui.Button(u8"Наказать!") then
            if checked_jail.v == 2 then
                if checked_NakNumber.v == 2 then
                    nakaz = "[1/3]"
                elseif checked_NakNumber.v == 3 then
                    nakaz = "[2/3]"
                elseif checked_NakNumber.v == 4 then
                    nakaz = "[3/3]"
                end
                if checked_band.v == 2 then
                    band = "Вагос"
                elseif checked_band.v == 3 then
                    band = "Баллас"
                elseif checked_band.v == 4 then
                    band = "Вагос"
                elseif checked_band.v == 5 then
                    band = "Ацтек"
                end

                sampSendChat("/jail " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz)
            else
                if checked_NakNumber.v == 2 then
                    nakaz = "[1/3]"
                elseif checked_NakNumber.v == 3 then
                    nakaz = "[2/3]"
                elseif checked_NakNumber.v == 4 then
                    nakaz = "[3/3]"
                end
                if checked_band.v == 2 then
                    band = "Вагос"
                elseif checked_band.v == 3 then
                    band = "Баллас"
                elseif checked_band.v == 4 then
                    band = "Вагос"
                elseif checked_band.v == 5 then
                    band = "Ацтек"
                end
                sampSendChat("/ban " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz)
            end
        end
    end
    imgui.End()
end


function cmd_grul(arg)
	thread:run("grul")
end

function cmd_1(arg)
	thread:run("1")
end

function cmd_2(arg)
	thread:run("2")
end

function cmd_3(arg)
	thread:run("3")
end

function cmd_clans(arg)
	thread:run("clans")
end

function thread_ghetto(option)
	if option == "grul" then
		sampSendChat("/msg Уважаемые игроки, при виде нарушения на каптах, пожалйста пишите в репорт с тегом [GW].")
		wait(3000)
		sampSendChat("/msg Так же не забывайте правила: СК разрешено только с 0:59, если территория захвата прилегает...")
		wait(3000)
		sampSendChat("/msg к респе. Побег от смерти на респу и стрельба с респы, воспринимаются, как провокация на СК")
		wait(3000)
		sampSendChat("/msg На форуме в разделе [Всё о гетто] есть тема [Края Спавн-Килл зон на Gang War]")
	end
	if option == "1" then
		sampSendChat("/a Начинаю следить за гетто")
		wait (1000)
		sampSendChat("/time")
	end
	if option == "2" then
		sampSendChat("/a Продалжаю следить за гетто")
		wait (1000)
		sampSendChat("/time")
	end
	if option == "3" then
		sampSendChat("/a Заканчиваю следить за гетто")
		wait (1000)
		sampSendChat("/time")
	end
	if option == "clans" then
		sampSendChat("/msg Хотите создать свой клан и стать самой сильно группировкой на сервере?")
		wait(3000)
		sampSendChat("/msg Всю подробню информацию по кланам, Вы найдте на форуме в соответствующем разделе.")
	end
end
