-- name: \\#FFFF00\\cool double jumping
-- description: \\#FFFF00\\DO A FLIP \\#FFFFFF\\modified by: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e
gGlobalSyncTable.isActive = true

local function get_isActive() 
    return gGlobalSyncTable.isActive
end

local function set_IsActive(newValue) 
    gGlobalSyncTable.isActive = newValue
end

local function toggle_IsActive() 
    set_IsActive(not get_isActive())
end

local function change_double_jump_animation(m)
    if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_DOUBLE_JUMP_RISE then
        smlua_anim_util_set_animation(m.marioObj, "mario_anim_replace_double")
    end
    if m.marioObj.header.gfx.animInfo.animID == CHAR_ANIM_DOUBLE_JUMP_FALL then
        smlua_anim_util_set_animation(m.marioObj, "anim_4_geez")
    end
end

local function mario_update(m)
    if get_isActive() == false then 
        return
    end
    change_double_jump_animation(m)
end

hook_event(HOOK_MARIO_UPDATE, mario_update)

_G.jumpingAnimExists = true
_G.jumpingAnim = {
    change_double_jump_animation = change_double_jump_animation,
    set_IsActive = set_IsActive,
    toggle_IsActive = toggle_IsActive,
}
