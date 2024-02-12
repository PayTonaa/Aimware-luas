




------------------- Zeuslines

local function distance3d(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end



local msc_p2 = gui.Reference('MISC',"GENERAL", "Extra")
local GroupBox = gui.Groupbox( msc_p2, "Zeus Range", 0, 250, 213, 150 );
local ActiveCheckBox = gui.Checkbox(GroupBox, "Active", "Activate", false)
local Tyleline = gui.Combobox( GroupBox, 'Type_line',"Type line", "Single line","Multi line")
local colortype = gui.Combobox( GroupBox, 'Type_color',"Color", "Single color","Multi color")
local function lerp_pos(x1, y1, z1, x2, y2, z2, percentage)
    local x = (x2 - x1) * percentage + x1
    local y = (y2 - y1) * percentage + y1
    local z = (z2 - z1) * percentage + z1
    return x, y, z
end

local function trace_line_skip_teammates( x1, y1, z1, x2, y2, z2, max_traces)

    local max_traces = max_traces or 10
    local fraction, entindex_hit = 0, -1
    local x_hit, y_hit, z_hit = x1, y1, z1

    local i=1
    while (entindex_hit == -1 ) and 1 > fraction and max_traces >= i do
    fraction, entindex_hit = engine.TraceLine( x_hit, y_hit, z_hit, x2, y2, z2,3)

        x_hit, y_hit, z_hit = lerp_pos(x_hit, y_hit, z_hit, x2, y2, z2, 1)

        i = i + 1
    end

    local traveled_total = distance3d(x1, y1, z1, x_hit, y_hit, z_hit)
    local total_distance = distance3d(x1, y1, z1, x2, y2, z2)

    return traveled_total/total_distance, entindex_hit
end

local function hsv_to_rgb(h, s, v, a)
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

  return r * 255, g * 255, b * 255, a * 255
end




local weapon_name_prev = nil
local last_switch = 0
local accuracy = 2.5

local is_taser;
local is_knife;
local function on_item_equip(Event)

    if (Event:GetName() ~= 'item_equip') then
        return;
    end

    local local_player, userid, item, weptype = client.GetLocalPlayerIndex(), Event:GetInt('userid'), Event:GetString('item'), Event:GetInt('weptype');


    if (local_player == client.GetPlayerIndexByUserID(userid)) then
        if (item == "taser" ) then
           is_taser=true;
           is_knife=false;
        elseif (item=="knife")then
        is_knife=true;
         is_taser=false;
        else 
        is_knife=false;
            is_taser=false;
        end
    end
end


client.AllowListener('item_equip');
callbacks.Register("FireGameEvent", "on_item_equip", on_item_equip);

