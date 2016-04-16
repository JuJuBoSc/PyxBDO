------------------------------------------------------------------------------
-- Version .2 by Triplany 2016-03-28
-- Increased buffer size to 1mb
-----------------------------------------------------------------------------


------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

LuaMainWindow = { }
local InputBuffer = '-- Return values in BDO are currently limited to strings, numbers, bools\r\n\r\n' ..
'print("This will Display In Pyx Console if Run in pyx")\r\n\r\n' ..
'return ("This will display in Lua Consoles lower Panel")'
local OutputBuffer = ""

------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- LuaMainWindow Functions
-----------------------------------------------------------------------------

function LuaMainWindow.DrawMainWindow()
    local valueChanged = false
    local _, shouldDisplay = ImGui.Begin("Lua Console", true, ImVec2(600, 500), -1.0)
    if shouldDisplay then
        local winSize = ImGui.GetWindowSize()
        --[[
    if winSize.x < 100 then
        winSize.x = 100
        ImGui.SetWindowSize(winSize,0)
    end
    if winSize.y < 100 then
        winSize.y = 100
        ImGui.SetWindowSize(winSize,0)
    end
    --]]
        local conSize = ImGui.GetContentRegionAvail()

        local luaInputSize = ImVec2(conSize.x,(conSize.y * 0.75) -15)
        local luaOutputSize = ImVec2(conSize.x,(conSize.y * 0.25) -15)

        __, InputBuffer = ImGui.InputTextMultiline("Lua_Input", InputBuffer, 1024000, luaInputSize, 0)
        ImGui.InputTextMultiline("Lua_Output", OutputBuffer, 1024000, luaOutputSize, 0)
        ImGui.Columns(4,"lua_console_buttons",false)

        if ImGui.Button("Run in Pyx##Lua_Pyx", ImVec2(ImGui.GetColumnWidth(), 20)) then
            OutputBuffer = LuaMainWindow.ExecuteLocalLua(InputBuffer)
            OutputBuffer = "Local Execute:\r\n"..OutputBuffer
        end
        			ImGui.NextColumn()

--        ImGui.SameLine()
        if ImGui.Button("Run in Bdo##Lua_Bdo", ImVec2(ImGui.GetColumnWidth(), 20)) then
            OutputBuffer = LuaMainWindow.ExecuteBDOLua(InputBuffer)
            OutputBuffer = "BDO Execute:\r\n"..OutputBuffer
        end
        			ImGui.NextColumn()
        			ImGui.NextColumn()
        if ImGui.Button("Clear All##Lua_Clear", ImVec2(ImGui.GetColumnWidth(), 20)) then
        InputBuffer = ""
        OutputBuffer = ""
        end


        ImGui.End()
    end
end

function LuaMainWindow.ExecuteLocalLua(script)
    if type(script) ~= "string" then
        return("Unknown script type. Must be String")
    end
    local execString, errorMsg = load(script)
    if execString == nil then
        return errorMsg
    else

        local retBuffer = execString()
        if retBuffer ~= nil then
            if type(retBuffer) == "string" or type(retBuffer) == 'number' then
                return retBuffer
            else
                return "Type Returned: " .. type(retBuffer)
            end
        else
            return "Executing returned nil"
        end
    end

end


function LuaMainWindow.ExecuteBDOLua(script)
    if type(script) ~= "string" then
        return("Unknown script type. Must be String")
    end
    

        local retBuffer = BDOLua.Execute (script)

        if retBuffer ~= nil then
            if type(retBuffer) == "string" or type(retBuffer) == 'number' then
                return retBuffer
            else
                return "Type Returned: " .. type(retBuffer)
            end
        else
            return "Executing returned nil"
        end
    

end


function LuaMainWindow.OnDrawGuiCallback()
    LuaMainWindow.DrawMainWindow()
end

