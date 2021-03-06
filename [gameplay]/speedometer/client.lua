local screenW, screenH = guiGetScreenSize()

local function dxDrawRelativeImage(startX, startY, width, height, image, rot, rotX, rotY, color, postGUI)
    dxDrawImage(startX * screenW, startY * screenH, width * screenW, height * screenH, image, rot or 0, rotX or 0, rotY or 0, color, postGUI or false)
end

function drawSpeedo()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end

    local velx, vely, velz = getElementVelocity(veh)
    local speed = (velx ^ 2 + vely ^ 2 + velz ^ 2) ^ (0.5)

    dxDrawRelativeImage(0.66, 0.61, 0.33, 0.49, "images/disc.png")
    dxDrawRelativeImage(0.7825, 0.61, 0.2, 0.46, "images/needle.png", -146 + (speed * 180))
end

local isSpeedoShown = false
function toggleRender(bool)
    if bool then
        isSpeedoShown = true
        addEventHandler("onClientRender", root, drawSpeedo)
    else
        isSpeedoShown = false
        removeEventHandler("onClientRender", root, drawSpeedo)
    end
end

function toggleSpeedo()
    toggleRender(not isSpeedoShown)
end
addCommandHandler("speedo", toggleSpeedo)

local function enterHandler(theVehicle)
    local vehType = getVehicleType(theVehicle)
    if (vehType == "Plane") or (vehType == "Helicopter") then return end

    if not isSpeedoShown then
        toggleRender(true)
    end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, enterHandler)

local function exitHandler(theVehicle)
    local vehType = getVehicleType(theVehicle)
    if (vehType == "Plane") or (vehType == "Helicopter") then return end

    if isSpeedoShown then
        toggleRender(false)
    end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, exitHandler)

local function destroyHandler()
    if (getElementType(source) == "vehicle") and (getVehicleController(source) == localPlayer) and isSpeedoShown then
        toggleRender(false)
    end
end
addEventHandler("onClientVehicleExplode", root, destroyHandler)
addEventHandler("onClientElementDestroy", root, destroyHandler)

-- Dying in vehicle, so not triggering onClientPlayerVehicleExit
function integrityCheck()
    if getPedOccupiedVehicle(localPlayer) and isSpeedoShown then
        toggleRender(false)
    end
end
addEventHandler("onClientPlayerWasted", localPlayer, integrityCheck)
