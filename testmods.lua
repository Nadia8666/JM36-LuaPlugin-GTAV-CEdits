-- file used when working on code changes for -master branch--

local function clamp(num, min, max) -- for some reason lua doesnt have math.clamp as a default function and it makes me sad :( its very useful
    if num > max then num = max elseif num < min then num = min end -- num < min = min | num > max = max
    return num
end

function configFileFindLineFromText(file, text, maxOccurences)
    maxOccurences = clamp(maxOccurences or 1, 1, math.huge) -- by default return first | 0 and 1 would act the same but 1 is easier to read imo due to table index's starting with 1 and everything

    local filePath = Scripts_Path.. file
    local configFile = assert(io_open(filePath, "r"), "Invalid File Path")
    local lines = {}

    for L in configFile:lines() do
        -- Loop through every line
        table_insert(lines, L)
    end
    configFile:close()

    local returnLineNum
    local occurences = 0

    for i,v in ipairs(lines) do
        if v:find(text) then
            occurences = occurences + 1
            returnLineNum = i 
            if occurences >= maxOccurences then break end
        end
    end

    return returnLineNum -- nil | number
end