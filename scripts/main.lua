local players = game:GetService("Players")
local player = players.LocalPlayer
local httpService = game:GetService("HttpService")


local data = {
    player = {},
    game = {}
}

function getGameStat()
    local wave_time = workspace._wave_time.Value
    local wave_num = workspace._wave_num.Value

    data.game = {
        wave_time = tostring(wave_time),
        wave_num = tostring(wave_num)
    }
end

function getPlayer()
    local stats = player._stats
    local resourceCandies = stats._resourceCandies.Value
    local resourceGemsLegacy = stats._resourceGemsLegacy.Value
    local resourceHolidayStars = stats._resourceHolidayStars.Value
    local gem_amount = stats.gem_amount.Value
    local gold_amount = stats.gold_amount.Value
    local player_xp = stats.player_xp.Value
    local damage_dealt = stats.damage_dealt.Value
    local player_name = player.Name
    local player_displayName = player.DisplayName

    data.player = {
        resourceCandies = resourceCandies,
        resourceGemsLegacy = resourceGemsLegacy,
        resourceHolidayStars = resourceHolidayStars,
        gem_amount = gem_amount,
        gold_amount = gold_amount,
        player_xp = player_xp,
        damage_dealt = damage_dealt,
        player_name = player_name,
        player_displayName = player_displayName
    }
end



function getLand()
    data.lanes = {}
    for _,land in pairs(game.Workspace._BASES.pve.LANES:GetChildren()) do
        data.lanes[land.Name] = {}
    
        for _,part in pairs(land:GetChildren()) do
            if part:IsA("Part") then
                data.lanes[land.Name][part.Name] = {
                    position = tostring(part.Position),
                    --cframe = tostring(part.CFrame)
                }
            end
        end
    end
end

local statsWhilteLists = {
    "kill_count",
    "player",
    "range",
    "range_stat",
    "shiny",
    "speed",
    "xp",
    "total_damage",
    "total_spent",
    "takedown_count",
    "max_upgrade",
    "lane",
    "health",
    "damage",
    "attack_cooldown",
    "upgrade",
    "shield",
    "id",
}
local buffsWhilteLists = {
    
}

function getUnitsData()
    data.units = {}

    local count = 1
    for _,unit in pairs(game.Workspace._UNITS:GetChildren()) do
        if unit:IsA("Model") then
            local _buffs = unit._buffs
            local _stats = unit._stats

            data.units[count] = {
                name = unit.Name,
                position = tostring(unit.PrimaryPart.Position),
                cframe = tostring(unit.PrimaryPart.CFrame),
                stats = {},
                buffs = {}
            }

            for _,stat in pairs(_stats:GetChildren()) do
                if table.find(statsWhilteLists, stat.Name) then
                    data.units[count].stats[stat.Name] = tostring(stat.Value)
                end
            end

            for _,buff in pairs(_buffs:GetChildren()) do
                if table.find(buffsWhilteLists, buff.Name) then
                    data.units[count].buffs[buff.Name] = tostring(buff.Value)
                end
            end

        end

        count = count + 1
    end
end

function getPlayersData()
    for i, v in pairs(players:GetPlayers()) do
        data.players[v.UserId] = {
            name = v.Name,
            displayname = v.DisplayName,
            uid = v.UserId,
            position = tostring(v.Character.HumanoidRootPart.Position),
            cframe = tostring(v.Character.HumanoidRootPart.CFrame),
        }
    end
end
 
function getAllData()
    --getPlayersData()
    --getUnitsData()
    --getLand()
    getPlayer()
    getGameStat()

    local playerId = tostring(player.UserId)

    local encodedData = httpService:UrlEncode(httpService:JSONEncode(data))
    local encodedPlayerId = httpService:UrlEncode(playerId)
    local discord_id = getgenv().discord_id

    local url = "http://26.46.248.62:8080/api/report?uuid="..encodedPlayerId.."&data="..encodedData.."&discord_id="..discord_id
    game:HttpGet(url)
end 

while wait(1) do
    getAllData()
end