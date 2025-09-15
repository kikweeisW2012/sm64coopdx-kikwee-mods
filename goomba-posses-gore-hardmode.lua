-- name:\\#964B00\\Goomba Possession v1.2
-- description:\\#964B00\\Press D-pad down near a Goomba to possess it! Press it again to return to Mario. \\#FF0000\\NOW WORKS WITH GORE/HARDMODE \\#FFFFFF\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

-- Constants
local POSSESSION_RANGE = 200
local MODEL_GOOMBA = _G.MODEL_GOOMBA or 0x67
local POSSESSION_ACTION = 0x40000000 -- Custom action flag

-- State
local possessed = false
local possessedGoomba = nil
local lastHealth = 0
local lastHurtCounter = 0

local id_bhvGoomba = _G.id_bhvGoomba or id_bhvGoomba -- try global, or let it be nil if not found

-- Find Goomba
local function find_nearest_goomba(m)
    local nearest = nil
    local minDist = POSSESSION_RANGE
    if id_bhvGoomba then
        local obj = obj_get_first_with_behavior_id(id_bhvGoomba)
        while obj do
            local dx = obj.oPosX - m.pos.x
            local dy = obj.oPosY - m.pos.y
            local dz = obj.oPosZ - m.pos.z
            local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
            obj = obj_get_next_with_same_behavior_id(obj)
        end
    else
        -- fallback: model check (less reliable)
        for list = 0, 15 do
            local obj = obj_get_first(list)
            while obj do
                if obj.header and obj.header.gfx and obj.header.gfx.sharedChild and obj.header.gfx.sharedChild.model == MODEL_GOOMBA then
                    local dx = obj.oPosX - m.pos.x
                    local dy = obj.oPosY - m.pos.y
                    local dz = obj.oPosZ - m.pos.z
                    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < minDist then
                        minDist = dist
                        nearest = obj
                    end
                end
                obj = obj_get_next(obj)
            end
        end
    end
    return nearest
end

local function set_mario_invisible(m)
    if m.marioObj and m.marioObj.header and m.marioObj.header.gfx and m.marioObj.header.gfx.node then
        m.marioObj.header.gfx.node.flags = m.marioObj.header.gfx.node.flags & ~GRAPH_RENDER_ACTIVE
    end
end

local function set_mario_visible(m)
    if m.marioObj and m.marioObj.header and m.marioObj.header.gfx and m.marioObj.header.gfx.node then
        m.marioObj.header.gfx.node.flags = m.marioObj.header.gfx.node.flags | GRAPH_RENDER_ACTIVE
    end
end

local function move_goomba_with_input(goomba, m)
    if not goomba then return end
    
    -- prevent squish of possessed goomba
    goomba.oAction = 0
    -- Goomba negative stats
    local speed = 4 -- reduced speed
    local jumpVel = 18 -- reduced jump height
    local stickMag = m.controller.stickMag
    local stickAngle = m.controller.stickY ~= 0 or m.controller.stickX ~= 0 and math.atan2(m.controller.stickY, m.controller.stickX) or 0
    if stickMag > 0 then
        goomba.oMoveAngleYaw = m.intendedYaw
        goomba.oForwardVel = speed * (stickMag / 32)
    else
        goomba.oForwardVel = 0
    end
    -- Jump with A
    if (m.controller.buttonPressed & A_BUTTON) ~= 0 and goomba.oPosY <= goomba.oHomeY + 5 then
        goomba.oVelY = jumpVel
    end
end

local function is_in_water(m)
    return m.waterLevel ~= 0 and m.pos.y < m.waterLevel - 50
end

local function block_interactions(m)
    -- Disabled action blocking for now - let Mario do whatever he wants
    -- The Goomba movement is handled separately
    return
end

local distractedGoombas = {}

local function distract_other_goombas(exceptGoomba)
    distractedGoombas = {}
    if id_bhvGoomba then
        local obj = obj_get_first_with_behavior_id(id_bhvGoomba)
        while obj do
            if obj ~= exceptGoomba then
                distractedGoombas[obj] = true
                obj.oAction = 0
                obj.oForwardVel = 0
            end
            obj = obj_get_next_with_same_behavior_id(obj)
        end
    end
end

local function restore_goombas()
    for obj, _ in pairs(distractedGoombas) do
        if obj then
            obj.oAction = 0
            obj.oForwardVel = 0
        end
    end
    distractedGoombas = {}
end

-- Main possession logic
local function mario_update(m)
    if m.playerIndex ~= 0 then return end -- Only local player
    local controller = m.controller
    if not possessed then
        restore_goombas()
        lastHealth = m.health or 0
        lastHurtCounter = m.hurtCounter or 0
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            local goomba = find_nearest_goomba(m)
            if goomba then
                possessed = true
                possessedGoomba = goomba
                set_mario_invisible(m)
                -- Move Mario to Goomba's position
                m.pos.x, m.pos.y, m.pos.z = goomba.oPosX, goomba.oPosY, goomba.oPosZ
                if _G.djui_popup_create then
                    djui_popup_create("You are now controlling a Goomba! Press D-Pad Down to return.", 2)
                end
            else
                if _G.djui_popup_create then
                    djui_popup_create("No Goomba found nearby!", 2)
                end
            end
        end
    else
        -- Unpossess
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            if possessedGoomba then
                m.pos.x, m.pos.y, m.pos.z = possessedGoomba.oPosX, possessedGoomba.oPosY, possessedGoomba.oPosZ
            end
            set_mario_visible(m)
            possessed = false
            possessedGoomba = nil
            restore_goombas()
            if _G.djui_popup_create then
                djui_popup_create("Returned to Mario!", 2)
            end
            return
        end
        if possessedGoomba then
            m.pos.x, m.pos.y, m.pos.z = possessedGoomba.oPosX, possessedGoomba.oPosY, possessedGoomba.oPosZ
            move_goomba_with_input(possessedGoomba, m)
            distract_other_goombas(possessedGoomba)
        end
        if is_in_water(m) then
            set_mario_visible(m)
            possessed = false
            possessedGoomba = nil
            restore_goombas()
            if _G.djui_popup_create then
                djui_popup_create("Goombas can't swim! You drowned and returned to Mario.", 2)
            end
            return
        end
        if lastHealth and m.health and m.health < lastHealth or (lastHurtCounter and m.hurtCounter and m.hurtCounter > lastHurtCounter) then
            set_mario_visible(m)
            possessed = false
            possessedGoomba = nil
            restore_goombas()
            if _G.djui_popup_create then
                djui_popup_create("Goomba defeated! You returned to Mario.", 2)
            end
            return
        end
        lastHealth = m.health or 0
        lastHurtCounter = m.hurtCounter or 0
        block_interactions(m)
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update) 