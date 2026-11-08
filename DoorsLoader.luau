local BaseUrl = "https://raw.githubusercontent.com/ActuallyGiggle/whiteking/refs/heads/main/"
if game.PlaceId ~= 6516141723 then
    loadstring(game:HttpGet(BaseUrl .. "DoorsMain.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "DoorsLobby.luau"))()
end
