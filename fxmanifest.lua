fx_version "cerulean"
lua54 "yes"
game "gta5"

author "DevJacob"
description "A FiveM script to help play audios with ease"
version "0.1.0"

ui_page "nui/index.html"

dependencies {
	"DevJacob_CallbackManager",
	"DevJacob_CommonLib",
}

files {
	"nui/index.html"
}

shared_scripts {
	"imports.lua",
}

client_scripts {
	"exports.lua",
	"client/nui.lua",
	"client/main.lua",
}

server_scripts {
	"exports.lua",
	"server/main.lua",
}

--[[
	Example Import:
	AudioManager = exports["DevJacob_AudioManager"]:getAudioManagerObject(GetCurrentResourceName())
]]