Pets = { }

function Pets.GetUnsealedPetInfo(petIndex)
    local script = [[
    			local petData	= ToClient_getPetUnsealedDataByIndex( ]] .. petIndex-1 .. [[)

    			local petStaticStatus		= petData:getPetStaticStatus()
    --			local iconPath			= petData:getIconPath()
    --			local petNo_s64			= petData:getPcPetNo()
    			local petName				= petData:getName()
    			local petLevel			= petData:getLevel()
    			local petLovely			= petData:getLovely()
    			local pethungry			= petData:getHungry()
    			local petState			= petData:getPetState()
    			local petMaxLevel			= petStaticStatus._maxLevel
    			local petMaxHungry		= petStaticStatus._maxHungry
    			local petRace				= petStaticStatus:getPetRace()
    			local petTier				= petStaticStatus:getPetTier() + 1
                local petExperience           = petData:getExperience()
                local petMaxExperience        = petData:getMaxExperience()

                    return petName, petLevel, petMaxLevel, pethungry, petMaxHungry, petRace, petTier, petExperience, petMaxExperience

    ]]

    local pName, pLevel, pMaxLevel, pHunger, pMaxHunger, pRace, pTier, pExperience, pMaxExperience = BDOLua.Execute(script)
    if pName == nil then
        return nil
    end
    return {Name = pName, Level = pLevel, MaxLevel = pMaxLevel, Hunger = pHunger, MaxHunger = pMaxHunger,
     Race = pRace, Tier = pTier, Experience = pExperience, MaxExperience = pMaxExperience }

end

function Pets.GetSealedPetInfo(petIndex)
    local script = [[
    			local petData	= ToClient_getPetSealedDataByIndex( ]] .. petIndex-1 .. [[)

    			local petStaticStatus		= petData:getPetStaticStatus()
    --			local iconPath			= petData:getIconPath()
    --			local petNo_s64			= petData:getPcPetNo()
    			local petName				= petData:getName()
    			local petLevel			= petData._level
    			local petLovely			= petData._lovely
    			local pethungry			= petData._hungry
    			local petState			= petData._petState
    			local petMaxLevel			= petStaticStatus._maxLevel
    			local petMaxHungry		= petStaticStatus._maxHungry
    			local petRace				= petStaticStatus:getPetRace()
    			local petTier				= petStaticStatus:getPetTier() + 1
                --local petExperience           = petData._experience
                --local petMaxExperience        = petData:getMaxExperience()

                    return petName, petLevel, petMaxLevel, pethungry, petMaxHungry, petRace, petTier, petExperience, petMaxExperience
    ]]

    local pName, pLevel, pMaxLevel, pHunger, pMaxHunger, pRace, pTier, pExperience, pMaxExperience = BDOLua.Execute(script)
    if pName == nil then
        return nil
    end
    return {Name = pName, Level = pLevel, MaxLevel = pMaxLevel, Hunger = pHunger, MaxHunger = pMaxHunger,
     Race = pRace, Tier = pTier, Experience = pExperience, MaxExperience = pMaxExperience }

end


function Pets.GetSealedPetCount()
    return(tonumber(BDOLua.Execute ("return ToClient_getPetSealedList()")))
end

function Pets.GetUnsealedPetCount()
    return(tonumber(BDOLua.Execute ("return ToClient_getPetUnsealedList()")))
end

function Pets.GetAllPets()
local allPets = {}
    for i=1,Pets.GetSealedPetCount(),1 do
    local pet = Pets.GetSealedPetInfo(i)
    pet["Sealed"] = true
    allPets[#allPets] = pet
    end

    for i=1,Pets.GetUnsealedPetCount(),1 do
    local pet = Pets.GetUnsealedPetInfo(i)
    pet["Sealed"] = false
    allPets[#allPets] = pet
    end

    return allPets
end

function Pets.GetTotalPets()
return Pets.GetSealedPetCount()+Pets.GetUnsealedPetCount()
end
