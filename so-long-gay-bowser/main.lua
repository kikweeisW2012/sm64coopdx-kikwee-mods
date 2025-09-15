-- name: \\#06402B\\Custom Bowser Throw Sound
-- description: \\#06402B\\Replaces the "So long-a Bowser" sound with a custom sound file \\#ffffff\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

for i=0,(MAX_PLAYERS-1) do
    local s = gPlayerSyncTable[i]
    s.heMario = false
end

local function use_custom_voice(m)
    local s = gPlayerSyncTable[m.playerIndex]
    return m.character.type == 4
end

local CUSTOM_VOICETABLE = {
	[CHAR_SOUND_SO_LONGA_BOWSER] = {'so_long_gay_bowser.ogg'}, -- Throwing Bowser
} 

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
    local sound
    if type(voice) == "table" then
        sound = voice[math.random(#voice)]
    else
        sound = voice
    end
    if sound == nil then return 0 end
    local voice_sample = stop_custom_character_sound(m, sound)
    if type(sound) ~= "string" then
        return sound
    end

    if (m.area == nil or m.area.camera == nil) and m.playerIndex == 0 then
        if gCustomVoiceStream ~= nil then
            audio_stream_stop(gCustomVoiceStream)
            audio_stream_destroy(gCustomVoiceStream)
        end
        gCustomVoiceStream = audio_stream_load(sound)
        audio_stream_play(gCustomVoiceStream, true, 1)
    else
        if voice_sample == nil then
            voice_sample = audio_sample_load(sound)
        end
        audio_sample_play(voice_sample, m.pos, 1)

        gCustomVoiceSamples[m.playerIndex] = voice_sample
    end
    return 0
end

--- @param m MarioState
local function custom_character_sound(m, characterSound)
    -- Only replace the specific Bowser sound, keep others default
    if characterSound == CHAR_SOUND_SO_LONGA_BOWSER then
        local voice = CUSTOM_VOICETABLE[CHAR_SOUND_SO_LONGA_BOWSER]
        return play_custom_character_sound(m, voice)
    end
    return nil -- Return nil to use default sounds for everything else
end
hook_event(HOOK_CHARACTER_SOUND, custom_character_sound)