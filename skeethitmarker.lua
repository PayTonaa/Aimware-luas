local hurt_time = 0
local alpha = 0;

--Change linesize here:
local linesize = 5

function Sounds( Event, Entity )

if ( Event:GetName() == 'player_hurt' ) then

    local ME = client.GetLocalPlayerIndex();

    local INT_UID = Event:GetInt( 'userid' );
    local INT_ATTACKER = Event:GetInt( 'attacker' );

    local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
    local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

    local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
    local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );

    if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then
       hurt_time = globals.RealTime()
       client.Command("play buttons\\arena_switch_press_02.wav", true); --replace sound here
    end

end

end


function DrawingHook() 

--Screensize:
local screenCenterX, screenCenterY = draw.GetScreenSize();
screenCenterX = screenCenterX / 2;
screenCenterY = screenCenterY / 2;

--Alpha/Colors:
local step = 255 / 0.3 * globals.FrameTime()
local r,b,g = gui.GetValue( "clr_misc_hitmarker" )
if hurt_time + 0.4 > globals.RealTime() then
alpha = 255
else
alpha = alpha - step
end

--Render:
if (alpha > 0) then
draw.Color( r,g,b,alpha)
draw.Line( screenCenterX - linesize * 2, screenCenterY - linesize * 2, screenCenterX - ( linesize ), screenCenterY - ( linesize ))
draw.Line( screenCenterX - linesize * 2, screenCenterY + linesize * 2, screenCenterX - ( linesize ), screenCenterY + ( linesize ))
draw.Line( screenCenterX + linesize * 2, screenCenterY + linesize * 2, screenCenterX + ( linesize ), screenCenterY + ( linesize ))
draw.Line( screenCenterX + linesize * 2, screenCenterY - linesize * 2, screenCenterX + ( linesize ), screenCenterY - ( linesize ))
end
end
client.AllowListener( 'player_hurt' );
callbacks.Register( "Draw", "DrawingHook", DrawingHook );
callbacks.Register( 'FireGameEvent', 'Hitsound', Sounds );