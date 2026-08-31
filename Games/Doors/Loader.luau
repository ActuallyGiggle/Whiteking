local PlaceId = game.PlaceId

-- Main Game PlaceIds (Add 6839171747 here!)
local MainGameIDs = {
    [6516141723] = true,
    [6839171747] = true,
    [11488258380] = true,
}

local LobbyIDs = {
    [6708206173] = true,
}

if MainGameIDs[PlaceId] then
    print("[Whiteking] Loading Main Game Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ActuallyGiggle/Whiteking/main/Main.luau?v=" .. tick()))()

elseif LobbyIDs[PlaceId] then
    print("[Whiteking] Loading Lobby Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ActuallyGiggle/Whiteking/main/Lobby.luau?v=" .. tick()))()

else
    -- Fallback so it defaults to main or warns instead of dying silently
    warn("[Whiteking] Unrecognized PlaceId (" .. tostring(PlaceId) .. "). Loading Main Game by default...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ActuallyGiggle/Whiteking/main/Main.luau?v=" .. tick()))()
end
