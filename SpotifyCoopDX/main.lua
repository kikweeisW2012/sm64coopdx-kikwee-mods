-- name: \\#1DB954\\SpotifyCoopDX
-- description: \\#1DB954\\Spotify inside of sm64coopdx\n\n\              Commands\\#f200fa\\\n\n\/skipto (song id)\\#00faf6\\ skip to any song\n\\\#f200fa\\/pause \\#00faf6\\pause a song\n\\\#f200fa\\/unpause \\#00faf6\\unpause a song\n\\\#f200fa\\/restart \\#00faf6\\restart the playing song\n\\\#f200fa\\/skipmany (number) \\#00faf6\\skip a multiple number of songs\n\\\#f200fa\\/skip \\#00faf6\\skip song \n\\#f200fa\\/playlist \\#00faf6\\shows list of songs in your playlist \n\\\#f200fa\\/song \\#00faf6\\shows song info\n\\\#ffffff\\By: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

_G.music_time_left = 60
_G.music_audio_stream = nil
_G.music_current = nil
_G.music_current_id = 1
_G.music_next_song = nil
_G.music_pause_position = 0
_G.music_is_paused = false

local function music_load_and_play(current)
    if _G.music_audio_stream then
        audio_stream_stop(_G.music_audio_stream)
        _G.music_audio_stream = nil
    end
    djui_chat_message_create("\\#00faf6\\Loading: " .. tostring(current.file))
    _G.music_audio_stream = audio_stream_load(current.file)
    if _G.music_audio_stream then
        djui_popup_create("\\#00faf6\\Now Playing:  \\#f200fa\\" .. current.name .. " \\#00faf6\\By: " .. current.artist, 1)
        audio_stream_play(_G.music_audio_stream, false, 1)
    else
        djui_popup_create("\\#ff4040\\Failed to load: " .. current.file, 2)
        -- Auto-skip quickly to the next track on failure
        _G.music_time_left = 1
    end
end

function music_on_mario_update(m)
    stop_background_music(get_current_background_music())
    if m.playerIndex == 0 then
        if not _G.music_current then
            _G.music_current = _G.playlist[_G.music_current_id]
            _G.music_time_left = ((_G.music_current.length or 0) * 30) + 300
            music_load_and_play(_G.music_current)
        else
            if _G.music_time_left < 1 then
                _G.music_current_id = _G.music_current_id + 1
                if _G.music_current_id > #_G.playlist then
                    _G.music_current_id = 1
                end
                _G.music_current = _G.playlist[_G.music_current_id]
                _G.music_time_left = ((_G.music_current.length or 0) * 30) + 300
                music_load_and_play(_G.music_current)
            else
                _G.music_time_left = _G.music_time_left - 1
            end
        end
    end
end

function music_on_cmd_skip()
    if _G.music_audio_stream then
        audio_stream_stop(_G.music_audio_stream)
    end
    _G.music_is_paused = false
    _G.music_pause_position = 0
    _G.music_time_left = 1
    return true
end

function music_on_cmd_song()
    if _G.music_current then
        djui_chat_message_create("\\#00faf6\\Current Song:  \\#f200fa\\" .. _G.music_current.name .. " \\#00faf6\\Song-ID:\\#f200fa\\ " .. tostring(_G.music_current_id) .. " \\#00faf6\\File-Name:\\#f200fa\\  " .. tostring(_G.music_current.file) .. " \\#00faf6\\Next song in:\\#f200fa\\  " .. tostring(math.ceil(_G.music_time_left / 30)) .. " seconds")
    else
        djui_chat_message_create("\\#ff4040\\No song currently playing.")
    end
    return true
end

function music_on_cmd_songlist()
    djui_chat_message_create("\\#00faf6\\playlist:")
    for i, song in ipairs(_G.playlist) do
        djui_chat_message_create("\\#f200fa\\[" .. i .. "] \\#00faf6\\" .. song.name .. "")
    end
    return true
end

function music_on_cmd_skipmany(number)
    local number_num = tonumber(number)
    if not number_num then
        djui_chat_message_create("\\#ff4040\\Invalid number: " .. tostring(number))
        return true
    end

    number_num = math.floor(number_num)
    if number_num < 1 or number_num > #_G.playlist then
        djui_chat_message_create("\\#ff4040\\Number out of range: " .. tostring(number_num))
        return true
    end

    _G.music_next_song = number_num
    if _G.music_audio_stream then
        audio_stream_stop(_G.music_audio_stream)
    end
    _G.music_is_paused = false
    _G.music_pause_position = 0
    _G.music_time_left = 1
    return true
end

function music_on_cmd_restart()
    if _G.music_audio_stream then
        audio_stream_stop(_G.music_audio_stream)
    end
    _G.music_is_paused = false
    _G.music_pause_position = 0
    _G.music_time_left = 1
    return true
end

function music_on_cmd_pause()
    if _G.music_audio_stream and not _G.music_is_paused then
        -- Get current playback position before stopping
        _G.music_pause_position = audio_stream_get_position(_G.music_audio_stream)
        audio_stream_stop(_G.music_audio_stream)
        _G.music_is_paused = true
        djui_chat_message_create("\\#f200fa\\Music paused")
    else
        djui_chat_message_create("\\#ff4040\\No music playing or already paused.")
    end
    return true
end

function music_on_cmd_unpause()
    if _G.music_is_paused and _G.music_current then
        -- Resume from where we paused
        _G.music_audio_stream = audio_stream_load(_G.music_current.file)
        if _G.music_audio_stream then
            audio_stream_play(_G.music_audio_stream, false, 1)
            -- Seek to the saved position
            audio_stream_set_position(_G.music_audio_stream, _G.music_pause_position)
            _G.music_is_paused = false
            djui_chat_message_create("\\#f200fa\\Music resumed")
        else
            djui_chat_message_create("\\#ff4040\\Failed to resume music.")
        end
    else
        djui_chat_message_create("\\#ff4040\\No music paused or no current song.")
    end
    return true
end

function music_on_cmd_skipto(songid)
    local songid_num = tonumber(songid)
    if not songid_num then
        djui_chat_message_create("\\#ff4040\\Invalid Song ID: " .. tostring(songid))
        return true
    end

    songid_num = math.floor(songid_num)
    if songid_num < 1 or songid_num > #_G.playlist then
        djui_chat_message_create("\\#ff4040\\Song ID out of range: " .. tostring(songid_num))
        return true
    end

    -- Set the current ID directly to the requested song ID
    _G.music_current_id = songid_num
    _G.music_current = _G.playlist[_G.music_current_id]
    
    -- Stop current playback
    if _G.music_audio_stream then
        audio_stream_stop(_G.music_audio_stream)
        _G.music_audio_stream = nil
    end
    
    -- Reset pause state
    _G.music_is_paused = false
    _G.music_pause_position = 0
    
    -- Load and play the requested song immediately
    _G.music_time_left = ((_G.music_current.length or 0) * 30) + 300
    music_load_and_play(_G.music_current)
    
    return true
end


hook_event(HOOK_MARIO_UPDATE, music_on_mario_update)
hook_chat_command('skip', "Skip to the next track", music_on_cmd_skip)
hook_chat_command('song', "Display the current track and time remaining until the next track", music_on_cmd_song)
hook_chat_command('playlist', "Lists all songs with their ID, name, and filename", music_on_cmd_songlist)
hook_chat_command('skipmany', "(Number)", music_on_cmd_skipmany)
hook_chat_command('restart', "Restart a song", music_on_cmd_restart)
hook_chat_command('pause', "Pause a song", music_on_cmd_pause)
hook_chat_command('unpause', "Unpause a song", music_on_cmd_unpause)
hook_chat_command('skipto', "(song id) skipto a song", music_on_cmd_skipto)