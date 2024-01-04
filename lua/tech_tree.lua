local p = {}
local getArgs = require('Module:Arguments').getArgs
local sharedTables = require('Module:SharedTables')

-- Refactor this to add metadata to each tier
local technologyTiers = {} 
local treeMetadata = {
    {woffset = 240},
    {woffset = 212},
    {woffset = 180},
    {woffset = 150}
}

function p.getTree(frame)
	local args = getArgs(frame)
	local iTier = tonumber(args[1])
	
	local output = [[
	<div style="width: 1000px; height: 0px; background-color: midnightblue; position: relative; transform: translateY(-530px); font-size: 0.5rem; line-height: 0.7rem">
		%s
	</div>
	]]

    local tierContent = sharedTables._getTable("TechTree", "tier"..iTier)
    local tier = sharedTables.tableToObjects(tierContent)
    return printObject(tier[1])

    -- parse position
    for i, tech in ipairs(tier) do
        if tech.Position ~= nil then
            local position = split(tech.Position, ",")
            tech.position = {tonumber(position[1]), tonumber(position[2])}
        end
    end

	local grid = ""
    local height = 48
    local hgap = 9
    local hoffset = 592
    
    local width = 76
    local wgap = 18
    local woffset = treeMetadata[iTier].woffset
    local fontColor = "white"
    
    for iTech = 1, #tier do
        local tech = tier[iTech]
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

function printObject(object) 
    result = "{\n"
    for key, value in pairs(object) do
       if type(value) == "table" then
           result = result .. key .. " = " .. printObject(value) .. "\n"
       else
           result = result .. key .. " = " .. value .. "\n"
       end
    end
    result = result .. "}"
    return result
end

return p
