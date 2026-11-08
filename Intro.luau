-- WhiteKing Hub intro animation.
-- Self-contained on purpose: it does not read WhiteKing.*, so it can start before the rest of the hub has loaded,
-- and it never throws to the caller. If anything here fails, the overlay is removed and the hub carries on.

local Env = getgenv()
if Env.WhiteKingIntroPlaying then
	return
end
Env.WhiteKingIntroPlaying = true

local CloneRef = Env.cloneref or function(Object)
	return Object
end

local function GetService(Name)
	return CloneRef(game:GetService(Name))
end

local TweenService = GetService("TweenService")
local Players = GetService("Players")
local HttpService = GetService("HttpService")

local TITLE = "WHITEKING"
local SUBTITLE = "HUB   ·   DOORS"

local Gui

local function Tween(Object, Time, Properties, Style, Direction)
	local NewTween = TweenService:Create(
		Object,
		TweenInfo.new(Time, Style or Enum.EasingStyle.Quint, Direction or Enum.EasingDirection.Out),
		Properties
	)
	NewTween:Play()
	return NewTween
end

local function CreateGui()
	local NewGui = Instance.new("ScreenGui")
	NewGui.Name = HttpService:GenerateGUID(false)
	NewGui.IgnoreGuiInset = true
	NewGui.ResetOnSpawn = false
	NewGui.DisplayOrder = 2147483646
	NewGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Parent
	if Env.gethui then
		local Success, Result = pcall(Env.gethui)
		if Success and Result then
			Parent = Result
		end
	end

	local Parented = pcall(function()
		NewGui.Parent = Parent or GetService("CoreGui")
	end)
	if not Parented or not NewGui.Parent then
		NewGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	return NewGui
end

local function Play()
	Gui = CreateGui()

	local Backdrop = Instance.new("Frame")
	Backdrop.Size = UDim2.fromScale(1, 1)
	Backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
	Backdrop.BackgroundTransparency = 1
	Backdrop.BorderSizePixel = 0
	Backdrop.Parent = Gui

	local Holder = Instance.new("Frame")
	Holder.AnchorPoint = Vector2.new(0.5, 0.5)
	Holder.Position = UDim2.fromScale(0.5, 0.5)
	Holder.Size = UDim2.fromOffset(0, 0)
	Holder.AutomaticSize = Enum.AutomaticSize.XY
	Holder.BackgroundTransparency = 1
	Holder.Parent = Backdrop

	local HolderScale = Instance.new("UIScale")
	HolderScale.Scale = 0.9
	HolderScale.Parent = Holder

	local HolderLayout = Instance.new("UIListLayout")
	HolderLayout.FillDirection = Enum.FillDirection.Vertical
	HolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	HolderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	HolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
	HolderLayout.Padding = UDim.new(0, 12)
	HolderLayout.Parent = Holder

	local TitleRow = Instance.new("Frame")
	TitleRow.LayoutOrder = 1
	TitleRow.Size = UDim2.fromOffset(0, 0)
	TitleRow.AutomaticSize = Enum.AutomaticSize.XY
	TitleRow.BackgroundTransparency = 1
	TitleRow.Parent = Holder

	local TitleLayout = Instance.new("UIListLayout")
	TitleLayout.FillDirection = Enum.FillDirection.Horizontal
	TitleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TitleLayout.Padding = UDim.new(0, 3)
	TitleLayout.Parent = TitleRow

	local Letters = {}
	for Index = 1, #TITLE do
		local Letter = Instance.new("TextLabel")
		Letter.LayoutOrder = Index
		Letter.Size = UDim2.fromOffset(0, 0)
		Letter.AutomaticSize = Enum.AutomaticSize.XY
		Letter.BackgroundTransparency = 1
		Letter.Font = Enum.Font.GothamBlack
		Letter.Text = TITLE:sub(Index, Index)
		Letter.TextSize = 64
		Letter.TextColor3 = Color3.new(1, 1, 1)
		Letter.TextTransparency = 1
		Letter.Parent = TitleRow
		table.insert(Letters, Letter)
	end

	local Line = Instance.new("Frame")
	Line.LayoutOrder = 2
	Line.Size = UDim2.fromOffset(0, 2)
	Line.BackgroundColor3 = Color3.new(1, 1, 1)
	Line.BorderSizePixel = 0
	Line.Parent = Holder

	local Subtitle = Instance.new("TextLabel")
	Subtitle.LayoutOrder = 3
	Subtitle.Size = UDim2.fromOffset(0, 0)
	Subtitle.AutomaticSize = Enum.AutomaticSize.XY
	Subtitle.BackgroundTransparency = 1
	Subtitle.Font = Enum.Font.GothamMedium
	Subtitle.Text = SUBTITLE
	Subtitle.TextSize = 18
	Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	Subtitle.TextTransparency = 1
	Subtitle.Parent = Holder

	-- In
	Tween(Backdrop, 0.4, { BackgroundTransparency = 0.2 })
	Tween(HolderScale, 1.2, { Scale = 1 }, Enum.EasingStyle.Back)
	task.wait(0.25)
	Tween(Line, 0.6, { Size = UDim2.fromOffset(260, 2) })
	for _, Letter in Letters do
		Tween(Letter, 0.35, { TextTransparency = 0 })
		task.wait(0.06)
	end
	task.wait(0.1)
	Tween(Subtitle, 0.5, { TextTransparency = 0 })

	-- Hold
	task.wait(1.4)

	-- Out
	Tween(Backdrop, 0.5, { BackgroundTransparency = 1 })
	Tween(HolderScale, 0.5, { Scale = 1.06 })
	Tween(Line, 0.5, { BackgroundTransparency = 1 })
	Tween(Subtitle, 0.4, { TextTransparency = 1 })
	for _, Letter in Letters do
		Tween(Letter, 0.4, { TextTransparency = 1 })
	end
	task.wait(0.55)
end

local Success, Err = pcall(Play)
if not Success then
	warn("[WhiteKing] Intro failed: " .. tostring(Err))
end
if Gui then
	pcall(function()
		Gui:Destroy()
	end)
end
Env.WhiteKingIntroPlaying = nil
