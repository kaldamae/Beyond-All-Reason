return {
	corvalk = {
		acceleration = 0.09,
		brakerate = 0.75,
		buildcostenergy = 1500,
		buildcostmetal = 75,
		buildpic = "CORVALK.DDS",
		buildtime = 4122,
		canfly = true,
		canmove = true,
		category = "ALL MOBILE WEAPON NOTLAND VTOL ANTIFLAME ANTIEMG ANTILASER NOTSUB NOTSHIP NOTHOVER",
		collide = true,
		cruisealt = 70,
		description = "Air Transport",
		energymake = 0.7,
		energyuse = 0.7,
		explodeas = "mediumexplosiongeneric",
		footprintx = 2,
		footprintz = 3,
		hoverattack = true,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 250,
		maxslope = 10,
		maxvelocity = 6.6,
		maxwaterdepth = 0,
		name = "Valkyrie",
		objectname = "CORVALK",
		releaseheld = true,
		seismicsignature = 0,
		selfdestructas = "mediumexplosiongeneric",
		sightdistance = 260,
		transportcapacity = 1,
		transportmass = 5000,
		transportsize = 3,
		turninplaceanglelimit = 360,
		turnrate = 550,
		blocking = false,
		customparams = {
			death_sounds = "generic",
			paralyzemultiplier = 0.025,
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg2",
				"deathceg3",
				"deathceg4",
			},
			explosiongenerators = {
				[1] = "custom:thruster-medium",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "vtolcrac",
			},
		},
	},
}
