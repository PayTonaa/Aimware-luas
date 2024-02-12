-- Engine Radar by Nyanpasu!

local function drawing_callback()
    for index, Player in pairs(entities.FindByClass("CCSPlayer")) do
        Player:SetProp("m_bSpotted", 1);
    end
end

-- Engine Radar by Nyanpasu!

callbacks.Register("Draw", "engine_radar_draw", drawing_callback);