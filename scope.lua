local tp_state = {
    level = {
        [1] = 40,
        [2] = 15
    },

    convar = "sensitivity",
    convar_tp = "cam_idealdist",

    cache = nil,
    cache_sense = nil
}

callbacks.Register("Draw", "scope_fix", function()
    local g_Local = entities.GetLocalPlayer()

    if g_Local == nil then
        return
    end

    -- Thirdperson / ViewFOV corrections
    local tp_dist = gui.GetValue("vis_thirdperson_dist")
    local cam_dist = client.GetConVar(tp_state.convar_tp)

    local m_bIsScoped = g_Local:GetProp("m_bIsScoped")
    if not (m_bIsScoped == 1 or m_bIsScoped == 257) and tp_dist > 0 then
        gui.SetValue("vis_thirdperson_dist", cam_dist)
    end

    local weapon = g_Local:GetPropEntity("m_hActiveWeapon")
    if weapon then
        if tp_state.cache == nil then tp_state["cache"] = gui.GetValue("vis_view_fov") end
        if tp_state.cache_sense == nil then tp_state["cache_sense"] = client.GetConVar(tp_state.convar) end

        if g_Local:IsAlive() and (m_bIsScoped == 1 or m_bIsScoped == 257) then
            local level = weapon:GetProp("m_zoomLevel")

            local tcache = tp_state.cache - 90
            local tcache = (tcache > 0 and tcache or 0)

            if level ~= nil and tp_state.level ~= nil then
                gui.SetValue("vis_view_fov", tp_state.level[level] + tcache)
                client.SetConVar(tp_state.convar, (level == 1 and (tp_state.cache_sense / 2) or tp_state.cache_sense), true)
            end
        else
            if tp_state.cache ~= nil then
                gui.SetValue("vis_view_fov", tp_state.cache)
                tp_state["cache"] = nil
            end

            if tp_state.cache_sense ~= nil then
                client.SetConVar(tp_state.convar, tp_state.cache_sense, true)
                tp_state["cache_sense"] = nil
            end
        end
    else
        if tp_state.cache ~= nil then
            gui.SetValue("vis_view_fov", tp_state.cache)
            tp_state["cache"] = nil
        end

        if tp_state.cache_sense ~= nil then
            client.SetConVar(tp_state.convar, tp_state.cache_sense, true)
            tp_state["cache_sense"] = nil
        end
    end
end)