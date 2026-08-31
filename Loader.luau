if Whiteking then
    return 
end
getgenv().Whiteking = {
    Legit = true
}

local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/ActuallyGiggle/Whiteking/refs/heads/main/"

getgenv().Whiteking = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),

    Legit = true,
}

local function CloneReference(Object)
    if Whiteking and Whiteking.Environment.cloneref then
        return Whiteking.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Whiteking.Environment.writefile and Whiteking.Environment.readfile then
    if not Whiteking.Environment.isfile("Whiteking/UserData.json") then
        local Data = {
            TotalExecutions = 0,
            UILibrary = "Obsidian"
        }
        Whiteking.Environment.writefile("Whiteking/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = Whiteking.Environment.readfile("Whiteking/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    if not Decoded.UILibrary then
        Decoded.UILibrary = "Obsidian"
    end

    Whiteking.TotalExecutions = Decoded.TotalExecutions
    Whiteking.UILibrary = Decoded.UILibrary

    Whiteking.Environment.writefile("Whiteking/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

Whiteking.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()
Whiteking.Analytics = loadstring(game:HttpGet(BaseUrl .. "Components/Analytics.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
