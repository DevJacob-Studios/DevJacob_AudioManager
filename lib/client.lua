AudioManager = {
    _CallbackManager = exports["DevJacob_CallbackManager"]:getCallbackManagerObject(),
    _CurrentResource = GetCurrentResourceName()
}

function AudioManager.PlaySoundOnClient(soundFile, target, options)
    options = options or {}
    volume = options.volume or 1.0
    loop = options.loop or false

    local _promise = promise.new()
    AudioManager._CallbackManager.TriggerServerCallback("DevJacob:AudioManager:Server:AddSound", function(soundId)
        _promise:resolve(soundId)
    end, {
        source = "onClient",
        data = {
            resource = AudioManager._CurrentResource,
            filePath = soundFile,
            volume = volume,
            loop = loop
        },
        clients = { target }
    })

    local soundId = Citizen.Await(_promise)
    return soundId
end

function AudioManager.PlaySoundOnClients(soundFile, targets, options)
    options = options or {}
    volume = options.volume or 1.0
    loop = options.loop or false
    radius = options.radius or 30.0

    local _promise = promise.new()
    AudioManager._CallbackManager.TriggerServerCallback("DevJacob:AudioManager:Server:AddSound", function(soundId)
        _promise:resolve(soundId)
    end, {
        source = "onClient",
        data = {
            resource = AudioManager._CurrentResource,
            filePath = soundFile,
            volume = volume,
            loop = loop
        },
        clients = targets
    })

    local soundId = Citizen.Await(_promise)
    return soundId
end

function AudioManager.PlaySoundFromCoords(soundFile, coords, options)
    options = options or {}
    volume = options.volume or 1.0
    loop = options.loop or false
    radius = options.radius or 30.0

    local _promise = promise.new()
    AudioManager._CallbackManager.TriggerServerCallback("DevJacob:AudioManager:Server:AddSound", function(soundId)
        _promise:resolve(soundId)
    end, {
        source = "fromCoords",
        data = {
            resource = AudioManager._CurrentResource,
            filePath = soundFile,
            volume = volume,
            loop = loop
        },
        root = coords,
        radius = radius,
    })

    local soundId = Citizen.Await(_promise)
    return soundId
end

function AudioManager.PlaySoundFromEntity(soundFile, entityHandle, options)
    options = options or {}
    volume = options.volume or 1.0
    loop = options.loop or false
    radius = options.radius or 30.0

    local _promise = promise.new()
    AudioManager._CallbackManager.TriggerServerCallback("DevJacob:AudioManager:Server:AddSound", function(soundId)
        _promise:resolve(soundId)
    end, {
        source = "fromEntity",
        data = {
            resource = AudioManager._CurrentResource,
            filePath = soundFile,
            volume = volume,
            loop = loop
        },
        handle = entityHandle,
        radius = radius,
    })

    local soundId = Citizen.Await(_promise)
    return soundId
end

function AudioManager.StopSound(soundId)
    TriggerServerEvent("DevJacob:AudioManager:Server:RemoveSound", soundId)
    return
end