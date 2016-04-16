SkillsHelper = { }

function SkillsHelper.GetKnownSkillId(skillsId)
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k,v in pairs(skillsId) do
            if BDOLua.Execute("local skillLevelInfo = getSkillLevelInfo(" .. v .. ") if skillLevelInfo then return skillLevelInfo._usable else return false end") then
                return v
            end
        end
    end
    return 0
end

function SkillsHelper.IsSkillUsable(skillId)
    local selfPlayer = GetSelfPlayer()
    if selfPlayer and skillId then
        return BDOLua.Execute("local skillSS = getSkillStaticStatus(" .. skillId .. ", 1) if skillSS then return skillSS:isUsableSkill() else return false end")
    end
    return false
end
