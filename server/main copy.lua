local nextSoundId = 0
local activeSounds = {}

------------------------------------------------------------
------------------------------------------------------------
local SoundObjStruct = {
    -- id = 0,
    source = "onClient" or "fromCoords" or "fromEntity",
    -- duration = 30,
    data = {
        resource = "example-resource",
        filePath = "file-path",
        volume = 1.0
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



function PlaySoundOnClients(soundData, clients)
    for i = 1, #clients do
        PlaySoundOnClient(soundData, clients[i])
    end
end

function PlaySoundOnClient(soundData, client)
    local SoundObjStruct = {
        id = 0,
        data = {
            resource = "example-resource",
            filePath = "file-path",
            volume = 1.0
        }
    }
end

function PlaySoundFromCoords(soundData, coords, radius)
    local SoundObjStruct = {
        id = 0,
        data = {
            resource = "example-resource",
            filePath = "file-path",
            volume = 1.0
        },
        root = vector3(0, 0, 0),
        radius = 30.0
    }

end

function PlaySoundFromEntity(soundData, entityHandle, radius)
    local SoundObjStruct = {
        id = 0,
        data = {
            resource = "example-resource",
            filePath = "file-path",
            volume = 1.0
        },
        handle = entityHandle,
        radius = 30.0
    }
end

local function OnEventSoundEnd(soundId)
    if activeSounds[soundId] ~= nil then
        activeSounds[soundId] = nil
    end
end

RegisterNetEvent("DevJacob:AudioManager:Server:SoundEnd", OnEventSoundEnd)