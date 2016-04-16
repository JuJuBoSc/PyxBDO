---------------------------------------------
-- GUI Variables
---------------------------------------------

g_packetEditorGui = nil
g_currentPacketBuffer = nil
g_currentPacketType = nil
g_packets = { }
g_dumpCSPackets = false
g_dumpSCPackets = false
g_filterOnlyIncludeOpCode = ""
g_filterExcludeOpCode = ""

---------------------------------------------
-- GUI Functions
---------------------------------------------

function OnDrawGuiCallback()
	local shouldDisplay;
	_, shouldDisplay = ImGui.Begin("Packet Sniffer", true, ImVec2(600, 230), -1.0)
	if shouldDisplay then
    
        _, g_dumpCSPackets = ImGui.Checkbox("Dump client -> server packets", g_dumpCSPackets)
        ImGui.SameLine()
        _, g_dumpSCPackets = ImGui.Checkbox("Dump server -> client packets", g_dumpSCPackets)
        
        _, g_filterOnlyIncludeOpCode = ImGui.InputText("Include filter", g_filterOnlyIncludeOpCode)
        _, g_filterExcludeOpCode = ImGui.InputText("Exclude filter", g_filterExcludeOpCode)
                        
        if ImGui.Button("Clear##clear_packets") then
            g_packets = { }
        end
        
        ImGui.Columns(5, "packets")
        ImGui.Separator()
        ImGui.Text("Time")
        ImGui.NextColumn()
        ImGui.Text("Direction")
        ImGui.NextColumn()
        ImGui.Text("OpCode")
        ImGui.NextColumn()
        ImGui.Text("Size")
        ImGui.NextColumn()
        ImGui.Text("Actions")
        ImGui.NextColumn()
        ImGui.Separator()
        local count = 0
        for k,v in pairs(g_packets) do
            if (g_filterOnlyIncludeOpCode:len() == 0 or v.OpCode:match(g_filterOnlyIncludeOpCode))
                and
                (g_filterExcludeOpCode:len() == 0 or not v.OpCode:match(g_filterExcludeOpCode))
             then
                ImGui.Text(v.Date)
                ImGui.NextColumn()
                ImGui.Text(v.Direction)
                ImGui.NextColumn()
                ImGui.Text(v.OpCode)
                ImGui.NextColumn()
                ImGui.Text(v.Packet.Size)
                ImGui.NextColumn()
                if ImGui.Button("Edit packet##edit_packet_" .. k) then
                    g_packetEditorGui = ImGuiPacketEditor(v.Packet)
                end
                ImGui.NextColumn()
            count = count + 1
            end
            if count > 500 then
                ImGui.Text("Limit reached !")
                ImGui.NextColumn()
                ImGui.NextColumn()
                ImGui.NextColumn()
                ImGui.NextColumn()
                break
            end
        end
        ImGui.Columns(1)
        ImGui.Spacing()

        ImGui.End()
	end
    
    if g_packetEditorGui then
        g_packetEditorGui:Draw()
    end
    
end

function OnSendPacket(name, opcode, packet)
    if g_dumpCSPackets then
        local packetData = 
        {
            Date = os.date("%H:%M:%S"),
            Direction = "C -> S",
            OpCode = name .. "(" .. opcode .. ")",
            Packet = packet
        }
        if (g_filterOnlyIncludeOpCode:len() == 0 or packetData.OpCode:match(g_filterOnlyIncludeOpCode))
            and
            (g_filterExcludeOpCode:len() == 0 or not packetData.OpCode:match(g_filterExcludeOpCode))
        then
            table.insert(g_packets, packetData)
        end
    end
end

function OnReceivePacket(name, opcode, packet)
    if g_dumpSCPackets then
        local packetData = 
        {
            Date = os.date("%H:%M:%S"),
            Direction = "S -> C",
            OpCode = name .. "(" .. opcode .. ")",
            Packet = packet
        }
        if (g_filterOnlyIncludeOpCode:len() == 0 or packetData.OpCode:match(g_filterOnlyIncludeOpCode))
            and
            (g_filterExcludeOpCode:len() == 0 or not packetData.OpCode:match(g_filterExcludeOpCode))
        then
            table.insert(g_packets, packetData)
        end
    end
end

Pyx.System.RegisterCallback("OnDrawGui", OnDrawGuiCallback)
Pyx.System.RegisterCallback("OnSendPacket", OnSendPacket)
Pyx.System.RegisterCallback("OnReceivePacket", OnReceivePacket)