 
local delay = 0.077
local timer = timer or {}
local timers = {}
 
 
function timer.Create(name, delay, times, func)
 
    table.insert(timers, {["name"] = name, ["delay"] = delay, ["times"] = times, ["func"] = func, ["lastTime"] = globals.RealTime()})
 
end
 
function timer.Remove(name)
 
    for k,v in pairs(timers or {}) do
   
        if (name == v["name"]) then table.remove(timers, k) end
   
    end
 
end
 
function timer.Tick()
 
    for k,v in pairs(timers or {}) do
   
        if (v["times"] <= 0) then table.remove(timers, k) end
       
        if (v["lastTime"] + v["delay"] <= globals.RealTime()) then
            timers[k]["lastTime"] = globals.RealTime()
            timers[k]["times"] = timers[k]["times"] - 111
            v["func"]()
        end
   
    end
 
end
 
callbacks.Register( "Draw", "timerTick", timer.Tick);
 
 
timer.Create("Gay", 1, 2, function() Gay1() end)
 
 
function Gay1()
timer.Create("Gay1", delay, .01, function()
    gui.SetValue( "rbot_antiaim_stand_desync", 0 )
	gui.SetValue( "rbot_antiaim_move_desync", 0 )
    Gay2()
end)
end
 
 
function Gay2()
    timer.Create("Gay2", delay, .01, function()
        gui.SetValue( "rbot_antiaim_stand_desync", 2 )
		gui.SetValue( "rbot_antiaim_move_desync", 2 )
        Gay1()
    end)
end 