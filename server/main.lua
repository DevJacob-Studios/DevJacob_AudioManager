local nextSoundId = 0
local activeSounds = {}

------------------------------------------------------------
------------------------------------------------------------
local SoundObjStruct = {
    source = "onClient" or "fromCoords" or "fromEntity",
    duration = 30,
    data = {
        resource = "example-resource",
        filePath = "file-path",
        volume = 1.0,
        loop = false
    },

    -- Source dependant variables
    clients = {  },
    root = vector3(0.0, 0.0, 0.0),
    handle = "entity-handle",
    radius = 30.0,
}
------------------------------------------------------------
------------------------------------------------------------

local function NextSoundId()
    local result = "sound-" .. nextSoundId
    nextSoundId = nextSoundId + 1
    return result
end

local function OnEventAddSound(soundData)
    local newSoundId = NextSoundId()
    activeSounds[newSoundId] = soundData
    TriggerClientEvent("DevJacob:AudioManager:Client:AddSound", -1, newSoundId, soundData)
end

local function OnEventUpdateSound(soundId, soundData)
    activeSounds[soundId] = soundData
    TriggerClientEvent("DevJacob:AudioManager:Client:UpdateSound", -1, soundId, soundData)
end

local function OnEventRemoveSound(soundId)
    if activeSounds[soundId] ~= nil then
        activeSounds[soundId] = nil
        TriggerClientEvent("DevJacob:AudioManager:Client:RemoveSound", -1, soundId)
    end
end

local function OnServerCallbackGetEntityCoords(source, callback, handle)
    callback(GetEntityCoords(handle))
end

local function OnServerCallbackAddSound(source, callback, soundData)
    local newSoundId = NextSoundId()
    activeSounds[newSoundId] = soundData
    TriggerClientEvent("DevJacob:AudioManager:Client:AddSound", -1, newSoundId, soundData)
    callback(newSoundId)
end

RegisterNetEvent("DevJacob:AudioManager:Server:AddSound", OnEventAddSound)
RegisterNetEvent("DevJacob:AudioManager:Server:UpdateSound", OnEventUpdateSound)
RegisterNetEvent("DevJacob:AudioManager:Server:RemoveSound", OnEventRemoveSound)

CallbackManager.RegisterServerCallback("DevJacob:AudioManager:Server:GetEntityCoords", OnServerCallbackGetEntityCoords)
CallbackManager.RegisterServerCallback("DevJacob:AudioManager:Server:AddSound", OnServerCallbackAddSound)
