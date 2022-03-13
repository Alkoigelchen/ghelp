

require "lib.moonloader" -- подключение библиотеки
local fa = require "fAwesome5"
local keys = require "vkeys"
local vkeys = require "vkeys"
local dlstatus = require('moonloader').download_statuslocal
local fa_font = nil
local inicfg = require 'inicfg'
local der = 'Ghelper.ini'

local tLastKeys = {} -- тут будут храниться предыдущие хоткеи при переактивации

latest = "1.3.7"
script_version ("1.3.7")

-- для выдачи наказаний через меню
local imgui = require 'imgui'
local sw, sh = getScreenResolution()
local main_window_state = imgui.ImBool(false)
local rkeys = require 'rkeys'
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey

local checked_kraska = imgui.ImInt(1)
local checked_band = imgui.ImInt(1)
local checked_jail = imgui.ImInt(1)
local combo_select = imgui.ImInt(0)
local sampev = require 'lib.samp.events'
local checked_NakNumber = imgui.ImInt(1)

local ids = -1 -- для получения ида во время слежки

-- массивы для выдачи накаханий и покраски территорий.
local arr_cheat = {"30 Aimbot", "30 WallHack", "10 Spread", "15 auto+c", "30 Saim", "30 Damager", "10 Extra WS", "45 Provo na sk", "30 SK", "10 Fly", "20 AirBreak", "15 Flycar", "10 Speedhack", '30 Bagouse', "10 Uhod ot smerti", "20 Pomeha carom", "20 DriveBy"}
local arr_gw = {"3/3", "Salo", "Damager", ("Obmen kuska"), 'Obmen obreza'}


local maincfg = inicfg.load({
	config = {
		tifloppa = true
	},

	hotkeys = {
		bindText = VK_F3
	},
	acfg =
	{
		lvl = 0
	},
		Style = {
		theme = 0
	}
},'GHelper.ini')
inicfg.save(maincfg, der)


local encoding = require "encoding"
encoding.default = 'CP1251'
u8 = encoding.UTF8
local theme = imgui.ImInt(maincfg.Style.theme)

		local tema = {
			u8'Фиолетовая тема',
			u8'Тёмно-Красная тема',
			u8'Тёмно-Зелёная тема',
			u8'Зеленая тема',
			u8'Глубая тема'
		}

		local ActiveClockMenu = {
	v = decodeJson(maincfg.hotkeys.bindClock)
}

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
					    end
	 if fontsize == nil then
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 35.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
    end
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
		autoupdate("https://raw.githubusercontent.com/ValeriiVavilin/ghelp/main/update.json", '['..string.upper(thisScript().name)..']: ', "vk.com/alkoigel")
		sampAddChatMessage("{ff4a4a}[GHelper] {FFFFFF}Успешно загружен. Активация - " .. vkeys.key_names[maincfg.hotkeys.bindText], -1)

	    thread = lua_thread.create_suspended(thread_ghetto)

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(rid)

    imgui.Process = false

		sampRegisterChatCommand("gh", cmd_gh)
		sampRegisterChatCommand("1", cmd_1)
		sampRegisterChatCommand("2", cmd_2)
		sampRegisterChatCommand("3", cmd_3)
		sampRegisterChatCommand("clans", cmd_clans)
		sampRegisterChatCommand("grul", cmd_grul)
		sampRegisterChatCommand('test', cmd_test)
    hotkeys = {
      bindText                    = { name = vkeys.key_names[maincfg.hotkeys.bindText],                 edit = false, ticked = os.clock(), tickedState = false, sName =
       "- Активация скрипта"                        }  }

    while true do
        wait(0)
				if isKeyJustPressed(maincfg.hotkeys.bindText) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
					cmd_gh()
				end
 imgui.Process = main_window_state.v
	end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if dialogId == 0 then
		adminLevel = text:match('Уровень: (%d)')
		ab = adminLevel:gsub('%D+','')
        print(ab)
        maincfg.acfg.lvl = ab
        if inicfg.save(maincfg, der) then end
	end
end

function sampev.onTogglePlayerSpectating(state)
    if state then
        specc = true
    else
        specc = false
    end
end

function sampev.onSpectatePlayer(id, type)
    if specc then
        ids = id
    end
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
		sampSendChat("/msg Уважаемые игроки, при виде нарушения на каптах, пожалуйста пишите в репорт с тегом [GW].")
		wait(3000)
		sampSendChat("/msg Так же не забывайте правила: СК разрешено только с 0:45. Ответ на провокацию под запретом.")
		wait(3000)
		sampSendChat("/msg Побег от смерти на респу и стрельба с респы, воспринимаются, как провокация на СК")
		wait(3000)
		sampSendChat("/msg На форуме в разделе [Всё о гетто] есть тема [Края Спавн-Килл зон на Gang War]")
		wait(3000)
		sampSendChat("/msg Просьба просмотреть данную тему, дабы не получать наказания")
	end
	if option == "1" then
		sampSendChat("/a [Следящий за Ghetto] Начинаю следить за каптуром")
		wait (1000)
		sampSendChat("/time")
        wait (1000)
        setVirtualKeyDown(VK_F8, true)
        setVirtualKeyDown(VK_F8, false)
	end
	if option == "2" then
		sampSendChat("/a [Следящий за Ghetto] Продолжаю следить за каптуром")
		wait (1000)
		sampSendChat("/time")
        wait (1000)
        setVirtualKeyDown(VK_F8, true)
        setVirtualKeyDown(VK_F8, false)
	end
	if option == "3" then
		sampSendChat("/a [Следящий за Ghetto] Заканчиваю следить за каптуром")
		wait (1000)
		sampSendChat("/time")
        wait (1000)
        setVirtualKeyDown(VK_F8, true)
        setVirtualKeyDown(VK_F8, false)
	end
	if option == "clans" then
		sampSendChat("/msg Хотите создать свой клан и стать самой сильно группировкой на сервере?")
		wait(3000)
		sampSendChat("/msg Всю подробню информацию по кланам, Вы найдте на форуме в соответствующем разделе.")
	end
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX( width / 50 - calc.x / 50 )
	imgui.Text(text)
end

local tab = imgui.ImInt(1)
local tabs = {
fa.ICON_FA_GLOBE_ASIA..u8' Выдача наказаний',
fa.ICON_FA_PALETTE..u8' Краска территорий',
fa.ICON_FA_SWATCHBOOK..u8' Меню управления',
fa.ICON_FA_COGS..u8' Настройки',
}

-- labels - Array - названия элементов меню
-- selected - imgui.ImInt() - выбранный пункт меню
-- size - imgui.ImVec2() - размер элементов
-- speed - float - скорость анимации выбора элемента (необязательно, по стандарту - 0.2)
-- centering - bool - центрирование текста в элементе (необязательно, по стандарту - false)
function imgui.CustomMenu(labels, selected, size, speed, centering)
    local bool = false
    speed = speed and speed or 0.2
    local radius = size.y * 0.50
    local draw_list = imgui.GetWindowDrawList()
    if LastActiveTime == nil then LastActiveTime = {} end
    if LastActive == nil then LastActive = {} end
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    for i, v in ipairs(labels) do
        local c = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
        if imgui.InvisibleButton(v..'##'..i, size) then
            selected.v = i
            LastActiveTime[v] = os.clock()
            LastActive[v] = true
            bool = true
        end
        imgui.SetCursorPos(c)
        local t = selected.v == i and 1.0 or 0.0
        if LastActive[v] then
            local time = os.clock() - LastActiveTime[v]
            if time <= 0.3 then
                local t_anim = ImSaturate(time / speed)
                t = selected.v == i and t_anim or 1.0 - t_anim
            else
                LastActive[v] = false
            end
        end
        local col_bg = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0,0,0,0))
        local col_box = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.ImVec4(0,0,0,0))
        local col_hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        local col_hovered = imgui.GetColorU32(imgui.ImVec4(col_hovered.x, col_hovered.y, col_hovered.z, (imgui.IsItemHovered() and 0.2 or 0)))
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + t * size.x, p.y + size.y), col_bg, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + size.x, p.y + size.y), col_hovered, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x+5, p.y + size.y), col_box)
        imgui.SetCursorPos(imgui.ImVec2(c.x+(centering and (size.x-imgui.CalcTextSize(v).x)/2 or 15), c.y+(size.y-imgui.CalcTextSize(v).y)/2))
        imgui.Text(v)
        imgui.SetCursorPos(imgui.ImVec2(c.x, c.y+size.y))
    end
    return bool
end
function cmd_gh()
main_window_state.v = not main_window_state.v
imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()

	if maincfg.Style.theme == 0 then theme0() end
	if maincfg.Style.theme == 1 then theme1() end
	if maincfg.Style.theme == 2 then theme2() end
	if maincfg.Style.theme == 3 then theme3() end
	if maincfg.Style.theme == 4 then theme4() end

	if not main_window_state.v then
			imgui.Process = false
	end
	if main_window_state.v then
		imgui.ShowCursor = true
		local X, Y = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(625, 320), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(X / 2, Y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin("GHelper", main_window_state, imgui.WindowFlags.NoResize)

		imgui.PushFont(fontsize)
		imgui.CenterText('GHelper')
		imgui.PopFont()
		imgui.SetCursorPos(imgui.ImVec2(0, 70))
		if imgui.CustomMenu(tabs, tab, imgui.ImVec2(135, 37)) then print('Вы переключили меню на пункт '..tab.v) end
		imgui.SetCursorPos(imgui.ImVec2(150, 35))
		imgui.BeginChild('##main', imgui.ImVec2(468, 280), true)
		if tab.v == 1 then
			imgui.RadioButton(u8"Грув", checked_band, 2) -- название круга, переменная,
			imgui.SameLine()
			imgui.RadioButton(u8"Баллас", checked_band, 3) -- название круга, переменная,
			imgui.SameLine()
			imgui.RadioButton(u8"Вагос", checked_band, 4)-- название круга, переменная,
			imgui.SameLine()
			imgui.RadioButton(u8"Ацтек", checked_band, 5) -- название круга, переменная,

			imgui.Separator()

			imgui.RadioButton(u8"Наказание 1/3", checked_NakNumber, 2)-- название квадрата, переменная.
			imgui.RadioButton(u8"Наказание 2/3", checked_NakNumber, 3)-- название квадрата, переменная.
			imgui.RadioButton(u8"Наказание 3/3", checked_NakNumber, 4) -- название квадрата, переменная.

			imgui.Separator()

			imgui.RadioButton(u8"Jail", checked_jail, 2) -- название квадрата, переменная.
			imgui.RadioButton(u8"Ban", checked_jail, 4)

			imgui.Combo(u8"Причина", combo_select, arr_cheat, #arr_cheat)

			if imgui.Button(u8"Наказать!") then
				if checked_jail.v == 2 then
					if checked_NakNumber.v == 2 then
						nakaz = "1/3"
					elseif checked_NakNumber.v == 3 then
						nakaz = "2/3"
					elseif checked_NakNumber.v == 4 then
						nakaz = "3/3"
						wait(100)
							if maincfg.acfg.lvl < 2 then  sampSendChat("/a /scapt 3/3")
							else
								sampSendChat('/scapt 3/3')
							end
					end
					if checked_band.v == 2 then
						band = "Грув"
					elseif checked_band.v == 3 then
						band = "Баллас"
					elseif checked_band.v == 4 then
						band = "Вагос"
					elseif checked_band.v == 5 then
						band = "Ацтек"
					end
						if maincfg.acfg.lvl < 2 then  sampSendChat("/a /jail " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz)
					else sampSendChat("/jail " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz) end
				else
					if checked_NakNumber.v == 2 then
						nakaz = "1/3"
					elseif checked_NakNumber.v == 3 then
						nakaz = "2/3"
					elseif checked_NakNumber.v == 4 then
						nakaz = "3/3"
						wait(100)
						sampSendChat('/scapt 3/3')
					end
					if checked_band.v == 2 then
						band = "Грув"
					elseif checked_band.v == 3 then
						band = "Баллас"
					elseif checked_band.v == 4 then
						band = "Вагос"
					elseif checked_band.v == 5 then
						band = "Ацтек"
					end
						if maincfg.acfg.lvl < 3 then  sampSendChat("/a /ban " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz)
						elseif maincfg.acfg.lvl == 3 then sampSendChat("/ban " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz)
						else sampSendChat("/cban " .. ids .. " " .. arr_cheat[combo_select.v + 1] .. " " .. band .. " " .. nakaz) end
				end
			end
		end
		if tab.v == 2 then
				imgui.Text(u8"Выберите банду которой вы отдаете территорию.")
				imgui.RadioButton(u8"Грув", checked_kraska, 2) -- название круга, переменная,
				imgui.SameLine()
				imgui.RadioButton(u8"Баллас", checked_kraska, 3) -- название круга, переменная,
				imgui.SameLine()
				imgui.RadioButton(u8"Вагос", checked_kraska, 4) -- название круга, переменная,
				imgui.SameLine()
				imgui.RadioButton(u8"Ацтек", checked_kraska, 5)
			imgui.Separator()
			if imgui.Button(u8"Покрасить за 3/3!",imgui.ImVec2(200, 30)) then
				if checked_kraska.v == 2 then
					kraska = "1"
					elseif checked_kraska.v == 3 then
					kraska = "2"
					elseif checked_kraska.v == 4 then
					kraska = "3"
					elseif checked_kraska.v == 5 then
					kraska = "4"
				end
			if maincfg.acfg.lvl < 5 then  sampAddChatMessage("{ff4a4a}[GHelper] {FFFFFF}: Данное действие доступно с 5го уровня.", -1)
				else sampSendChat("/changegz " .. kraska .. " 3/3", -1) end
			end
			imgui.SameLine()
			if imgui.Button(u8"Покрасить за silent aimbot!",imgui.ImVec2(200, 30)) then
				if checked_kraska.v == 2 then
					kraska = "1"
				elseif checked_kraska.v == 3 then
					kraska = "2"
				elseif checked_kraska.v == 4 then
					kraska = "3"
				elseif checked_kraska.v == 5 then
					kraska = "4"
				end
				if maincfg.acfg.lvl < 5 then  sampAddChatMessage("{ff4a4a}[GHelper] {FFFFFF}: Данное действие доступно с 5го уровня.", -1)
				else sampSendChat("/changegz " .. kraska .. " сало", -1) end
			end
			if imgui.Button(u8"Покрасить за дамагер!",imgui.ImVec2(200, 30)) then
				if checked_kraska.v == 2 then
					kraska = "1"
				elseif checked_kraska.v == 3 then
					kraska = "2"
				elseif checked_kraska.v == 4 then
					kraska = "3"
				elseif checked_kraska.v == 5 then
					kraska = "4"
				end
				if maincfg.acfg.lvl < 5 then  sampAddChatMessage("{ff4a4a}[GHhelper] {FFFFFF}: Данное действие доступно с 5го уровня.", -1)
				else sampSendChat("/changegz " .. kraska .. " дамагер", -1) end
			end
			imgui.SameLine()
			if imgui.Button(u8"Обменять кусок.",imgui.ImVec2(200, 30)) then
				if checked_kraska.v == 2 then
					kraska = "1"
				elseif checked_kraska.v == 3 then
					kraska = "2"
				elseif checked_kraska.v == 4 then
					kraska = "3"
				elseif checked_kraska.v == 5 then
					kraska = "4"
				end
				if maincfg.acfg.lvl < 5 then  sampAddChatMessage("{ff4a4a}[Ghelper] {FFFFFF}: Данное действие доступно с 5го уровня.", -1)
				else sampSendChat("/changegz " .. kraska .. " Обмен куска", -1) end
			end
			if imgui.Button(u8"Обменять обрез.",imgui.ImVec2(200, 30)) then
				if checked_kraska.v == 2 then
					kraska = "1"
				elseif checked_kraska.v == 3 then
					kraska = "2"
				elseif checked_kraska.v == 4 then
					kraska = "3"
				elseif checked_kraska.v == 5 then
					kraska = "4"
				end
				if maincfg.acfg.lvl < 5 then  sampAddChatMessage("{ff4a4a}[Ghelper] {FFFFFF}: Данное действие доступно с 5го уровня.", -1)
				else sampSendChat("/changegz " .. kraska .. " Обмен обреза", -1) end
			end
		end

		if tab.v == 3 then
			if imgui.Button(u8"Рассказать о правилах каптура", imgui.ImVec2(200, 30)) then
				cmd_grul()
			end
			imgui.SameLine()
			if imgui.Button(u8"Рассказать о создании кланов", imgui.ImVec2(200, 30)) then
				cmd_clans()
			end
			imgui.Separator()
			imgui.Combo(u8"Причина", combo_select, arr_gw, #arr_gw)
			if imgui.Button(u8"Остановить капт") then
				if maincfg.acfg.lvl < 2 then  sampSendChat("/a /scapt " .. arr_gw[combo_select.v + 1])
				else sampSendChat("/scapt " .. arr_gw[combo_select.v + 1]) end
			end
		end
		if tab.v == 4 then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
        imgui.Text(fa.ICON_FA_USER_CIRCLE.. u8' Автор:')
        imgui.SameLine()
        imgui.TextDisabled('Alkoigel')

        if imgui.IsItemClicked(0) then
            imgui.OpenPopup(u8'Автор: Alkoigel')
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
                imgui.Text(u8' Тыкай если интересно')
            imgui.EndTooltip()
        end

        if imgui.BeginPopupModal(u8'Автор: Alkoigel', imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
            imgui.SetWindowSize(imgui.ImVec2(170, 110))
            imgui.SetCursorPosX(5)
            if imgui.Button('VK', imgui.ImVec2(50, 50)) then os.execute('explorer "https://vk.com/alkoigel"') end; imgui.SameLine()
            imgui.SetCursorPosX(60)
            if imgui.Button('VK', imgui.ImVec2(50, 50)) then os.execute('explorer "https://vk.com/Alkoigel"') end; imgui.SameLine()
            imgui.SetCursorPosX(115)
            if imgui.Button(u8'VK', imgui.ImVec2(50, 50)) then os.execute('explorer "https://vk.com/alkoigel"') end; imgui.SetCursorPosX(5)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(160, 20)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
imgui.SetCursorPos(imgui.ImVec2(10, 25))
        imgui.Text(fa.ICON_FA_USER_TIE.. u8' Разработчик:')
        imgui.SameLine()
        imgui.TextDisabled('Alkoigel, Ragadqa')

        if imgui.IsItemClicked(0) then
            imgui.OpenPopup(u8'Разработчик: Alkoigel, Ragadqa')
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
                imgui.Text(u8' Тыкай если интересно')
            imgui.EndTooltip()
        end
		if imgui.BeginPopupModal(u8'Разработчик: Alkoigel, Ragadqa', imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
            imgui.SetWindowSize(imgui.ImVec2(190, 110))
            imgui.SetCursorPosX(5)
            if imgui.Button('Alkoigel', imgui.ImVec2(55, 50)) then os.execute('explorer "https://vk.com/alkoigel"') end; imgui.SameLine()
            imgui.SetCursorPosX(65)
            if imgui.Button('ragadqa', imgui.ImVec2(60, 50)) then os.execute('explorer "https://vk.com/ragadqa"') end; imgui.SameLine()
            imgui.SetCursorPosX(130)
            if imgui.Button(u8'VK', imgui.ImVec2(55, 50)) then os.execute('explorer "https://vk.com/monser_dev"') end; imgui.SetCursorPosX(5)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(190, 20)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
        imgui.SetCursorPos(imgui.ImVec2(10, 40))
        imgui.Text(fa.ICON_FA_EXCLAMATION_TRIANGLE.. u8' Версия:')
        imgui.SameLine()
        imgui.TextDisabled('1.3.7')

		imgui.SetCursorPos(imgui.ImVec2(10, 55))
		imgui.Text(fa.ICON_FA_BOOK.. u8' Лог обновлений: ')
        imgui.SameLine()
        imgui.TextDisabled(u8'Кликабельно')

        if imgui.IsItemClicked(0) then
            imgui.OpenPopup(u8'Лог обновлений')
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
			imgui.Text(u8'Нажмите для просмотра')
            imgui.EndTooltip()
        end

        if imgui.BeginPopupModal(u8'Лог обновлений', imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize) then
            imgui.SetWindowSize(imgui.ImVec2(400, 445))
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Обновление: 1.1.0')
			imgui.PopFont()
			imgui.CenterText(u8'- Релиз')
			imgui.TextWrapped(u8'- Теперь скрипт автоматически делает скриншот после начала слежки за гетто')
			imgui.CenterText(u8'- Пофикшены баги')
			imgui.CenterText(u8'- Добавлены новые пункты в F3 меню')
			imgui.TextWrapped(u8'- Некоторые значения в таблице F3 теперь пишутся на русском языке')
			imgui.CenterText(u8'- Добавлена команда /kraska ')
			imgui.Text('\n')
			imgui.SetCursorPosX(5)
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Обновление: 1.2.0')
			imgui.PopFont()
			imgui.CenterText(u8'- Полностью переработано меню скрипта')
			imgui.CenterText(u8'- Добавление иконок')
			imgui.CenterText(u8'- Фикс багов')
			imgui.TextWrapped(u8'- Теперь можно самому ставить кнопку для активации скрипта')
			imgui.CenterText(u8'- Обновлен стиль скрипта')
			imgui.CenterText(u8'- Добавлена таблица наказаний')
			imgui.CenterText(u8'- Добавлено несколько стилей имгуи')
			imgui.CenterText(u8'- Обновлены бинды для msg')
			imgui.Text('\n')
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Обновление: 1.3.0')
			imgui.PopFont()
			imgui.CenterText(u8'- Реализация работы на любом уровне')
			imgui.Text('\n')
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Обновление: 1.3.5')
			imgui.PopFont()
			imgui.CenterText(u8'- Устранение багов')
			imgui.PushFont(fontsize)
			imgui.Text('\n')
			imgui.CenterText(u8'Обновление: 1.3.6')
			imgui.PopFont()
			imgui.CenterText(u8'- Теперь при входе в игру скрипт пишет клавишу активции не F3,')
			imgui.CenterText(u8'а ту которую выбрали Вы.')
			imgui.CenterText(u8'- Поправлены ссылки на разработчиков')
			imgui.SetCursorPosX(110)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(170, 25)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
				imgui.SetCursorPos(imgui.ImVec2(10, 70))
		imgui.Text(fa.ICON_FA_GRADUATION_CAP.. u8' Таблица наказаний: ')
        imgui.SameLine()
        imgui.TextDisabled(u8'Кликабельно')

        if imgui.IsItemClicked(0) then
            imgui.OpenPopup(u8'Таблица наказаний')
        end
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
			imgui.Text(u8'Нажмите для просмотра')
            imgui.EndTooltip()
        end

        if imgui.BeginPopupModal(u8'Таблица наказаний', imgui.WindowFlags.NoResize) then
      imgui.SetWindowSize(imgui.ImVec2(500, 600))
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Гетто:')
			imgui.PopFont()
			imgui.TextWrapped(u8'- DriveBy — /kick, /jail на 20 минут (если вы наехали случайно - не считается за ДБ. Наезд машиной на игрока и оставить авто на нем - массовое ДБ.)')
			imgui.CenterText(u8'- SpawnKill — /jail на 30 минут')
			imgui.CenterText(u8'- TeamKill — /jail на 30 минут')
			imgui.CenterText(u8'- Помеха транспортом на капте - /jail на 30 минут')
			imgui.TextWrapped(u8'- Багоюз(прыжок на колесико мыши на велосипеде) - /jail 30 минут(Нельзя забираться на труднодоступные крыши).')
			imgui.CenterText(u8'- Помеха капту — /kick/ /jail 10 минут')
			imgui.CenterText(u8'- Каптить куском/обрезом - /jail на 10 минут')
			imgui.CenterText(u8'- Провокация на СК - /jail на 30-60 минут')
			imgui.CenterText(u8'- Слив территорий банд - /jail на 120 минут')
			imgui.CenterText(u8'- Офф от смерти (перезаход на децеле /gw, /dm и т.д.) - /jail на 30 минут')
			imgui.Text('\n')
			imgui.SetCursorPosX(5)
			imgui.PushFont(fontsize)
			imgui.CenterText(u8'Остальное:')
			imgui.PopFont()
			imgui.CenterText(u8'- Использование макросов на +C — /ban 5 дней')
			imgui.CenterText(u8'- SpeedHack — /ban 10 дней, при нанесении вреда серверу - 20-30 дней')
			imgui.CenterText(u8'- Коллизия — /ban на 10 дней')
			imgui.CenterText(u8'- Метла — /ban на 10 дней')
			imgui.CenterText(u8'- Телепортация — /ban на 15 дней')
			imgui.CenterText(u8'- GodMode — /ban (/cban) на 30 дней')
			imgui.CenterText(u8'- GodMode car — /ban на 20 дней')
			imgui.CenterText(u8'- Aim — /ban (/cban) на 30 дней')
			imgui.CenterText(u8'- WallHack — /ban на 20 дней')
			imgui.CenterText(u8'- Sobeit — /ban (/cban) на 20 дней, при нанесении вреда серверу - 30 дней')
			imgui.CenterText(u8'- Рванка — /ban (/cban) 30 дней, удаление аккаунта.')
			imgui.CenterText(u8'- Spider — /ban на 3 дня')
			imgui.CenterText(u8'- Spread — /ban 15 дней')
			imgui.CenterText(u8'- Dgun — /ban (/cban) на 30 дней')
			imgui.CenterText(u8'- AirBrake — /ban на 20 дней')
			imgui.CenterText(u8'- Antistun — блокировка игрового аккаунта на 10 дней')
			imgui.TextWrapped(u8'- Cleo Slap — /ban на 3 дня, использование в целях получения материальной выгоды - 10 дней.')
			imgui.CenterText(u8'- Cleo +C — /ban на 15 дней')
			imgui.CenterText(u8'- Extra WS — /ban на 10 дней')
			imgui.CenterText(u8'- Антипадение с байка — /ban на 3 дня')
			imgui.TextWrapped(u8'- CamHack — /ban на 3 дня (можно использовать с одобрения главной администрации).')
			imgui.CenterText(u8'- Админ-чекер — /ban на 3 дня')
			imgui.CenterText(u8'- Cleo анимации — не наказываем, если не имеет преимущества, /ban на 3 дня.')
			imgui.TextWrapped(u8'- Cleo Fake Death — /ban на 5 дней, /ban на 30 дней (в случае подставы с занесением в черный список сервера).')
			imgui.CenterText(u8'- Cleo Spawn Vehicle — /ban 5 дней')
			imgui.CenterText(u8'- Cleo Crashes.asi — v.2.51 разрешен. Более ранние версии - /ban на 5 дней.')
			imgui.CenterText(u8'- Anti-AFK — /ban на 5 дней.')
			imgui.CenterText(u8'- Турбомаркус (B1-B6) - /ban на 10 дней')
			imgui.CenterText(u8'- Автохил - /ban 15 дней')
			imgui.CenterText(u8'- fly - /ban 15 дней')
			imgui.CenterText(u8'- Invisible - /ban 15 дней')
			imgui.CenterText(u8'- Noreload - /ban 20 дней')
			imgui.CenterText(u8'- AutoReconnect - /ban 5 дней')
			imgui.CenterText(u8'- Клео сбив(cleo sbiv) Любого вида - /ban 5 дней')
			imgui.CenterText(u8'- Угроза разноса сервера - /banip 30 дней')
			imgui.CenterText(u8'- Cleo jump(прыжок) - /ban на 10 дней')
			imgui.CenterText(u8'- Sprinthook - /ban 15 дней.')
			imgui.SetCursorPosX(160)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(170, 25)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
	imgui.Separator()
	        for k,v in pairs(hotkeys) do
          if v.edit then
            local downKey = getDownKeys()
            maincfg.hotkeys[k] = downKey
            if downKey == '' then
              if os.clock() - v.ticked > 0.5 then
                v.ticked = os.clock()
                v.tickedState = not v.tickedState
              end
              v.name = v.tickedState and "No" or "##isNo "..v.ticked
            else
              v.name = vkeys.key_names[maincfg.hotkeys[k]]
              v.edit = false
              inicfg.save(maincfg, 'GHelper.ini')
            end
          end
          if imgui.Button(u8(tostring(maincfg.hotkeys[k] == nil and "Отсутствует".."##"..k or v.name.."##"..k)), imgui.ImVec2(110, 0)) then
            v.edit = true
          end imgui.SameLine() imgui.Text(u8(v.sName))
        end
		imgui.Separator()
		imgui.Text(fa.ICON_FA_ADJUST..u8' Темы скрипта')

		if imgui.Combo(u8'##Temi', theme, tema, -1)then
			maincfg.Style.theme = theme.v
			inicfg.save(maincfg, 'GHelper.ini')
		end
	end
		imgui.EndChild()
		imgui.End()
	end
end

function getDownKeys()
    local curkeys = ""
    local bool = false
    for k,v in pairs(vkeys) do
        if isKeyDown(v) then
            curkeys = v
            bool = true
        end
    end
    return curkeys, bool
end

function checkDownKey()
    local bool = false
    for k,v in pairs(vkeys) do
        if isKeyDown(v) then
            bool = true
        end
    end
    return bool
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
end

function theme0()
		imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4

		style.WindowPadding = imgui.ImVec2(8, 8)
		style.WindowRounding = 6
		style.ChildWindowRounding = 5
		style.FramePadding = imgui.ImVec2(5, 3)
		style.FrameRounding = 3.0
		style.ItemSpacing = imgui.ImVec2(5, 4)
		style.ItemInnerSpacing = imgui.ImVec2(4, 4)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 8
		style.GrabRounding = 1
		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

	colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00);
	colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
	colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
	colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
	colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
	colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
	colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
	colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
	colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
	colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end

function theme1()
		imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4

		style.WindowPadding = imgui.ImVec2(8, 8)
		style.WindowRounding = 6
		style.ChildWindowRounding = 5
		style.FramePadding = imgui.ImVec2(5, 3)
		style.FrameRounding = 3.0
		style.ItemSpacing = imgui.ImVec2(5, 4)
		style.ItemInnerSpacing = imgui.ImVec2(4, 4)
		style.IndentSpacing = 21
		style.ScrollbarSize = 10.0
		style.ScrollbarRounding = 13
		style.GrabMinSize = 8
		style.GrabRounding = 1
		style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
		style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

		colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
	end


	function theme2()
			imgui.SwitchContext()
			local style = imgui.GetStyle()
			local colors = style.Colors
			local clr = imgui.Col
			local ImVec4 = imgui.ImVec4

			style.WindowPadding = imgui.ImVec2(8, 8)
			style.WindowRounding = 6
			style.ChildWindowRounding = 5
			style.FramePadding = imgui.ImVec2(5, 3)
			style.FrameRounding = 3.0
			style.ItemSpacing = imgui.ImVec2(5, 4)
			style.ItemInnerSpacing = imgui.ImVec2(4, 4)
			style.IndentSpacing = 21
			style.ScrollbarSize = 10.0
			style.ScrollbarRounding = 13
			style.GrabMinSize = 8
			style.GrabRounding = 1
			style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
			style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

			colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
	    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
	    colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
	    colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
	    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
	    colors[clr.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
	    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	    colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
	    colors[clr.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
	    colors[clr.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
	    colors[clr.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
	    colors[clr.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
	    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
	    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
	    colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
	    colors[clr.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
	    colors[clr.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
	    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
	    colors[clr.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
	    colors[clr.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
	    colors[clr.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
	    colors[clr.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
	    colors[clr.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
	    colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
	    colors[clr.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
	    colors[clr.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
	    colors[clr.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
	    colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
	    colors[clr.CloseButton]            = ImVec4(0.00, 0.82, 0.39, 1.00)
	    colors[clr.CloseButtonHovered]     = ImVec4(0.00, 0.88, 0.42, 1.00)
	    colors[clr.CloseButtonActive]      = ImVec4(0.00, 1.00, 0.48, 1.00)
	    colors[clr.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
	    colors[clr.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
	    colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
	    colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
	    colors[clr.ModalWindowDarkening]   = ImVec4(0.17, 0.17, 0.17, 0.48)
		end


			function theme3()
			imgui.SwitchContext()
			local style = imgui.GetStyle()
			local colors = style.Colors
			local clr = imgui.Col
			local ImVec4 = imgui.ImVec4

			style.WindowPadding = imgui.ImVec2(8, 8)
			style.WindowRounding = 6
			style.ChildWindowRounding = 5
			style.FramePadding = imgui.ImVec2(5, 3)
			style.FrameRounding = 3.0
			style.ItemSpacing = imgui.ImVec2(5, 4)
			style.ItemInnerSpacing = imgui.ImVec2(4, 4)
			style.IndentSpacing = 21
			style.ScrollbarSize = 10.0
			style.ScrollbarRounding = 13
			style.GrabMinSize = 8
			style.GrabRounding = 1
			style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
			style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

			colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 0.78)
            colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00)
            colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
            colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00)
            colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg]              = ImVec4(0.25, 0.29, 0.20, 1.00)
            colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00)
            colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
            colors[clr.TitleBg]              = ImVec4(0.09, 0.12, 0.14, 0.65)
            colors[clr.TitleBgActive]        = ImVec4(0.35, 0.58, 0.06, 1.00)
            colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
            colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
            colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
            colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
            colors[clr.ComboBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
            colors[clr.CheckMark]            = ImVec4(0.72, 1.00, 0.28, 1.00)
            colors[clr.SliderGrab]           = ImVec4(0.43, 0.57, 0.05, 1.00)
            colors[clr.SliderGrabActive]     = ImVec4(0.55, 0.67, 0.15, 1.00)
            colors[clr.Button]               = ImVec4(0.40, 0.57, 0.01, 1.00)
            colors[clr.ButtonHovered]        = ImVec4(0.45, 0.69, 0.07, 1.00)
            colors[clr.ButtonActive]         = ImVec4(0.27, 0.50, 0.00, 1.00)
            colors[clr.Header]               = ImVec4(0.20, 0.25, 0.29, 0.55)
            colors[clr.HeaderHovered]        = ImVec4(0.72, 0.98, 0.26, 0.80)
            colors[clr.HeaderActive]         = ImVec4(0.74, 0.98, 0.26, 1.00)
            colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
            colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
            colors[clr.ResizeGrip]           = ImVec4(0.68, 0.98, 0.26, 0.25)
            colors[clr.ResizeGripHovered]    = ImVec4(0.72, 0.98, 0.26, 0.67)
            colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
            colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
            colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
            colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
            colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
            colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
		end


					function theme4()
			imgui.SwitchContext()
			local style = imgui.GetStyle()
			local colors = style.Colors
			local clr = imgui.Col
			local ImVec4 = imgui.ImVec4

			style.WindowPadding = imgui.ImVec2(8, 8)
			style.WindowRounding = 6
			style.ChildWindowRounding = 5
			style.FramePadding = imgui.ImVec2(5, 3)
			style.FrameRounding = 3.0
			style.ItemSpacing = imgui.ImVec2(5, 4)
			style.ItemInnerSpacing = imgui.ImVec2(4, 4)
			style.IndentSpacing = 21
			style.ScrollbarSize = 10.0
			style.ScrollbarRounding = 13
			style.GrabMinSize = 8
			style.GrabRounding = 1
			style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
			style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

			colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
			colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
			colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
			colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
			colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
			colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
			colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
			colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
			colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
			colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
			colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
			colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
			colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
			colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
			colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
			colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
			colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
			colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
		end

function autoupdate(json_url, prefix, url)
		  local dlstatus = require('moonloader').download_status
		  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
		  if doesFileExist(json) then os.remove(json) end
		  downloadUrlToFile(json_url, json,
		    function(id, status, p1, p2)
		      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		        if doesFileExist(json) then
		          local f = io.open(json, 'r')
		          if f then
		            local info = decodeJson(f:read('*a'))
		            updatelink = info.updateurl
		            updateversion = info.latest
		            f:close()
		            os.remove(json)
		            if updateversion ~= thisScript().version then
		              lua_thread.create(function(prefix)
		                local dlstatus = require('moonloader').download_status
		                local color = -1
		                sampAddChatMessage(('{0000FF}[Ghelper]: {FFFFFF}Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
		                wait(250)
		                downloadUrlToFile(updatelink, thisScript().path,
		                  function(id3, status1, p13, p23)
		                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
		                      print(string.format('Загружено %d из %d.', p13, p23))
		                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
		                      print('Загрузка обновления завершена.')
		                      sampAddChatMessage(('{0000FF}[Ghelper]: {FFFFFF}Обновление завершено!'), color)
		                      goupdatestatus = true
		                      lua_thread.create(function() wait(500) thisScript():reload() end)
		                    end
		                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
		                      if goupdatestatus == nil then
		                        sampAddChatMessage(('{0000FF}[Ghelper]: {FFFFFF}Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
		                        update = false
		                      end
		                    end
		                  end
		                )
		                end, prefix
		              )
		            else
		              update = false
		              print('v'..thisScript().version..': Обновление не требуется.')
		            end
		          end
		        else
		          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
		          update = false
		        end
		      end
		    end
		  )
		  while update ~= false do wait(100) end
		end
