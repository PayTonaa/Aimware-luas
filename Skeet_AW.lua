function gradient(x1, y1, x2, y2, left)
    local w = x2 - x1
    local h = y2 - y1

    for i = 0, w do
        local a = (i / w) * 200

        draw.Color(0, 0, 0, a)
        if left then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y1 + h)
        else
            draw.FilledRect(x1 + w - i, y1, x1 + w - i + 1, y1 + h)
        end
    end
end


local frame_rate = 0.0
local get_abs_fps = function()
    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
    return math.floor((1.0 / frame_rate) + 0.5)
end

function is_me(player)
    return (player:GetIndex() == client.GetLocalPlayerIndex())
end

function is_enemy(player)
    return (entities.GetLocalPlayer():GetTeamNumber() ~= player:GetTeamNumber())
end

function get_player_boundaries(player)
    local min_x, min_y, min_z = player:GetMins()
    local max_x, max_y, max_z = player:GetMaxs()

    return {min_x, min_y, min_z}, {max_x, max_y, max_z}
end

function get_player_position(player)
    local x, y, z = player:GetAbsOrigin()
    return {x, y, z}
end

function w2s(pos)
    local x, y = client.WorldToScreen(pos[1], pos[2], pos[3])
    if x == nil or y == nil then
        return nil
    end
    return {x, y}
end

function get_bounding_box(player)
    local mins, maxs = get_player_boundaries(player)
    local screen_pos, pos_3d, screen_top, top_3d

    pos_3d = get_player_position(player)
    pos_3d[3] = pos_3d[3] - 10

    top_3d = get_player_position(player)
    top_3d[3] = top_3d[3] + maxs[3] + 10

    screen_pos = w2s(pos_3d)
    screen_top = w2s(top_3d)

    if (screen_pos ~= nil and screen_top ~= nil) then
        local height = screen_pos[2] - screen_top[2]

        local width = height / 2.2

        

        local left = screen_pos[1] - width / 2
        local right = (screen_pos[1] - width / 2) + width
        local top = screen_top[2] + width / 5
        local bottom = screen_top[2] + height

        local box = {left = left, right = right, top = top, bottom = bottom}

        return box
    end

    return nil
end
--Author: SAAC(yougame.biz/ttom)
function draw_text(text, pos, centered, shadow, font, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.SetFont(font)
    local _x, _y = pos[1], pos[2]
    if (centered) then
        local w, h = draw.GetTextSize(text)
        _x = _x - w / 2
    end
    if (shadow) then
        draw.TextShadow(_x, _y, text)
    else
        draw.Text(_x, _y, text)
    end
end

function rect_outline(pos1, pos2, color, outline_color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.OutlinedRect(pos1[1], pos1[2], pos2[1], pos2[2])

    draw.Color(outline_color[1], outline_color[2], outline_color[3], outline_color[4])
    draw.OutlinedRect(pos1[1] - 1, pos1[2] - 1, pos2[1] + 1, pos2[2] + 1)
    draw.OutlinedRect(pos1[1] + 1, pos1[2] + 1, pos2[1] - 1, pos2[2] - 1)
end

function rect_fill(pos1, pos2, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.FilledRect(pos1[1], pos1[2], pos2[1], pos2[2])
end

function get_text_size(text, font)
    draw.SetFont(font)
    local w, h = draw.GetTextSize(text)
    return {w, h}
end

function get_screen_size()
    local w, h = draw.GetScreenSize()
    return {w, h}
end
--Author: SAAC(yougame.biz/ttom)
function draw_line(pos1, pos2, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.Line(pos1[1], pos1[2], pos2[1], pos2[2])
end

local abs_frame_time = globals.AbsoluteFrameTime;     local frame_rate = 0.0; local get_abs_fps = function()  frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * abs_frame_time(); return math.floor((1.0 / frame_rate) + 0.5);  end
frequency = 0.1 -- range: [0, oo) | lower is slower
intensity = 180 -- range: [0, 255] | lower is darker
saturation = 1 -- range: [0.00, 1.00] | lower is less saturated
 
function hsvToR(h, s, v)
 local r, g, b
 
 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);
 
 i = i % 6
 
 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end
 
 return r * intensity
end
 
function hsvToG(h, s, v)
 local r, g, b
 
 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);
 
 i = i % 6
 
 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end
 
 return g * intensity
end
 
function hsvToB(h, s, v)
 local r, g, b
 
 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);
 
 i = i % 6
 
 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end
 
 return b * intensity
end
--Author: SAAC(yougame.biz/ttom)
function drawGradient(x,y,w,h,dir,colors)
    local size,clength = 0, 0;
    local red, green, blue,alpha = 0,0,0,0;
    local mr, mg, mb, ma= 0,0,0,0;
   
    for i = 1, #colors, 1 do
        size = size + 1;
    end
   
    if(dir == "up" or dir == "down") then
        clength = h / (size-1);
    else
        clength = w / (size-1);
    end
   
    for i,color in ipairs(colors) do
        local x1,y1 = x, y;
        local x2,y2 = x1+w, y1+h;
        if(colors[i+1] ~= nil) then
            red = color[1];
            mr = (color[1] - colors[i+1][1]) / clength;
 
            green = color[2];
            mg = (color[2] - colors[i+1][2]) / clength;
           
            blue = color[3];
            mb = (color[3] - colors[i+1][3]) / clength;
 
            alpha = color[4];
            ma = (color[4] - colors[i+1][4]) / clength;
           
            for j=0, clength, 1 do
                red = red - mr;
                green = green - mg;
                blue = blue - mb;
                alpha = alpha - ma;
                draw.Color(red,green,blue,alpha);
                if(dir == "right") then
                    draw.FilledRect(x1+j,y1,j+x1+1,y2+1);
                elseif(dir == "left") then
                    draw.FilledRect(x2-j,y1,x2-j+1,y2+1);    
                elseif(dir == "up") then
                    draw.FilledRect(x2+1,y2-j+1,x1,y2-j);                    
                else
                    draw.FilledRect(x1,y1+j,x2+1,y1+j+1);                                
                end
            end
           
            if(dir == "right") then
                x = x + clength;    
            elseif(dir == "left") then
                x = x - clength;    
            elseif(dir == "up") then
                y = y - clength;
            else
                y = y + clength;
            end
        end
    end
end

local function drawCircle(Position, Radius)

    for degrees = 1, 360, 1 do
        local thisPoint = nil;
        local lastPoint = nil;
                
        if Position[3] == nil then
            thisPoint = {Position[1] + math.sin(math.rad(degrees)) * Radius, Position[2] + math.cos(math.rad(degrees)) * Radius};	
            lastPoint = {Position[1] + math.sin(math.rad(degrees - 1)) * Radius, Position[2] + math.cos(math.rad(degrees - 1)) * Radius};
        else
            thisPoint = {client.WorldToScreen(Position[1] + math.sin(math.rad(degrees)) * Radius, Position[2] + math.cos(math.rad(degrees)) * Radius, Position[3])};
            lastPoint = {client.WorldToScreen(Position[1] + math.sin(math.rad(degrees - 1)) * Radius, Position[2] + math.cos(math.rad(degrees - 1)) * Radius, Position[3])};
        end
                     
        if thisPoint[1] ~= nil and thisPoint[2] ~= nil and lastPoint[1] ~= nil and lastPoint[2] ~= nil then		
            draw.Line(thisPoint[1], thisPoint[2], lastPoint[1], lastPoint[2]);		
        end
        
    end

end

local function ActiveWeaponInfo(Entity)
    
    local ent_weapon = Entity:GetPropEntity("m_hActiveWeapon")

    if ent_weapon == nil then
        return nil
    end

    local str_weapon = ent_weapon:GetName()

    if string.find(str_weapon, "revolver") then
        return "revolver", 2 
    end
    if string.find(str_weapon, "ssg08") then
        return "scout", 1 
    end
    if string.find(str_weapon, "awp") then
        return "sniper", 1 
    end
    if string.find(str_weapon, "scar20") or string.find(str_weapon, "g3sg1") then
        return "autosniper", 1 
    end

    local type_weapon = Entity:GetWeaponType()

    if type_weapon == 0 then
        return nil
    end

    if type_weapon == 1 then
        return "pistol", 2
    end
    if type_weapon == 2 then
        return "smg", 1
    end
    if type_weapon == 3 then
        return "rifle", 1
    end
    if type_weapon == 4 then
        return "shotgun", 1
    end

    return nil
end

-- Global Variables ---
local msc_peekReturning = false
local msc_quickPeeking = false
local msc_peekCompleted = false

local start_ammo = 0
local cur_ammo = 0

local pos_peekOrigin = {}
local wpninfo_peek = nil
local startwpn_peek = nil
local curwpn_peek = nil

local cacheArray = 
{
    {"autostop", 0},
    {"autostop_key", 0}
}

--Author: SAAC(yougame.biz/ttom)
function HitGroup(INT_HITGROUP)
    if INT_HITGROUP == nil then
        return;
    elseif INT_HITGROUP == 0 then
        return "body";
    elseif INT_HITGROUP == 1 then
        return "head";
    elseif INT_HITGROUP == 2 then
        return "chest";
    elseif INT_HITGROUP == 3 then
        return "stomach";
    elseif INT_HITGROUP == 4 then
        return "left arm";
    elseif INT_HITGROUP == 5 then
        return "right arm";
    elseif INT_HITGROUP == 6 then
        return "left leg";
    elseif INT_HITGROUP == 7 then
        return "right leg";
    elseif INT_HITGROUP == 10 then
        return "body";
    end
end
local activeHitLogs = {};

function add(time, ...)
    table.insert(activeHitLogs, {
        ["text"] = { ... },
        ["time"] = time,
        ["delay"] = globals.RealTime() + time,
        ["color"] = {{150, 185, 1}, {16, 0, 0}},
        ["x_pad"] = -11,
        ["x_pad_b"] = -11,
    })
end

function getMultiColorTextSize(lines)
    local fw = 0
    local fh = 0;
    for i = 1, #lines do
        local w, h = draw.GetTextSize(lines[i][4])
        fw = fw + w
        fh = h;
    end
    return fw, fh
end

function drawMultiColorText(x, y, lines)
    local x_pad = 0
    for i = 1, #lines do
        local line = lines[i];
        local r, g, b, msg = line[1], line[2], line[3], line[4]
        draw.Color(r, g, b, 255);
        draw.Text(x + x_pad, y, msg);
        local w, _ = draw.GetTextSize(msg)
        x_pad = x_pad + w
    end
end
--Author: SAAC(yougame.biz/ttom)
function showLog(count, color, text, layer)
    local y = 15 + (35 * (count - 1));
    local w, h = getMultiColorTextSize(text)
    local mw = w < 150 and 150 or w
    if globals.RealTime() < layer.delay then
        if layer.x_pad < mw then layer.x_pad = layer.x_pad + (mw - layer.x_pad) * 0.05 end
        if layer.x_pad > mw then layer.x_pad = mw end
        if layer.x_pad > mw / 1.09 then
            if layer.x_pad_b < mw - 6 then
                layer.x_pad_b = layer.x_pad_b + ((mw - 6) - layer.x_pad_b) * 0.05
            end
        end
        if layer.x_pad_b > mw - 6 then
            layer.x_pad_b = mw - 6
        end
    else
        if layer.x_pad_b > -11 then
            layer.x_pad_b = layer.x_pad_b - (((mw - 5) - layer.x_pad_b) * 0.05) + 0.01
        end
        if layer.x_pad_b < (mw - 11) and layer.x_pad >= 0 then
            layer.x_pad = layer.x_pad - (((mw + 1) - layer.x_pad) * 0.05) + 0.01
        end
        if layer.x_pad < 0 then
            table.remove(activeHitLogs, count)
        end
    end
    local c1 = color[1]
    local c2 = color[2]
    local a = 255;
    draw.Color(c1[1], c1[2], c1[3], a);
    draw.FilledRect(layer.x_pad - layer.x_pad, y, layer.x_pad + 28, (h + y) + 20);
    draw.Color(c2[1], c2[2], c2[3], a);
    draw.FilledRect(layer.x_pad_b - layer.x_pad, y, layer.x_pad_b + 22, (h + y) + 20);
    drawMultiColorText(layer.x_pad_b - mw + 18, y + 3 + 6, text)
end

function hitlog_draw_callback()
	if skeet_event:GetValue() then
    for index, hitlog in pairs(activeHitLogs) do
        showLog(index, hitlog.color, hitlog.text, hitlog)
    end
	end
end

function hitlog_game_event_callback(Event)
	if skeet_event:GetValue() then
    local eventType = Event:GetName();

    local isHurt = eventType == 'player_hurt';
    local weaponFired = eventType == 'weapon_fire';
    if isHurt == false and weaponFired == false then
        return
    end
    local localPlayer = entities.GetLocalPlayer();
    local user = entities.GetByUserID(Event:GetInt('userid'));
    if (localPlayer == nil or user == nil) then
        return;
    end
    if isHurt then
        local attacker = entities.GetByUserID(Event:GetInt('attacker'));
        local remainingHealth = Event:GetInt('health');
        local damageDone = Event:GetInt('dmg_health');
        if (attacker == nil) then
            return;
        end
        if (localPlayer:GetIndex() == attacker:GetIndex()) then
            add(5,
                { 255, 255, 255, "Hit " },
                { 150, 185, 1, string.sub(user:GetName(), 0, 28) },
                { 255, 255, 255, " in the " },
                { 150, 185, 1, HitGroup(Event:GetInt('hitgroup')) },
                { 255, 255, 255, " for " },
                { 150, 185, 1, damageDone },
                { 255, 255, 255, " damage (" },
                { 150, 185, 1, remainingHealth .. " health remaining" },
                { 255, 255, 255, ")" })
        end
    elseif weaponFired then
        if (localPlayer:GetIndex() == user:GetIndex() and target ~= nil) then
            -- todo implement miss shots
        end
    end
	end
end
--Author: SAAC(yougame.biz/ttom)
local hitmarker_alpha = 0

local ico_font = draw.CreateFont("undefeated", 13, 400)
local watermark_font = draw.CreateFont("Tahoma", 12, 700)
local lby_font = draw.CreateFont("Verdana", 32, 750)
local flags_font = draw.CreateFont("Smallest Pixel-7", 11, 400)
local hp_font = draw.CreateFont("Smallest Pixel-7", 10, 400)
local testweap_font = draw.CreateFont("Smallest Pixel-7", 11, 400)
local name_font = draw.CreateFont("Verdana", 12, 400)
local font_main = draw.CreateFont("Tahoma Bold", 20, 20)
local font_main_small = draw.CreateFont("Tahoma Bold", 13, 13)

local info_box_title = draw.CreateFont("Verdana", 18, 700)
local info_box_log = draw.CreateFont("Verdana", 13, 700)

client.Command("cl_hud_background_alpha 0", true)

local angles = {}

local logs = {}
local thirdperson_distance = 0
local thirdperson_toggle = false

function add_log(text)
    table.insert(logs, {text = text, expiration = 5, fadein = 0})
end



local kills  = {}
local deaths = {}
local KillsList = {}
local LocalNameListfo = "Unknown"

--WINDOW--
--local SkeetWin = gui.Window("skeet_visuals", "Skeet Visuals", 200, 200, 276, 330);
--local linegroup = gui.Groupbox(SkeetWin, "Visuals settings", 13, 13, 250, 270);
--STUFF START--
local M_Ref1 = gui.Reference("MISC", "GENERAL", "Main")
local skeet_group = gui.Groupbox(M_Ref1, "Skeet lua [Visuals]", 0, 200, 170, 290)
local skeet_enable = gui.Checkbox(skeet_group, "skeet_enable", "Enable", 1);
local skeet_box = gui.Checkbox(skeet_group, "skeet_box", "Box", 1);
local skeet_name = gui.Checkbox(skeet_group, "skeet_name", "Name", 1);
local skeet_flags = gui.Checkbox(skeet_group, "skeet_flags", "Flags", 1);
local skeet_zoom = gui.Checkbox(skeet_group, "skeet_zoom", "Zoom flag", 1);
local skeet_reload = gui.Checkbox(skeet_group, "skeet_reload", "Dont work", 1);
local skeet_health = gui.Checkbox(skeet_group, "skeet_health", "Health", 1);
local skeet_weap = gui.Checkbox(skeet_group, "skeet_weap", "Weapon and Ammo", 1);

local M_Ref1 = gui.Reference("MISC", "GENERAL", "Bypass")
local skeet_misc = gui.Groupbox(M_Ref1, "Skeet lua [Misc]", 0, 135, 170, 290)
local skeet_swfix = gui.Checkbox(skeet_misc, "skeet_swfix", "Slowwalk fix", 1);
local skeet_bar = gui.Checkbox(skeet_misc, "skeet_bar", "Info Bar", 1);
local skeet_hitmarker = gui.Checkbox(skeet_misc, "skeet_hitmarker", "Hitmarker", 1);
local skeet_kills = gui.Checkbox(skeet_misc, "skeet_kills", "(Dont work now)", 1);
local skeet_event = gui.Checkbox(skeet_misc, "skeet_event", "Event Logger", 1);
local skeet_skybox = gui.Checkbox(skeet_misc, "skeet_skybox", "Skybox", 1);
local skeet_mark = gui.Checkbox(skeet_misc, "skeet_mark", "Watermark", 1);

--STUFF END--

--QUICK PEEK--
local ref_vis_msc_assistance = gui.Reference("VISUALS", "MISC", "Assistance")

local ref_rbot_shared = gui.Reference("RAGE", "WEAPON", "SHARED", "Accuracy")
local ref_rbot_pistol = gui.Reference("RAGE", "WEAPON", "PISTOL", "Accuracy")
local ref_rbot_revolver = gui.Reference("RAGE", "WEAPON", "REVOLVER", "Accuracy")
local ref_rbot_smg = gui.Reference("RAGE", "WEAPON", "SMG", "Accuracy")
local ref_rbot_rifle = gui.Reference("RAGE", "WEAPON", "RIFLE", "Accuracy")
local ref_rbot_shotgun = gui.Reference("RAGE", "WEAPON", "SHOTGUN", "Accuracy")
local ref_rbot_scout = gui.Reference("RAGE", "WEAPON", "SCOUT", "Accuracy")
local ref_rbot_autosniper = gui.Reference("RAGE", "WEAPON", "A. SNIPER", "Accuracy")
local ref_rbot_sniper = gui.Reference("RAGE", "WEAPON", "SNIPER", "Accuracy")
local ref_rbot_lmg = gui.Reference("RAGE", "WEAPON", "LMG", "Accuracy")


local cob_quickpeek_indicator = gui.Combobox(ref_vis_msc_assistance, "msc_quickpeek_indicator", "Quick Peek Indication", "Off", "On World", "On HUD", "On Both")
local cob_quickpeek_indicator_detail = gui.Combobox(ref_vis_msc_assistance, "msc_quickpeek_indicator", "Quick Peek Indication Style", "Fancy", "Simplified")

local key_shared_quickpeek = gui.Keybox(ref_rbot_shared, "rbot_shared_quickpeek_key", "Quick Peek Key", 0)
local sl_shared_quickpeek_returnaftershots = gui.Slider(ref_rbot_shared, "rbot_shared_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 15 )
local chb_shared_quickpeek_knife = gui.Checkbox(ref_rbot_shared, "rbot_shared_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_pistol_quickpeek = gui.Keybox(ref_rbot_pistol, "rbot_pistol_quickpeek_key", "Quick Peek Key", 0)
local sl_pistol_quickpeek_returnaftershots = gui.Slider(ref_rbot_pistol, "rbot_pistol_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 15 )
local chb_pistol_quickpeek_knife = gui.Checkbox(ref_rbot_pistol, "rbot_pistol_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_revolver_quickpeek = gui.Keybox(ref_rbot_revolver, "rbot_revolver_quickpeek_key", "Quick Peek Key", 0)
local sl_revolver_quickpeek_returnaftershots = gui.Slider(ref_rbot_revolver, "rbot_revolver_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 8 )
local chb_revolver_quickpeek_knife = gui.Checkbox(ref_rbot_revolver, "rbot_revolver_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_smg_quickpeek = gui.Keybox(ref_rbot_smg, "rbot_smg_quickpeek_key", "Quick Peek Key", 0)
local sl_smg_quickpeek_returnaftershots = gui.Slider(ref_rbot_smg, "rbot_smg_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 15 )
local chb_smg_quickpeek_knife = gui.Checkbox(ref_rbot_smg, "rbot_smg_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_rifle_quickpeek = gui.Keybox(ref_rbot_rifle, "rbot_rifle_quickpeek_key", "Quick Peek Key", 0)
local sl_rifle_quickpeek_returnaftershots = gui.Slider(ref_rbot_rifle, "rbot_rifle_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 15 )
local chb_rifle_quickpeek_knife = gui.Checkbox(ref_rbot_rifle, "rbot_rifle_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_shotgun_quickpeek = gui.Keybox(ref_rbot_shotgun, "rbot_shotgun_quickpeek_key", "Quick Peek Key", 0)
local sl_shotgun_quickpeek_returnaftershots = gui.Slider(ref_rbot_shotgun, "rbot_shotgun_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 8 )
local chb_shotgun_quickpeek_knife = gui.Checkbox(ref_rbot_shotgun, "rbot_shotgun_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_scout_quickpeek = gui.Keybox(ref_rbot_scout, "rbot_scout_quickpeek_key", "Quick Peek Key", 0)
local sl_scout_quickpeek_returnaftershots = gui.Slider(ref_rbot_scout, "rbot_scout_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 10 )
local chb_scout_quickpeek_knife = gui.Checkbox(ref_rbot_scout, "rbot_scout_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_autosniper_quickpeek = gui.Keybox(ref_rbot_autosniper, "rbot_autosniper_quickpeek_key", "Quick Peek Key", 0)
local sl_autosniper_quickpeek_returnaftershots = gui.Slider(ref_rbot_autosniper, "rbot_autosniper_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 15 )
local chb_autosniper_quickpeek_knife = gui.Checkbox(ref_rbot_autosniper, "rbot_autosniper_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_sniper_quickpeek = gui.Keybox(ref_rbot_sniper, "rbot_sniper_quickpeek_key", "Quick Peek Key", 0)
local sl_sniper_quickpeek_returnaftershots = gui.Slider(ref_rbot_sniper, "rbot_sniper_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 10 )
local chb_sniper_quickpeek_knife = gui.Checkbox(ref_rbot_sniper, "rbot_sniper_quickpeek_knife", "Quick Peek Switch to Knife", 1)

local key_lmg_quickpeek = gui.Keybox(ref_rbot_lmg, "rbot_lmg_quickpeek_key", "Quick Peek Key", 0)
local sl_lmg_quickpeek_returnaftershots = gui.Slider(ref_rbot_lmg, "rbot_lmg_quickpeek_returnaftershots", "Return After X Shots", 1, 1, 10 )
local chb_lmg_quickpeek_knife = gui.Checkbox(ref_rbot_lmg, "rbot_lmg_quickpeek_knife", "Quick Peek Switch to Knife", 1)
-- -- -- --

local menuPressed = 1;

--Author: SAAC(yougame.biz/ttom)
local function ResetPeek()
    if msc_quickPeeking or msc_peekReturning or msc_peekCompleted then
        msc_quickPeeking = false
        msc_peekReturning = false
        msc_peekCompleted = false
        cur_ammo = 0
        start_ammo = 0

        for i = 1, #cacheArray do
            gui.SetValue("rbot_" .. wpninfo_peek[1] .. "_" .. cacheArray[i][1], cacheArray[i][2])
        end

        wpninfo_peek = nil
        startwpn_peek = nil
    end
end
function drawing()

local local_player = entities.GetLocalPlayer()
if skeet_enable:GetValue() then
local x, y = draw.GetScreenSize()
if skeet_bar:GetValue() then
if (local_player ~= nil) then

local lcname = local_player:GetName()
    local centerX = x / 2

    --the bar idk lol

    --left
    gradient(centerX - 200, y - 20, centerX - 51, y, 0, true)
    gradient(centerX - 200, y - 20, centerX - 51, y - 19, true)
    
    --middle
    draw.Color(0, 0, 0, 200)
    draw.FilledRect(centerX - 50, y - 20, centerX + 50, y)

    draw.Color(0, 0, 0, 255)
    draw.FilledRect(centerX - 50, y - 20, centerX + 50, y - 19)

    --right
    gradient(centerX + 50, y - 20, centerX + 200, y, false)
    gradient(centerX + 50, y - 20, centerX + 200, y - 19, false)

    --fps
   

    draw.Color(200, 255, 0, 255)
    draw.Text(centerX - 5, y - 15, lcname)

    --kills
    draw.Color(255, 255, 255, 255)
    draw.Text(centerX - 70, y - 15, #kills)

    draw.Color(255, 100, 0, 255)
    draw.Text(centerX - 55, y - 15, "Kills")

    --deaths
    draw.Color(255, 255, 255, 255)
    draw.Text(centerX + 50, y - 15, #deaths)

    draw.Color(255, 50, 50, 255)
    draw.Text(centerX + 65, y - 15, "Deaths")
end
end

	if skeet_mark:GetValue() then
	if (local_player ~= nil) then
local ff = draw.CreateFont('Tahoma', 60)
local classicf = draw.CreateFont('Tahoma', 12)
local name = client.GetPlayerNameByIndex(client.GetLocalPlayerIndex())
   local R = hsvToR((globals.RealTime() * frequency) % 1, saturation, 1)
    local G = hsvToG((globals.RealTime() * frequency) % 1, saturation, 1)
    local B = hsvToB((globals.RealTime() * frequency) % 1, saturation, 1)
	 
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 20, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 15, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 16, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 21, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 19, 5, x - 3, 29)
          
     
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 90, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 85, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 86, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 91, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 89, 5, x - 3, 29)
          
       
       
       
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 130, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 125, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 126, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 131, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 129, 5, x - 3, 29)
          
          
        
       
        
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 110, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 95, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 106, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 111, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 109, 5, x - 3, 29)
           
       
        
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 130, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 125, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 126, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 131, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 129, 5, x - 3, 29)
          
      
       
        
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(x - 180, 5, x - 3, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(x - 175, 10, x - 8, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 176, 10, x - 8, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(x - 181, 4, x - 2, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(x - 179, 5, x - 3, 29)
           
       
        -- fps
           
           draw.SetFont(classicf)
           draw.Color(math.floor(R), math.floor(G), math.floor(B), 255)
           draw.Text(x - 107, 12, "fps: ".. get_abs_fps())
           draw.Color(235, 235, 235, 255)
           draw.Text(x - 64, 12, "|")
           
        --ping
         
           draw.SetFont(classicf)
           local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
           draw.Color(math.floor(R), math.floor(G), math.floor(B), 255)
           draw.Text(x - 53, 12, "Ping: ".. m_iPing)

          
        
        -- text        
           
           draw.SetFont(classicf)
           draw.Color(214, 214, 214, 230)
           draw.Text(x - 170, 12, "game")
           draw.Color(159, 202, 43, 230)
           draw.Text(x - 145, 12, "sense")   
		   draw.Color(235, 235, 235, 255)
           draw.Text(x - 115, 12, "|")   		   
           
        end
 end
	
	if skeet_kills:GetValue() then
		if (local_player ~= nil) then
			local ayy = 10
			local players = entities.FindByClass("CCSPlayer")
			for i = 1, #players do
				local player = players[i]
				if (player ~= local_player) then
					local obs = player:GetPropInt("m_iObserverMode")
					if (obs) then
						
						local playername = player:GetName()
						--draw.Text(x - 100, ayy, playername)
						ayy = ayy + 10
						
					end
				end
			end	
		end
   
	end
	
	
	
    local screen_size = get_screen_size()
	
    if (local_player ~= nil) then
        -- skeetlike event logger
		if skeet_event:GetValue() then
		if (local_player ~= nil) then
    for index, hitlog in pairs(activeHitLogs) do
        showLog(index, hitlog.color, hitlog.text, hitlog)
    end
	end
	end
        -- esp
        local players = entities.FindByClass("CCSPlayer")
        for i = 1, #players do
            local player = players[i]
            if (is_enemy(player) and player:IsAlive() or is_me(player) and player:IsAlive() and thirdperson_distance > 5) then
                -- get bounding box
				
                local bbox = get_bounding_box(player)
                if (bbox ~= nil) then
                    -- box
				if skeet_box:GetValue() then
                    rect_outline({bbox.left, bbox.top}, {bbox.right, bbox.bottom}, {255, 255, 255, 200}, {0, 0, 0, 200})
				end
                    -- health
				if skeet_health:GetValue() then
                    rect_fill({bbox.left - 5, bbox.top}, {bbox.left - 1, bbox.bottom}, {0, 0, 0, 200})
                    local hp = math.min(player:GetHealth(), 100)
                    local height = bbox.bottom - bbox.top - 1
                    local healthbar_height = (hp / 100) * height
                    rect_fill(
                        {bbox.left - 4, bbox.bottom - healthbar_height},
                        {bbox.left - 2, bbox.bottom - 1},
                        {10, 190, 0, 200}
                    )
					draw_text(
                        hp,
                        {bbox.left - 4, bbox.bottom - healthbar_height - 6},
                        true,
                        true,
                        hp_font,
                        {255, 255, 255, 255}
                    )
				end
                    -- name
					if skeet_name:GetValue() then
                    local name = player:GetName()
                    draw_text(
                        name,
                        {bbox.left + (bbox.right - bbox.left) / 2, bbox.top - 13},
                        true,
                        true,
                        name_font,
                        {255, 255, 255, 200}
                    )
					end
                    -- flags hevlar and kelmet
					if skeet_flags:GetValue() then
                    local flags = ""

                    if (player:GetPropInt("m_bHasHelmet") == 1) then
                        flags = flags .. "H"
                    end

                    if (player:GetPropInt("m_ArmorValue") ~= 0) then
                        flags = flags .. "K"
                    end
					
					local isScoped = player:GetPropInt( "m_bIsScoped" );
					if skeet_zoom:GetValue() then
					if isScoped == 1 or isScoped == 257 then
						draw_text("ZOOM", {bbox.right + 4, bbox.top + 4}, false, true, flags_font, {150, 150, 220, 200})
					end
					end
					
					
					
					

                    if (flags ~= "") then
                        draw_text(flags, {bbox.right + 4, bbox.top - 2}, false, true, flags_font, {255, 255, 255, 200})
                    end
					end
                    -- weapon
					if skeet_weap:GetValue() then
                    local weapon = player:GetPropEntity("m_hActiveWeapon")
                    if (weapon ~= nil) then
                        local weapon_name = weapon:GetClass()
                        weapon_name = weapon_name:gsub("CWeapon", "")
                        weapon_name = weapon_name:gsub("CKnife", "knife")
                       weapon_name = weapon_name:lower()

                        if (weapon_name:sub(1, 1) == "c") then
                            weapon_name = weapon_name:sub(2)
                        end
						
						
						

                        local ammo = weapon:GetPropInt("m_iClip1")
                        local max_ammo = weapon:GetPropInt("m_iPrimaryReserveAmmoCount")
						
						if (max_ammo > 0) then
                           weapon_name = weapon_name .. " " .. "[" .. ammo .. "/" .. max_ammo .. "]"
                        end

                        draw_text(
                            weapon_name,
                            {bbox.left + (bbox.right - bbox.left) / 2, bbox.bottom + 1},
                            true,
                            true,
                            flags_font,
                            {255, 255, 255, 200}
                        )
                    end
					end
                end
            end
        end
    end
	end
	
	local LocalPlayer = entities.GetLocalPlayer()
    
    -- Local player null and alive check
    if LocalPlayer == nil or not LocalPlayer:IsAlive() then
        ResetPeek()
        return
    end

    local pos_LocalPlayer = {LocalPlayer:GetAbsOrigin()}

    -- If weapon isn't a knife
    if LocalPlayer:GetWeaponType() ~= 0 then
        wpninfo_peek = {ActiveWeaponInfo(LocalPlayer)}
        curwpn_peek = LocalPlayer:GetWeaponID()
    end

    -- Check if array is null
    if wpninfo_peek == nil then
        return
    end

    -- Check if weapon is null
    if wpninfo_peek[1] == nil then
        return
    end

    -- If shared weapon configuration
    if gui.GetValue("rbot_sharedweaponcfg") then
        wpninfo_peek[1] = "shared"
    end

    -- Round Sliders
    if gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_returnaftershots") % 1 > 0 then
        gui.SetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_returnaftershots", math.floor(gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_returnaftershots") + 0.5))
    end

    -- Check if key is set
    if gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_key") == nil or gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_key") <= 0 then
        return
    end

    if input.IsButtonDown(gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_key")) and (startwpn_peek == curwpn_peek or startwpn_peek == nil) and start_ammo >= cur_ammo then
        if LocalPlayer:GetWeaponType() ~= 0 then
            cur_ammo = LocalPlayer:GetPropEntity("m_hActiveWeapon"):GetPropInt("m_iClip1")
        end

        if not msc_quickPeeking and LocalPlayer:GetWeaponType() ~= 0 then      
            
            msc_quickPeeking = true
            startwpn_peek = curwpn_peek  
            start_ammo = cur_ammo
            pos_peekOrigin = pos_LocalPlayer

            for i = 1, #cacheArray do
                cacheArray[i][2] = gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_" .. cacheArray[i][1])
            end

            gui.SetValue("rbot_" .. wpninfo_peek[1] .. "_" .. cacheArray[1][1], 1)
            gui.SetValue("rbot_" .. wpninfo_peek[1] .. "_" .. cacheArray[2][1], 0)
        elseif not msc_quickPeeking and LocalPlayer:GetWeaponType() == 0 then
            return
        end

        if msc_peekCompleted then
            msc_peekCompleted = false
            start_ammo = cur_ammo
            
            if gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_knife") then
                client.Command("slot" .. wpninfo_peek[2], true)
            end
        end

        if cur_ammo + gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_returnaftershots") <= start_ammo and not msc_peekReturning then
            msc_peekReturning = true

            if gui.GetValue("rbot_" .. wpninfo_peek[1] .. "_quickpeek_knife") then
                client.Command("slot3", true)
            end
        end
        
        local world_forward = {vector.Subtract( pos_peekOrigin,  pos_LocalPlayer )}
        local world_angles = {vector.Angles(world_forward)}
        
        local world_linestart = {pos_peekOrigin[1] - 9 * math.cos(math.rad(world_angles[2])), pos_peekOrigin[2] - 9 * math.sin(math.rad(world_angles[2])), pos_peekOrigin[3]}
        local world_lineend = {pos_LocalPlayer[1] + 5 * math.cos(math.rad(world_angles[2])), pos_LocalPlayer[2] + 5 * math.sin(math.rad(world_angles[2])), pos_LocalPlayer[3]}
        
        local wts_peekOrigin = {client.WorldToScreen(pos_peekOrigin[1], pos_peekOrigin[2], pos_peekOrigin[3])}
        local wts_peekOriginText = {client.WorldToScreen(pos_peekOrigin[1], pos_peekOrigin[2], pos_peekOrigin[3] + 20)}
        local wts_LocalPlayer = {client.WorldToScreen(pos_LocalPlayer[1], pos_LocalPlayer[2], pos_LocalPlayer[3])}

        local peek_distance = math.floor(vector.Distance(pos_peekOrigin, pos_LocalPlayer) + 0.5)
        local str_Indicator = "Quick Peeking: " .. peek_distance .. " units"
        local size_strIndicator
        
        if msc_peekReturning then
            str_Indicator = "Quick Returning: " .. peek_distance .. " units"
        end

        if (cob_quickpeek_indicator:GetValue() == 1 or cob_quickpeek_indicator:GetValue() == 3) and (wts_peekOrigin[1] ~= nil and wts_peekOriginText[1] ~= nil and wts_LocalPlayer[1] ~= nil) then
            draw.SetFont(font_main_small)
            size_strIndicator = {draw.GetTextSize(str_Indicator)}
            draw.Color(gui.GetValue("clr_gui_window_header_tab2"))
            if cob_quickpeek_indicator_detail:GetValue() == 0 then
                drawCircle(pos_peekOrigin, 10)
                drawCircle(pos_peekOrigin, 8)
                drawCircle(pos_LocalPlayer, 6)
                drawCircle(pos_LocalPlayer, 4)
                draw.Color(255, 255, 255, 255)
                drawCircle(pos_peekOrigin, 9)
                drawCircle(pos_LocalPlayer, 5)
            end
            draw.Color(255, 255, 255, 255)
            draw.TextShadow(wts_peekOriginText[1] - size_strIndicator[1] / 2, wts_peekOriginText[2], str_Indicator)

            local wts_linestart = {client.WorldToScreen(world_linestart[1], world_linestart[2], world_linestart[3])}
            local wts_lineend = {client.WorldToScreen(world_lineend[1], world_lineend[2], world_lineend[3])}

            if msc_peekReturning then
                draw.Color(gui.GetValue("clr_gui_window_header_tab2"))
            else
                draw.Color(255, 255, 255, 255)
            end

            if wts_linestart[1] ~= nil and wts_lineend[1] ~= nil and peek_distance > 15 then
                draw.Line(wts_linestart[1], wts_linestart[2], wts_lineend[1], wts_lineend[2])
            end

        end

        if cob_quickpeek_indicator:GetValue() >= 2 then
            local width_screen, height_screen = draw.GetScreenSize()
            draw.SetFont(font_main)
            size_strIndicator = {draw.GetTextSize(str_Indicator)}
            
            if cob_quickpeek_indicator_detail:GetValue() == 0 then
                draw.Color(0, 0, 0, 125)
                draw.FilledRect( width_screen / 2  - size_strIndicator[1] / 2, height_screen * 0.95 - size_strIndicator[2] / 2, width_screen / 2 + size_strIndicator[1] / 2, height_screen * 0.95 + size_strIndicator[2] / 2 ) 
                draw.Color(gui.GetValue("clr_gui_window_header_tab2"))
                draw.Line(width_screen / 2  - size_strIndicator[1] / 2, height_screen * 0.95 - size_strIndicator[2] / 2, width_screen / 2 + size_strIndicator[1] / 2, height_screen * 0.95 - size_strIndicator[2] / 2)
            end
            
            draw.Color(255, 255, 255, 255)
            draw.Text(width_screen / 2 - size_strIndicator[1] / 2, height_screen * 0.95 - size_strIndicator[2] / 2, str_Indicator)
        end
    
    else
        ResetPeek()
    end
end

local hits = {}
--Author: SAAC(yougame.biz/ttom)

function events(event)
    local EventListW = event:GetName()
    if EventListW == 'player_death' then
        local LocalForList = client.GetLocalPlayerIndex()
        local AttackerList = client.GetPlayerIndexByUserID(event:GetInt('attacker'))
        local VictimList = client.GetPlayerNameByUserID(event:GetInt('userid'))

        if LocalForList == AttackerList then
            LocalNameListfo = client.GetPlayerNameByIndex(AttackerList)
            table.insert(KillsList, 1, VictimList)
        end
    elseif EventListW == 'round_start' then
        KillsList = {}
    end
	
	
    local lcp = client.GetLocalPlayerIndex( );
	local atack = client.GetPlayerIndexByUserID( event:GetInt( 'attacker' ) );
	local vict = client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) );

	if (event:GetName( ) == "client_disconnect") or (event:GetName( ) == "begin_new_match") then
		kills = {}
		deaths = {}
	end

	if event:GetName( ) == "player_death" then
		if atack == lcp then
			kills[#kills + 1] = {};
		end
		
		if (vict == lcp) then
			deaths[#deaths + 1] = {};
		end

	end
	
    if (event:GetName() == "player_hurt") then
        local me = client.GetLocalPlayerIndex()
        local index_attacker = client.GetPlayerIndexByUserID(event:GetInt("attacker"))
        local index_player = client.GetPlayerIndexByUserID(event:GetInt("userid"))

        if (index_attacker == me) then
			if skeet_hitmarker:GetValue() then
            client.Command("play buttons\\arena_switch_press_02.wav", true); --replace sound here
            hitmarker_alpha = 255
			end

            if (hits[index_player] == nil) then
                hits[index_player] = 0
            end

            add_log(
                "hit " .. client.GetPlayerNameByIndex(index_player):lower() .. " for " .. event:GetInt("dmg_health")
            )
            hits[index_player] = hits[index_player] + 1
        end
    end
    if (event:GetName() == "player_death") then
        local me = client.GetLocalPlayerIndex()
        local index_attacker = client.GetPlayerIndexByUserID(event:GetInt("attacker"))
        local index_player = client.GetPlayerIndexByUserID(event:GetInt("userid"))

        if (index_attacker == me) then
            if (hits[index_player] == nil) then
                hits[index_player] = 0
            end

            add_log("killed " .. client.GetPlayerNameByIndex(index_player):lower() .. " by " .. hits[index_player] .. " hits")
            hits[index_player] = 0
            end
         end
	  if skeet_event:GetValue() then
    local eventType = event:GetName();

    local isHurt = eventType == 'player_hurt';
    local weaponFired = eventType == 'weapon_fire';
    if isHurt == false and weaponFired == false then
        return
    end
    local localPlayer = entities.GetLocalPlayer();
    local user = entities.GetByUserID(event:GetInt('userid'));
    if (localPlayer == nil or user == nil) then
        return;
    end
    if isHurt then
        local attacker = entities.GetByUserID(event:GetInt('attacker'));
        local remainingHealth = event:GetInt('health');
        local damageDone = event:GetInt('dmg_health');
        if (attacker == nil) then
            return;
        end
        if (localPlayer:GetIndex() == attacker:GetIndex()) then
            add(5,
                { 255, 255, 255, "Hit " },
                { 150, 185, 1, string.sub(user:GetName(), 0, 28) },
                { 255, 255, 255, " in the " },
                { 150, 185, 1, HitGroup(event:GetInt('hitgroup')) },
                { 255, 255, 255, " for " },
                { 150, 185, 1, damageDone },
                { 255, 255, 255, " damage (" },
                { 150, 185, 1, remainingHealth .. " health remaining" },
                { 255, 255, 255, ")" })
        end
    elseif weaponFired then
        if (localPlayer:GetIndex() == user:GetIndex() and target ~= nil) then
            -- todo implement miss shots
        end
    end
end
end
function create_move(cmd)
    local pitch, yaw, roll = cmd:GetViewAngles()
    angles = {pitch, yaw, roll}
end
local function CreateMoveCallback(UserCmd)

    if msc_peekReturning then
        local LocalPlayer = entities.GetLocalPlayer()    
        local ang_LocalPlayer = {UserCmd:GetViewAngles()}
        local world_forward = {vector.Subtract( pos_peekOrigin,  {LocalPlayer:GetAbsOrigin()} )}

        UserCmd:SetForwardMove( ( (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[2]) + (math.cos(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 200 )
        UserCmd:SetSideMove( ( (math.cos(math.rad(ang_LocalPlayer[2]) ) * -world_forward[2]) + (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 200 )
        
        if vector.Length(world_forward) < 10 then
            msc_peekReturning = false
            msc_peekCompleted = true
        end
    end

end
--Author: SAAC(yougame.biz/ttom)
function SkyBox()
	if skeet_skybox:GetValue() then
		client.SetConVar("sv_skyname", "sky_descent")
	end
end

local gui_set = gui.SetValue
local gui_get = gui.GetValue
local c_reg = callbacks.Register
local b_toggle = input.IsButtonDown

local auto =   gui_get("rbot_autosniper_autostop")
local awp =    gui_get("rbot_sniper_autostop")
local ssg =    gui_get("rbot_scout_autostop")
local rev =    gui_get("rbot_revolver_autostop")
local pist =   gui_get("rbot_pistol_autostop")
local smg =    gui_get("rbot_smg_autostop")
local rifle =  gui_get("rbot_rifle_autostop")
local shotg =  gui_get("rbot_shotgun_autostop")
local lmg =    gui_get("rbot_lmg_autostop")
local shared = gui_get("rbot_shared_autostop")


local key = "shift"

function SlowWalkFIX()

if skeet_swfix:GetValue() then
    if b_toggle(key) then
        draw.Color(0,255,0,255);
        draw.Text(10, 980, "SlowWalk FIX")
 gui_set("rbot_autosniper_autostop", 0)
 gui_set("rbot_lmg_autostop", 0)
 gui_set("rbot_pistol_autostop", 0)
 gui_set("rbot_revolver_autostop", 0)
 gui_set("rbot_rifle_autostop", 0)
 gui_set("rbot_scout_autostop", 0)
 gui_set("rbot_shared_autostop", 0)
 gui_set("rbot_shotgun_autostop", 0)
 gui_set("rbot_smg_autostop", 0) 
 gui_set("rbot_sniper_autostop", 0)

  else

 gui_set("rbot_autosniper_autostop", auto)
 gui_set("rbot_lmg_autostop", lmg)
 gui_set("rbot_pistol_autostop", pist)
 gui_set("rbot_revolver_autostop", rev)
 gui_set("rbot_rifle_autostop", rifle)
 gui_set("rbot_scout_autostop", ssg)
 gui_set("rbot_shared_autostop", shared)
 gui_set("rbot_shotgun_autostop", shotg)
 gui_set("rbot_smg_autostop", smg) 
 gui_set("rbot_sniper_autostop", awp)

    end
end
end

--Author: SAAC(yougame.biz/ttom)





client.AllowListener("player_death")
client.AllowListener("round_prestart")
client.AllowListener('round_start')
client.AllowListener("player_hurt")
callbacks.Register("CreateMove", "create_move", create_move)
callbacks.Register("FireGameEvent", "events", events)
callbacks.Register("Draw", "drawing", drawing)
callbacks.Register("Draw", "Custom_Skies", SkyBox)
c_reg("Draw", "SlowWalk FIX", SlowWalkFIX)
callbacks.Register("CreateMove", CreateMoveCallback)