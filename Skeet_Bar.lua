local chromatab = gui.Reference("MISC", "GENERAL", "Main")
local linegroup = gui.Groupbox(chromatab, "Chroma Lines", 0, 200, 200, 221)
local enable = gui.Checkbox(linegroup, "rab_enable_line", "Enable", 0);
local line_mode = gui.Combobox(linegroup, "rab_line_mode", "Color", "Chroma");
local line_thickness = gui.Slider(linegroup, "rab_line_thickness", "Thickness", 4, 1, 10);
local line_alpha = gui.Slider(linegroup, "rab_line_alpha", "Line Alpha", 255, 0, 255);
local r, g, b = 255, 0, 0;
local rgb = {}
local menuPressed = 1;

function drawLine()
   if input.IsButtonPressed(gui.GetValue("msc_menutoggle")) then
       menuPressed = menuPressed == 0 and 1 or 0
   end
   chromatab:SetActive(menuPressed);
   updateFadeRGB();
   local screenSize = draw.GetScreenSize();
   local whichMode = line_mode:GetValue();
   local isRainbow = whichMode == 0;
   local thickness = line_thickness:GetValue();
   local alpha = line_alpha:GetValue();
   if enable:GetValue() then
       if (isRainbow) then
           draw.Color(r, g, b, alpha);
           draw.FilledRect(0, 0, screenSize, thickness);
       elseif (not isRainbow) then
           draw.Color(math.floor(rgb[1]), math.floor(rgb[2]), math.floor(rgb[3]), alpha);
           draw.FilledRect(0, 0, screenSize, thickness);
       end
   end
end

function updateFadeRGB()
   if (r > 0 and b == 0) then
       r = r - 1;
       g = g + 1;
   end
   if (g > 0 and r == 0) then
       g = g - 1;
       b = b + 1;
   end
   if (b > 0 and g == 0) then
       r = r + 1;
       b = b - 1;
   end
end


callbacks.Register('Draw', 'chroma_rab_draw', drawLine);