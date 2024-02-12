---------------------------------------------------- SpecList ----------------------------------------------------


--SimpleSpeclist by Cheeseot
local specshit = gui.Reference( "MISC", "GENERAL", "Extra");
local BetterSpecBox = gui.Checkbox( specshit, "lua_betterspec", "Simple speclist", 0 );

function betterspec()
local specfont = draw.CreateFont('Impact', 20)
local sorting = 0
local specpos1, specpos2 = gui.GetValue("wnd_showspec");
    if BetterSpecBox:GetValue() then
    gui.SetValue("msc_showspec", 0);
    local lp = entities.GetLocalPlayer();
        if lp ~= nil then
            local players = entities.FindByClass("CCSPlayer");
            for i = 1, #players do
            local player = players[i];
                if player ~= lp and player:GetHealth() <= 0 then
                local name = player:GetName();
                    if player:GetPropEntity("m_hObserverTarget") ~= nil then
                    local playerindex = player:GetIndex()
                        if name ~= "GOTV" and playerindex ~= 1 then
                        local target = player:GetPropEntity("m_hObserverTarget");
                            if target:IsPlayer() then
                            local targetindex = target:GetIndex();
                            local myindex = client.GetLocalPlayerIndex();
                                if lp:IsAlive() then
                                    if targetindex == myindex then
                                    draw.SetFont(specfont);
                                    draw.Color(255,255,255,255);
                                    draw.Text( specpos1, specpos2 + (sorting * 16), name );
                                    draw.TextShadow( specpos1, specpos2 + (sorting * 16), name );
                                    sorting = sorting + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end    
callbacks.Register ("Draw", "betterspec", betterspec)
--SimpleSpeclist by Cheeseot

---------------------------------------------------- Speclist Fix ----------------------------------------------------

function SPECTATOR_fix(event)
    if (event:GetName() == 'round_start') then
        client.Command('cl_fullupdate', true)
    end
end

client.AllowListener('round_start')
callbacks.Register('FireGameEvent', 'SpecFix', SPECTATOR_fix)