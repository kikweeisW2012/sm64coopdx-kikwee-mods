--name: \\#FF0000\\Tilt SPAZ
--description: \\#FF0000\\CRASHOUT \\#FFFFFF\\modified by: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e
    
    local frame = 0

local function play_anim(m)
    if (m.controller.buttonDown & D_JPAD ~= 0) then
        smlua_anim_util_set_animation(m.marioObj, "Tilt_Spaz")
    
    frame = frame + 1

    if frame > 17 then
        frame = 0
    end
    set_anim_to_frame(m, frame)
    --djui_chat_message_create(tostring(frame))
    end
end
hook_event(HOOK_MARIO_UPDATE, play_anim)