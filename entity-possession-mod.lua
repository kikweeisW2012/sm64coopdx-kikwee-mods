-- name:\\#FF0000\\ENTITY \\#00FF00\\Possession \\#FF0000\\v1.0
-- description:\\#00FF00\\Press D-pad down near a \\#FF0000\\entity \\#00FF00\\(basicly \\#FF0000\\anything\\#00FF00\\) to \\#FF0000\\possess \\#00FF00\\it \\#FFFFFF\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

-- Constants
local POSSESSION_RANGE = 200

-- State
local possessed = false
local possessedKoopa = nil
local lastHealth = 0
local lastHurtCounter = 0
local hitCount = 0
local speedMultiplier = 2.0 -- 2x speed boost
local originalForwardVel = 0

-- Find Koopa Troopa - very simple approach
local function find_nearest_koopa(m)
    local nearest = nil
    local minDist = POSSESSION_RANGE
    
    -- Search all object lists for any object that could be a Koopa
    for list = 0, 15 do
        local obj = obj_get_first(list)
        while obj do
            -- Basic validation
            if obj.header and obj.oPosX and obj.oPosY and obj.oPosZ then
                -- Calculate distance
                local dx = obj.oPosX - m.pos.x
                local dy = obj.oPosY - m.pos.y
                local dz = obj.oPosZ - m.pos.z
                local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
                
                -- Check if it's close enough and not Mario
                if dist < minDist and obj ~= m.marioObj then
                    -- Very simple check - just make sure it has movement properties
                    if obj.oMoveAngleYaw ~= nil and obj.oForwardVel ~= nil then
                        minDist = dist
                        nearest = obj
                    end
                end
            end
            obj = obj_get_next(obj)
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

local function is_in_water(m)
    return m.waterLevel ~= 0 and m.pos.y < m.waterLevel - 50
end

local function handle_hit(m)
    if not possessed then return false end
    
    local currentHealth = m.health or 0
    local currentHurtCounter = m.hurtCounter or 0
    
    -- Check if Mario got hit
    if (lastHealth and currentHealth < lastHealth) or (lastHurtCounter and currentHurtCounter > lastHurtCounter) then
        hitCount = hitCount + 1
        
        if hitCount == 1 then
            -- First hit: reduce speed to normal
            speedMultiplier = 1.0
            -- Second hit: un-possess
            set_mario_visible(m)
            possessed = false
            possessedKoopa = nil
            hitCount = 0
            speedMultiplier = 2.0 -- reset for next possession
            if _G.djui_popup_create then
                djui_popup_create("entity defeated! You returned to Mario.", 2)
            end
            return true -- signal that we un-possessed
        end
    end
    
    lastHealth = currentHealth
    lastHurtCounter = currentHurtCounter
    return false
end

-- Main possession logic
local function mario_update(m)
    if m.playerIndex ~= 0 then return end -- Only local player
    local controller = m.controller
    
    if not possessed then
        lastHealth = m.health or 0
        lastHurtCounter = m.hurtCounter or 0
        hitCount = 0
        speedMultiplier = 2.0 -- reset speed multiplier
        
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            local koopa = find_nearest_koopa(m)
            if koopa then
                possessed = true
                possessedKoopa = koopa
                set_mario_invisible(m)
                -- Store original position
                originalForwardVel = m.forwardVel or 0
                if _G.djui_popup_create then
                    djui_popup_create("You are now controlling a entity! Press D-Pad Down to return.", 2)
                end
            else
                if _G.djui_popup_create then
                    djui_popup_create("No entity found nearby", 2)
                end
            end
        end
    else
        -- Check for hits first
        if handle_hit(m) then
            return -- already un-possessed
        end
        
        -- Unpossess
        if (controller.buttonPressed & D_JPAD) ~= 0 then
            set_mario_visible(m)
            possessed = false
            possessedKoopa = nil
            hitCount = 0
            speedMultiplier = 2.0 -- reset for next possession
            if _G.djui_popup_create then
                djui_popup_create("Returned to Mario!", 2)
            end
            return
        end
        
        -- Apply speed boost to Mario's movement
        if m.forwardVel > 0 then
            -- Apply speed multiplier to Mario's forward velocity
            m.forwardVel = m.forwardVel * speedMultiplier
        end
        
        -- Update Mario's position to follow the Koopa if it still exists
        if possessedKoopa and possessedKoopa.header then
            m.pos.x, m.pos.y, m.pos.z = possessedKoopa.oPosX, possessedKoopa.oPosY, possessedKoopa.oPosZ
        else
            -- Koopa was destroyed, un-possess
            set_mario_visible(m)
            possessed = false
            possessedKoopa = nil
            hitCount = 0
            speedMultiplier = 2.0
            if _G.djui_popup_create then
                djui_popup_create("entity was destroyed! You returned to Mario.", 2)
            end
            return
        end
        
        if is_in_water(m) then
            set_mario_visible(m)
            possessed = false
            possessedKoopa = nil
            hitCount = 0
            speedMultiplier = 2.0 -- reset for next possession
            if _G.djui_popup_create then
                djui_popup_create("this entity can't swim! You drowned and returned to Mario.", 2)
            end
            return
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update) 