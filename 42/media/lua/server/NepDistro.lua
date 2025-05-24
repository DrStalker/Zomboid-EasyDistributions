require "Items/ProceduralDistributions"
--require "Vehicles/VehicleDistribution"


NepDistro = NepDistro or {}
NepDistro.Debug = true
NepDistro.VerboseDebug = true


function NepDistro.DebugSay(message)
    if NepDistro.Debug then print ("NepDistro: "..tostring(message)) end
end

function NepDistro.DebugSayVerbose(message)
    if NepDistro.VerboseDebug then NepDistro.DebugSay(message) end
end

function NepDistro.ErrorSay(message)
    print ("NepDistro: ERROR "..tostring(message))
end


function NepDistro.FindItemLootValues(refItem)
    local retValues={}
    local found=0
    --refItem might be a short or full item name, and loot tables use both so:
    local script=ScriptManager.instance:getItem(refItem)
    if script==nil then 
        NepDistro.ErrorSay("unable to find reference item "..tostring(refItem))
        return {}
    end
    local fullName=script:getFullName()
    local shortName=script:getName()
    for k,v in pairs(ProceduralDistributions.list) do
        --k -> tablename, v.items -> the list of stuff in the table
        for j,w in pairs(v.items) do
            if w==fullName or w==shortName then
                NepDistro.DebugSayVerbose(tostring(k).." "..tostring(w).." "..tostring(v.items[j+1]))
                table.insert(retValues, {lootTable=k, probabilty=(v.items[j+1])})
                --retValues[k]=v.items[j+1]
                found=found+1
            end
        end
    end
    NepDistro.DebugSay("Found "..tostring(found).." entries for "..refItem)
    return retValues
end

function NepDistro.AddLoot(newItem, refItem, lootMult)
    if lootMult == nil then lootMult=1.0 end --default if not specified
    if type(newItem) ~= "string" or type(refItem) ~= "string" or type(lootMult) ~= "number"  then
        NepDistro.ErrorSay("newItem and refItem must be strings and (if used) lootMult must be a number.")
        NepDistro.ErrorSay("newItem: "..type(newItem).." refItem: "..type(refItem).." lootMult: "..type(lootMult))
        return
    end
    local refValues = NepDistro.FindItemLootValues(refItem)
    local added = 0
    for k,v in pairs(refValues) do
        NepDistro.DebugSayVerbose("Adding "..newItem.." to table "..v.lootTable.." value: "..string.format("%.3f",v.probabilty * lootMult))
        table.insert(ProceduralDistributions["list"][v.lootTable].items, newItem);
        table.insert(ProceduralDistributions["list"][v.lootTable].items, v.probabilty * lootMult);
        added=added+1
    end
    NepDistro.DebugSay("Added "..added.." loot entries for "..newItem.." based on "..refItem.." with a "..string.format("%.3f",lootMult).." modifier")
end



--NepDistro.AddLoot("Base.NepPR57","Base.ArmorSchematic",1)
--NepDistro.AddLoot("Base.NepPR57","Base.Pistol",1)