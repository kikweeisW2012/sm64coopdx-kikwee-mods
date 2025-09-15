-- name: \\#A020F0\\teleportation No Cooldown version v1.1
-- description: \\#A020F0\\Press D-pad Down to enter freecam and do it again to teleport where you are (this is a no cooldown version). \\#ffffff\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

local freecam_mode = false
local original_flags = nil
local D_JPAD = 0x0400

local FRAMES_PER_SECOND = 30
local DURATION = 10 * FRAMES_PER_SECOND -- 10 seconds

local function set_mario_invisible(m)
    if m.marioObj and m.marioObj.header and m.marioObj.header.gfx and m.marioObj.header.gfx.node then
        original_flags = m.marioObj.header.gfx.node.flags
        m.marioObj.header.gfx.node.flags = m.marioObj.header.gfx.node.flags & ~GRAPH_RENDER_ACTIVE
    end
end

local function set_mario_visible(m)
    if m.marioObj and m.marioObj.header and m.marioObj.header.gfx and m.marioObj.header.gfx.node and original_flags then
        m.marioObj.header.gfx.node.flags = original_flags
        original_flags = nil
    end
end

local function mario_update(m)
    if m.playerIndex ~= 0 then return end -- Only local player
    local controller = m.controller

    if not freecam_mode then
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            freecam_mode = true
            set_mario_invisible(m)
            djui_popup_create("teleportation active (press A to go up, Z to go down), press D-pad down again to teleport", 2)
        end
    else
        -- teleportation logic
        local speed = 30
        if m.intendedMag ~= 0 then
            m.faceAngle.y = m.intendedYaw
            m.vel.x = speed * math.sin(m.intendedYaw / 32768 * math.pi)
            m.vel.z = speed * math.cos(m.intendedYaw / 32768 * math.pi)
        else
            m.vel.x = 0
            m.vel.z = 0
        end
        m.vel.y = 0
        if controller.buttonDown & A_BUTTON ~= 0 then
            m.vel.y = 20
        elseif controller.buttonDown & Z_TRIG ~= 0 then
            m.vel.y = -20
        end
        -- Exit teleportation early
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            set_mario_visible(m)
            m.vel.x = 0
            m.vel.y = 0
            m.vel.z = 0
            freecam_mode = false
            djui_popup_create("teleported!", 2)
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update) 