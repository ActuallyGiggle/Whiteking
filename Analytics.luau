--[[

    Optional usage analytics. Disabled by default: AnalyticsUrl is empty, so nothing is sent.
    If you set it to your own endpoint, this POSTs the Roblox username, executor name,
    execution count, game name and PlaceId as JSON. No IP addresses or HWIDs are collected.

]]--


local function CloneReference(Object)
    if WhiteKing.Environment.cloneref then
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

local AnalyticsUrl = "" -- set to your own endpoint to enable

if AnalyticsUrl ~= "" and WhiteKing.Environment.identifyexecutor and WhiteKing.Environment.request then
    local Player = Services.Players.LocalPlayer
    local Data = {
        Account = Player.Name,
        Executor = WhiteKing.Environment.identifyexecutor(),
        Executions = tonumber(WhiteKing.TotalExecutions),
        GameName = Services.MarketplaceService:GetProductInfo(game.PlaceId).Name,
        PlaceId = tostring(game.PlaceId)
    }

    task.spawn(function()
        pcall(function()
            WhiteKing.Environment.request({
                Url = AnalyticsUrl,
                Method = "POST",
                Headers = {
                    ["content-type"] = "application/json"
                },
                Body = Services.HttpService:JSONEncode(Data)
            })
        end)
    end)
end
