function rainbowesp()
 
   local speed = 2
   local r = math.floor(math.sin(globals.RealTime() * speed) * 127 + 128)
   local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
   local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)
   local a = 255
   
   for k,v in pairs({  "clr_chams_ct_invis",
                       "clr_chams_ct_vis",
                       "clr_chams_t_invis",
                       "clr_chams_t_vis",
                       "clr_esp_box_ct_vis",
                       "clr_esp_box_other_invis",
                       "clr_esp_box_t_vis",
                       "clr_misc_hitmarker"}) do
                       
       gui.SetValue(v, r,g,b,a)
       
   end
end
 
callbacks.Register( "Draw", "uwu", rainbowesp);