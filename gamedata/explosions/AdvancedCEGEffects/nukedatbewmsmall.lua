-- nukedatbewmsmall

return {
  ["nukedatbewmsmall"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 5.5,
        sizegrowth         = 40,
        speed              = [[0, 1 0, 0]],
        texture            = [[flareorg]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.4   0 0 0 0.01]],
        size               = 350,
        ttl                = 30,
        sizegrowth         = -1,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.9 0.75 0.55   0 0 0 0.01]],
        size               = 300,
        sizegrowth         = 0,
        ttl                = 33,
        texture            = [[groundflash]],
      },
    },
    heatedgroundflash = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      water              = false,
      properties = {
        colormap           = [[1 0.15 0.05 0.33   1 0.15 0.05 0.2   0 0 0 0.01]],
        size               = 60,
        sizegrowth         = 0,
        ttl                = 60,
        texture            = [[groundflash]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.87,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 80,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 10,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.82,
        colormap           = [[0 0 0 0   1 0.93 0.7 0.09   0.9 0.53 0.21 0.066   0.66 0.28 0.04 0.033   0 0 0 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 12,
        particlelife       = 14,
        particlelifespread = 7,
        particlesize       = 6,
        particlesizespread = 12,
        particlespeed      = 3.3,
        particlespeedspread = 5,
        pos                = [[0, 15, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
    sparks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.96,
        colormap           = [[0.8 0.5 0.2 0.01   0.95 0.55 0.25 0.017   0.6 0.35 0.1 0.01   0 0 0 0.01]],
        directional        = true,
        emitrot            = 25,
        emitrotspread      = 40,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.55, 0]],
        numparticles       = 20,
        particlelife       = 14,
        particlelifespread = 12,
        particlesize       = 100,
        particlesizespread = 170,
        particlespeed      = 5,
        particlespeedspread = 10,
        pos                = [[0, 4, 0]],
        sizegrowth         = 1,
        sizemod            = 0.66,
        texture            = [[gunshotglow]],
        useairlos          = false,
      },
    },
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.98,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66    0.1 0.07 0.03 0.58   0.08 0.065 0.035 0.47   0.075 0.07 0.06 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 35,
        emitrotspread      = 16,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.55, 0]],
        numparticles       = 30,
        particlelife       = 45,
        particlelifespread = 20,
        particlesize       = 2.5,
        particlesizespread = -1.3,
        particlespeed      = 5,
        particlespeedspread = 12,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.015,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.96,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66    0.1 0.07 0.03 0.58   0.08 0.065 0.035 0.47   0.075 0.07 0.06 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 20,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.55, 0]],
        numparticles       = 5,
        particlelife       = 45,
        particlelifespread = 20,
        particlesize       = 2.3,
        particlesizespread = -1.25,
        particlespeed      = 5,
        particlespeedspread = 12,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.015,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.96,
        colormap           = [[0 0 0 0.01  0.025 0.02 0.02 0.05  0.06 0.055 0.055 0.1  0.043 0.04 0.04 0.06   0.0238 0.022 0.022 0.03  0 0 0 0.01]],
        directional        = false,
        emitrot            = 40,
        emitrotspread      = 15,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 25,
        particlelife       = 70,
        particlelifespread = 120,
        particlesize       = 50,
        particlesizespread = 25,
        particlespeed      = 0.25,
        particlespeedspread = 3.5,
        pos                = [[0, 40, 0]],
        sizegrowth         = 0.15,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },

    nukefloor = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 6,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0 i1]],
        explosiongenerator = [[custom:nuke-floor]],
        pos                = [[-30 r60, 13, -30 r60]],
      },
    },
    nukestem = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 7,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[i1.5]],
        explosiongenerator = [[custom:nuke-stem]],
        pos                = [[-5 r10, -55 i25, -5 r10]],
      },
    },
    nukestem2 = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 6,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[i1]],
        explosiongenerator = [[custom:nuke-stem2]],
        pos                = [[-5 r10, -55 i25, -5 r10]],
      },
    },
    nukemid = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 5,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[6 i2]],
        explosiongenerator = [[custom:nuke-mid]],
        pos                = [[-5 r10, 77 i6, -5 r10]],
      },
    },
    nukeheadring = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[5 i1]],
        explosiongenerator = [[custom:nuke-headring]],
        pos                = [[0, 110, 0]],
      },
    },
    nukehead = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 12,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[6 i1]],
        explosiongenerator = [[custom:nuke-head]],
        pos                = [[-12 r24, 110 i2.6, -12 r24]],
      },
    },
  },

  ["nuke-floor"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.4,
        colormap           = [[0.63 0.5 0.4 0.01  0.28 0.25 0.21 0.4   0.18 0.16 0.14 0.38   0.15 0.14 0.13 0.38   0.14 0.13 0.12 0.34   0.108 0.1 0.09 0.26   0.105 0.1 0.09 0.26   0.1 0.095 0.085 0.2   0.095 0.09 0.085 0.2   0.045 0.045 0.04 0.1   0.045 0.045 0.04 0.1   0.022 0.022 0.02 0.05   0.022 0.022 0.02 0.05   0 0 0 0.01]],
        directional        = true,
        emitrot            = 97,
        emitrotspread      = 4,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.005, 0.0]],
        numparticles       = 25,
        particlelife       = 75,
        particlelifespread = 55,
        particlesize       = 15,
        particlesizespread = 7,
        particlespeed      = 0,
        particlespeedspread = 90,
        pos                = [[0.0, 0, 0.0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-floor-old"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.82,
        colormap           = [[0.64 0.5 0.4 0.01  0.3 0.25 0.2 0.4   0.2 0.16 0.13 0.38   0.17 0.14 0.12 0.38   0.145 0.13 0.11 0.34   0.11 0.1 0.08 0.26   0.11 0.1 0.08 0.26   0.1 0.095 0.085 0.2   0.1 0.095 0.085 0.2   0.045 0.045 0.04 0.1   0.045 0.045 0.04 0.1   0.022 0.022 0.02 0.05   0.022 0.022 0.02 0.05   0 0 0 0.01]],
        directional        = true,
        emitrot            = 100,
        emitrotspread      = 4,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.01, 0.0]],
        numparticles       = 25,
        particlelife       = 75,
        particlelifespread = 55,
        particlesize       = 15,
        particlesizespread = 7,
        particlespeed      = 0,
        particlespeedspread = 22,
        pos                = [[0.0, 0, 0.0]],
        sizegrowth         = -0.07,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-stem"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[0.25 0.2 0.1 0.5   0.45 0.24 0.18 0.45  0.3 0.18 0.13 0.4   0.25 0.17 0.13 0.37   0.33 0.22 0.12 0.35  0.25 0.19 0.12 0.35   0.2 0.15 0.11 0.3   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.08, 0.0]],
        numparticles       = 3,
        particlelife       = 14,
        particlelifespread = 4,
        particlesize       = 5.5,
        particlesizespread = 1.2,
        particlespeed      = 1,
        particlespeedspread = 1,
        pos                = [[0.0, 0, 0.0]],
        sizegrowth         = 0.15,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-stem2"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[0.17 0.15 0.12 0.15  0.17 0.15 0.11 0.4   0.17 0.14 0.1 0.38   0.17 0.14 0.1 0.38   0.16 0.13 0.095 0.34   0.13 0.11 0.09 0.26   0.11 0.095 0.075 0.2   0.085 0.075 0.07 0.15   0 0 0 0.01]],
        directional        = true,
        emitrot            = 3,
        emitrotspread      = 3,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.08, 0.0]],
        numparticles       = [[4 r1.5]],
        particlelife       = 42,
        particlelifespread = 15,
        particlesize       = 6,
        particlesizespread = 2.5,
        particlespeed      = 3,
        particlespeedspread = 3,
        pos                = [[0.0, 0, 0.0]],
        sizegrowth         = 0.15,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-mid"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.82,
        colormap           = [[0.38 0.28 0.18 0.4  0.22 0.16 0.1 0.33  0.2 0.15 0.1 0.3   0.2 0.15 0.1 0.3   0.22 0.18 0.09 0.25  0.2 0.15 0.07 0.22   0.19 0.16 0.1 0.25   0 0 0 0.01]],
        directional        = true,
        emitrot            = 100,
        emitrotspread      = 1,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.3, 0.0]],
        numparticles       = 2,
        particlelife       = 30,
        particlelifespread = 10,
        particlesize       = 9,
        particlesizespread = 6,
        particlespeed      = 1,
        particlespeedspread = 2,
        pos                = [[0, 5, 0]],
        sizegrowth         = -0.15,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-headring"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.44,
        colormap           = [[0 0 0 0.01    0.006 0.003 0.001 0.009    0.2 0.16 0.07 0.03    0.3 0.24 0.1 0.35   0.4 0.3 0.15 0.42    0.7 0.5 0.28 0.4   0.55 0.3 0.25 0.32   0.45 0.225 0.13 0.25    0.3 0.2 0.07 0.2    0 0 0 0.01]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 2,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.66, 0.0]],
        numparticles       = 30,
        particlelife       = 18,
        particlelifespread = 22,
        particlesize       = 22,
        particlesizespread = 1.5,
        particlespeed      = 10.5,
        particlespeedspread = 0.6,
        pos                = [[48, 48, 48]],
        sizegrowth         = -0.7,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  ["nuke-head"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[0.22 0.19 0.15 0.4   0.22 0.19 0.17 0.35   0.18 0.15 0.13 0.33   0.15 0.13 0.11 0.32   0.135 0.12 0.1 0.28  0.08 0.07 0.06 0.19   0.065 0.06 0.05 0.15   0 0 0 0.01]],
        directional        = true,
        emitrot            = 100,
        emitrotspread      = 2,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.015, 0.0]],
        numparticles       = 10,
        particlelife       = 30,
        particlelifespread = 44,
        particlesize       = 3.3,
        particlesizespread = 1.5,
        particlespeed      = 1,
        particlespeedspread = 2.6,
        pos                = [[50, 50, 50]],
        sizegrowth         = 0.25,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },



  ["nukedatbewmsmall-old"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 5.5,
        sizegrowth         = 40,
        speed              = [[0, 1 0, 0]],
        texture            = [[flareorg]],
      },
    },
    groundflash_large = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      properties = {
        colormap           = [[1 0.7 0.3 0.4   0 0 0 0.01]],
        size               = 350,
        ttl                = 30,
        sizegrowth         = -1,
        texture            = [[groundflash]],
      },
    },
    groundflash_white = {
        class              = [[CSimpleGroundFlash]],
        count              = 1,
        air                = true,
        ground             = true,
        water              = true,
        properties = {
            colormap           = [[1 0.9 0.75 0.45   0 0 0 0.01]],
            size               = 300,
            sizegrowth         = 0,
            ttl                = 14,
            texture            = [[groundflash]],
        },
    },
    heatedgroundflash = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = false,
      ground             = false,
      unit               = false,
      nounit             = true,
      water              = false,
      properties = {
        colormap           = [[1 0.15 0.05 0.4   1 0.15 0.05 0.3   0 0 0 0.01]],
        size               = 36,
        sizegrowth         = 0,
        ttl                = 47,
        texture            = [[groundflash]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.87,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 80,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 10,
        particlespeedspread = 6,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake]],
      },
    },
    explosion = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.82,
        colormap           = [[0 0 0 0   1 0.93 0.7 0.09   0.9 0.53 0.21 0.066   0.66 0.28 0.04 0.033   0 0 0 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 50,
        particlelife       = 4,
        particlelifespread = 15,
        particlesize       = 6,
        particlesizespread = 18,
        particlespeed      = 0.5,
        particlespeedspread = 8,
        pos                = [[0, 2, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
    fireglow = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.5,
        colormap           = [[0.15 0.14 0.1 0.005   0 0 0 0.01]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0.0, 1, 0.0]],
        gravity            = [[0.0, 0.0, 0.0]],
        numparticles       = 1,
        particlelife       = 19,
        particlelifespread = 0,
        particlesize       = 75,
        particlesizespread = 4,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1.5,
        sizemod            = 1,
        texture            = [[glow]],
        useairlos          = false,
      },
    },
    fireglow2 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.5,
        colormap           = [[0.26 0.22 0.08 0.26   0.44 0.38 0.13 0.44   0.2 0.14 0 0.2   0 0 0 0.01]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0.0, 0, 0.0]],
        gravity            = [[0.0, 0.0, 0.0]],
        numparticles       = 1,
        particlelife       = 21,
        particlelifespread = 0,
        particlesize       = 150,
        particlesizespread = 2,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = false,
      },
    },
    innersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.75,
        alwaysVisible = 0,
        sizeGrowth = 0.3,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, 0.02, 0]],
        colorMap=[[1 0.66 0.45 0.35    0.44 0.24 0.14 0.45   0.25 0.17 0.13 0.4    0.19 0.16 0.14 0.35   0.1 0.095 0.088 0.25   0.07 0.065 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife = 33,
        particleLifeSpread = 90,
        numParticles = 6,
        particleSpeed = 3,
        particleSpeedSpread = 13,
        particleSize = 30,
        particleSizeSpread = 44,
        directional=0,
      },
    },
    outersmoke = {
      class = [[CSimpleParticleSystem]],
      water=0,
      air=1,
      ground=1,
      count=1,
      properties = {
        airdrag=0.2,
        alwaysVisible = 0,
        sizeGrowth = 0.3,
        sizeMod = 1.0,
        pos = [[r-1 r1, 0, r-1 r1]],
        emitRot=33,
        emitRotSpread=50,
        emitVector = [[0, 1, 0]],
        gravity = [[0, -0.02, 0]],
        colorMap=[[1 0.66 0.45 0.35    0.44 0.24 0.14 0.45   0.25 0.17 0.13 0.4    0.19 0.16 0.14 0.35   0.1 0.095 0.088 0.25   0.07 0.065 0.058 0.17    0 0 0 0.01]],
        Texture=[[graysmoke]],
        particleLife = 20,
        particleLifeSpread = 75,
        numParticles = 4,
        particleSpeed = 3.2,
        particleSpeedSpread = 14,
        particleSize = 55,
        particleSizeSpread = 44,
        directional=0,
      },
    },
    sparks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.95,
        colormap           = [[0.8 0.5 0.2 0.01   0.9 0.5 0.2 0.017   0 0 0 0.01]],
        directional        = true,
        emitrot            = 25,
        emitrotspread      = 40,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.3, 0]],
        numparticles       = 50,
        particlelife       = 3,
        particlelifespread = 10,
        particlesize       = 5,
        particlesizespread = 24,
        particlespeed      = 3.2,
        particlespeedspread = 7.4,
        pos                = [[0, 4, 0]],
        sizegrowth         = 1,
        sizemod            = 0.84,
        texture            = [[gunshotglow]],
        useairlos          = false,
      },
    },
    dirt = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.95,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66    0.1 0.07 0.03 0.58   0.08 0.065 0.035 0.47   0.075 0.07 0.06 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 24,
        emitrotspread      = 30,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 66,
        particlelife       = 18,
        particlelifespread = 55,
        particlesize       = 1.6,
        particlesizespread = -1.3,
        particlespeed      = 6,
        particlespeedspread = 7.5,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    dirt2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.95,
        colormap           = [[0.04 0.03 0.01 0   0.1 0.07 0.033 0.66    0.1 0.07 0.03 0.58   0.08 0.065 0.035 0.47   0.075 0.07 0.06 0.4   0 0 0 0  ]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 16,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.33, 0]],
        numparticles       = 33,
        particlelife       = 60,
        particlelifespread = 60,
        particlesize       = 1.5,
        particlesizespread = -1.25,
        particlespeed      = 6.5,
        particlespeedspread = 10,
        pos                = [[0, 3, 0]],
        sizegrowth         = -0.01,
        sizemod            = 1,
        texture            = [[bigexplosmoke]],
        useairlos          = false,
      },
    },
    --shard1 = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  properties = {
    --    airdrag            = 0.93,
    --    colormap           = [[1 0.55 0.45 1    0.55 0.44 0.38 1    0.36 0.34 0.33 1    0 0 0 0.01]],
    --    directional        = true,
    --    emitrot            = 15,
    --    emitrotspread      = 25,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, -0.3, 0]],
    --    numparticles       = [[10 r4.5]],
    --    particlelife       = 55,
    --    particlelifespread = 12,
    --    particlesize       = 3,
    --    particlesizespread = 5,
    --    particlespeed      = 7.5,
    --    particlespeedspread = 14,
    --    pos                = [[0, 2, 0]],
    --    sizegrowth         = 0,
    --    sizemod            = 1,
    --    texture            = [[shard1]],
    --    useairlos          = false,
    --  },
    --},
    --shard2 = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  properties = {
    --    airdrag            = 0.93,
    --    colormap           = [[1 0.55 0.45 1    0.55 0.44 0.38 1    0.36 0.34 0.33 1    0 0 0 0.01]],
    --    directional        = true,
    --    emitrot            = 15,
    --    emitrotspread      = 25,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, -0.3, 0]],
    --    numparticles       = [[10 r4.5]],
    --    particlelife       = 55,
    --    particlelifespread = 12,
    --    particlesize       = 3,
    --    particlesizespread = 5,
    --    particlespeed      = 7.5,
    --    particlespeedspread = 14,
    --    pos                = [[0, 2, 0]],
    --    sizegrowth         = 0,
    --    sizemod            = 1,
    --    texture            = [[shard2]],
    --    useairlos          = false,
    --  },
    --},
    --shard3 = {
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  properties = {
    --    airdrag            = 0.93,
    --    colormap           = [[1 0.55 0.45 1    0.55 0.44 0.38 1    0.36 0.34 0.33 1    0 0 0 0.01]],
    --    directional        = true,
    --    emitrot            = 15,
    --    emitrotspread      = 25,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, -0.3, 0]],
    --    numparticles       = [[10 r4.5]],
    --    particlelife       = 55,
    --    particlelifespread = 12,
    --    particlesize       = 3,
    --    particlesizespread = 5,
    --    particlespeed      = 7.5,
    --    particlespeedspread = 14,
    --    pos                = [[0, 2, 0]],
    --    sizegrowth         = 0,
    --    sizemod            = 1,
    --    texture            = [[shard3]],
    --    useairlos          = false,
    --  },
    --},
    clouddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[0 0 0 0.01  0.022 0.022 0.022 0.03  0.05 0.05 0.05 0.068  0.042 0.042 0.042 0.052  0.023 0.023 0.023 0.028  0 0 0 0.01]],
        directional        = false,
        emitrot            = 45,
        emitrotspread      = 4,
        emitvector         = [[0.5, 1.35, 0.5]],
        gravity            = [[0, 0.03, 0]],
        numparticles       = 10,
        particlelife       = 70,
        particlelifespread = 500,
        particlesize       = 100,
        particlesizespread = 100,
        particlespeed      = 3,
        particlespeedspread = 4,
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.35,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    grounddust = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      unit               = false,
      properties = {
        airdrag            = 0.92,
        colormap           = [[0.07 0.07 0.07 0.1 	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = -2,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.03, 0]],
        numparticles       = 150,
        particlelife       = 15,
        particlelifespread = 130,
        particlesize       = 11,
        particlesizespread = 5,
        particlespeed      = 9,
        particlespeedspread = 4,
        pos                = [[0, 5, 0]],
        sizegrowth         = 0.18,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke]],
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        heat               = 20,
        heatfalloff        = 1.3,
        maxheat            = 60,
        pos                = [[r-2 r2, 4, r-2 r2]],
        size               = 36,
        sizegrowth         = 1.2,
        speed              = [[0, 1 0, 0]],
        texture            = [[orangenovaexplo]],
      },
    },
  },

}

