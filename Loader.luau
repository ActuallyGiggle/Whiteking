local DoorsGameId = 2440500124

if game.GameId ~= DoorsGameId then
    warn("[WhiteKing Hub] This hub only supports DOORS.")
    return
end

if WhiteKing then
    return 
end
getgenv().WhiteKing = {
    Legit = true
}

local BaseUrl = "https://raw.githubusercontent.com/ActuallyGiggle/whiteking/refs/heads/main/"

-- Intro plays while the rest of the hub downloads. It is optional: a failed download must never stop the loader.
task.spawn(function()
    local Fetched, Source = pcall(function()
        return game:HttpGet(BaseUrl .. "Intro.luau")
    end)
    if not Fetched then
        return
    end
    local Compiled = loadstring(Source)
    if Compiled then
        pcall(Compiled)
    end
end)

getgenv().WhiteKing = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "ESP.luau"))(),

    Legit = true, -- pog
}

local function CloneReference(Object)
    if WhiteKing and WhiteKing.Environment.cloneref then
        return WhiteKing.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if WhiteKing.Environment.writefile and WhiteKing.Environment.readfile then
    if not WhiteKing.Environment.isfile("WhiteKing/UserData.json") then
        local Data = {
            TotalExecutions = 0,
            UILibrary = "Obsidian"
        }
        WhiteKing.Environment.writefile("WhiteKing/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = WhiteKing.Environment.readfile("WhiteKing/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    if not Decoded.UILibrary then
        Decoded.UILibrary = "Obsidian"
    end

    WhiteKing.TotalExecutions = Decoded.TotalExecutions
    WhiteKing.UILibrary = Decoded.UILibrary

    WhiteKing.Environment.writefile("WhiteKing/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

WhiteKing.Interface = loadstring(game:HttpGet(BaseUrl .. "Interface.luau"))()
WhiteKing.Analytics = loadstring(game:HttpGet(BaseUrl .. "Analytics.luau"))()

loadstring(game:HttpGet(BaseUrl .. "DoorsLoader.luau"))()
