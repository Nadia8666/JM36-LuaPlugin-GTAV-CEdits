local GenPlate = {}

GenPlate.Characters = {"a", "b", "c", "d", "e", "f", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
GenPlate.Numbers = {1,2,3,4,5,6,7,8,9}

---
---@param MaxLength number, MaxLength default 8
---@param NumberEquality number
GenPlate.GenerateRandomPlate = function (MaxLength, NumberEquality)
    NumberEquality = (NumberEquality or 2)
    if MaxLength >= 1 then
        local FinishedText = ""
        for i=1, MaxLength do
            local Char = GenPlate.Characters[math.random(1, #GenPlate.Characters)]
            local Numbers = GenPlate.Numbers[math.random(1, #GenPlate.Numbers)]
            local NumberOrChar = math.random(1,NumberEquality)
            if NumberOrChar == 1 then
                FinishedText = FinishedText.. Char
            else
                FinishedText = FinishedText.. tostring(Numbers)
            end
        end

        return FinishedText
    else
        return "0"
    end
end


return GenPlate