--// AUTO BASH REJOIN LOOP (AUTO EXEC FIXED)

getgenv().AutoBash = false
getgenv().SelectedPlayer = nil
getgenv().Amount = "1"

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- executor queue
local queue =
    queue_on_teleport or
    syn.queue_on_teleport or
    fluxus.queue_on_teleport

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoBashUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,210)
frame.Position = UDim2.new(0.5,-125,0.5,-105)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(0,220,0,30)
dropdown.Position = UDim2.new(0,15,0,15)
dropdown.Text = "Select Player"

local drop = Instance.new("Frame", frame)
drop.Size = UDim2.new(0,220,0,100)
drop.Position = UDim2.new(0,15,0,50)
drop.BackgroundColor3 = Color3.fromRGB(35,35,35)
drop.Visible = false

local amount = Instance.new("TextBox", frame)
amount.Size = UDim2.new(0,220,0,30)
amount.Position = UDim2.new(0,15,0,155)
amount.PlaceholderText = "Amount"
amount.Text = "1"

amount.FocusLost:Connect(function()
    getgenv().Amount = amount.Text
end)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0,80,0,30)
toggle.Position = UDim2.new(1,-95,1,-35)
toggle.Text = "ON"

-- populate players
local function refresh()
    for _,v in pairs(drop:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    local y = 0
    for _,plr in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", drop)
        b.Size = UDim2.new(1,0,0,25)
        b.Position = UDim2.new(0,0,0,y)
        b.Text = plr.Name

        b.MouseButton1Click:Connect(function()
            getgenv().SelectedPlayer = plr.Name
            dropdown.Text = plr.Name
            drop.Visible = false
        end)

        y = y + 25
    end
end

refresh()
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

dropdown.MouseButton1Click:Connect(function()
    drop.Visible = not drop.Visible
end)

-- MAIN LOOP
local function start()
    task.spawn(function()
        while getgenv().AutoBash do

            -- cursor
            ReplicatedStorage.RemoteEvents.Settings:FireServer(
                "Cursor",
                "\xFF"
            )

            task.wait(1)

            -- send money
            ReplicatedStorage.RemoteEvents.BashApp:FireServer(
                tonumber(getgenv().Amount),
                getgenv().SelectedPlayer
            )

            task.wait(1)

            -- queue reopen
            if queue then
                queue(game:HttpGet("https://raw.githubusercontent.com/Who1amG/DaStreets/refs/heads/main/DaStreetsInfMoney.lua"))
            end

            -- rejoin
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                game.JobId,
                LocalPlayer
            )

            task.wait(4)
        end
    end)
end

toggle.MouseButton1Click:Connect(function()
    getgenv().AutoBash = not getgenv().AutoBash

    if getgenv().AutoBash then
        start()
    end
end)
