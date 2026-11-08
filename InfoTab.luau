return function(Window)
    local LatestChangelog = {
        "11/8/2026",
        "<font color='rgb(0, 255, 0)'>- Added support for Hotel and Mines</font>",
        "- This script is still in development",
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

    local Library = WhiteKing.Interface.Library
    local SaveManager = WhiteKing.Interface.SaveManager
    local ThemeManager = WhiteKing.Interface.ThemeManager

    local Toggles = Library.Toggles
    local Options = Library.Options

    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "user")

    local User = InfoTab:AddLeftGroupbox("User Info")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("ID: " .. LocalPlayer.Name, true)
    User:AddLabel("Total Executions: " .. (WhiteKing.TotalExecutions and WhiteKing.TotalExecutions or "N/A"), true)

    local About = InfoTab:AddLeftGroupbox("About")
    About:AddLabel("WhiteKing is made by ActuallyGiggle and is a continuation of BlackKing.", true)
    About:AddLabel("Based on open-source work by FireBacon (MIT).", true)

    local Changelog = InfoTab:AddRightGroupbox("Changelog")
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local Name, Version = WhiteKing.Environment.identifyexecutor()
    local Executor = InfoTab:AddRightGroupbox("Executor Info")
    Executor:AddLabel("Name: " .. Name, true)
	Executor:AddLabel("Version: " .. (Version and Version or "N/A"), true)
    Executor:AddDivider()
    Executor:AddLabel("Test Result: ", true)

    for Index, Result in pairs(WhiteKing.Environment.Results) do
		-- fix for veloshitty 💔
		Result = Result:gsub("<", "(")
		Result = Result:gsub(">", ")")
		
        Executor:AddLabel(Result, true)
    end

    local Community = InfoTab:AddLeftGroupbox("Community")
    Community:AddButton("Copy Discord Invite", function()
	    toclipboard("https://dsc.gg/whitekinghub")
	    Library:Notify("Discord invite copied.")
    end)
end
