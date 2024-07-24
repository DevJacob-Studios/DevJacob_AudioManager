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
	"nui/index.html",
	"lib/client.lua",
	"lib/server.lua",
}

shared_scripts {
	"imports.lua",
}

client_scripts {
	"@DevJacob_CommonLib/lib/client.lua",
	"client/nui.lua",
	"client/main.lua",
}

server_scripts {
	"@DevJacob_CommonLib/lib/server.lua",
	"server/main.lua",
}
