Config = {}

Config.WantedSystemActive  = true
Config.OutlawTriggerAmount = 100
Config.UpdateInterval = 1
Config.ClearWantedOnDeath = true -- Clear outlaw status when player dies

---------------------------------
-- discord webhook settings
---------------------------------
Config.Discord = {
    Enabled = true,
    WebhookURL = '', -- Add your webhook URL here
    BotName = 'Wanted System',
    BotAvatar = '', -- Optional avatar URL
    Color = 16711680, -- Red color (decimal)
    
    -- Event toggles
    LogOutlawStatus = true, -- Log when player becomes wanted
    LogStatusCleared = true, -- Log when wanted status is cleared
    LogThresholdReached = true, -- Log when outlaw trigger amount is reached
}

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 100.0
Config.FadeIn = false -- disabled for performance
Config.MaxSpawnedPedsPerPlayer = 10 -- prevent resource exhaustion
Config.LocationCheckInterval = 1000 -- ms between location checks (was 500)
Config.StatusCheckInterval = 10000 -- ms between outlaw status checks (was 5000)
Config.NearbyLocationRange = 300.0 -- only check locations within this range

---------------------------------
-- npc locations
---------------------------------
Config.BanditLocations = {

    {
        coords = vector3(1890.96, -1870.35, 43.15),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1890.96, -1870.35, 43.15, 155.61),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1862.92, -1878.16, 42.69),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1862.92, -1878.16, 42.69, 276.46),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1869.49, -1846.49, 42.65),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1869.49, -1846.49, 42.65, 36.58),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1874.18, -1838.72, 42.52),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1874.18, -1838.72, 42.52, 76.89),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-279.79, 799.01, 119.34),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-279.79, 799.01, 119.34, 169.41),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-276.11, 799.30, 119.35),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-276.11, 799.30, 119.35, 190.03),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-334.77, 776.93, 116.11),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-334.77, 776.93, 116.11, 71.89),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-186.47, 640.14, 113.57),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-186.47, 640.14, 113.57, 6.94),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1432.82, 359.05, 89.01),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1432.82, 359.05, 89.01, 258.59),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1418.40, 378.67, 90.32),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1418.40, 378.67, 90.32, 267.50),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(499.76, 579.38, 109.47),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(499.76, 579.38, 109.47, 319.13),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(495.73, 581.15, 109.40),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(495.73, 581.15, 109.40, 324.25),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2526.86, 809.45, 74.66),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(2526.86, 809.45, 74.66, 49.92),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2537.38, 817.13, 75.47),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(2537.38, 817.13, 75.47, 92.98),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2548.19, 785.17, 75.74),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(2548.19, 785.17, 75.74, 68.50),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2990.00, 569.32, 44.47),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(2990.00, 569.32, 44.47, 206.78),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(3009.66, 561.40, 44.65),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(3009.66, 561.40, 44.65, 112.17),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(3019.72, 1347.95, 42.72),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(3019.72, 1347.95, 42.72, 63.28),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-812.91, -1328.31, 43.67),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-812.91, -1328.31, 43.67, 164.03),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-791.77, -1310.69, 43.61),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-791.77, -1310.69, 43.61, 99.51),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-817.18, -1279.23, 43.64),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-817.18, -1279.23, 43.64, 293.82),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-724.12, -1250.78, 44.73),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-724.12, -1250.78, 44.73, 114.98),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-740.85, -1258.82, 44.73),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-740.85, -1258.82, 44.73, 309.10),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-2352.71, -2368.67, 62.16),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-2352.71, -2368.67, 62.16, 126.69),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-3710.62, -2597.20, -13.30),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-3710.62, -2597.20, -13.30, 81.30),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-3662.54, -2617.30, -13.83),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-3662.54, -2617.30, -13.83, 6.95),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-3626.42, -2605.82, -13.35),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-3626.42, -2605.82, -13.35, 123.88),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-5508.81, -2958.47, -1.57),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-5508.81, -2958.47, -1.57, 18.02),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-5526.39, -2930.67, -2.00),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-5526.39, -2930.67, -2.00, 220.97),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-5501.97, -2885.83, -5.02),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-5501.97, -2885.83, -5.02, 184.15),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1981.10, -1641.46, 117.14),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1981.10, -1641.46, 117.14, 189.91),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1991.21, -1607.16, 118.14),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1991.21, -1607.16, 118.14, 263.36),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1961.02, -1620.55, 116.01),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1961.02, -1620.55, 116.01, 307.61),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1804.29, -349.06, 164.15),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1804.29, -349.06, 164.15, 246.56),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1763.30, -392.27, 156.415),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1763.30, -392.27, 156.41, 153.25),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1771.62, -437.45, 155.09),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1771.62, -437.45, 155.09, 67.86),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1828.43, -431.25, 159.85),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1828.43, -431.25, 159.85, 355.67),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1006.64, -553.89, 99.62),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1006.64, -553.89, 99.62, 321.98),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1308.18, -1295.67, 75.91),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1308.18, -1295.67, 75.91, 156.59),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1355.84, -1309.29, 76.93),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1355.84, -1309.29, 76.93, 105.28),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1364.98, -1357.00, 78.27),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1364.98, -1357.00, 78.27, 313.91),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1308.28, -1348.89, 77.67),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1308.28, -1348.89, 77.67, 42.70),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1421.35, -1367.20, 81.75),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1421.35, -1367.20, 81.75, 71.63),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1334.73, -1380.39, 80.49),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1334.73, -1380.39, 80.49, 175.42),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1279.92, -1343.68, 77.51),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1279.92, -1343.68, 77.51, 338.41),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1213.32, -1291.27, 76.91),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1213.32, -1291.27, 76.91, 327.54),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(1271.80, -1201.34, 82.73),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(1271.80, -1201.34, 82.73, 212.60),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(-1301.32, 387.52, 95.29),
        npcmodel = `a_m_m_valdeputyresident_01`,
        npccoords = vector4(-1301.32, 387.52, 95.29, 253.38),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2861.25, -1235.96, 46.34),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2861.25, -1235.96, 46.34, 261.28),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2842.63, -1229.61, 47.67),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2842.63, -1229.61, 47.67, 76.81),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2814.18, -1231.43, 47.55),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2814.18, -1231.43, 47.55, 68.16),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2807.44, -1323.22, 46.45),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2807.44, -1323.22, 46.45, 76.21),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2742.84, -1393.47, 46.18),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2742.84, -1393.47, 46.18, 158.50),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2662.03, -1492.63, 45.97),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2662.03, -1492.63, 45.97, 188.89),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2676.17, -1550.51, 45.97),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2676.17, -1550.51, 45.97, 32.74),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2509.62, -1466.24, 46.33),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2509.62, -1466.24, 46.33, 189.25),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },
    {
        coords = vector3(2641.73, -787.18, 42.36),
        npcmodel = `s_m_m_dispatchpolice_01`,
        npccoords = vector4(2641.73, -787.18, 42.36, 359.96),
        npcweapon = `weapon_revolver_schofield`,
        npcwander = 50.0,
    },

}
