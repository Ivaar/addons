-- Copyright (c) 2014, Brax
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of <addon name> nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL BRAX BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


_addon.name = 'StatusBar'
_addon.version = '0.5'
_addon.author = 'Brax'
_addon.command = 'statusbar'

require('chat')
require('logger')
require('strings')
require('maths')
require('tables')
res = require 'resources'

texts = require('texts')
config = require('config')

tb_name	= 'statusbar'
visible = false
targetmob = 0
inDynamis = false
inSalvage = true

local st = {}
	st.hours = ''
	st.minutes = ''
	st.target = ''

staggers = T{}
staggers['morning'] = T{}
staggers['morning']['ja'] = {"Kindred Thief", "Kindred Beastmaster", "Kindred Monk", "Kindred Ninja", "Kindred Ranger", "Hydra Thief", "Hydra Beastmaster", "Hydra Monk", "Hydra Ninja", "Hydra Ranger", "Nightmare Bugard", "Nightmare Crawler", "Nightmare Fly", "Nightmare Flytrap", "Nightmare Funguar", "Nightmare Gaylas", "Nightmare Hornet", "Nightmare Kraken", "Nightmare Raven", "Nightmare Roc", "Nightmare Uragnite", "Vanguard Ambusher", "Vanguard Assassin", "Vanguard Beasttender", "Vanguard Footsoldier", "Vanguard Gutslasher", "Vanguard Hitman", "Vanguard Impaler", "Vanguard Kusa", "Vanguard Liberator", "Vanguard Mason", "Vanguard Militant", "Vanguard Neckchopper", "Vanguard Ogresoother", "Vanguard Pathfinder", "Vanguard Pitfighter", "Vanguard Purloiner", "Vanguard Salvager","Vanguard Sentinel","Vanguard Trooper","Vanguard Welldigger"}
staggers['morning']['magic'] = {"Kindred White Mage", "Kindred Bard", "Kindred Summoner", "Kindred Black Mage", "Kindred Red Mage", "Hydra White Mage", "Hydra Bard", "Hydra Summoner", "Hydra Black Mage", "Hydra Red Mage", "Nightmare Bunny", "Nightmare Cluster", "Nightmare Eft", "Nightmare Hippogryph", "Nightmare Makara", "Nightmare Mandragora", "Nightmare Sabotender", "Nightmare Sheep", "Nightmare Snoll", "Nightmare Stirge", "Nightmare Weapon", "Vanguard Alchemist", "Vanguard Amputator", "Vanguard Bugler", "Vanguard Chanter", "Vanguard Constable", "Vanguard Dollmaster", "Vanguard Enchanter", "Vanguard Maestro", "Vanguard Mesmerizer", "Vanguard Minstrel", "Vanguard Necromancer", "Vanguard Oracle", "Vanguard Prelate", "Vanguard Priest", "Vanguard Protector", "Vanguard Shaman", "Vanguard Thaumaturge", "Vanguard Undertaker", "Vanguard Vexer", "Vanguard Visionary"}
staggers['morning']['ws'] = {"Kindred Paladin", "Kindred Warrior", "Kindred Samurai", "Kindred Dragoon", "Kindred Dark Knight", "Hydra Paladin", "Hydra Warrior", "Hydra Samurai", "Hydra Dragoon", "Hydra Dark Knight", "Nightmare Crab", "Nightmare Dhalmel", "Nightmare Diremite", "Nightmare Goobbue", "Nightmare Leech", "Nightmare Manticore", "Nightmare Raptor", "Nightmare Scorpion", "Nightmare Tiger", "Nightmare Treant", "Nightmare Worm", "Vanguard Armorer", "Vanguard Backstabber", "Vanguard Defender", "Vanguard Dragontamer", "Vanguard Drakekeeper", "Vanguard Exemplar", "Vanguard Grappler", "Vanguard Hatamoto", "Vanguard Hawker", "Vanguard Inciter", "Vanguard Partisan", "Vanguard Persecutor", "Vanguard Pillager", "Vanguard Predator", "Vanguard Ronin", "Vanguard Skirmisher", "Vanguard Smithy", "Vanguard Tinkerer", "Vanguard Vigilante", "Vanguard Vindicator"}
staggers['day'] = T{}
staggers['day']['ja'] = {"Kindred Thief", "Kindred Beastmaster", "Kindred Monk", "Kindred Ninja", "Kindred Ranger", "Hydra Thief", "Hydra Beastmaster", "Hydra Monk", "Hydra Ninja", "Hydra Ranger", "Nightmare Bunny", "Nightmare Cluster", "Nightmare Eft", "Nightmare Hippogryph", "Nightmare Makara", "Nightmare Mandragora", "Nightmare Sabotender", "Nightmare Sheep", "Nightmare Snoll", "Nightmare Stirge", "Nightmare Weapon", "Vanguard Ambusher", "Vanguard Assassin", "Vanguard Beasttender", "Vanguard Footsoldier", "Vanguard Gutslasher", "Vanguard Hitman", "Vanguard Impaler", "Vanguard Kusa", "Vanguard Liberator", "Vanguard Mason", "Vanguard Militant", "Vanguard Neckchopper", "Vanguard Ogresoother", "Vanguard Pathfinder", "Vanguard Pitfighter", "Vanguard Purloiner", "Vanguard Salvager", "Vanguard Sentinel", "Vanguard Trooper", "Vanguard Welldigger"}
staggers['day']['magic'] = {"Kindred White Mage", "Kindred Bard", "Kindred Summoner", "Kindred Black Mage", "Kindred Red Mage", "Hydra White Mage", "Hydra Bard", "Hydra Summoner", "Hydra Black Mage", "Hydra Red Mage", "Nightmare Crab", "Nightmare Dhalmel", "Nightmare Diremite", "Nightmare Goobbue", "Nightmare Leech", "Nightmare Manticore", "Nightmare Raptor", "Nightmare Scorpion", "Nightmare Tiger", "Nightmare Treant", "Nightmare Worm", "Vanguard Alchemist", "Vanguard Amputator", "Vanguard Bugler", "Vanguard Chanter", "Vanguard Constable", "Vanguard Dollmaster", "Vanguard Enchanter", "Vanguard Maestro", "Vanguard Mesmerizer", "Vanguard Minstrel", "Vanguard Necromancer", "Vanguard Oracle", "Vanguard Prelate", "Vanguard Priest", "Vanguard Protector", "Vanguard Shaman", "Vanguard Thaumaturge", "Vanguard Undertaker", "Vanguard Vexer", "Vanguard Visionary"}
staggers['day']['ws'] = {"Kindred Paladin", "Kindred Warrior", "Kindred Samurai", "Kindred Dragoon", "Kindred Dark Knight", "Hydra Paladin", "Hydra Warrior", "Hydra Samurai", "Hydra Dragoon", "Hydra Dark Knight", "Nightmare Bugard", "Nightmare Crawler", "Nightmare Fly", "Nightmare Flytrap", "Nightmare Funguar", "Nightmare Gaylas", "Nightmare Hornet", "Nightmare Kraken", "Nightmare Raven", "Nightmare Roc", "Nightmare Uragnite", "Vanguard Armorer", "Vanguard Backstabber", "Vanguard Defender", "Vanguard Dragontamer", "Vanguard Drakekeeper", "Vanguard Exemplar", "Vanguard Grappler", "Vanguard Hatamoto", "Vanguard Hawker", "Vanguard Inciter", "Vanguard Partisan", "Vanguard Persecutor", "Vanguard Pillager", "Vanguard Predator", "Vanguard Ronin", "Vanguard Skirmisher", "Vanguard Smithy", "Vanguard Tinkerer", "Vanguard Vigilante", "Vanguard Vindicator"}
staggers['night'] = T{}
staggers['night']['ja'] = {"Kindred Thief", "Kindred Beastmaster", "Kindred Monk", "Kindred Ninja", "Kindred Ranger", "Hydra Thief", "Hydra Beastmaster", "Hydra Monk", "Hydra Ninja", "Hydra Ranger", "Nightmare Crab", "Nightmare Dhalmel", "Nightmare Diremite", "Nightmare Goobbue", "Nightmare Leech", "Nightmare Manticore", "Nightmare Raptor", "Nightmare Scorpion", "Nightmare Tiger", "Nightmare Treant", "Nightmare Worm", "Vanguard Ambusher", "Vanguard Assassin", "Vanguard Beasttender", "Vanguard Footsoldier", "Vanguard Gutslasher", "Vanguard Hitman", "Vanguard Impaler", "Vanguard Kusa", "Vanguard Liberator", "Vanguard Mason", "Vanguard Militant", "Vanguard Neckchopper", "Vanguard Ogresoother", "Vanguard Pathfinder", "Vanguard Pitfighter", "Vanguard Purloiner", "Vanguard Salvager", "Vanguard Sentinel", "Vanguard Trooper", "Vanguard Welldigger"}
staggers['night']['magic'] = {"Kindred White Mage", "Kindred Bard", "Kindred Summoner", "Kindred Black Mage", "Kindred Red Mage", "Hydra White Mage", "Hydra Bard", "Hydra Summoner", "Hydra Black Mage", "Hydra Red Mage", "Nightmare Bugard", "Nightmare Crawler", "Nightmare Fly", "Nightmare Flytrap", "Nightmare Funguar", "Nightmare Gaylas", "Nightmare Hornet", "Nightmare Kraken", "Nightmare Raven", "Nightmare Roc", "Nightmare Uragnite", "Vanguard Alchemist", "Vanguard Amputator", "Vanguard Bugler", "Vanguard Chanter", "Vanguard Constable", "Vanguard Dollmaster", "Vanguard Enchanter", "Vanguard Maestro", "Vanguard Mesmerizer", "Vanguard Minstrel", "Vanguard Necromancer", "Vanguard Oracle", "Vanguard Prelate", "Vanguard Priest", "Vanguard Protector", "Vanguard Shaman", "Vanguard Thaumaturge", "Vanguard Undertaker", "Vanguard Vexer", "Vanguard Visionary"}
staggers['night']['ws'] = {"Kindred Paladin", "Kindred Warrior", "Kindred Samurai", "Kindred Dragoon", "Kindred Dark Knight", "Hydra Paladin", "Hydra Warrior", "Hydra Samurai", "Hydra Dragoon", "Hydra Dark Knight", "Nightmare Bunny", "Nightmare Cluster", "Nightmare Eft", "Nightmare Hippogryph", "Nightmare Makara", "Nightmare Mandragora", "Nightmare Sabotender", "Nightmare Sheep", "Nightmare Snoll", "Nightmare Stirge", "Nightmare Weapon", "Vanguard Armorer", "Vanguard Backstabber", "Vanguard Defender", "Vanguard Dragontamer", "Vanguard Drakekeeper", "Vanguard Exemplar", "Vanguard Grappler", "Vanguard Hatamoto", "Vanguard Hawker", "Vanguard Inciter", "Vanguard Partisan", "Vanguard Persecutor", "Vanguard Pillager", "Vanguard Predator", "Vanguard Ronin", "Vanguard Skirmisher", "Vanguard Smithy", "Vanguard Tinkerer", "Vanguard Vigilante", "Vanguard Vindicator"}

ProcZones = {"Dynamis - San d'Oria","Dynamis - Windurst","Dynamis - Bastok","Dynamis - Jeuno","Dynamis - Beaucedine","Dynamis - Xarcabard","Dynamis - Valkurm","Dynamis - Buburimu","Dynamis - Qufim","Dynamis - Tavnazia"}

SalvageZones = {"Aht Urhgan Whitegate","Eastern Adoulin","Bhaflau Remnants","Arrapago Remnants"}
SalvagePathos = {}
SalvagePathos['Aht Urhgan Whitegate'] = {}
SalvagePathos['Aht Urhgan Whitegate']['Zasshal'] = "Salvage Permit"

SalvagePathos['Arrapago Remnants'] = {}
SalvagePathos['Arrapago Remnants']['Acrolith'] = "Cotton Purse"
SalvagePathos['Arrapago Remnants']['Archaic Chariot'] = "Magic, STR, DEX, INT"
SalvagePathos['Arrapago Remnants']['Archaic Gear'] = "Weapon, Range/Ammo, Body"
SalvagePathos['Arrapago Remnants']['Archaic Gears'] = "Magic, STR, DEX, INT"
SalvagePathos['Arrapago Remnants']['Chigoe Stinger'] = "Cotton Coin Purse"
SalvagePathos['Arrapago Remnants']['Flytrap'] = "DEX, MND, AGI"
SalvagePathos['Arrapago Remnants']['Lamia Dancer'] = "Magic, MP, Hands"
SalvagePathos['Arrapago Remnants']['Lamia Dartist'] = "Abilities, HP, Feet/Legs"
SalvagePathos['Arrapago Remnants']['Lamia Fatedealer'] = "CHR, VIT"
SalvagePathos['Arrapago Remnants']['Lamia Graverobber'] = "MND, Magic"
SalvagePathos['Arrapago Remnants']['Leech'] = "Range/Ammo, Rings/Earring"
SalvagePathos['Arrapago Remnants']['Merrow Chantress'] = "Magic, MP, Hands"
SalvagePathos['Arrapago Remnants']['Merrow Icedancer'] = "Magic, Head/Neck, Sub Job"
SalvagePathos['Arrapago Remnants']['Merrow Kabukidancer'] = "Abilities, HP, Feet/Legs"
SalvagePathos['Arrapago Remnants']['Merrow Shadowdancer'] = "Magic, MP, Hands"
SalvagePathos['Arrapago Remnants']['Qutrub'] = "Abilities, MP, INT"
SalvagePathos['Arrapago Remnants']['Vulture'] = "Sub Job, Head/Neck, Back/Waist"


SalvagePathos['Bhaflau Remnants'] = {}
SalvagePathos['Bhaflau Remnants']['Acrolith'] = "Cotton Purse"
SalvagePathos['Bhaflau Remnants']['Archaic Gear'] = "MND, AGI, DEX, HP"
SalvagePathos['Bhaflau Remnants']['Archaic Gears'] = "STR, INT, VIT, CHR, MP"
SalvagePathos['Bhaflau Remnants']['Black Pudding'] = "Legs/Feet, Hands, Body"
SalvagePathos['Bhaflau Remnants']['Dahak'] = "HP, MP"
SalvagePathos['Bhaflau Remnants']['Fly'] = "Head/Neck, Rings/Earrings, Back/Waist"
SalvagePathos['Bhaflau Remnants']['Long-Bowed Chariot'] = "Cotton Purse"
SalvagePathos['Bhaflau Remnants']['Moblin Armsman'] = "Weapon, Range/Ammo, Feet/Legs"
SalvagePathos['Bhaflau Remnants']['Moblin Poniardman'] = "Weapon, Range/Ammo, Feet/Legs"
SalvagePathos['Bhaflau Remnants']['Troll Cameist'] = "Sub Job, Magic, MND"
SalvagePathos['Bhaflau Remnants']['Troll Engraver'] = "Abilities, Sub Job, CHR"
SalvagePathos['Bhaflau Remnants']['Troll Gemologist'] = "Sub Job, Magic, VIT"
SalvagePathos['Bhaflau Remnants']['Troll Lapidarist'] = "Magic, Sub Job, STR"
SalvagePathos['Bhaflau Remnants']['Troll Smelter'] = "Sub Job, Abilities, AGI"
SalvagePathos['Bhaflau Remnants']['Troll Stoneworker'] = "Sub Job, Abilities, DEX"
SalvagePathos['Bhaflau Remnants']['Wamouracampa'] = "Head/Neck, Rings/Earrings, Back/Waist"
SalvagePathos['Bhaflau Remnants']['Wandering Wamoura'] = "Legs/Feet, Hands, Body"

proctype = {"ja","magic","ws"}
		
local defaults = T{}
	defaults.saved = 0
	defaults.mode = 1
	defaults.st = T{}
	defaults.st.pos = {}
	defaults.st.pos.x = 100
	defaults.st.pos.y = 0
	defaults.st.text = {}
	defaults.st.text.alpha = 255
	defaults.st.text.red = 255
	defaults.st.text.green = 255
	defaults.st.text.blue = 255
	defaults.st.text.size = 10
	defaults.st.text.font = 'Arial'
	defaults.st.bg = {}
	defaults.st.bg.alpha = 0
	defaults.st.bg.red = 100
	defaults.st.bg.green = 100
	defaults.st.bg.blue = 100
	defaults.st.bg.visible = true
	settings = config.load(defaults)


function initialize()
	status_bar_string = "${time|} ${target|} ${hexid|} ${targethpp|} ${current_proc|} "
	st.stt = texts.new(status_bar_string,settings.st)
	if windower.ffxi.get_info().logged_in then
		st.stt:show()
	end
	SalvageZoneCheck()
end
	
windower.register_event('login','load',initialize)

function disband()
	st.stt:destroy()
	default_settings()
end

windower.register_event('logout','unload',disband)

function default_settings()
	settings:save('all')
end

function updatebar()
	if targetmob > 0 then
	else
		st.target = ''
		st.targethpp = ''
		st.current_proc = ''
		st.hexid = ''
	end
	st.stt:update(st)
end

windower.register_event('time change', function(new, old)
	st.hours = math.floor(new / 60)
	st.minutes = tostring(new % 60)
	st.minutes = st.minutes:zfill(2)
	st.day = res.days[windower.ffxi.get_info().day].name
	local currenttime = windower.ffxi.get_info()['time']
 	if currenttime >= 0*60 and currenttime < 8*60 then
  		st.window = 'morning'
 	elseif currenttime >= 8*60 and currenttime < 16*60 then
  		st.window = 'day'
	elseif currenttime >= 16*60 and currenttime <= 24*60 then
  		st.window = 'night'
 	end
	if type(windower.ffxi.get_mob_by_target('t')) == 'table' then
		st.targethpp = windower.ffxi.get_mob_by_target('t')['hpp'] .. "%"
	end
	st.time = st.day .. " " .. st.hours .. ":" .. st.minutes .. ' (' .. st.window .. ')'
	updatebar()
end)

windower.register_event('target change',function (targ_id)
	targetmob = targ_id
	if targetmob >0 then
		st.target = windower.ffxi.get_mob_by_index(targetmob)['name']
		st.targethpp = windower.ffxi.get_mob_by_index(targetmob)['hpp'] .. '%'
		st.hexid = num2hex(targ_id)
		if inDynamis then
			for i=1, #proctype do
				for j=1, #staggers[st.window][proctype[i]] do
					if st.target == staggers[st.window][proctype[i]][j] then
						current_proc = proctype[i]
					end
				end
			end
			if current_proc == 'ja' then
				current_proc = 'Job Ability'
				st.current_proc = '[' .. current_proc .. ']'
			elseif current_proc == 'magic' then
				current_proc = 'Magic'
				st.current_proc = '[' .. current_proc .. ']'
			elseif current_proc == 'ws' then
				current_proc = 'Weapon Skill'
				st.current_proc = '[' .. current_proc .. ']'
			end
		end
		if inSalvage then
		if SalvagePathos[res.zones[windower.ffxi.get_info().zone].name] then
			if SalvagePathos[res.zones[windower.ffxi.get_info().zone].name][st.target] then
				current_proc = SalvagePathos[res.zones[windower.ffxi.get_info().zone].name][st.target]
				st.current_proc = '[' .. current_proc .. ']'
			else
				st.current_proc = ''
			end
			end
		end
	end
	updatebar()
end)

function num2hex(num)
    local hexstr = '0123456789ABCDEF'
    local s = ''
    while num > 0 do
        local mod = math.fmod(num, 16)
        s = string.sub(hexstr, mod+1, mod+1) .. s
        num = math.floor(num / 16)
    end
    if s == '' then s = '0' end
    return s
end

windower.register_event('zone change', function(new, newid, old, oldid)
	if checkZone() then inDynamis = true
	else inDynamis = false
	end
	if SalvageZoneCheck() then inSalvage = true
	else inSalvage = false
	end
end)

function SalvageZoneCheck()
	thisZone = string.lower(res.zones[windower.ffxi.get_info().zone].name)
    for key, value in pairs(SalvageZones) do
        if string.lower(value) == thisZone then return key end
    end
    return false
end

function checkZone()
	thisZone = string.lower(res.zones[windower.ffxi.get_info().zone].name)
    for key, value in pairs(ProcZones) do
        if string.lower(value) == thisZone then return key end
    end
    return false
end

windower.register_event('addon command', function(...)
    local args = T{...}
    if args[1] == nil then args[1] = 'help' end
	if args[1] == 'help' then
		windower.add_to_chat(3,'Statusbar Help!')
		windower.add_to_chat(3,"//statusbar pos x y")
		windower.add_to_chat(3,"//statusbar col R G B ")
		windower.add_to_chat(3,"//statusbar colalpha value")
		windower.add_to_chat(3,"//statusbar bg R G B ")
		windower.add_to_chat(3,"//statusbar bgalpha value")
	elseif args[1] == 'pos' then
		st.stt:pos(args[2],args[3])
	elseif args[1] == 'col' then
		st.stt:color(args[2],args[3],args[4])
	elseif args[1] == 'colalpha' then
		st.stt:alpha(args[2])
	elseif args[1] == 'bg' then
		st.stt:bg_color(args[2],args[3],args[4])
	elseif args[1] == 'bgalpha' then
		st.stt:bg_alpha(args[2])
	end
end)
