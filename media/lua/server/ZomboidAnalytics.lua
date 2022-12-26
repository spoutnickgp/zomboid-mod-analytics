ZomboidAnalytics = {}

logEvent = function(log_type, event_type, position, message)
    full_message =  event_type .. " @ " .. position:getX() .. "x" .. position:getY() .. " - " .. message
    print(full_message)
    writeLog("analytics-" .. log_type, full_message);
end

logZombieId = function(zombie)
    return "Zombie #" .. zombie:getOnlineID();
end

logPlayerId = function(character)
    return "Player #" .. character:getUsername();
end

ZomboidAnalytics.onCharacterDeath = function(character)
    square = character:getCurrentSquare()
    if character:isZombie() then
        logEvent("death", "ZombieDeath", square, logZombieId(character) .. " killed");
    else
        score = "(survived ".. character:getHoursSurvived() .. " hours, killed " .. character:getZombieKills() .. " zombies)"
        logEvent("death", "PlayerDeath", square, logPlayerId(character) .. " killed " .. score);
    end
end

ZomboidAnalytics.onWeaponHitCharacter = function(wielder, target, weapon, damage)
    square = target:getCurrentSquare()
    if target:isZombie() then
        logEvent("combat", "ZombieHit", square, logZombieId(target) .. " hit for " .. damage .. " HP");
    else
        logEvent("combat", "PlayerHit", square, logPlayerId(target) .. " hit for " .. damage .. " HP");
    end
end

ZomboidAnalytics.OnHitZombie = function(zombie, target, body_part, weapon)
    print("OnHitZombie")
end

ZomboidAnalytics.OnBeingHitByZombie = function()
    print("OnBeingHitByZombie")
end

ZomboidAnalytics.OnEnterVehicle = function(character)
    square = character:getCurrentSquare()
    logEvent("action", "EnterVehicle", square, logPlayerId(character) .. " entered a vehicle");

end

Events.OnWeaponHitCharacter.Add(ZomboidAnalytics.onWeaponHitCharacter)
Events.OnCharacterDeath.Add(ZomboidAnalytics.onCharacterDeath)
Events.OnEnterVehicle.Add(ZomboidAnalytics.OnEnterVehicle)
Events.OnBeingHitByZombie.Add(ZomboidAnalytics.OnBeingHitByZombie)
Events.OnHitZombie.Add(ZomboidAnalytics.OnHitZombie)