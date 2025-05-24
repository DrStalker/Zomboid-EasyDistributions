require "Items/ProceduralDistributions"
--require "Vehicles/VehicleDistribution"


EasyDistro = EasyDistro or {}
EasyDistro.Debug = true
EasyDistro.VerboseDebug = false


function EasyDistro.DebugSay(message)
    if EasyDistro.Debug then print ("EasyDistro: "..tostring(message)) end
end

function EasyDistro.DebugSayVerbose(message)
    if EasyDistro.VerboseDebug then EasyDistro.DebugSay(message) end
end

function EasyDistro.ErrorSay(message)
    print ("EasyDistro: ERROR "..tostring(message))
end

function EasyDistro.EnableDebug(bool)
    bool=bool or true
    EasyDistro.Debug = bool
end

function EasyDistro.EnableVerbose(bool)
    bool=bool or true
    EasyDistro.VerboseDebug = bool
    if bool then EasyDistro.Debug = bool end
end

-- ----------------------------------------------------
-- Find all the loot table entries for an item, returns them as a table of {lootTable=, probabilty=}

function EasyDistro.FindItemLootValues(refItem)
    local retValues={}
    local found=0
    --refItem might be a short or full item name, and loot tables use both so:
    local script=ScriptManager.instance:getItem(refItem)
    if script==nil then 
        EasyDistro.ErrorSay("unable to find reference item "..tostring(refItem))
        return {}
    end
    local fullName=script:getFullName()
    local shortName=script:getName()
    for k,v in pairs(ProceduralDistributions.list) do
        --k -> tablename, v.items -> the list of stuff in the table
        for j,w in pairs(v.items) do
            if w==fullName or w==shortName then
                EasyDistro.DebugSayVerbose(tostring(k).." "..tostring(w).." "..tostring(v.items[j+1]))
                table.insert(retValues, {lootTable=k, probabilty=(v.items[j+1])})
                --retValues[k]=v.items[j+1]
                found=found+1
            end
        end
    end
    EasyDistro.DebugSayVerbose("Found "..tostring(found).." entries for "..refItem)
    return retValues
end

-- ----------------------------------------------------
-- Does some sanity checking, calls FindItemLootValues then adds new values to loot tables.

function EasyDistro.AddItem(newItem, refItem, lootMult)
    if lootMult == nil then lootMult=1.0 end --default if not specified
    if type(newItem) ~= "string" or type(refItem) ~= "string" or type(lootMult) ~= "number"  then
        EasyDistro.ErrorSay("newItem and refItem must be strings and (if used) lootMult must be a number.")
        EasyDistro.ErrorSay("newItem: "..type(newItem).." refItem: "..type(refItem).." lootMult: "..type(lootMult))
        return
    end
    local refValues = EasyDistro.FindItemLootValues(refItem)
    local added = 0
    for k,v in pairs(refValues) do
        EasyDistro.DebugSayVerbose("Adding "..newItem.." to table "..v.lootTable.." value: "..string.format("%.3f",v.probabilty * lootMult))
        table.insert(ProceduralDistributions["list"][v.lootTable].items, newItem);
        table.insert(ProceduralDistributions["list"][v.lootTable].items, v.probabilty * lootMult);
        added=added+1
    end
    EasyDistro.DebugSay("Added "..added.." loot entries for "..newItem.." based on "..refItem.." with a "..string.format("%.3f",lootMult).." modifier")
    
end

-- ----------------------------------------------------
-- This is only needed if ItemPickerJava.Parse() has already been run.

function EasyDistro.UpdateItemPicker()
    ItemPickerJava:Parse() -- Updates the java loot generation with the new Values from ProceduralDistributions
end    

--EasyDistro.Add("Base.NepPR57","Base.ArmorSchematic",1)
--EasyDistro.Add("Base.NepPR57","Base.Pistol",1)