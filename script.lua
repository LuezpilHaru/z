--[[
    Swordburst 3 - FallAngelHub
    Deobfuscated from LuaObfuscator.com (Alpha 0.10.9)
]]--

-- Key system check
if (getgenv().key == "lxrkngg") then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GSstarGamer/roblox-scripts/refs/heads/main/Swordburst3UpdatedOBF.lua"))()
    return
end

-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Key system UI (if enabled)
if (getgenv().keysystem == true) then
    local keySystemUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/ui/xrer_mstudio45.lua"))()
    keySystemUI.New({
        ApplicationName = "FallAngelHub",
        Name = "FallAngelHub",
        Info = "Get Key For FallAngelHub",
        DiscordInvite = "https://discord.gg/auzBFqDrwZ",
        AuthType = "clientid"
    })
    repeat task.wait() until keySystemUI.Finished() or keySystemUI.Closed
end

-- Load UI Libraries
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create main window
local Window = Fluent:CreateWindow({
    Title = "Swordburst 3",
    SubTitle = "FallAngelHub | discord.gg/Mv8Yjxqfet",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create tabs
local Tabs = {
    mainTab = Window:AddTab({ Title = "Main", Icon = "scroll" }),
    killauraTab = Window:AddTab({ Title = "Kill Aura", Icon = "swords" }),
    miscTab = Window:AddTab({ Title = "Misc", Icon = "layout-grid" }),
    towerTab = Window:AddTab({ Title = "Void Tower", Icon = "shield" }),
    guildTab = Window:AddTab({ Title = "Guild", Icon = "building" }),
    targetTab = Window:AddTab({ Title = "Target", Icon = "target" }),
    teleportTab = Window:AddTab({ Title = "Teleport", Icon = "user-cog" }),
    upgradeTab = Window:AddTab({ Title = "Upgrade", Icon = "hammer" }),
    webhookTab = Window:AddTab({ Title = "Webhook", Icon = "bell" }),
    creditTab = Window:AddTab({ Title = "Information", Icon = "users" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Fluent options reference
local Options = Fluent.Options

-- Services (cloneref for anti-detection)
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local TweenService = cloneref(game:GetService("TweenService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))

-- Local player
local LocalPlayer = Players.LocalPlayer

-- Required game modules
local StaminaModule = require(ReplicatedStorage.Systems.Stamina)
local FishingModule = require(ReplicatedStorage.Systems.Fishing)
local TeleportModule = require(ReplicatedStorage.Systems.Teleport)
local QuestList = require(ReplicatedStorage.Systems.Quests.QuestList)
local ItemList = require(ReplicatedStorage.Systems.Items.ItemList)

-- State variables
local currentTween
local isBossWaiting
local selectedFloor
local cancelTween
local isUniqueFlag
local _unused_v22
local selectedWaystone
local webhookUrl

-- Cloned string functions (anti-detection)
local cloneFn = clonefunction
local strSub = cloneFn(string.sub)
local strMatch = cloneFn(string.match)
local strFind = cloneFn(string.find)
local strSplit = cloneFn(string.split)

-- Data lists
local mobNames = {}
local oreNames = {}
local bossNames = {}
local questNames = {}
local waystoneNames = {}
local fishingLevels = {}
local skillNames = {}
local dropNames = {}

-- Farm method options
local farmMethods = { "above", "below", "behind" }

-- Floor list
local floorList = { "Floor1", "Floor2", "Floor3", "Floor4", "Floor5", "Floor6", "Town", "TowerHub" }

-- Categories excluded from dismantle/webhook
local excludedCategories = { "Material", "Mount", "Cosmetic", "Pickaxe" }

-- Enchant ID to description map
local enchantMap = {
    ["1"] = "MOVESPD + 20%",
    ["2"] = "ATK + 8%",
    ["3"] = "HPREGEN + 20%",
    ["4"] = "MAXHP + 20%",
    ["5"] = "CRIT + 10%",
    ["6"] = "SPREGEN + 40%",
    ["7"] = "CRITDMG + 75%",
    ["8"] = "BURSTPWR + 10%",
    ["9"] = "STAMINA + 25%"
}

-- Rarity lists for dismantle (and below)
local dismantleRarities = {
    "common (white)",
    "uncommon (green) and below",
    "rare (blue) and below",
    "epic (purple) and below",
    "legendary (orange) and below"
}

-- Rarity lists for webhook (and higher)
local webhookRarities = {
    "common (white) and higher",
    "uncommon (green) and higher",
    "rare (blue) and higher",
    "epic (purple) and higher",
    "legendary (orange) only"
}

-- Rarity string to numeric value
local rarityValues = {
    ["common (white)"] = 1,
    ["uncommon (green)"] = 2,
    ["rare (blue)"] = 3,
    ["epic (purple)"] = 4,
    ["legendary (orange)"] = 5
}

-- Mob spawn positions per floor
local mobPositions = {
    Floor1 = {
        Basilisk = {
            Position = Vector3.new(-862.26318359375, -77.29805755615234, 738.7144165039062),
            CFrame = CFrame.new(-862.26318359375, -77.29805755615234, 738.7144165039062)
        },
        ["Brown Bear"] = {
            Position = Vector3.new(798.4417724609375, 174.1746368408203, 1415.19677734375),
            CFrame = CFrame.new(798.4417724609375, 174.1746368408203, 1415.19677734375)
        },
        ["Crystal Boar"] = {
            Position = Vector3.new(-529.992431640625, 150.70542907714844, 783.7307739257812),
            CFrame = CFrame.new(-529.992431640625, 150.70542907714844, 783.7307739257812)
        },
        ["Razor Boar"] = {
            Position = Vector3.new(897.904296875, 131.67388916015625, -947.9832153320312),
            CFrame = CFrame.new(897.904296875, 131.67388916015625, -947.9832153320312)
        },
        ["Rock Golem"] = {
            Position = Vector3.new(279.1563720703125, 207.06259155273438, 1357.7916259765625),
            CFrame = CFrame.new(279.1563720703125, 207.06259155273438, 1357.7916259765625)
        },
        ["Soldier Boar"] = {
            Position = Vector3.new(-1760.115234375, -43.43751907348633, 1748.4549560546875),
            CFrame = CFrame.new(-1760.115234375, -43.43751907348633, 1748.4549560546875)
        },
        ["Thunder Sakura Moose"] = {
            Position = Vector3.new(-488.3043212890625, 210.30789184570312, -119.70502471923828),
            CFrame = CFrame.new(-488.3043212890625, 210.30789184570312, -119.70502471923828)
        },
        Tortoise = {
            Position = Vector3.new(1446.4488525390625, 127.01861572265625, -370.18182373046875),
            CFrame = CFrame.new(1446.4488525390625, 127.01861572265625, -370.18182373046875)
        },
        Wolf = {
            Position = Vector3.new(863.54443359375, 131.0957489013672, 40.45374298095703),
            CFrame = CFrame.new(863.54443359375, 131.0957489013672, 40.45374298095703)
        }
    },
    Floor2 = {
        ["Ember Jaguar"] = {
            Position = Vector3.new(565.008544921875, 404.27178955078125, 43.87567138671875),
            CFrame = CFrame.new(565.008544921875, 404.27178955078125, 43.87567138671875)
        },
        ["Fiery Moose"] = {
            Position = Vector3.new(-145.9317169189453, 386.11541748046875, -3065.82763671875),
            CFrame = CFrame.new(-145.9317169189453, 386.11541748046875, -3065.82763671875)
        },
        ["Fire Imp"] = {
            Position = Vector3.new(22.740245819091797, -297.7325744628906, -3466.63818359375),
            CFrame = CFrame.new(22.740245819091797, -297.7325744628906, -3466.63818359375)
        },
        ["Fire Wasp"] = {
            Position = Vector3.new(-63.78221893310547, 333.5207214355469, 984.7338256835938),
            CFrame = CFrame.new(-63.78221893310547, 333.5207214355469, 984.7338256835938)
        },
        ["Hell Hound"] = {
            Position = Vector3.new(-980.1229858398438, -331.5343322753906, -1971.0489501953125),
            CFrame = CFrame.new(-980.1229858398438, -331.5343322753906, -1971.0489501953125)
        },
        ["Lava Basilisk"] = {
            Position = Vector3.new(1413.092529296875, 405.06268310546875, -671.137939453125),
            CFrame = CFrame.new(1413.092529296875, 405.06268310546875, -671.137939453125)
        },
        ["Magma Golem"] = {
            Position = Vector3.new(-1658.054443359375, 518.244384765625, -1454.707763671875),
            CFrame = CFrame.new(-1658.054443359375, 518.244384765625, -1454.707763671875)
        },
        Phoenix = {
            Position = Vector3.new(-1882.8916015625, 515.0499877929688, -1031.61083984375),
            CFrame = CFrame.new(-1882.8916015625, 515.0499877929688, -1031.61083984375)
        },
        ["Skeleton Bear"] = {
            Position = Vector3.new(836.9502563476562, 402.3498840332031, -822.7938232421875),
            CFrame = CFrame.new(836.9502563476562, 402.3498840332031, -822.7938232421875)
        }
    },
    Floor3 = {
        ["Chill Bat"] = {
            Position = Vector3.new(-1673.8651123046875, 236.44541931152344, -1950.248046875),
            CFrame = CFrame.new(-1673.8651123046875, 236.44541931152344, -1950.248046875)
        },
        ["Cold Mammoth"] = {
            Position = Vector3.new(-3169.08935546875, 234.57823181152344, 56.66799545288086),
            CFrame = CFrame.new(-3169.08935546875, 234.57823181152344, 56.66799545288086)
        },
        ["Mist Bunny"] = {
            Position = Vector3.new(-223.70713806152344, 64.55667114257812, 2469.333251953125),
            CFrame = CFrame.new(-223.70713806152344, 64.55667114257812, 2469.333251953125)
        },
        ["Frost Scorpion"] = {
            Position = Vector3.new(-138.11627197265625, 81.73929595947266, -1139.07861328125),
            CFrame = CFrame.new(-138.11627197265625, 81.73929595947266, -1139.07861328125)
        },
        Penguin = {
            Position = Vector3.new(719.542236328125, 17.156511306762695, 474.27288818359375),
            CFrame = CFrame.new(719.542236328125, 17.156511306762695, 474.27288818359375)
        },
        ["Polar Bear"] = {
            Position = Vector3.new(-2866.92529296875, 228.58213806152344, -515.750244140625),
            CFrame = CFrame.new(-2866.92529296875, 228.58213806152344, -515.750244140625)
        },
        ["Snow Kitsune"] = {
            Position = Vector3.new(-475.0198669433594, 84.20121002197266, -2415.970703125),
            CFrame = CFrame.new(-475.0198669433594, 84.20121002197266, -2415.970703125)
        },
        ["Ice Wraith"] = {
            Position = Vector3.new(-22720.41796875, 2971.15771484375, 1777.969482421875),
            CFrame = CFrame.new(-22720.41796875, 2971.15771484375, 1777.969482421875)
        },
        Icewhal = {
            Position = Vector3.new(-24497.66796875, 2986.56396484375, -81.09378814697266),
            CFrame = CFrame.new(-24497.66796875, 2986.56396484375, -81.09378814697266)
        }
    },
    Floor4 = {
        ["Spirit Lion"] = {
            Position = Vector3.new(343.34210205078125, 152.0961456298828, -67.30443572998047),
            CFrame = CFrame.new(343.34210205078125, 152.0961456298828, -67.30443572998047)
        },
        ["Oasis Tortoise"] = {
            Position = Vector3.new(1497.599609375, 154.2374267578125, 509.84295654296875),
            CFrame = CFrame.new(1497.599609375, 154.2374267578125, 509.84295654296875)
        },
        ["Desert Phoenix"] = {
            Position = Vector3.new(-1181.2447509765625, 151.6582794189453, -785.0072021484375),
            CFrame = CFrame.new(-1181.2447509765625, 151.6582794189453, -785.0072021484375)
        },
        Dragonfly = {
            Position = Vector3.new(2307.233642578125, 152.5059356689453, 801.1273193359375),
            CFrame = CFrame.new(2307.233642578125, 152.5059356689453, 801.1273193359375)
        },
        Camel = {
            Position = Vector3.new(786.9095458984375, 154.65435791015625, 1914.4541015625),
            CFrame = CFrame.new(786.9095458984375, 154.65435791015625, 1914.4541015625)
        },
        Raptor = {
            Position = Vector3.new(-381.48236083984375, 153.4777069091797, -826.4151000976562),
            CFrame = CFrame.new(-381.48236083984375, 153.4777069091797, -826.4151000976562)
        },
        Crocodile = {
            Position = Vector3.new(365.55291748046875, 152.9317169189453, -1804.8533935546875),
            CFrame = CFrame.new(365.55291748046875, 152.9317169189453, -1804.8533935546875)
        },
        ["Jeweled Scarab"] = {
            Position = Vector3.new(-588.2952270507812, -395.679931640625, 3732.31005859375),
            CFrame = CFrame.new(-588.2952270507812, -395.679931640625, 3732.31005859375)
        },
        ["Tomb Scorpion"] = {
            Position = Vector3.new(169.7813262939453, -413.28143310546875, 3333.253662109375),
            CFrame = CFrame.new(169.7813262939453, -413.28143310546875, 3333.253662109375)
        }
    },
    Floor5 = {
        ["Blossom Boar"] = {
            Position = Vector3.new(581.1213989257812, 885.1898803710938, 1110.18603515625),
            CFrame = CFrame.new(581.1213989257812, 885.1898803710938, 1110.18603515625)
        },
        Goblin = {
            Position = Vector3.new(-1950.064697265625, 865.5941162109375, -626.42529296875),
            CFrame = CFrame.new(-1950.064697265625, 865.5941162109375, -626.42529296875)
        },
        Mushroom = {
            Position = Vector3.new(-1358.4400634765625, 886.2601928710938, -2928.14990234375),
            CFrame = CFrame.new(-1358.4400634765625, 886.2601928710938, -2928.14990234375)
        },
        ["Spectral Wolf"] = {
            Position = Vector3.new(-2140.5302734375, 900.9379272460938, -1486.4871826171875),
            CFrame = CFrame.new(-2140.5302734375, 900.9379272460938, -1486.4871826171875)
        },
        ["Twilight Deer"] = {
            Position = Vector3.new(-1681.6004638671875, 888.3148803710938, -2067.5009765625),
            CFrame = CFrame.new(-1681.6004638671875, 888.3148803710938, -2067.5009765625)
        },
        Unicorn = {
            Position = Vector3.new(-938.0299682617188, 886.2479248046875, 1005.3434448242188),
            CFrame = CFrame.new(-938.0299682617188, 886.2479248046875, 1005.3434448242188)
        },
        Twinklefly = {
            Position = Vector3.new(705.8857421875, 880.232177734375, -347.11468505859375),
            CFrame = CFrame.new(705.8857421875, 880.232177734375, -347.11468505859375)
        },
        Panther = {
            Position = Vector3.new(-8661.46484375, 1146.79736328125, 3319.56396484375),
            CFrame = CFrame.new(-8661.46484375, 1146.79736328125, 3319.56396484375)
        },
        Treant = {
            Position = Vector3.new(-9304.0517578125, 1137.72705078125, 2322.852783203125),
            CFrame = CFrame.new(-9304.0517578125, 1137.72705078125, 2322.852783203125)
        }
    },
    Floor6 = {
        Crab = {
            Position = Vector3.new(643.5852661132812, 102.09477233886719, 1658.966552734375),
            CFrame = CFrame.new(643.5852661132812, 102.09477233886719, 1658.966552734375)
        },
        Jellyfish = {
            Position = Vector3.new(-302.4776916503906, 16.64453887939453, -1410.512451171875),
            CFrame = CFrame.new(-302.4776916503906, 16.64453887939453, -1410.512451171875)
        },
        ["Ocean Wraith"] = {
            Position = Vector3.new(-2067.8251953125, 15.906257629394531, 1336.381591796875),
            CFrame = CFrame.new(-2067.8251953125, 15.906257629394531, 1336.381591796875)
        },
        Seahorse = {
            Position = Vector3.new(895.560546875, 89.81387329101562, 504.3514709472656),
            CFrame = CFrame.new(895.560546875, 89.81387329101562, 504.3514709472656)
        },
        ["Sea Turtle"] = {
            Position = Vector3.new(559.524169921875, 88.0638427734375, -293.3013610839844),
            CFrame = CFrame.new(559.524169921875, 88.0638427734375, -293.3013610839844)
        },
        Pirate = {
            Position = Vector3.new(-1040.4793701171875, 17.908702850341797, -1369.8963623046875),
            CFrame = CFrame.new(-1040.4793701171875, 17.908702850341797, -1369.8963623046875)
        },
        ["Sea Basilisk"] = {
            Position = Vector3.new(-2138.6552734375, 16.04883575439453, -96.77153015136719),
            CFrame = CFrame.new(-2138.6552734375, 16.04883575439453, -96.77153015136719)
        },
        Tortoise = {
            Position = Vector3.new(),
            CFrame = CFrame.new()
        },
        ["Thunder Sakura Moose"] = {
            Position = Vector3.new(),
            CFrame = CFrame.new()
        }
    }
}

---------------------------------------------------------------------------
-- Utility Functions
---------------------------------------------------------------------------

-- Get the player's character (waits if not yet spawned)
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Get the HumanoidRootPart of the character
local function getHumanoidRootPart()
    return getCharacter():FindFirstChild("HumanoidRootPart") or getCharacter():WaitForChild("HumanoidRootPart", 10)
end

-- Get a list of other player names in the server
local function getOtherPlayerNames()
    local names = {}
    for _, player in next, Players:GetPlayers() do
        if (player ~= LocalPlayer) then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- Send a Discord webhook notification
local function sendWebhook(url, itemName, enchantId)
    local itemName = itemName or "nothing"
    local enchantDesc = enchantMap[enchantId] or "nothing"

    local level = LocalPlayer.PlayerGui.MainHUD.Frame.Bars.LevelShadow.LevelLabel.Text
    local xp = LocalPlayer.PlayerGui.MainHUD.Frame.XPFrame.XPCount.Text
    local vel = LocalPlayer.PlayerGui.Inventory.Frame.Currency.Vel.TextLabel.Text

    local payload = {
        embeds = {
            {
                title = "**SwordBurst 3**",
                description = "Username: " .. LocalPlayer.Name
                    .. "\n Level: " .. level
                    .. "\n XP: " .. xp
                    .. "\n Vel: " .. vel
                    .. "\n Got Item : " .. itemName
                    .. " Enchant : " .. enchantDesc,
                type = "rich",
                color = tonumber(7498202)
            }
        }
    }

    local body = game:GetService("HttpService"):JSONEncode(payload)
    local headers = { ["content-type"] = "application/json" }
    request = http_request or request or HttpPost or syn.request
    local requestData = {
        Url = url,
        Body = body,
        Method = "POST",
        Headers = headers
    }
    request(requestData)
end

-- Create a floating platform part under the player
local function createPlatform(cframe, size, canCollide)
    local platform = Instance.new("Part")
    platform.Parent = workspace
    platform.Anchored = true
    platform.CanCollide = canCollide
    platform.Size = Vector3.new(20, 1, 20)
    platform.Transparency = 0.5
    platform.Name = "huehueheue"
    platform.CFrame = cframe
    return platform
end

-- Tween the player's HumanoidRootPart to a target position
local function tweenTo(part, target, speed, offset)
    local offset = offset or CFrame.new(0, 0, 0)

    -- Cancel any existing tween
    if (currentTween and (currentTween.PlaybackState == Enum.PlaybackState.Playing)) then
        currentTween:Cancel()
    end

    if (not part or not target) then
        return
    end

    currentTween = TweenService:Create(
        part,
        TweenInfo.new(
            (part.Position - target.Position).magnitude / speed,
            Enum.EasingStyle.Linear
        ),
        { CFrame = target.CFrame * offset }
    )

    local tweenCompleted = false
    currentTween.Completed:Connect(function()
        tweenCompleted = true
    end)

    if (currentTween.PlaybackState ~= Enum.PlaybackState.Playing) then
        currentTween:Play()
    end

    repeat
        task.wait()

        -- Clean up any existing platform parts
        if workspace:FindFirstChild("huehueheue") then
            for _, child in next, workspace:GetChildren() do
                if (child.Name == "huehueheue") then
                    child:Destroy()
                end
            end
        end

        -- Safety check: cancel if character is missing or cancelTween flag is set
        if (not getCharacter() or not getHumanoidRootPart() or cancelTween or not part or not target) then
            if currentTween then
                currentTween:Cancel()
            end
            return
        end

        -- Create platform under player to prevent falling
        if (getCharacter() and getHumanoidRootPart()) then
            createPlatform(getHumanoidRootPart().CFrame * CFrame.new(0, -5, 0), 1, true)
        end
    until tweenCompleted and getCharacter() and getHumanoidRootPart()
end

-- Find the nearest waystone to a given part
local function getNearestWaystone(targetPart)
    local minDist = math.huge
    local nearestWaystone
    for _, waystone in next, workspace.Waystones:GetChildren() do
        if (not strFind(waystone.Name, "Teleporter") and waystone:FindFirstChild("Spawn") and getCharacter() and getHumanoidRootPart() and targetPart) then
            local dist = (targetPart.Position - waystone.Spawn.Position).magnitude
            if (dist < minDist) then
                nearestWaystone = waystone
                minDist = dist
            end
        end
    end
    return nearestWaystone
end

-- Get the current floor name based on PlaceId
local function getCurrentFloor()
    for floorName, floorData in next, debug.getupvalue(TeleportModule.TeleportToWorld, 1) do
        if (floorData.LiveID == game.PlaceId) then
            return floorName
        end
    end
    return
end

---------------------------------------------------------------------------
-- Initialize Data Lists
---------------------------------------------------------------------------

-- Populate boss names
if workspace:FindFirstChild("BossArenas") then
    for _, arena in next, workspace.BossArenas:GetChildren() do
        table.insert(bossNames, arena.Name)
    end
end

-- Populate mob names
if workspace:FindFirstChild("MobSpawns") then
    for _, mobSpawn in next, workspace.MobSpawns:GetChildren() do
        table.insert(mobNames, mobSpawn.Name)
    end
end

-- Populate waystone names
if workspace:FindFirstChild("Waystones") then
    for _, waystone in next, workspace.Waystones:GetChildren() do
        table.insert(waystoneNames, waystone.Name)
    end
end

-- Populate ore names (unique only)
if workspace:FindFirstChild("Ores") then
    for _, ore in next, workspace.Ores:GetChildren() do
        isUniqueFlag = true
        for _, existingName in next, oreNames do
            if (existingName == ore.Name) then
                isUniqueFlag = false
            end
        end
        if isUniqueFlag then
            table.insert(oreNames, ore.Name)
        end
    end
end

-- Populate fishing spot levels (unique, sorted)
if workspace:FindFirstChild("FishingSpots") then
    for _, fishSpot in next, workspace.FishingSpots:GetChildren() do
        isUniqueFlag = true
        for _, existingLevel in next, fishingLevels do
            if (existingLevel == fishSpot.Level.Value) then
                isUniqueFlag = false
            end
        end
        if isUniqueFlag then
            table.insert(fishingLevels, fishSpot.Level.Value)
        end
    end
    table.sort(fishingLevels)
end

-- Clean up existing UI templates to prevent duplicates
for _, child in next, LocalPlayer.PlayerGui.Upgrade.Frame.List:GetChildren() do
    if (child.Name == "ItemTemplate") then
        child:Destroy()
    end
end

for _, child in next, LocalPlayer.PlayerGui.Mounts.Frame.Mounts.MountList.Items:GetChildren() do
    if (child.Name == "ItemTemplate") then
        child:Destroy()
    end
end

for _, child in next, LocalPlayer.PlayerGui.Enchant.Frame.List:GetChildren() do
    if (child.Name == "ItemTemplate") then
        child:Destroy()
    end
end

-- Populate quest names
for questIndex, questData in next, QuestList do
    table.insert(questNames, "Level " .. questData.Level .. " " .. questData.Target .. " " .. ((questData.Repeatable and "Repeatable") or ""))
end

-- Disable idle kick
for _, connection in next, getconnections(LocalPlayer.Idled) do
    if connection['Disable'] then
        connection['Disable'](connection)
    elseif connection['Disconnect'] then
        connection['Disconnect'](connection)
    end
end

-- Populate drop names
for _, drop in next, workspace.Drops:GetChildren() do
    table.insert(dropNames, drop.Name)
end

-- Populate skill names
for _, skill in next, ReplicatedStorage.Systems.Skills.Skills:GetChildren() do
    table.insert(skillNames, skill.Name)
end

---------------------------------------------------------------------------
-- UI Setup - Main Tab
---------------------------------------------------------------------------

Tabs.mainTab:AddDropdown("method", {
    Title = "Select Auto farm method",
    Values = farmMethods,
    Multi = false,
    Default = "behind"
})

Tabs.mainTab:AddSlider("tweenspeed", {
    Title = "Tweening Speed",
    Description = "",
    Default = 90,
    Min = 50,
    Max = 100,
    Rounding = 1
})

local autoLevelToggle = Tabs.mainTab:AddToggle("autolvl", {
    Title = "Auto level farm",
    Default = false,
    Description = "Non-Repeatable quests will not be done."
})
autoLevelToggle:OnChanged(function()
    if (Options.autolvl.Value == false) then
        if currentTween then
            cancelTween = true
        end
    else
        cancelTween = false
    end
end)

Tabs.mainTab:AddSlider("dist", {
    Title = "Auto Farm Distance",
    Description = "",
    Default = 15,
    Min = 1,
    Max = 50,
    Rounding = 0
})

Tabs.mainTab:AddDropdown("choosemob", {
    Title = "Select Mobs",
    Values = mobNames,
    Multi = false,
    Default = nil
})

local autoMobsToggle = Tabs.mainTab:AddToggle("automobs", {
    Title = "Auto Farm Mobs",
    Default = false
})
autoMobsToggle:OnChanged(function()
    if (Options.automobs.Value == false) then
        if currentTween then
            cancelTween = true
        end
    else
        cancelTween = false
    end
end)

Tabs.mainTab:AddDropdown("boss", {
    Title = "Select Boss",
    Values = bossNames,
    Multi = false,
    Default = nil
})

Tabs.mainTab:AddParagraph({
    Title = "Auto Farm Boss",
    Content = "When boss havent spawn will farm selected mob"
})

local autoBossToggle = Tabs.mainTab:AddToggle("autoboss", {
    Title = "Auto farm Boss",
    Default = false
})
autoBossToggle:OnChanged(function()
    if (Options.autoboss.Value == false) then
        if currentTween then
            cancelTween = true
        end
    else
        cancelTween = false
    end
end)

Tabs.mainTab:AddDropdown("choosequest", {
    Title = "Select Quest",
    Values = questNames,
    Multi = false,
    Default = nil
})

Tabs.mainTab:AddToggle("autoquest", {
    Title = "Auto Quest",
    Default = false
})

Tabs.mainTab:AddSlider("cds", {
    Title = "Mine Ores Cooldown",
    Description = "",
    Default = 0.45,
    Min = 0.45,
    Max = 1,
    Rounding = 2
})

Tabs.mainTab:AddDropdown("mine", {
    Title = "Select Ores",
    Values = oreNames,
    Multi = false,
    Default = nil
})

local autoMineToggle = Tabs.mainTab:AddToggle("automine", {
    Title = "Auto Mine Ores",
    Default = false
})
autoMineToggle:OnChanged(function()
    if (Options.automine.Value == false) then
        if currentTween then
            cancelTween = true
        end
    else
        cancelTween = false
    end
end)

Tabs.mainTab:AddToggle("autocollect", {
    Title = "Auto Collect",
    Default = false
})

---------------------------------------------------------------------------
-- UI Setup - Kill Aura Tab
---------------------------------------------------------------------------

Tabs.killauraTab:AddParagraph({
    Title = "Kill Aura Cooldown",
    Content = "Higher up cooldown if does no damage"
})

Tabs.killauraTab:AddSlider("cd", {
    Title = "Kill Aura Cooldown",
    Description = "",
    Default = 0.3,
    Min = 0.25,
    Max = 1,
    Rounding = 2
})

Tabs.killauraTab:AddSlider("range", {
    Title = "Kill Aura Range",
    Description = "",
    Default = 40,
    Min = 1,
    Max = 100,
    Rounding = 0
})

Tabs.killauraTab:AddToggle("aura", {
    Title = "Kill Aura",
    Default = false
})

Tabs.killauraTab:AddParagraph({
    Title = "Kill aura for Players",
    Content = "Enable PvP to dmg ppl"
})

Tabs.killauraTab:AddToggle("killauraplr", {
    Title = "Kill Aura for Players",
    Default = false
})

Tabs.killauraTab:AddToggle("skille", {
    Title = "Auto Skill E",
    Default = false
})

Tabs.killauraTab:AddToggle("skillr", {
    Title = "Auto Skill R",
    Default = false
})

Tabs.killauraTab:AddToggle("skillf", {
    Title = "Auto Skill F",
    Default = false
})

Tabs.killauraTab:AddToggle("skillx", {
    Title = "Auto Skill X",
    Default = false
})

Tabs.killauraTab:AddToggle("ignoreparty", {
    Title = "Ignore Party Members",
    Default = false
})

---------------------------------------------------------------------------
-- UI Setup - Teleport Tab
---------------------------------------------------------------------------

local waystoneDropdown = Tabs.teleportTab:AddDropdown("", {
    Title = "Select Waystones",
    Values = waystoneNames,
    Multi = false,
    Default = nil
})
waystoneDropdown:OnChanged(function(value)
    selectedWaystone = value
end)

Tabs.teleportTab:AddButton({
    Title = "Teleport Waystones",
    Description = "",
    Callback = function()
        if (selectedWaystone and getCharacter() and getHumanoidRootPart()) then
            for _, waystone in next, workspace.Waystones:GetChildren() do
                if (waystone.Name == selectedWaystone) then
                    tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                    task.wait(1)
                    ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(waystone:FindFirstChild("Spawn")))
                    task.wait(2)
                end
            end
        end
    end
})

local floorDropdown = Tabs.teleportTab:AddDropdown("", {
    Title = "Select Floor",
    Values = floorList,
    Multi = false,
    Default = nil
})
floorDropdown:OnChanged(function(value)
    selectedFloor = value
end)

Tabs.teleportTab:AddButton({
    Title = "Teleport to Selected Floor",
    Description = "",
    Callback = function()
        if selectedFloor then
            ReplicatedStorage.Systems.Teleport.Teleport:FireServer(selectedFloor)
        end
    end
})

---------------------------------------------------------------------------
-- UI Setup - Misc Tab
---------------------------------------------------------------------------

local disable3DToggle = Tabs.miscTab:AddToggle("3drendering", {
    Title = "Disable 3D Rendering",
    Default = false
})
disable3DToggle:OnChanged(function()
    if Options["3drendering"].Value then
        RunService:Set3dRenderingEnabled(false)
    else
        RunService:Set3dRenderingEnabled(true)
    end
end)



Tabs.miscTab:AddButton({
    Title = "Infinite Stamina",
    Description = "",
    Callback = function()
        debug.setupvalue(StaminaModule.SetMaxStamina, 1, 99999999)
        debug.setupvalue(StaminaModule.CanUseStamina, 1, 99999999)
    end
})

Tabs.miscTab:AddButton({
    Title = "Claim All Chest",
    Description = "",
    Callback = function()
        for _, child in next, workspace:GetChildren() do
            if ((child.Name == "Chest") and child:FindFirstChild("RootPart") and child:FindFirstChild("RootPart"):FindFirstChild("ProximityPrompt") and getCharacter() and getHumanoidRootPart()) then
                local dist = (getHumanoidRootPart().Position - child:FindFirstChild("RootPart").Position).Magnitude
                if (dist >= 800) then
                    tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                    task.wait(1)
                    ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(child:FindFirstChild("RootPart")))
                    task.wait(2)
                end
                tweenTo(getHumanoidRootPart(), child:FindFirstChild("RootPart"), Options['tweenspeed'].Value, CFrame.new(0, 2, 0))
                repeat
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(true, "E", false, game)
                until child:FindFirstChild("RootPart"):FindFirstChild("ProximityPrompt") == nil
            end
        end
    end
})

Tabs.miscTab:AddButton({
    Title = "Unlock all waystones",
    Description = "",
    Callback = function()
        for _, waystone in next, workspace.Waystones:GetChildren() do
            if tonumber(waystone.Name) then
                tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                task.wait(1)
                ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(waystone:FindFirstChild("Spawn")))
                task.wait(1)
                ReplicatedStorage.Systems.Locations.UnlockWaystone:FireServer(waystone)
                task.wait(1)
            end
        end
    end
})

Tabs.miscTab:AddDropdown("rarity", {
    Title = "Select Rarity",
    Values = dismantleRarities,
    Multi = false,
    Default = nil
})

Tabs.miscTab:AddToggle("dismantle", {
    Title = "Dismantle Selected rarity",
    Default = false
})

Tabs.miscTab:AddDropdown("fish", {
    Title = "Select Fishing Spots Level",
    Values = fishingLevels,
    Multi = false,
    Default = ""
})

Tabs.miscTab:AddToggle("autofish", {
    Title = "Auto Fishing",
    Default = false
})

---------------------------------------------------------------------------
-- UI Setup - Information Tab
---------------------------------------------------------------------------

Tabs.creditTab:AddParagraph({ Title = "Head Dev - fallen_del", Content = "" })
Tabs.creditTab:AddParagraph({ Title = "Dev - gs._", Content = "" })
Tabs.creditTab:AddParagraph({ Title = "UI Library by dawid", Content = "" })

Tabs.creditTab:AddButton({
    Title = "Discord Server",
    Description = "",
    Callback = function()
        setclipboard("https://discord.gg/auzBFqDrwZ")
    end
})

---------------------------------------------------------------------------
-- UI Setup - Webhook Tab
---------------------------------------------------------------------------

Tabs.webhookTab:AddInput("Input", {
    Title = "Webhook Url",
    Default = "",
    Placeholder = "Ur webhook url",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        webhookUrl = value
    end
})

Tabs.webhookTab:AddButton({
    Title = "Test Webhook",
    Description = "",
    Callback = function()
        if webhookUrl then
            sendWebhook(webhookUrl)
        end
    end
})

Tabs.webhookTab:AddDropdown("rarityw", {
    Title = "Select Rarity for webhook",
    Values = webhookRarities,
    Multi = false,
    Default = "legendary (orange) only"
})

Tabs.webhookTab:AddToggle("webhook", {
    Title = "Webhook",
    Default = false
})

---------------------------------------------------------------------------
-- UI Setup - Target Tab
---------------------------------------------------------------------------

Tabs.targetTab:AddDropdown("choosetarget", {
    Title = "Select Target",
    Values = getOtherPlayerNames(),
    Multi = false,
    Default = nil
})

local targetPlayerToggle = Tabs.targetTab:AddToggle("targetplr", {
    Title = "Tp to Selected Players",
    Default = false
})
targetPlayerToggle:OnChanged(function()
    if (Options.targetplr.Value == false) then
        if currentTween then
            cancelTween = true
        end
    else
        cancelTween = false
    end
end)

---------------------------------------------------------------------------
-- UI Setup - Upgrade Tab
---------------------------------------------------------------------------

Tabs.upgradeTab:AddButton({
    Title = "Open Upgrade Gui",
    Description = "",
    Callback = function()
        if LocalPlayer.PlayerGui.Upgrade.Frame.List:FindFirstChild("ItemTemplate") then
            LocalPlayer.PlayerGui.Upgrade.Enabled = true
            LocalPlayer.PlayerGui.Upgrade.Frame.Visible = true
        else
            repeat
                task.wait(0.1)
                if (getCharacter() and getHumanoidRootPart()) then
                    local dist = (getHumanoidRootPart().Position - workspace.CraftingStations.Smithing.Position).Magnitude
                    if (dist >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(workspace.CraftingStations.Smithing))
                        task.wait(2)
                    end
                end
                tweenTo(getHumanoidRootPart(), workspace.CraftingStations.Smithing, Options['tweenspeed'].Value)
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
            until LocalPlayer.PlayerGui.Upgrade.Frame.List:FindFirstChild("ItemTemplate")
        end
    end
})

Tabs.upgradeTab:AddButton({
    Title = "Open Mount Gui",
    Description = "",
    Callback = function()
        if LocalPlayer.PlayerGui.Mounts.Frame.Mounts.MountList.Items:FindFirstChild("ItemTemplate") then
            LocalPlayer.PlayerGui.Mounts.Enabled = true
            LocalPlayer.PlayerGui.Mounts.Frame.Visible = true
        else
            repeat
                task.wait(0.1)
                if (getCharacter() and getHumanoidRootPart()) then
                    local dist = (getHumanoidRootPart().Position - workspace.CraftingStations.Mounts.Position).Magnitude
                    if (dist >= 1000) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(workspace.CraftingStations.Mounts))
                        task.wait(2)
                    end
                end
                tweenTo(getHumanoidRootPart(), workspace.CraftingStations.Mounts, Options['tweenspeed'].Value)
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
            until LocalPlayer.PlayerGui.Mounts.Frame.Mounts.MountList.Items:FindFirstChild("ItemTemplate")
        end
    end
})

Tabs.upgradeTab:AddButton({
    Title = "Open Enchant Gui",
    Description = "",
    Callback = function()
        if LocalPlayer.PlayerGui.Enchant.Frame.List:FindFirstChild("ItemTemplate") then
            LocalPlayer.PlayerGui.Enchant.Enabled = true
            LocalPlayer.PlayerGui.Enchant.Frame.Visible = true
        else
            repeat
                task.wait(0.1)
                if (getCharacter() and getHumanoidRootPart()) then
                    local dist = (getHumanoidRootPart().Position - workspace.CraftingStations.Enchanting.Position).Magnitude
                    if (dist >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(workspace.CraftingStations.Enchanting))
                        task.wait(2)
                    end
                end
                tweenTo(getHumanoidRootPart(), workspace.CraftingStations.Enchanting, Options['tweenspeed'].Value)
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
            until LocalPlayer.PlayerGui.Enchant.Frame.List:FindFirstChild("ItemTemplate")
        end
    end
})

---------------------------------------------------------------------------
-- UI Setup - Void Tower Tab
---------------------------------------------------------------------------

Tabs.towerTab:AddToggle("tower", {
    Title = "Auto Farm Mobs",
    Default = false
})

Tabs.towerTab:AddInput("floor", {
    Title = "Floor",
    Default = 1,
    Placeholder = "",
    Numeric = true,
    Finished = false
})

Tabs.towerTab:AddButton({
    Title = "Start Void Tower",
    Description = "",
    Callback = function()
        ReplicatedStorage.Systems.TowerDungeon.StartDungeon:FireServer(Options['floor'].Value)
    end
})

Tabs.towerTab:AddButton({
    Title = "Exit Void Tower",
    Description = "",
    Callback = function()
        ReplicatedStorage.Systems.TowerDungeon.ExitDungeon:FireServer()
    end
})

---------------------------------------------------------------------------
-- UI Setup - Guild Tab
---------------------------------------------------------------------------

Tabs.guildTab:AddButton({
    Title = "Teleport To Guild Arena",
    Description = "",
    Callback = function()
        ReplicatedStorage.Systems.Guilds.TeleportToArena:FireServer()
    end
})

Tabs.guildTab:AddToggle("autoguild", {
    Title = "Auto Farm Guild Boss",
    Default = false
})

---------------------------------------------------------------------------
-- Combat & Mob Finding Functions
---------------------------------------------------------------------------

-- Find the nearest mob in workspace (any mob)
local function getNearestMob()
    local minDist = math.huge
    local nearestMob
    for _, mob in next, workspace.Mobs:GetChildren() do
        if (mob:FindFirstChild("HumanoidRootPart") and getCharacter() and getHumanoidRootPart()) then
            local dist = (getHumanoidRootPart().Position - mob:FindFirstChild("HumanoidRootPart").Position).magnitude
            if mob:FindFirstChild("Healthbar") then
                if (dist < minDist) then
                    nearestMob = mob
                    minDist = dist
                end
            end
        end
    end
    return nearestMob
end

-- Get the CFrame offset based on farm method setting
local function getFarmOffset()
    if (Options['method'].Value == "above") then
        return CFrame.new(0, Options['dist'].Value, 0)
    elseif (Options['method'].Value == "below") then
        return CFrame.new(0, -Options['dist'].Value, 0)
    elseif (Options['method'].Value == "behind") then
        return CFrame.new(0, 0, Options['dist'].Value)
    end
end

-- Find mobs by name and mobs within kill aura range
local function findMobs(mobName)
    local minDist = math.huge
    local result = { mobs = nil, multimobs = {} }

    for _, mob in next, workspace.Mobs:GetChildren() do
        if (mob:FindFirstChild("HumanoidRootPart") and getCharacter() and getHumanoidRootPart()) then
            local dist = (getHumanoidRootPart().Position - mob:FindFirstChild("HumanoidRootPart").Position).magnitude

            -- Find nearest mob matching the given name
            if (mobName and strFind(mob.Name, mobName) and mob:FindFirstChild("Healthbar")) then
                if (dist < minDist) then
                    result.mobs = mob
                    minDist = dist
                end
            end

            -- Collect all mobs within kill aura range
            if (dist <= tonumber(Options['range'].Value)) then
                table.insert(result.multimobs, mob)
            end
        end
    end
    return result
end

-- Find players by name and players within kill aura range
local function findPlayers(playerName)
    local minDist = math.huge
    local result = { plr = nil, multiplr = {} }

    -- Get party member names
    local function getPartyMembers()
        local members = {}
        if LocalPlayer.PlayerGui:FindFirstChild("Party") then
            for _, member in next, LocalPlayer.PlayerGui.Party.Frame.Members:GetChildren() do
                if ((member.Name == "Template") and member:FindFirstChild("Username")) then
                    table.insert(members, member:FindFirstChild("Username").Text)
                end
            end
        end
        return members
    end

    for _, player in next, Players:GetPlayers() do
        if ((player ~= LocalPlayer) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and getCharacter() and getHumanoidRootPart()) then
            -- Skip party members if ignore party is enabled
            if (Options['ignoreparty'].Value and table.find(getPartyMembers(), player.DisplayName)) then
                continue
            end

            local dist = (getHumanoidRootPart().Position - player.Character:FindFirstChild("HumanoidRootPart").Position).magnitude

            -- Find nearest player matching the given name
            if (playerName and strFind(player.Name, playerName) and player.Character:FindFirstChild("Healthbar")) then
                if (dist < minDist) then
                    result.plr = player.Character
                    minDist = dist
                end
            end

            -- Collect all players within kill aura range
            if (dist <= tonumber(Options['range'].Value)) then
                table.insert(result.multiplr, player.Character)
            end
        end
    end
    return result
end

-- Find the nearest ore of the selected type
local function getNearestOre()
    local minDist = math.huge
    local nearestOre
    for _, ore in next, workspace.Ores:GetChildren() do
        if ((ore.Name == Options['mine'].Value) and getCharacter() and getHumanoidRootPart() and ore:FindFirstChildWhichIsA("MeshPart") and (ore:FindFirstChildWhichIsA("MeshPart").Position ~= Vector3.new(-2285.5, 231.625, -464.5999755859375))) then
            local dist = (getHumanoidRootPart().Position - ore:FindFirstChildWhichIsA("MeshPart").Position).magnitude
            if (dist < minDist) then
                nearestOre = ore
                minDist = dist
            end
        end
    end
    return nearestOre
end

-- Get quest index from quest display string
local function getQuestIndex(questString)
    for questIndex, questData in next, QuestList do
        if strFind("Level " .. questData.Level .. " " .. questData.Target .. " " .. ((questData.Repeatable and "Repeatable") or ""), questString) then
            return questIndex
        end
    end
    return
end

-- Get the best repeatable quest for the player's current level
local function getBestRepeatableQuest()
    local playerLevel = ReplicatedStorage.Profiles[LocalPlayer.Name].Level.Value
    local bestQuest = { lvl = 0, mob = "", questindex = nil }

    for questIndex, questData in next, QuestList do
        local questLevel = questData.Level
        if questData.Repeatable then
            if ((questLevel > bestQuest.lvl) and (questLevel <= playerLevel)) then
                bestQuest.lvl = questLevel
                bestQuest.mob = questData.Target
                bestQuest.questindex = questIndex
            end
        end
    end
    return bestQuest
end

-- Check if a quest has been completed
local function isQuestCompleted(questIndex)
    for _, completedQuest in next, ReplicatedStorage.Profiles[LocalPlayer.Name].Quests.Completed:GetChildren() do
        if (tonumber(completedQuest.Name) == questIndex) then
            return true
        end
    end
    return false
end

-- Get fishing spot matching selected level
local function getFishingSpot()
    local fishingSpot
    if workspace:FindFirstChild("FishingSpots") then
        for _, spot in next, workspace.FishingSpots:GetChildren() do
            if (spot.Level.Value == Options['fish'].Value) then
                fishingSpot = spot
            end
        end
    end
    return fishingSpot
end

---------------------------------------------------------------------------
-- Main Loops
---------------------------------------------------------------------------

-- Auto Level Farm Loop
task.spawn(function()
    while task.wait() do
        if Options['autolvl'].Value then
            local bestQuest = getBestRepeatableQuest()
            if (getCharacter() and getHumanoidRootPart()) then
                if (findMobs(bestQuest.mob).mobs and findMobs(bestQuest.mob).mobs:FindFirstChild("HumanoidRootPart")) then
                    -- Clean up platforms
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local mobRoot = findMobs(bestQuest.mob).mobs:FindFirstChild("HumanoidRootPart") or findMobs(bestQuest.mob).mobs:WaitForChild("HumanoidRootPart", 10)
                    local distToMob = (getHumanoidRootPart().Position - mobRoot.Position).Magnitude

                    -- Teleport via waystone if too far
                    if (distToMob >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        if (findMobs(bestQuest.mob).mobs and mobRoot) then
                            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(mobRoot))
                        end
                        task.wait(2)
                    end

                    -- Move to mob
                    if (findMobs(bestQuest.mob).mobs and mobRoot and getCharacter() and getHumanoidRootPart()) then
                        if (Options['method'].Value ~= "behind") then
                            if (distToMob >= (tonumber(Options['range'].Value) + 1)) then
                                tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                            end
                            if (findMobs(bestQuest.mob).mobs and mobRoot and getCharacter() and getHumanoidRootPart()) then
                                local platform = createPlatform(mobRoot.CFrame * getFarmOffset() * CFrame.new(0, -5, 0), 1, true)
                                if ((platform.Position - getHumanoidRootPart().Position).Magnitude >= 10) then
                                    tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset() * CFrame.new(0, 3, 0))
                                end
                            end
                        else
                            tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                    end
                else
                    -- Mob not found in workspace, go to known spawn position
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local distToSpawn = (getHumanoidRootPart().Position - mobPositions[getCurrentFloor()][bestQuest.mob].Position).Magnitude
                    if (distToSpawn >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(mobPositions[getCurrentFloor()][bestQuest.mob]))
                        task.wait(2)
                    end

                    if (getCharacter() and getHumanoidRootPart()) then
                        if (distToSpawn >= (tonumber(Options['range'].Value) + 1)) then
                            tweenTo(getHumanoidRootPart(), mobPositions[getCurrentFloor()][bestQuest.mob], Options['tweenspeed'].Value, CFrame.new(0, -20, 0))
                        end
                        createPlatform(getHumanoidRootPart().CFrame * CFrame.new(0, -5, 0), 1, true)
                    end
                end
            end

            -- Accept and complete quest
            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Quests"):WaitForChild("AcceptQuest"):FireServer(bestQuest.questindex)
            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Quests"):WaitForChild("CompleteQuest"):FireServer(bestQuest.questindex)
        end
    end
end)

-- Auto Farm Mobs / Tower / Target Player Loop
task.spawn(function()
    while task.wait(0.1) do
        -- Void Tower auto farm
        if Options['tower'].Value then
            if (getCharacter() and getHumanoidRootPart()) then
                if (getNearestMob() and getNearestMob():FindFirstChild("HumanoidRootPart")) then
                    -- Clean up platforms
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local mobRoot = getNearestMob():FindFirstChild("HumanoidRootPart") or getNearestMob():WaitForChild("HumanoidRootPart", 10)
                    local distToMob = (getHumanoidRootPart().Position - mobRoot.Position).Magnitude

                    if (mobRoot and getCharacter() and getHumanoidRootPart()) then
                        if (Options['method'].Value ~= "behind") then
                            if (distToMob >= (tonumber(Options['range'].Value) + 1)) then
                                tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                            end
                            if (getNearestMob() and mobRoot and getCharacter() and getHumanoidRootPart()) then
                                local platform = createPlatform(mobRoot.CFrame * getFarmOffset() * CFrame.new(0, -5, 0), 1, true)
                                if ((platform.Position - getHumanoidRootPart().Position).Magnitude >= 10) then
                                    tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset() * CFrame.new(0, 3, 0))
                                end
                            end
                        else
                            tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                    end
                else
                    -- No mobs found, wait and check for portal
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    createPlatform(getHumanoidRootPart().CFrame * CFrame.new(0, -5, 0), 1, true)
                    task.wait(3)

                    -- If no mobs, find and go to portal
                    if not getNearestMob() then
                        for _, room in next, workspace.TowerDungeon:GetChildren() do
                            if ((room.Name == "StaircaseRoom") and room:FindFirstChild("Portal") and getCharacter() and getHumanoidRootPart()) then
                                tweenTo(getHumanoidRootPart(), room:FindFirstChild("Portal"), Options['tweenspeed'].Value)
                            end
                        end
                    end
                end
            end
        end

        -- Auto Farm Selected Mob
        if ((Options['automobs'].Value or isBossWaiting) and Options['choosemob'].Value) then
            if (getCharacter() and getHumanoidRootPart()) then
                if (findMobs(Options['choosemob'].Value).mobs and findMobs(Options['choosemob'].Value).mobs:FindFirstChild("HumanoidRootPart")) then
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local mobRoot = findMobs(Options['choosemob'].Value).mobs:FindFirstChild("HumanoidRootPart") or findMobs(Options['choosemob'].Value).mobs:WaitForChild("HumanoidRootPart", 10)
                    local distToMob = (getHumanoidRootPart().Position - mobRoot.Position).Magnitude

                    if (distToMob >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        if (findMobs(Options['choosemob'].Value).mobs and mobRoot) then
                            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(mobRoot))
                        end
                        task.wait(2)
                    end

                    if (findMobs(Options['choosemob'].Value).mobs and mobRoot and getCharacter() and getHumanoidRootPart()) then
                        if (Options['method'].Value ~= "behind") then
                            if (distToMob >= (tonumber(Options['range'].Value) + 1)) then
                                tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                            end
                            if (findMobs(Options['choosemob'].Value).mobs and mobRoot and getCharacter() and getHumanoidRootPart()) then
                                local platform = createPlatform(mobRoot.CFrame * getFarmOffset() * CFrame.new(0, -5, 0), 1, true)
                                if ((platform.Position - getHumanoidRootPart().Position).Magnitude >= 10) then
                                    tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset() * CFrame.new(0, 3, 0))
                                end
                            end
                        else
                            tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                    end
                else
                    -- Mob not found, go to known spawn position
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local distToSpawn = (getHumanoidRootPart().Position - mobPositions[getCurrentFloor()][Options['choosemob'].Value].Position).Magnitude
                    if (distToSpawn >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(mobPositions[getCurrentFloor()][Options['choosemob'].Value]))
                        task.wait(2)
                    end

                    if (getCharacter() and getHumanoidRootPart()) then
                        if (distToSpawn >= (tonumber(Options['range'].Value) + 1)) then
                            tweenTo(getHumanoidRootPart(), mobPositions[getCurrentFloor()][Options['choosemob'].Value], Options['tweenspeed'].Value, CFrame.new(0, -20, 0))
                        end
                        createPlatform(getHumanoidRootPart().CFrame * CFrame.new(0, -5, 0), 1, true)
                    end
                end
            end
        end

        -- Target Player teleport
        if (Options['targetplr'].Value and Options['choosetarget'].Value) then
            if (getCharacter() and getHumanoidRootPart() and findPlayers(Options['choosetarget'].Value).plr and findPlayers(Options['choosetarget'].Value).plr:FindFirstChild("HumanoidRootPart")) then
                if workspace:FindFirstChild("huehueheue") then
                    for _, child in next, workspace:GetChildren() do
                        if (child.Name == "huehueheue") then
                            child:Destroy()
                        end
                    end
                end

                local playerRoot = findPlayers(Options['choosetarget'].Value).plr:FindFirstChild("HumanoidRootPart") or findPlayers(Options['choosetarget'].Value).plr:WaitForChild("HumanoidRootPart", 10)
                local distToPlayer = (getHumanoidRootPart().Position - playerRoot.Position).Magnitude

                if (distToPlayer >= 800) then
                    tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                    task.wait(1)
                    ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(playerRoot))
                    task.wait(2)
                end

                if (playerRoot and getCharacter() and getHumanoidRootPart()) then
                    if (Options['method'].Value ~= "behind") then
                        if (distToPlayer >= (tonumber(Options['range'].Value) + 1)) then
                            tweenTo(getHumanoidRootPart(), playerRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                        createPlatform(getHumanoidRootPart().CFrame * CFrame.new(0, -5, 0), 1, true)
                    else
                        tweenTo(getHumanoidRootPart(), playerRoot, Options['tweenspeed'].Value, getFarmOffset())
                    end
                end
            end
        end
    end
end)

-- Auto Boss Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if Options['autoboss'].Value then
            if (getCharacter() and getHumanoidRootPart() and Options['boss'].Value) then
                if (findMobs(Options['boss'].Value).mobs and findMobs(Options['boss'].Value).mobs:FindFirstChild("HumanoidRootPart")) then
                    -- Boss is alive, fight it
                    isBossWaiting = false
                    if workspace:FindFirstChild("huehueheue") then
                        for _, child in next, workspace:GetChildren() do
                            if (child.Name == "huehueheue") then
                                child:Destroy()
                            end
                        end
                    end

                    local bossRoot = findMobs(Options['boss'].Value).mobs:FindFirstChild("HumanoidRootPart") or findMobs(Options['boss'].Value).mobs:WaitForChild("HumanoidRootPart", 10)
                    local distToBoss = (getHumanoidRootPart().Position - bossRoot.Position).Magnitude

                    if (distToBoss >= 800) then
                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                        task.wait(1)
                        if (findMobs(Options['boss'].Value).mobs and bossRoot) then
                            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(bossRoot))
                        end
                        task.wait(2)
                    end

                    if (findMobs(Options['boss'].Value).mobs and bossRoot and getCharacter() and getHumanoidRootPart()) then
                        if (Options['method'].Value ~= "behind") then
                            if (distToBoss >= (tonumber(Options['range'].Value) + 1)) then
                                tweenTo(getHumanoidRootPart(), bossRoot, Options['tweenspeed'].Value, getFarmOffset())
                            end
                            if (findMobs(Options['boss'].Value).mobs and bossRoot and getCharacter() and getHumanoidRootPart()) then
                                local platform = createPlatform(bossRoot.CFrame * getFarmOffset() * CFrame.new(0, -5, 0), 1, true)
                                if (((platform.Position - getHumanoidRootPart().Position).Magnitude >= 10) and ((platform.Position - getHumanoidRootPart().Position).Magnitude <= 800)) then
                                    tweenTo(getHumanoidRootPart(), bossRoot, Options['tweenspeed'].Value, getFarmOffset() * CFrame.new(0, 3, 0))
                                end
                            end
                        else
                            tweenTo(getHumanoidRootPart(), bossRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                    end
                else
                    -- Boss not alive, check arena for spawn timer
                    local spawnThreshold
                    for _, arena in next, workspace.BossArenas:GetChildren() do
                        if strFind(arena.Name, Options['boss'].Value) then
                            -- Determine spawn threshold based on status
                            if strFind(arena.Spawn.ArenaBillboard.Frame.StatusLabel.Text, "Boss Cooldown") then
                                spawnThreshold = 0
                            elseif strFind(arena.Spawn.ArenaBillboard.Frame.StatusLabel.Text, "Spawning Boss") then
                                spawnThreshold = 15
                            end

                            -- Parse timer from status text
                            local timerText = strSub(arena.Spawn.ArenaBillboard.Frame.StatusLabel.Text, 16, 19)
                            local timerValue = strSplit(timerText, ")")[1]

                            if (tonumber(timerValue) and (tonumber(timerValue) <= spawnThreshold)) then
                                -- Boss is about to spawn, go to arena
                                isBossWaiting = false
                                local distToArena = (getHumanoidRootPart().Position - arena:FindFirstChild("Spawn").Position).magnitude

                                if (distToArena >= 800) then
                                    local questRequirement = workspace.Teleporters.DungeonBoss.QuestRequirement.Value
                                    if isQuestCompleted(questRequirement) then
                                        -- Use dungeon teleporter
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        firetouchinterest(getHumanoidRootPart(), workspace.Teleporters.DungeonBoss.A.Touch, 0)
                                        firetouchinterest(getHumanoidRootPart(), workspace.Teleporters.DungeonBoss.A.Touch, 1)
                                        task.wait(2)
                                    else
                                        -- Use waystone teleport
                                        tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                                        task.wait(1)
                                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(arena:FindFirstChild("Spawn")))
                                        task.wait(2)
                                    end
                                end

                                if (getCharacter() and getHumanoidRootPart()) then
                                    if (distToArena >= 100) then
                                        tweenTo(getHumanoidRootPart(), arena:FindFirstChild("Spawn"), Options['tweenspeed'].Value, CFrame.new(0, 1, 80))
                                    end
                                end
                            else
                                -- Boss not spawning soon, farm mobs instead
                                isBossWaiting = true
                            end
                        end
                    end
                end
            else
                isBossWaiting = false
            end
        end
    end
end)

-- Kill Aura Loop (basic attacks)
task.spawn(function()
    while task.wait(Options['cd'].Value) do
        local targets = {}
        local nearbyMobs = findMobs().multimobs
        local nearbyPlayers = findPlayers().multiplr

        -- Add mobs to target list
        if (Options['aura'].Value and (#nearbyMobs >= 1)) then
            for _, mob in next, nearbyMobs do
                table.insert(targets, mob)
            end
        end

        -- Add players to target list
        if (Options['killauraplr'].Value and (#nearbyPlayers >= 1)) then
            for _, player in next, nearbyPlayers do
                table.insert(targets, player)
            end
        end

        -- Fire attack
        if (#targets >= 1) then
            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Combat"):WaitForChild("PlayerAttack"):FireServer(targets)
        end
    end
end)

-- Skill Usage Loop
task.spawn(function()
    while task.wait(0.5) do
        -- Get equipped skills from skill bar
        local equippedSkills = {}
        if LocalPlayer.PlayerGui:FindFirstChild("SkillBar") then
            for _, skill in next, LocalPlayer.PlayerGui.SkillBar.Frame:GetChildren() do
                if table.find(skillNames, skill.Name) then
                    table.insert(equippedSkills, skill.Name)
                end
            end

            -- Also check touch frame (mobile)
            if (#equippedSkills < 1) then
                for _, skill in next, LocalPlayer.PlayerGui.SkillBar.TouchFrame:GetChildren() do
                    if table.find(skillNames, skill.Name) then
                        table.insert(equippedSkills, skill.Name)
                    end
                end
            end
        end

        -- Get targets
        local targets = {}
        local nearbyMobs = findMobs().multimobs
        local nearbyPlayers = findPlayers().multiplr

        if (Options['aura'].Value and (#nearbyMobs >= 1)) then
            for _, mob in next, nearbyMobs do
                table.insert(targets, mob)
            end
        end

        if (Options['killauraplr'].Value and (#nearbyPlayers >= 1)) then
            for _, player in next, nearbyPlayers do
                table.insert(targets, player)
            end
        end

        -- Use each skill and fire skill attacks (per-slot toggle: E=1, R=2, F=3, X=4)
        local skillSlotToggles = {"skille", "skillr", "skillf", "skillx"}
        for slotIndex, skillName in next, equippedSkills do
            local toggleKey = skillSlotToggles[slotIndex]
            if toggleKey and Options[toggleKey] and Options[toggleKey].Value then
                if (#targets >= 1) then
                    ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Skills"):WaitForChild("UseSkill"):FireServer(skillName)
                    for hitIndex = 1, 8 do
                        ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Combat"):WaitForChild("PlayerSkillAttack"):FireServer(targets, skillName, hitIndex)
                    end
                end
            end
        end
    end
end)

-- Auto Collect Drops Loop
task.spawn(function()
    while task.wait(3) do
        if Options['autocollect'].Value then
            for _, drop in next, ReplicatedStorage.Drops:GetChildren() do
                if (drop:GetAttributes("Owner").Owner == LocalPlayer.Name) then
                    ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Drops"):WaitForChild("Pickup"):FireServer(drop)
                end
            end
        end
    end
end)

-- Auto Quest Loop
task.spawn(function()
    while task.wait(0.1) do
        if (Options['autoquest'].Value and Options['choosequest'].Value) then
            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Quests"):WaitForChild("AcceptQuest"):FireServer(getQuestIndex(Options['choosequest'].Value))
            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Quests"):WaitForChild("CompleteQuest"):FireServer(getQuestIndex(Options['choosequest'].Value))
        end
    end
end)

-- Auto Mine Loop
task.spawn(function()
    while task.wait(Options['cds'].Value) do
        if (Options['automine'].Value and Options['mine'].Value) then
            if (getNearestOre() and getNearestOre():FindFirstChildWhichIsA("MeshPart") and getCharacter() and getHumanoidRootPart()) then
                local distToOre = (getHumanoidRootPart().Position - getNearestOre():FindFirstChildWhichIsA("MeshPart").Position).magnitude
                if (distToOre >= 15) then
                    tweenTo(getHumanoidRootPart(), getNearestOre():FindFirstChildWhichIsA("MeshPart"), Options['tweenspeed'].Value, CFrame.new(0, 3, 0))
                end
                ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Equipment"):WaitForChild("EquipTool"):FireServer("Pickaxe", true)
                ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Mining"):WaitForChild("Mine"):FireServer()
            end
        end
    end
end)

-- Auto Dismantle Loop
task.spawn(function()
    while task.wait(0.5) do
        if (Options['dismantle'].Value and Options['rarity'].Value) then
            local rarityKey = strSplit(Options['rarity'].Value, " ")[1] .. " " .. strSplit(Options['rarity'].Value, " ")[2]
            for itemName, itemData in next, ItemList do
                if (itemData.Rarity and (itemData.Rarity <= rarityValues[rarityKey]) and not table.find(excludedCategories, itemData.Category)) then
                    for _, inventoryItem in next, ReplicatedStorage.Profiles[LocalPlayer.Name].Inventory:GetChildren() do
                        if strFind(itemName, inventoryItem.Name) then
                            ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Crafting"):WaitForChild("Dismantle"):FireServer(inventoryItem)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end
end)

-- NoClip + Teleport Detection - ONLY when farming features are active
task.spawn(function()
    local lastPosition = nil
    local wasNoclipping = false

    RunService.RenderStepped:Connect(function()
        local isFarming = Options['autolvl'].Value
            or Options['automobs'].Value
            or Options['autoboss'].Value
            or Options['automine'].Value
            or Options['tower'].Value
            or Options['targetplr'].Value
            or Options['autoguild'].Value

        if isFarming and getCharacter() then
            wasNoclipping = true

            -- Noclip: disable collision
            for _, part in pairs(getCharacter():GetDescendants()) do
                if (part:IsA("BasePart") and (part.CanCollide == true)) then
                    part.CanCollide = false
                end
            end

            -- Teleport detection: cancel tween if position jumps > 100 studs
            local hrp = getHumanoidRootPart()
            if hrp then
                local currentPos = hrp.Position
                if lastPosition then
                    local jumpDist = (currentPos - lastPosition).Magnitude
                    if (jumpDist >= 100) then
                        -- Player was teleported (portal/waystone), cancel tween
                        if currentTween then
                            currentTween:Cancel()
                            currentTween = nil
                        end
                        cancelTween = true

                        -- Reset velocity to stop drifting
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                        -- Allow farming loops to resume after a short delay
                        task.delay(0.5, function()
                            cancelTween = false
                        end)
                    end
                end
                lastPosition = currentPos
            end
        else
            -- Restore collision when farming is turned off
            if wasNoclipping and getCharacter() then
                for _, part in pairs(getCharacter():GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
                wasNoclipping = false
            end
            lastPosition = nil
        end
    end)
end)

-- Anti-Dash Fly: handle rapid Q spam (4-5 consecutive presses)
task.spawn(function()
    local UserInputService = cloneref(game:GetService("UserInputService"))

    -- Force types to clean up
    local forceTypes = {
        ["BodyVelocity"] = true,
        ["BodyForce"] = true,
        ["LinearVelocity"] = true,
        ["BodyGyro"] = true,
        ["VectorForce"] = true
    }

    local lastDashTime = 0
    local DASH_CLEANUP_DURATION = 3.5 -- 5 dashes × 0.6s each + buffer

    local function isFarming()
        return Options['autolvl'].Value
            or Options['automobs'].Value
            or Options['autoboss'].Value
            or Options['automine'].Value
            or Options['tower'].Value
            or Options['targetplr'].Value
            or Options['autoguild'].Value
    end

    local function cleanupForces()
        if not getCharacter() then return end

        -- Remove all force objects from character
        for _, part in pairs(getCharacter():GetDescendants()) do
            if forceTypes[part.ClassName] then
                part:Destroy()
            end
        end

        -- Reset velocity
        local hrp = getHumanoidRootPart()
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end

    -- Detect player pressing Q (dash key) — update timestamp on each press
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Q and isFarming() then
            lastDashTime = tick()
        end
    end)

    -- Continuous cleanup: every frame for 1.5s after last Q press
    RunService.RenderStepped:Connect(function()
        if (tick() - lastDashTime) <= DASH_CLEANUP_DURATION and isFarming() then
            cleanupForces()
        end
    end)

    -- Fallback: detect forces added by auto-skill loop
    local function onCharacter(character)
        character.DescendantAdded:Connect(function(descendant)
            if forceTypes[descendant.ClassName] and isFarming() then
                task.delay(0.15, function()
                    if descendant and descendant.Parent then
                        descendant:Destroy()
                    end
                end)
            end
        end)
    end

    -- Listen on current and future characters (respawn)
    if LocalPlayer.Character then
        onCharacter(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacter)
end)

-- Webhook on Item Drop
task.spawn(function()
    ReplicatedStorage.Drops.ChildAdded:Connect(function(newDrop)
        if (Options['webhook'].Value and webhookUrl and Options['rarityw'].Value) then
            local rarityKey = strSplit(Options['rarityw'].Value, " ")[1] .. " " .. strSplit(Options['rarityw'].Value, " ")[2]
            for itemName, itemData in next, ItemList do
                if (itemData.Rarity and (itemData.Rarity >= rarityValues[rarityKey]) and not table.find(excludedCategories, itemData.Category)) then
                    if (strFind(itemName, newDrop.Name) and (newDrop:GetAttributes("Owner").Owner == LocalPlayer.Name)) then
                        local enchantValue
                        if newDrop:WaitForChild("LegendEnchant").Value then
                            enchantValue = newDrop:WaitForChild("LegendEnchant").Value
                        end
                        sendWebhook(webhookUrl, newDrop.Name, tostring(enchantValue))
                    end
                end
            end
        end
    end)
end)

-- Auto Fishing Loop
task.spawn(function()
    while task.wait(0.1) do
        if Options['autofish'].Value then
            if (Options['fish'].Value == "") then
                Fluent:Notify({
                    Title = "Select Fishing Spots Level",
                    Content = "please select fishing spots level",
                    Duration = 5
                })
                continue
            end

            local distToFish = (getHumanoidRootPart().Position - getFishingSpot().Fish.Position).magnitude

            -- Teleport via waystone if too far
            if (distToFish >= 800) then
                tweenTo(getHumanoidRootPart(), getNearestWaystone(getHumanoidRootPart()).Spawn, Options['tweenspeed'].Value)
                task.wait(1)
                ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Locations"):WaitForChild("TeleportWaystone"):FireServer(getNearestWaystone(getFishingSpot().Fish))
                task.wait(2)
            end

            -- Move to fishing spot
            if (distToFish >= 50) then
                tweenTo(getHumanoidRootPart(), getFishingSpot().Fish, Options['tweenspeed'].Value, CFrame.new(0, 0, 5))
            end

            task.wait(0.5)

            -- Equip fishing rod if not already fishing
            if not LocalPlayer.PlayerGui:FindFirstChild("FishBillboard") then
                ReplicatedStorage.Systems:WaitForChild("Equipment"):WaitForChild("EquipTool"):FireServer("FishingRod", true)
            end

            task.wait(1)

            -- Start fishing if not already
            if (debug.getupvalue(FishingModule.Reel, 1) ~= true) then
                pcall(function()
                    FishingModule.BeginFish(FishingModule, LocalPlayer, getFishingSpot())
                end)
            end

            -- Wait until fish is caught or auto fish is disabled
            repeat
                task.wait(0.1)
            until (debug.getupvalue(FishingModule.Reel, 4) == true) or (Options['autofish'].Value == false)

            -- Reel in the fish
            FishingModule.Reel()
        end
    end
end)

-- Auto Guild Boss Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if Options['autoguild'].Value then
            for _, mob in next, workspace.Mobs:GetChildren() do
                if mob:FindFirstChild("HumanoidRootPart") then
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:WaitForChild("HumanoidRootPart", 5)
                    if (mobRoot and getCharacter() and getHumanoidRootPart()) then
                        local distToMob = (getHumanoidRootPart().Position - mobRoot.Position).magnitude
                        if (Options['method'].Value ~= "behind") then
                            if (distToMob >= (tonumber(Options['range'].Value) + 1)) then
                                tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                            end
                            if (findMobs(Options['boss'].Value).mobs and mobRoot and getCharacter() and getHumanoidRootPart()) then
                                local platform = createPlatform(mobRoot.CFrame * getFarmOffset() * CFrame.new(0, -5, 0), 1, true)
                                if (((platform.Position - getHumanoidRootPart().Position).Magnitude >= 10) and ((platform.Position - getHumanoidRootPart().Position).Magnitude <= 800)) then
                                    tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset() * CFrame.new(0, 3, 0))
                                end
                            end
                        else
                            tweenTo(getHumanoidRootPart(), mobRoot, Options['tweenspeed'].Value, getFarmOffset())
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------------------------
-- Settings & Save Manager Setup
---------------------------------------------------------------------------

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FallAngelHub")
SaveManager:SetFolder("FallAngelHub/Swordburst3")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

---------------------------------------------------------------------------
-- Open/Close GUI Button
---------------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.5) do
        if not game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("lelelel") then
            local screenGui = Instance.new("ScreenGui")
            local button = Instance.new("ImageButton")
            local label = Instance.new("TextLabel")

            screenGui.Name = "lelelel"
            screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            button.Parent = screenGui
            button.BackgroundColor3 = Color3.fromRGB(116, 104, 96)
            button.BackgroundTransparency = 0.5
            button.BorderColor3 = Color3.fromRGB(0, 0, 0)
            button.BorderSizePixel = 4
            button.Position = UDim2.new(0, 0, 0.308541536, 0)
            button.Size = UDim2.new(0, 137, 0, 35)
            button.Image = "http://www.roblox.com/asset/?id=1547208871"
            button.ImageColor3 = Color3.fromRGB(162, 255, 188)

            label.Parent = button
            label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
            label.BorderColor3 = Color3.fromRGB(0, 0, 0)
            label.BorderSizePixel = 0
            label.Position = UDim2.new(0.325138301, 0, 0.042424228, 0)
            label.Size = UDim2.new(0, 47, 0, 33)
            label.Font = Enum.Font.Unknown
            label.Text = "Open/Close Gui"
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            label.TextSize = 14

            local function setupButtonClick()
                button.MouseButton1Click:Connect(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "LeftControl", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "LeftControl", false, game)
                end)
            end

            coroutine.wrap(setupButtonClick)()
        end
    end
end)
