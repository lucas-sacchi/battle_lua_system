math.randomseed(os.time())

local createCharacters = require("data.characters")
local Battle = require("core.battle")

local luffy, zoro = createCharacters()

Battle.start(luffy, zoro)
