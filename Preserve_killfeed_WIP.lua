local kills = {}
local pLocalName = "Unknown"

function onAction(Event)
    local eventType = Event:GetName()

    if eventType == 'player_death' then
        local pLocal = client.GetLocalPlayerIndex()
        local iAttacker = client.GetPlayerIndexByUserID(Event:GetInt('attacker'))
        local victimName = client.GetPlayerNameByUserID(Event:GetInt('userid'))

        if pLocal == iAttacker then
            pLocalName = client.GetPlayerNameByIndex(iAttacker)
            table.insert(kills, 1, victimName)
        end
    elseif eventType == 'round_start' then
        kills = {}
    end
end

function onDraw()
    local textOffset = 5

    local sW, sH = draw.GetScreenSize()
    local rectHeight = 0
    local textSpacing = 0
    local width = 0
    for i=1, #kills do
        local row = pLocalName.." killed "..kills[i]
        local tW, tH = draw.GetTextSize(row)
        if tW > width then
            width = tW
        end
        if textSpacing == 0 then
            textSpacing = tH
        end
        rectHeight = rectHeight + textSpacing
    end

    rectHeight = rectHeight + textSpacing
    width = width + (textOffset * 2)

    draw.Color(0, 0, 0, 200)
    draw.FilledRect(sW - width, 0, sW, rectHeight)
    draw.Color(255, 255, 255, 255)
    local y = 0
    for i=1, #kills do
        local row = pLocalName.." killed "..kills[i]
        draw.Text(sW - width + textOffset, y + textOffset, row)
        y = y + textSpacing
    end
end

client.AllowListener('round_start')
client.AllowListener('player_death')
callbacks.Register('FireGameEvent', 'onAction', onAction)
callbacks.Register('Draw', 'onDraw', onDraw)
