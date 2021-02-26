-- TODO: Add sounds
-- TODO: Add a command and run loop only if script is used

local cooldown = 60
local tick = 0

-- HORSE_RACING_WALL = for the big screen

Citizen.CreateThread(function()
    -- Scaleform
    Utils.Scaleform = RequestScaleformMovie('HORSE_RACING_CONSOLE')

    while not HasScaleformMovieLoaded(Utils.Scaleform) do
        Wait(0)
    end

    DisplayHud(false)
    SetPlayerControl(PlayerId(), false, 0)

    Utils:ShowMainScreen()
    Utils:SetMainScreenCooldown(cooldown)

    -- Add horses
    Utils:AddHorses()

    while true do
        Wait(0)

        local xMouse, yMouse = GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240)

        -- Fake cooldown
        tick = (tick + 10)

        if (tick == 1000) then
            if (cooldown == 1) then
                cooldown = 60
            end
            
            cooldown = (cooldown - 1)
            tick = 0

            Utils:SetMainScreenCooldown(cooldown)
        end
        
        -- Mouse control
        BeginScaleformMovieMethod(Utils.Scaleform, 'SET_MOUSE_INPUT')
        ScaleformMovieMethodAddParamFloat(xMouse)
        ScaleformMovieMethodAddParamFloat(yMouse)
        EndScaleformMovieMethod()

        -- Draw
        DrawScaleformMovieFullscreen(Utils.Scaleform, 255, 255, 255, 255)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if IsControlJustPressed(2, 237) then
            local clickedButton = Utils:GetMouseClickedButton()

            if Utils.ChooseHorseVisible then
                if (clickedButton ~= 12) then
                    Utils:ShowBetScreen((clickedButton - 1))
                    Utils.ChooseHorseVisible = false
                end
            end

            -- Rules button
            if (clickedButton == 15) then
                Utils:ShowRules()
            end

            -- Close buttons
            if (clickedButton == 12) then
                if Utils.ChooseHorseVisible then
                    Utils.ChooseHorseVisible = false
                end
                
                Utils:ShowMainScreen()
            end

            -- Start bet
            if (clickedButton == 1) then
                Utils:ShowHorseSelection()
            end
        end
    end
end)