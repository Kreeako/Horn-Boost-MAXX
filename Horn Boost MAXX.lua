util.require_natives()

local function get_vehicle_ped_is_in(ped, include_last_vehicle)
    if include_last_vehicle or PED.IS_PED_IN_ANY_VEHICLE(ped) then
        return PED.GET_VEHICLE_PED_IS_IN(ped, false)
    end
    return 0
end

local function inputting()
    if chat.get_state() ~= 0 then
        return true
    elseif menu.command_box_is_open() then
        return true
    end
    return false
end

local use_cam = false
local boost = 200
menu.toggle_loop(menu.my_root(), "Horn Boost MAXX", { "" }, "", function()
    if not inputting() then
        if util.is_key_down(0x45) and my_veh ~= 0 then
            if use_cam then
                local cam_rot = players.get_cam_rot(players.user())
                local cam_dir = v3.toDir(v3(cam_rot));
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_veh, 1,  cam_dir.x * new_boost, cam_dir.y * new_boost, cam_dir.z * new_boost, false, false, true, true);
            else
                local veh_rot = ENTITY.GET_ENTITY_ROTATION(my_veh, 2)
                local veh_dir = v3.toDir(v3(veh_rot))
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_veh, 1,  veh_dir.x * new_boost, veh_dir.y * new_boost, veh_dir.z * new_boost, false, false, true, true);
            end
        end
    end
end)

menu.toggle(menu.my_root(), "Use Camera", { "" }, "", function(state)
    use_cam = state
end)

menu.slider_float(menu.my_root(), "Boost Amount", { "boost" }, "", -2147483647, 2147483647, 200, 1, function(value)
    boost = value
end)

util.create_tick_handler(function()
    my_ped = players.user_ped()
    my_veh = get_vehicle_ped_is_in(my_ped, false)
    new_boost = boost / 100
end)

util.keep_running()