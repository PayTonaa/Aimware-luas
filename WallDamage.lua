local Alive = false
local x1, y1, z1
local z
local clientx, clienty, clientz
local mode = 0
local enemy;
--local marker = draw.CreateFont("Verdana", 15, 500);

local box_auto = gui.Groupbox(gui.Reference("Rage", "Weapon", "A. Sniper", "Accuracy"), "Damage Behind Wall", 0, 300, 213, 200)
local box_sniper = gui.Groupbox(gui.Reference("Rage", "Weapon", "Sniper", "Accuracy"), "Damage Behind Wall", 0, 320, 213, 200)
local box_scout = gui.Groupbox(gui.Reference("Rage", "Weapon", "Scout", "Accuracy"), "Damage Behind Wall", 0, 300, 213, 200)
local box_revolver = gui.Groupbox(gui.Reference("Rage", "Weapon", "Revolver", "Accuracy"), "Damage Behind Wall", 0, 300, 213, 200)
local box_pistol = gui.Groupbox(gui.Reference("Rage", "Weapon", "Pistol", "Accuracy"), "Damage Behind Wall", 0, 290, 213, 200)
local box_rifle = gui.Groupbox(gui.Reference("Rage", "Weapon", "Rifle", "Accuracy"), "Damage Behind Wall", 0, 260, 213, 200)

local rbot_autosniper_mindamage_active = gui.Checkbox(box_auto, "rbot_autosniper_mindamage_active", "Damage Behind Wall", false)
local rbot_sniper_mindamage_active = gui.Checkbox(box_sniper, "rbot_sniper_mindamage_active", "Damage Behind Wall", false)
local rbot_scout_mindamage_active = gui.Checkbox(box_scout, "rbot_scout_mindamage_active", "Damage Behind Wall", false)
local rbot_revolver_mindamage_active = gui.Checkbox(box_revolver, "rbot_revolver_mindamage_active", "Damage Behind Wall", false)
local rbot_pistol_mindamage_active = gui.Checkbox(box_pistol, "rbot_pistol_mindamage_active", "Damage Behind Wall", false)
local rbot_rifle_mindamage_active = gui.Checkbox(box_rifle, "rbot_rifle_mindamage_active", "Damage Behind Wall", false)

local rbot_autosniper_mindamage_2 = gui.Slider(box_auto, "rbot_autosniper_mindamage_2", "Damage Visible", 0, 0, 100);
local rbot_sniper_mindamage_2 = gui.Slider(box_sniper, "rbot_sniper_mindamage_2", "DamageVisible", 0, 0, 100);
local rbot_scout_mindamage_2 = gui.Slider(box_scout, "rbot_scout_mindamage_2", "Damage Visible", 0, 0, 100);
local rbot_revolver_mindamage_2 = gui.Slider(box_revolver, "rbot_revolver_mindamage_2", "Damage Visible", 0, 0, 100);
local rbot_pistol_mindamage_2 = gui.Slider(box_pistol, "rbot_pistol_mindamage_2", "Damage Visible", 0, 0, 100);
local rbot_rifle_mindamage_2 = gui.Slider(box_rifle, "rbot_rifle_mindamage_2", "Damage Visible", 0, 0, 100);

local rbot_autosniper_mindamage_1 = gui.Slider(box_auto, "rbot_autosniper_mindamage_1", "Damage behind Wall", 0, 0, 100);
local rbot_sniper_mindamage_1 = gui.Slider(box_sniper, "rbot_sniper_mindamage_1", "Damage behind Wall", 0, 0, 100);
local rbot_scout_mindamage_1 = gui.Slider(box_scout, "rbot_scout_mindamage_1", "Damage behind Wall", 0, 0, 100);
local rbot_revolver_mindamage_1 = gui.Slider(box_revolver, "rbot_revolver_mindamage_1", "Damage behind Wall", 0, 0, 100);
local rbot_pistol_mindamage_1 = gui.Slider(box_pistol, "rbot_pistol_mindamage_1", "Damage behind Wall", 0, 0, 100);
local rbot_rifle_mindamage_1 = gui.Slider(box_rifle, "rbot_rifle_mindamage_1", "Damage behind Wall", 0, 0, 100);

local rbot_autosniper_mindamage_mode = gui.Combobox(box_auto, "rbot_autosniper_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")
local rbot_sniper_mindamage_mode = gui.Combobox(box_sniper, "rbot_sniper_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")
local rbot_scout_mindamage_mode = gui.Combobox(box_scout, "rbot_scout_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")
local rbot_revolver_mindamage_mode = gui.Combobox(box_revolver, "rbot_revolver_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")
local rbot_pistol_mindamage_mode = gui.Combobox(box_pistol, "rbot_pistol_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")
local rbot_rifle_mindamage_mode = gui.Combobox(box_rifle, "rbot_rifle_mindamage_mode", "Scan Mode", "Head", "Head + Body", "Full")


local adaptive_weapons = {
    -- see line 219
    ["rbot_autosniper_mindamage"] = { 11, 38 },
    ["rbot_sniper_mindamage"] = { 9 },
    ["rbot_scout_mindamage"] = { 40 },
    ["rbot_revolver_mindamage"] = { 64 },
    ["rbot_pistol_mindamage"] = { 1, 2, 3, 4, 30, 32, 36, 61, 63 },
    ["rbot_rifle_mindamage"] = { 7, 8, 10, 13, 16, 39, 60 },
    ["false"] = {},
}

local function table_contains(table, item) -- see line 219
    for i = 1, #table do
        if table[i] == item then
            return true
        end
    end
    return false
end

local function find_key(value) -- see line 219
    for k, v in pairs(adaptive_weapons) do
        if table_contains(v, value) then
            return k
        end
    end
end

local function get_enemy(e) -- get and return enemy
    enemy = e;
    return enemy
end

local function entities_check() -- getting local player informazion and if your crouched
    local LocalPlayer = entities.GetLocalPlayer();
    if enemy ~= nil then
        Alive = enemy:IsAlive()
    end
    if LocalPlayer ~= nil then
        x1, y1, z1 = LocalPlayer:GetAbsOrigin()
        if (math.floor((entities.GetLocalPlayer():GetPropInt("m_fFlags") % 4) / 2) == 1) then
            z = 46
        else
            z = 64 -- adjust your z Value so it traces from the head an not feet
        end
        clientx, clienty, clientz = client.WorldToScreen(x1, y1, z1 + z)
        return LocalPlayer
    end
end

local function body_vis()
    local body = false
    if entities_check() ~= nil and enemy ~= nil then

        local t3 = 0
        local t4 = 0
        local stomach = 0
        for i = 2, 3 do

            if i == 3 then
                stomach = -5
            end

            local x2, y2, z2 = enemy:GetHitboxPosition(i)
            if x2 ~= nil then

                for x = -6, 6, 6 do
                    local c = engine.TraceLine(x1, y1, z1 + z, x2, y2 + x, z2 + stomach, 1);
                    local c1 = engine.TraceLine(x1, y1, z1 + z, x2 - x, y2, z2 + stomach, 1);
                    local clientx2, clienty2, clientz2 = client.WorldToScreen(x2, y2 + x, z2 + stomach)
                    local clientx3, clienty3, clientz3 = client.WorldToScreen(x2 - x, y2, z2 + stomach)
                    t3 = c + i + t3 + c1
                    t4 = t4 + i + 2
                    --[[draw.Color(255, 255, 255, 255)
                    draw.marker)]]
                  --[[ if (clientx2 and clienty2) ~= nil then
                        draw.Text(clientx2, clienty2, "+")
                        draw.Text(clientx3, clienty3, "+")
                    end]]
                end
            end
        end

        if t3 < t4 then
            body = true
        else
            body = false
        end
    end
    return body
end

local function head_vis()
    local head = false
    if entities_check() ~= nil and enemy ~= nil then
        local t3 = 0
        local t4 = 0
        for i = -2, 2, 2 do

            local x2, y2, z2 = enemy:GetHitboxPosition(0)

            if x2 ~= nil then
                local c = engine.TraceLine(x1, y1, z1 + z, x2, y2 + i, z2 + 4, 1);
                local c1 = engine.TraceLine(x1, y1, z1 + z, x2 - i * 1.5, y2, z2 + 4, 1);
                local clientx2, clienty2, clientz2 = client.WorldToScreen(x2, y2 + i, z2 + 4)
                local clientx3, clienty3, clientz3 = client.WorldToScreen(x2 - i * 1.5, y2, z2 + 4)
                t3 = c + i + t3 + c1
                t4 = t4 + i + 2
                --[[draw.Color(255, 255, 255, 255)
                draw.marker)]]
             --[[ if (clientx2 and clienty2) ~= nil then
                    draw.Text(clientx2, clienty2, "+")
                    draw.Text(clientx3, clienty3, "+")
                end]]
            end
        end

        if t3 < t4 then
            head = true
        else
            head = false
        end
    end
    return head
end

local function feet_vis()
    local feet = false
    if entities_check() ~= nil and enemy ~= nil then

        local t3 = 0
        local t4 = 0
        for i = 6, 7 do
            local x2, y2, z2 = enemy:GetHitboxPosition(i)
            if x2 ~= nil then
                for x = -3, 3, 3 do
                    local c = engine.TraceLine(x1, y1, z1 + z, x2, y2, z2, 1);
                    local clientx2, clienty2, clientz2 = client.WorldToScreen(x2 + x, y2, z2)
                    t3 = c + i + t3
                    t4 = t4 + i + 1
                   --[[ if (clientx2 and clienty2) ~= nil then
                        draw.Color(255, 255, 255, 255)
                        draw.Text(clientx2 - 7, clienty2 - 15, "+")
                    end ]]
                end
            end
        end
        if t3 < t4 then
            feet = true
        else
            feet = false
        end
    end
    if feet then
    end
    return feet
end

local function enemy_vis() --checks for which mode is selected returns true depending on mode if enemy is visible

    local vis = falsey
    if mode == 0 then
        if not head_vis() then
            vis = false
        else
            vis = true
        end
    end

    if mode == 1 then
        if not head_vis() and not body_vis() then
            vis = false
        else
            vis = true
        end
    end


    if mode == 2 then
        if not feet_vis() and not head_vis() and not body_vis() then
            vis = false
        else
            vis = true
        end
    end

    return vis
end

local function set_damage()

    if entities_check() ~= nil and enemy ~= nil then
        local weapon = entities_check():GetWeaponID()
        local slider = find_key(weapon) --finding mindamage var

        if slider ~= nil then
            local slider_invis = (slider .. "_1") -- getting the var name of the check boxes/sliders
            local slider_vis = (slider .. "_2")
            local mode_box = (slider .. "_mode")
            local active = gui.GetValue((slider .. "_active"))
            if active then

                if slider ~= false then -- makes sure only support weapon is selected
                    mode = gui.GetValue(mode_box) -- which mode is selected

                    if enemy_vis() then
                        local damage = gui.GetValue(slider_vis) --setting damage
                        gui.SetValue(slider, damage)
                    else
                        local damage = gui.GetValue(slider_invis)
                        gui.SetValue(slider, damage)
                    end
                end
            end
        end
    end
end





callbacks.Register("AimbotTarget", "get_enemy", get_enemy);
callbacks.Register("Draw", "set_damage", set_damage);
callbacks.Register("Draw", "enemy_vis", enemy_vis);           local damage = gui.GetValue(slider_invis)
                       gui.SetValue(slider, damage)
                   end
               end
           end
       end
   end
end





callbacks.Register("AimbotTarget", "get_enemy", get_enemy);
callbacks.Register("Draw", "set_damage", set_damage);
callbacks.Register("Draw", "enemy_vis", enemy_vis);