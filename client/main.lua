local activeSounds = {}
local clientSounds = {}

local function IsEligibleToHearSound(id, sound)
    if sound.source == "onClient" then
        if sound.clients == nil then
            return false, nil
        end

        if not DevJacobLib.Table.ArrayContainsValue(sound.clients, GetPlayerServerId(PlayerId())) then
            return false, nil
        end

        return true, sound.data.volume

    elseif sound.source == "fromCoords" then
        if sound.root == nil or sound.radius == nil then
            return false, nil
        end

        local playerPos = GetEntityCoords(PlayerPedId())
        local distanceToRoot = #(sound.root - playerPos)
        if distanceToRoot > sound.radius then
            return false, nil
        end

        if distanceToRoot <= 3.5 then
            return true, sound.data.volume
        end

        local percentAwayFromRoot = distanceToRoot / sound.radius
        local volume = percentAwayFromRoot * sound.data.volume

        return true, volume

    elseif sound.source == "fromEntity" then
        if sound.handle == nil or sound.radius == nil then
            return false, nil
        end

        -- Get entity coords from server if needed
        local root = GetEntityCoords(sound.handle)
        if root.x == 0.0 and root.y == 0.0 and root.z == 0.0 then
            local _promise = promise.new()
            CallbackManager.TriggerServerCallback("DevJacob:AudioManager:Server:GetEntityCoords", function(coords)
                _promise:resolve(coords)
            end, sound.handle)
    
            root = Citizen.Await(_promise)
        end

        local playerPos = GetEntityCoords(PlayerPedId())
        local distanceToRoot = #(root - playerPos)
        if distanceToRoot > sound.radius then
            return false, nil
        end

        local percentAwayFromRoot = distanceToRoot / sound.radius
        local volume = 1.0 - (percentAwayFromRoot * sound.data.volume)

        return true, volume

    else
        return false, nil
    end
end

local function GetNuiFileUrl(resource, path) 
    return "https://cfx-nui-" .. resource .. "/" .. path
end

local function OnEventAddSound(id, soundData)
    activeSounds[id] = soundData
    clientSounds[id] = {
        state = "inactive",
        volume = nil,
    }

    Citizen.CreateThread(function()
        local soundId = id
        while activeSounds[soundId] ~= nil do
            Citizen.Wait(1)
            local sound = activeSounds[soundId]
            if sound == nil then break end

            local clientData = clientSounds[soundId]
            if clientData == nil then break end

            local canHear, volume = IsEligibleToHearSound(soundId, sound)

            if clientData.state == "active" and canHear == false then
                NUI:UpdateSound(soundId, { volume = 0.0 })
                clientSounds[soundId].volume = volume

            elseif canHear == true and clientData.state == "inactive" then
                NUI:PlaySound(soundId, GetNuiFileUrl(sound.data.resource, sound.data.filePath), { volume = volume })
                clientSounds[soundId].state = "active"
                clientSounds[soundId].volume = volume
            
            elseif clientData.state == "active" and clientData.volume ~= volume then
                NUI:UpdateSound(soundId, { volume = volume })
                clientSounds[soundId].volume = volume
            
            end
        end
    end)
end

local function OnEventRemoveSound(id)
    activeSounds[id] = nil
    clientSounds[id] = nil
    NUI:StopSound(id)
end

local function OnEventUpdateSound(id, soundData)
    activeSounds[id] = soundData
end

local function OnNuiCallbackSoundEnd(data, callback)
    local soundId = data.soundId

    TriggerServerEvent("DevJacob:AudioManager:Server:RemoveSound", soundId)

    callback()
end

RegisterNUICallback("soundEnd", OnNuiCallbackSoundEnd)

RegisterNetEvent("DevJacob:AudioManager:Client:AddSound", OnEventAddSound)
RegisterNetEvent("DevJacob:AudioManager:Client:RemoveSound", OnEventRemoveSound)
RegisterNetEvent("DevJacob:AudioManager:Client:UpdateSound", OnEventUpdateSound)
