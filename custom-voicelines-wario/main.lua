-- name: \\#f200fa\\Custom \\#fdd50b\\wario \\#00faf6\\voicelines
-- description: \\#f200fa\\add your custom \\#00faf6\\voicelines\\#f200fa\\ to sm64coopdx \\#ffffff\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e
local function use_custom_voice(m)
    return m.character.type == CT_WARIO -- Only true for wario
end

-- Use global CUSTOM_VOICETABLE from add-voicelines.lua, fallback to empty table if not loaded
local CUSTOM_VOICETABLE = _G.CUSTOM_VOICETABLE or {}

gCustomVoiceSamples = {}
gCustomVoiceStream = nil

function stop_custom_character_sound(m, sound)
    local voice_sample = gCustomVoiceSamples[m.playerIndex]
    if voice_sample == nil or not voice_sample.loaded then
        return
    end

    audio_sample_stop(voice_sample)
    if voice_sample.file.relativePath:match('^.+/(.+)$') == sound then
        return voice_sample
    end
end

--- @param m MarioState
function play_custom_character_sound(m, voice)
    if not use_custom_voice(m) then
        return nil  -- Early return if not wario
    end

    local sound
    if type(voice) == "table" then
        sound = voice[math.random(#voice)]
    else
        sound = voice
    end
    print("[DEBUG] play_custom_character_sound called with sound:", sound)
    if sound == nil then return 0 end
    if type(sound) ~= "string" then
        print("[DEBUG] Sound is not a string, returning:", sound)
        return sound
    end

    local ext = sound:match("%.([a-zA-Z0-9]+)$")
    if ext ~= "ogg" and ext ~= "mp3" then
        print("[DEBUG] Unsupported file type:", ext)
        return 0
    end

    local voice_sample = stop_custom_character_sound(m, sound)

    if (m.area == nil or m.area.camera == nil) and m.playerIndex == 0 then
        print("[DEBUG] Playing as stream for player 0")
        if gCustomVoiceStream ~= nil then
            audio_stream_stop(gCustomVoiceStream)
            audio_stream_destroy(gCustomVoiceStream)
        end
        gCustomVoiceStream = audio_stream_load(sound)
        audio_stream_play(gCustomVoiceStream, true, 1)
    else
        if voice_sample == nil then
            print("[DEBUG] Loading sample for:", sound)
            voice_sample = audio_sample_load(sound)
        end
        print("[DEBUG] Playing sample for player", m.playerIndex)
        audio_sample_play(voice_sample, m.pos, 1)

        gCustomVoiceSamples[m.playerIndex] = voice_sample
    end
    return 0
end

--- @param m MarioState
local function custom_character_sound(m, characterSound)
    if not use_custom_voice(m) then
        return nil -- Return nil to allow default sound if not wario
    end
    local voice = CUSTOM_VOICETABLE[characterSound]
    print("[DEBUG] custom_character_sound called for:", characterSound, "voice:", voice)
    if voice and voice ~= '' then
        print("[DEBUG] Custom sound found for action:", characterSound)
        return play_custom_character_sound(m, voice)
    end
    print("[DEBUG] No custom sound for action:", characterSound)
    return nil -- Use default sound if not custom
end
hook_event(HOOK_CHARACTER_SOUND, custom_character_sound)