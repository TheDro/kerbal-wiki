local p = {}
local getArgs = require('Module:Arguments').getArgs

local technologyTiers = {} -- redefined at the bottom

function p.getTree(frame)
	local args = getArgs(frame)
	local iTier = tonumber(args[1])
	
	local output = [[
	<div style="width: 1000px; height: 0px; background-color: midnightblue; position: relative; transform: translateY(-530px); font-size: 0.5rem; line-height: 0.7rem">
		%s
	</div>
	]]

    local tier = technologyTiers[iTier]
	local grid = ""
    local height = 48
    local hgap = 9
    local hoffset = 592
    
    local width = 76
    local wgap = 18
    local woffset = tier.woffset
    local fontColor = "white"
    
    for iTech = 1, #tier.research do
        local tech = tier.research[iTech]
        local template = [[
            <div style="color: %s; height: %spx; width: %spx; background-color: transparent; position: absolute; top: %spx; left: %spx">
            <div style="position: relative; left: 52px; display: inline-block; margin: 5px 0; background-color: #324248">%s</div>
            <div style="font-size: 0.41rem; background-color: #4a5868">%s</div>
            </div>
        ]]
        local content = string.format(template,
        	fontColor,
        	height,
        	width,
        	(tech.position[1]-1)*(height+hgap) + hoffset, 
        	(tech.position[2]-1)*(width+wgap) + woffset, 
        	tech.cost,
        	tech.name
        	)
        grid = grid..content
    end
	
    return string.format(output, grid)
end

function p.getTreeTable(frame)
    local args = getArgs(frame)
    local iTier = tonumber(args[1])
    local tier = technologyTiers[iTier]
    return p.objectsToTable(tier.research, {"name", "cost"})
end

function p.getTreeTableContent(frame)
	return "<pre>"..p.getTreeTable(frame).."</pre>"
end


-- columns are optional
function p.objectsToTable(objects, columns)
    local result = "{| class=\"wikitable\"\n"
  
    if (columns == null) then
      columns = getKeys(objects[1])
    end

    -- Add header row
    firstObject = objects[1]
    for i, column in pairs(columns) do
        result = result .. "! " .. column .. "\n"
    end

    -- Iterate over the array elements
    for i, item in ipairs(objects) do
        result = result .. "|-\n"
        
        -- Iterate over the properties of each object
        for i, column in pairs(columns) do
            result = result .. "| " .. tostring(item[column]) .. "\n"
        end
    end
    
    result = result .. "|}"
    
    return result
end

-- convert a wiki table to an array of objects

-- {| class="wikitable"
-- ! name
-- ! cost
-- |-
-- | Starting Rocketry
-- | 0
-- |-
-- | Light Launchers
-- | 10
-- |-
-- | Solid Fuel Booster
-- | 15
-- |-
-- | Orbital Rocketry
-- | 25
-- |}

-- becomes

-- result = {
--     {name = "Starting Rocketry", cost = "0"},
--     {name = "Light Launchers", cost = "10"},
--     {name = "Solid Fuel Booster", cost = "15"},
--     {name = "Orbital Rocketry", cost = "25"},
-- }



function p.test()

    inputTable = [[
{| class="fandom-table"
|+
!name
!cost
!two 
lines
!exclamation
|-
|hey
|1
|1
2
|! what
|-
|there
|2 
|
* 1
* 2
|something!
|-
|
|
|
|
|}
    ]]
    
    local bleh = {}
	bleh["what"] = "else"
	-- return "<pre>".. printObject(bleh) .. "</pre>"
    return "<pre>".. printObject(p.tableToObjects(inputTable)[1]) .."</pre>"
    -- return "<pre>" .. p.tableToObjects(inputTable) .. "</pre>"
end

function p.tableToObjects(inputTable)
    local result = {}
    local columns = {}
    local header = inputTable:match("\n!(.-)\n|")
    local body = inputTable:match("\n|%-(.-)\n|}")

    columns = split(header, "\n!")
    rows = split(body, "\n|-")

    for i, row in ipairs(rows) do
        local object = {}
        local cells = split(row, "\n|")
        cells = {unpack(cells, 2, #cells)}
        for i, cell in ipairs(cells) do
        	local column = columns[i]
        	if (column == null) then
        		column = "missing"
        	end
            object[column] = cell
        end
        table.insert(result, object)
    end

	return result
end

function printObject(object) 
    result = "{\n"
    for key, value in pairs(object) do
        result = result .. key .. " = " .. value .. "\n"
    end
    result = result .. "}"
    return result
end

function split(str, separator)
    local result = {}
    str2 = str .. separator
    local safeSeparator = string.gsub(separator, "%-", "%%-")
    for match in str2:gmatch("(.-)"..safeSeparator) do
        table.insert(result, match)
    end
    return result
end

function join(array, separator)
    local result = ""
    for i, v in ipairs(array) do
        result = result .. v
        if i < #array then
            result = result .. separator
        end
    end
    return result
end

function getKeys(object)
    local keys = {}
    for key, value in pairs(object) do
        table.insert(keys, key)
    end
    return keys
end

technologyTiers = {
    {
        woffset = 240,
	    research = { -- Tier 1
            {name = "Starting Rocketry", cost = 0, position = "1,1"},
            {name = "Light Launchers", cost = 10, position = "1,2"},
            {name = "Solid Fuel Booster", cost = 15, position = "1,3"},
            {name = "Orbital Rocketry", cost = 25, position = "1,4"},
            {name = "Mun Landing", cost = 80, position = "1,6"},
            {name = "Power Launchers", cost = 180, position = "1,8"},
            {name = "Environmental Science", cost = 10, position = "2,3"},
            {name = "Struts", cost = 35, position = "2,4"},
            {name = "Reaction Control System", cost = 50, position = "2,5"},
            {name = "Monopropellant Drive", cost = 80, position = "2,6"},
            {name = "Tiny Engines", cost = 120, position = "2,7"},
            {name = "Probes", cost = 10, position = "3,3"},
            {name = "Lights & Utilities", cost = 15, position = "3,4"},
            {name = "Power Management", cost = 35, position = "3,5"},
            {name = "Long-Range Probes", cost = 50, position = "3,6"},
            {name = "Small Payloads", cost = 35, position = "4,5"},
            {name = "Research Miniaturization", cost = 50, position = "4,6"},
            {name = "Introductory Construction", cost = 10, position = "5,3"},
            {name = "Specialized Decoupling", cost = 15, position = "5,4"},
            {name = "Basic Docking", cost = 50, position = "5,6"},
            {name = "Basic Trusses", cost = 25, position = "6,4"},
            {name = "Micro-Construction", cost = 35, position = "6,5"},
            {name = "Aerodynamics & Stability", cost = 10, position = "7,3"},
            {name = "Survivability", cost = 10, position = "7,4"},
            {name = "Light Aviation", cost = 50, position = "7,5"}
        }
    },
    { -- Tier 2
        woffset = 212,
        research = {
            {name = "Medium Orbital Rockets", cost = 180, position = "1,1.9"},
            {name = "Medium Launchers", cost = 400, position = "1,4"},
            {name = "Nuclear Propulsion", cost = 650, position = "1,6"},
            {name = "Modulear Launchers", cost = 300, position = "1,8"},
            {name = "Fuel Lines", cost = 300, position = "2,3"},
            {name = "Precision Propulsion", cost = 400, position = "2,4"},
            {name = "Xenon Propulsion", cost = 850, position = "2,7"},
            {name = "Enhanced Electronics", cost = 230, position = "3,3"},
            {name = "Durable Power Systems", cost = 300, position = "3,4"},
            {name = "Rovers", cost = 400, position = "3,5"},
            {name = "Autonomous Sampling", cost = 500, position = "3,6"},
            {name = "Atmospheric Science", cost = 300, position = "4,4"},
            {name = "Landing Utilities", cost = 400, position = "4,5"},
            {name = "Heavy Landings", cost = 500, position = "4,6"},
            {name = "Expanded Construction", cost = 230, position = "5,3"},
            {name = "Precision Machining", cost = 300, position = "5,4"},
            {name = "Medium Payloads", cost = 400, position = "5,5"},
            {name = "Medium Trusses", cost = 500, position = "5,6"},
            {name = "Advanced Truss Adapters", cost = 650, position = "5,7"},
            {name = "Enhanced Coupling", cost = 300, position = "6,4"},
            {name = "Tiny & Large Docking", cost = 400, position = "6,5"},
            {name = "Precision Aerodynamics", cost = 230, position = "7,3"},
            {name = "Mk2 Jets", cost = 300, position = "7,4"},
            {name = "High-Altitude Aviation", cost = 400, position = "7,5"},
            {name = "Aviation Utility", cost = 500, position = "7,6"},
            {name = "Aerial Drones", cost = 400, position = "8,5"}
        }
    },
    { -- Tier 3
        woffset = 270,
        research = {
            {name = "Heavy Rocketry", cost = 1400, position = "1,1"},
            {name = "Heavy Launchers", cost = 1800, position = "1,2"},
            {name = "Deep Space Methalox", cost = 2900, position = "1,4"},
            {name = "Heavy Nuclear Propulsion", cost = 4500, position = "1,6"},
            {name = "Oversized Monopropellant Fuel", cost = 1800, position = "2,2"},
            {name = "Heavy Orbital Operations", cost = 2300, position = "2,3"},
            {name = "Deep Space Probes", cost = 1400, position = "3,2"},
            {name = "Enlarged Power Systems", cost = 1800, position = "3,3"},
            {name = "Long-Range Generation", cost = 2300, position = "3,4"},
            {name = "Nuclear Power", cost = 2900, position = "3,5"},
            {name = "Radiation Science", cost = 1800, position = "4,3"},
            {name = "Orbital Science", cost = 2900, position = "4,5"},
            {name = "Heavy Construction", cost = 1400, position = "5,2"},
            {name = "Heavy Trusses", cost = 1800, position = "5,3"},
            {name = "Large Payloads", cost = 2300, position = "5,4"},
            {name = "Large Coupling", cost = 1800, position = "6,3"},
            {name = "Specialized Docking", cost = 2300, position = "6,4"},
            {name = "Large Aerodynamics", cost = 1400, position = "7,2"},
            {name = "Jumbo Jets", cost = 1800, position = "7,3"},
            {name = "Airliners", cost = 2300, position = "7,4"}
        }
    },
    { -- Tier 4
        woffset = 240,
        research = {    
            {name = "XL Methalox Tanks", cost = 5000, position = "1,2"},
            {name = "XL Hydrogen Tanks", cost = 6000, position = "1,3"},
            {name = "XL Electronics", cost = 5000, position = "2,3"},
            {name = "Aquatic Sciences", cost = 6000, position = "2,4"},
            {name = "Orbital Report", cost = 7000, position = "2,5"},
            {name = "Oversized Landing", cost = 5000, position = "3,3"},
            {name = "Space Truckin'", cost = 7000, position = "3,5"},
            {name = "XL Construction", cost = 5000, position = "4,3"},
            {name = "XL Trusses", cost = 6000, position = "4,4"},
            {name = "XL Truss Adapters", cost = 7000, position = "4,5"},
            {name = "XL Payloads", cost = 8000, position = "4,6"},
            {name = "XL Coupling", cost = 6000, position = "5,4"},
            {name = "XL Docking", cost = 7000, position = "5,5"},
            {name = "Space SHuttles", cost = 6000, position = "6,4"},
            {name = "Spaceplanes", cost = 5000, position = "7,3"},
            {name = "Mk3 Fuel Systems", cost = 6000, position = "7,4"}
        }
    }
}

return p
