local MeeleWeapons = {
    ["WEAPON_NIGHTSTICK"] = 0.0, 
    ["WEAPON_GOLFCLUB"] = 0.0,  
    ["WEAPON_FLASHLIGHT"] = 0.0,    	
    ["WEAPON_DAGGER"] = 0.0,    
    ["WEAPON_BAT"] = 0.0,    
    ["WEAPON_BOTTLE"] = 0.0,    
    ["WEAPON_CROWBAR"] = 0.0,    
    ["WEAPON_HAMMER"] = 0.0,    
    ["WEAPON_HATCHET"] = 0.0,    
    ["WEAPON_KNUCKLE"] = 0.0,    
    ["WEAPON_KNIFE"] = 0.0,    
    ["WEAPON_MACHETE"] = 0.0,    
    ["WEAPON_SWITCHBLADE"] = 0.0,    
    ["WEAPON_WRENCH"] = 0.0,    
    ["WEAPON_BATTLEAXE"] = 0.0,    
    ["WEAPON_POOLCUE"] = 0.0,    
    ["WEAPON_STONE_HATCHET"] = 0.0,    
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

		for weapon, modifier in pairs(MeeleWeapons) do
			if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(weapon) then
				SetPlayerMeleeWeaponDamageModifier(PlayerId(), v)
			end
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		N_0xf4f2c0d4ee209e20() -- REMOVA CAMERA 3D

    -- DANO DAS ARMAS
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"),0.7) -- FACA
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"),0.01) -- CASSETETE
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"),0.75) -- MARTELO
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"),0.80) -- TACO DE BASEBALL
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"),0.75) -- PÉ DE CABRA
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"),0.75) -- TACO DE GOLF
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"),0.75) -- ADAGA
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"),0.4) -- MACHADO
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"),0.2) -- SOCO INGLÊS
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"),0.9) -- MACHETE
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"),0.75) -- LANTERNA
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"),0.7) -- MACHADO DE GUERRA
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"),0.75) -- TACO DE SINUCA
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"),0.75) -- CHAVE INGLESA
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STONE_HATCHET"),0.25) -- MACHADO DE PEDRA
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"),1.4) -- MACHADO DE PEDRA

    -- DANO DAS PISTOLAS SEMI
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"),1.5) -- 7 tiros
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"),1.5) -- 7 tiros
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"),1.1) -- 7 tiros
		
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"), 1.5) -- dose
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"), 1.5) -- dose
		
    -- DANO DAS PISTOLAS AUTO
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"),1.5) -- 8 tiros

		--mp5 mk2
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG_MK2"),1.5) -- 8 tiros
    
    -- DANO DAS SUB-METRALHADORAS
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSMG"),2.0) --MTAR - 7 tiros
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPDW"),1.6) --SIG - 7 tiros

		-- DANO DOS FUZIS
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),1.7) --AK-47
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SPECIALCARBINE_MK2"),1.7) --G36
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"),1.7) --M4A1
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE_MK2"),1.7) --M4A4

    -- GRANADAS
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMOKEGRENADE"),0.0)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BZGAS"),0.0)
		if GetPedDrawableVariation(PlayerPedId(),1) == 46 then
			N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BZGAS"),0.0)
		else
			N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BZGAS"),1.0)
		end
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		HideHudComponentThisFrame(23)
		HideHudComponentThisFrame(24)
		HideHudComponentThisFrame(25)
		HideHudComponentThisFrame(26)
		HideHudComponentThisFrame(27)
		HideHudComponentThisFrame(28)
		HideHudComponentThisFrame(29)
		HideHudComponentThisFrame(30)
		HideHudComponentThisFrame(31)
		HideHudComponentThisFrame(32)
		HideHudComponentThisFrame(33)
		HideHudComponentThisFrame(34)
		HideHudComponentThisFrame(35)
		HideHudComponentThisFrame(36)
		HideHudComponentThisFrame(37)
		HideHudComponentThisFrame(38)
		HideHudComponentThisFrame(39)
		HideHudComponentThisFrame(40)
		HideHudComponentThisFrame(41)
		HideHudComponentThisFrame(42)
		HideHudComponentThisFrame(43)
		HideHudComponentThisFrame(44)
		HideHudComponentThisFrame(45)
		HideHudComponentThisFrame(46)
		HideHudComponentThisFrame(47)
		HideHudComponentThisFrame(48)
		HideHudComponentThisFrame(49)
		HideHudComponentThisFrame(50)
    	HideHudComponentThisFrame(51)
		RemoveAllPickupsOfType() -- M4A1
		RemoveAllPickupsOfType() -- M4A4
    	RemoveAllPickupsOfType(0xBFEFFF6D) -- AK103
    	RemoveAllPickupsOfType(0x394F415C) -- AK47
		RemoveAllPickupsOfType(0xBFEE6C3B) -- PICKUP_WEAPON_DAGGER
		RemoveAllPickupsOfType(0x81EE601E) -- PICKUP_WEAPON_BAT
		RemoveAllPickupsOfType(0xFA51ABF5) -- PICKUP_WEAPON_BOTTLE
		RemoveAllPickupsOfType(0x872DC888) -- PICKUP_WEAPON_CROWBAR
		RemoveAllPickupsOfType(0x88EAACA7) -- PICKUP_WEAPON_GOLFCLUB
		RemoveAllPickupsOfType(0x295691A9) -- PICKUP_WEAPON_HAMMER
		RemoveAllPickupsOfType(0x4E301CD0) -- PICKUP_WEAPON_HATCHET
		RemoveAllPickupsOfType(0xFD9CAEDE) -- PICKUP_WEAPON_KNUCKLE
		RemoveAllPickupsOfType(0x278D8734) -- PICKUP_WEAPON_KNIFE
		RemoveAllPickupsOfType(0xD8257ABF) -- PICKUP_WEAPON_MACHETE
		RemoveAllPickupsOfType(0xDDE4181A) -- PICKUP_WEAPON_SWITCHBLADE
		RemoveAllPickupsOfType(0x5EA16D74) -- PICKUP_WEAPON_NIGHTSTICK
		RemoveAllPickupsOfType(0xE5121369) -- PICKUP_WEAPON_WRENCH
		RemoveAllPickupsOfType(0x0977C0F2) -- PICKUP_WEAPON_BATTLEAXE
		RemoveAllPickupsOfType(0x093EBB26) -- PICKUP_WEAPON_POOLCUE
		RemoveAllPickupsOfType(0xF9AFB48F) -- PICKUP_WEAPON_PISTOL
		RemoveAllPickupsOfType(0x8967B4F3) -- PICKUP_WEAPON_COMBATPISTOL
		RemoveAllPickupsOfType(0x3B662889) -- PICKUP_WEAPON_APPISTOL
		RemoveAllPickupsOfType(0xFD16169E) -- PICKUP_WEAPON_STUNGUN
		RemoveAllPickupsOfType(0x6C5B941A) -- PICKUP_WEAPON_PISTOL50
		RemoveAllPickupsOfType(0xC5B72713) -- PICKUP_WEAPON_SNSPISTOL
		RemoveAllPickupsOfType(0x9CF13918) -- PICKUP_WEAPON_HEAVYPISTOL
		RemoveAllPickupsOfType(0xEBF89D5F) -- PICKUP_WEAPON_VINTAGEPISTOL
		RemoveAllPickupsOfType(0xBD4DE242) -- PICKUP_WEAPON_FLAREGUN
		RemoveAllPickupsOfType(0x8ADDEC75) -- PICKUP_WEAPON_MARKSMANPISTOL
		RemoveAllPickupsOfType(0x614BFCAC) -- PICKUP_WEAPON_REVOLVER
		RemoveAllPickupsOfType(0x1D9588D3) -- PICKUP_WEAPON_MICROSMG
		RemoveAllPickupsOfType(0x3A4C2AD2) -- PICKUP_WEAPON_SMG
		RemoveAllPickupsOfType(0x741C684A) -- PICKUP_WEAPON_ASSAULTSMG
		RemoveAllPickupsOfType(0x789576E2) -- PICKUP_WEAPON_COMBATPDW
		RemoveAllPickupsOfType(0xF5C5DADC) -- PICKUP_WEAPON_MACHINEPISTOL
		RemoveAllPickupsOfType(0xD3722A5B) -- PICKUP_WEAPON_MINISMG
		RemoveAllPickupsOfType(0xA9355DCD) -- PICKUP_WEAPON_PUMPSHOTGUN
		RemoveAllPickupsOfType(0x96B412A3) -- PICKUP_WEAPON_SAWNOFFSHOTGUN
		RemoveAllPickupsOfType(0x9299C95B) -- PICKUP_WEAPON_ASSAULTSHOTGUN
		RemoveAllPickupsOfType(0x6E4E65C2) -- PICKUP_WEAPON_BULLPUPSHOTGUN
		RemoveAllPickupsOfType(0x763F7121) -- PICKUP_WEAPON_MUSKET
		RemoveAllPickupsOfType(0xBED46EC5) -- PICKUP_WEAPON_HEAVYSHOTGUN
		RemoveAllPickupsOfType(0xF9E2DF1F) -- PICKUP_WEAPON_DBSHOTGUN
		RemoveAllPickupsOfType(0xBCC5C1F2) -- PICKUP_WEAPON_AUTOSHOTGUN
		RemoveAllPickupsOfType(0xF33C83B0) -- PICKUP_WEAPON_ASSAULTRIFLE
		RemoveAllPickupsOfType(0xDF711959) -- PICKUP_WEAPON_CARBINERIFLE
		RemoveAllPickupsOfType(0xFAD1F1C9) -- PICKUP_WEAPON_CARBINERIFLE_MK2
		RemoveAllPickupsOfType(0xB2B5325E) -- PICKUP_WEAPON_ADVANCEDRIFLE
		RemoveAllPickupsOfType(0x0968339D) -- PICKUP_WEAPON_SPECIALCARBINE
		RemoveAllPickupsOfType(0x815D66E8) -- PICKUP_WEAPON_BULLPUPRIFLE
		RemoveAllPickupsOfType(0x0FE73AB5) -- PICKUP_WEAPON_COMPACTRIFLE
		RemoveAllPickupsOfType(0x85CAA9B1) -- PICKUP_WEAPON_MG
		RemoveAllPickupsOfType(0xB2930A14) -- PICKUP_WEAPON_COMBATMG
		RemoveAllPickupsOfType(0x5307A4EC) -- PICKUP_WEAPON_GUSENBERG
		RemoveAllPickupsOfType(0xFE2A352C) -- PICKUP_WEAPON_SNIPERRIFLE
		RemoveAllPickupsOfType(0x693583AD) -- PICKUP_WEAPON_HEAVYSNIPER
		RemoveAllPickupsOfType(0x079284A9) -- PICKUP_WEAPON_MARKSMANRIFLE
		RemoveAllPickupsOfType(0x4D36C349) -- PICKUP_WEAPON_RPG
		RemoveAllPickupsOfType(0x2E764125) -- PICKUP_WEAPON_GRENADELAUNCHER
		RemoveAllPickupsOfType(0x2F36B434) -- PICKUP_WEAPON_MINIGUN
		RemoveAllPickupsOfType(0x22B15640) -- PICKUP_WEAPON_FIREWORK
		RemoveAllPickupsOfType(0xE46E11B4) -- PICKUP_WEAPON_RAILGUN
		RemoveAllPickupsOfType(0xC01EB678) -- PICKUP_WEAPON_HOMINGLAUNCHER
		RemoveAllPickupsOfType(0xF0EA0639) -- PICKUP_WEAPON_COMPACTLAUNCHER
		RemoveAllPickupsOfType(0x5E0683A1) -- PICKUP_WEAPON_GRENADE
		RemoveAllPickupsOfType(0x2DD30479) -- PICKUP_WEAPON_MOLOTOV
		RemoveAllPickupsOfType(0x7C119D58) -- PICKUP_WEAPON_STICKYBOMB
		RemoveAllPickupsOfType(0x624F7213) -- PICKUP_WEAPON_PROXMINE
		RemoveAllPickupsOfType(0xAF692CA9) -- PICKUP_WEAPON_PIPEBOMB
		RemoveAllPickupsOfType(0x1CD604C7) -- PICKUP_WEAPON_SMOKEGRENADE
		RemoveAllPickupsOfType(0xC69DE3FF) -- PICKUP_WEAPON_PETROLCAN
		RemoveAllPickupsOfType(0xBDB6FFA5) -- PICKUP_WEAPON_FLASHLIGHT
	
		DisablePlayerVehicleRewards(PlayerId())
		SetPedInfiniteAmmo(PlayerPedId(),true,GetHashKey("WEAPON_FIREEXTINGUISHER"))
		SetCreateRandomCops(false)
		SetGarbageTrucks(false)
		SetRandomBoats(false)
		SetVehicleModelIsSuppressed(GetHashKey("pounder"),true)
		
		-- DESATIVA SOM DE SIRENES
		StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
		SetAudioFlag("PoliceScannerDisabled",true)
		ForceAmbientSiren(false)

		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		RemoveVehiclesFromGeneratorsInArea(x-9999.0,y-9999.0,z-9999.0,x+9999.0,y+9999.0,z+9999.0)

		Citizen.Wait(0)
  	end
end)