print("This is a Client")

Citizen.CreateThread(function()

    -- Hej medborgare som läser koden, du får gärna lära dig hur man gör saker genom att läsa
    -- vår kåd. Men kopiera den inte helt, det är inte snällt mot oss och det är roligt att
    -- göra saker själv.

    -- Se till att man faktist har en ped
    Wait(10)
    local playerPed = PlayerPedId()
    while not(playerPed and playerPed ~= -1) do
        playerPed = playerPedId()
        Wait(10)
    end

    -- Se till att man faktist kommit in på servern
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(10)
    end

    -- FadeOut
    DoScreenFadeOut(200)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    -- Förflytta Spelaren's Ped
    local x = -712.077
    local y = -243.289
    local z = 37.000
    local player = PlayerId()
    local pedId = PlayerPedId()
    local ped = GetPlayerPed(player)

    -- Ta iväg kontroll från spelaren och pausa ped:en
    SetPlayerControl(player, false, false)
    if IsEntityVisible(ped) then
        SetEntityVisible(ped, false)
    end
    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    SetPlayerInvincible(player, true)
    if not IsPedFatallyInjured(ped) then
        ClearPedTasksImmediately(ped)
    end

    -- Böna och be gta att ladda in vår player model
    local model = 'a_m_y_runner_01'
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
    SetPlayerModel(player, model)
    SetModelAsNoLongerNeeded(model)
    -- Update ped variable to the new one
    pedId = PlayerPedId()
    ped = GetPlayerPed(player)

    -- Placera spelaren's ped
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(pedId, x, y, z, false, false, false, true)
    NetworkResurrectLocalPlayer(x, y, z, 0.00, true, true, false)
    ClearPedTasksImmediately(pedId)
    -- Sätt Player Stats
    SetEntityHealth(pedId, 170)
    SetEntityMaxHealth(pedId,170)
    RemoveAllPedWeapons(pedId)
    ClearPlayerWantedLevel(PlayerId())
    SetPedConfigFlag(ped,32,true)
    SetFlyThroughWindscreenParams(35.0,40.0,17.0,10.0)

    -- Vänta tills ped:en är placerad
    local time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(pedId) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen()

    -- Ge tillbaka kontroll till spelaren
    SetPlayerControl(player, true, false)
    if not IsEntityVisible(ped) then
        SetEntityVisible(ped, true)
    end
    if not IsPedInAnyVehicle(ped) then
        SetEntityCollision(ped, true)
    end
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(player, false)

    -- ge spelaren's dator tid att ladda in allt innan dom får se
    Wait(2200)

    if IsScreenFadedOut() then
        DoScreenFadeIn(800)
        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end

    -- Vi är klara
    print("SpawnDone")
end)

Citizen.CreateThread(function ()
    while true do
        SetPedDensityMultiplierThisFrame(0.1)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.1)
        SetRandomVehicleDensityMultiplierThisFrame(0.3)
        SetParkedVehicleDensityMultiplierThisFrame(0.2)
        SetVehicleDensityMultiplierThisFrame(0.2)
        Wait(0)
    end
end)

RegisterCommand('revive', function(source, args)
    local pos = GetEntityCoords(PlayerPedId())
    local x = pos.x
    local y = pos.y
    local z = pos.z + 0.5
    local pedId = PlayerPedId()
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(pedId, x, y, z, false, false, false, true)
    NetworkResurrectLocalPlayer(x, y, z, 0.00, true, true, false)
    ClearPedTasksImmediately(pedId)
    SetEntityHealth(pedId, 170)
    SetEntityMaxHealth(pedId,170)
end, false)

RegisterCommand('heal', function(source, args)
    SetEntityHealth(PlayerPedId(),GetEntityMaxHealth(PlayerPedId()))
end, false)

RegisterCommand('whereami', function(source, args)
    print(GetEntityCoords(PlayerPedId()))
end, false)