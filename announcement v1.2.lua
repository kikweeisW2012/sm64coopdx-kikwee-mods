-- name: \\#FFA500\\Announcements v1.2
-- description: \\#FFA500\\use /a (text) for custom announcements for your server \\#FFFFFF\\By: \\#00faf6\\   k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

--sync--
if not gGlobalSyncTable.announcementTimer then
    gGlobalSyncTable.announcementTimer = 0
end

--variables--
local POPUP_DURATION = 6 * 60 -- 15 seconds at 60 FPS
local D_JPAD = 0x0400

--command--
local function mario_update(m)
    
    if m.playerIndex ~= 0 then return end

end

local function on_announcement_command(msg)
    
    local text = string.sub(msg, 1) 
    
    
    if text and text ~= "" then
        gGlobalSyncTable.announcementMessage = text
        gGlobalSyncTable.announcementTimer = POPUP_DURATION
        return true 
    else
        djui_chat_message_create("Usage: /a (your message here)")
        return true
    end
end

--timer+hud--
local function on_hud_render()
    if gGlobalSyncTable.announcementTimer > 0 then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_MENU)
        djui_hud_set_color(255, 255, 255, 255)

        local text = gGlobalSyncTable.announcementMessage
        local scale = 0.2

        -- Break text into lines of 54 characters max
        local lines = {}
        for i = 1, #text, 54 do
            table.insert(lines, string.sub(text, i, i + 53))
        end

        -- Get screen info
        local screen_width = djui_hud_get_screen_width()
        local screen_height = djui_hud_get_screen_height()

        -- Start Y at top area (like your original)
        local start_y = screen_height / 8  

        -- Draw each line centered horizontally, stacked vertically
        for i, line in ipairs(lines) do
            local text_width = djui_hud_measure_text(line) * scale
            local x = (screen_width / 2) - (text_width / 2)
            local y = start_y + ((i - 1) * 20) -- 20px spacing per line
            djui_hud_print_text(line, x, y, scale)
        end

        -- Decrement timer on server
        if network_is_server() then
            gGlobalSyncTable.announcementTimer = gGlobalSyncTable.announcementTimer - 1
        end
    end
end

local function on_announcement_command(msg)
    -- Only allow host to use this command
    if not network_is_server() then
        djui_chat_message_create("\\#880808\\Only the host can use this command.")
        return true
    end

    local text = string.sub(msg, 1)

    if text and text ~= "" then
        gGlobalSyncTable.announcementMessage = text
        gGlobalSyncTable.announcementTimer = POPUP_DURATION
        return true
    else
        djui_chat_message_create("Usage: /a (your message here)")
        return true
    end
end


--hooks--
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_chat_command("a", "Display a custom announcement message", on_announcement_command)
