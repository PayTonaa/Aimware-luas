local function autobuy( event )
   if event:GetName() == "round_prestart" then
       client.Command("buy awp; buy elite; buy taser; buy vest; buy vesthelm; buy defuser; buy incgrenade; buy molotov; buy hegrenade; buy smokegrenade", true)
   end
end

client.AllowListener( "round_prestart" );

callbacks.Register( "FireGameEvent", "autobuy", autobuy);
