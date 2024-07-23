NUI = {}

function NUI:PlaySound(soundId, filePath, options)
    options = options or {}
    
    SendNUIMessage({
        type = "PLAY_SOUND",
        soundId = soundId,
        filePath = filePath,
        options = options,
    })
end

function NUI:UpdateSound(soundId, options)
    SendNUIMessage({
        type = "UPDATE_SOUND",
        soundId = soundId,
        options = options,
    })
end

function NUI:StopSound(soundId)
    SendNUIMessage({
        type = "STOP_SOUND",
        soundId = soundId,
    })
end

function NUI:PauseSound(soundId)
    SendNUIMessage({
        type = "PAUSE_SOUND",
        soundId = soundId,
    })
end

function NUI:ResumeSound(soundId)
    SendNUIMessage({
        type = "RESUME_SOUND",
        soundId = soundId,
    })
end