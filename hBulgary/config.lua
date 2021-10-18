Config = {

    stealzone = {
        { 
            name = "Appartement",
            Enter = vector3(96.49, -239.7915, 51.399), hEnter = 350.0,
            Exit = vector3(346.52, -1012.8, -99.2), hExit = 180.0,
            MaxStealTime = 20,-- en seconde
            lockpicktime = 5, -- en seconde
            Objects = {
                {
                    name = "Television",
                    pos = vector3(338.1217, -996.578, -99.19624), hObj = 90.0,
                    time = 5,-- en seconde
                    Item = "tv"
                },
                {
                    name = "Tableau",
                    pos = vector3(347.11, -998.25, -99.196), hObj = 360.0,
                    time = 5,-- en seconde
                    Item = "table"
                },
                {
                    name = "Bijoux",
                    pos = vector3(351.56, -999.21, -99.196), hObj = 180.0,
                    time = 3,-- en seconde
                    Item = "jewelry"
                }
            },
        },
        { 
            name = "Appartement nul",
            Enter = vector3(312.92, -218.79, 58.01), hEnter = 155.0,
            Exit = vector3(266.11, -1007.18, -101.012), hExit = 180.0,
            MaxStealTime = 20,-- en seconde
            lockpicktime = 5,-- en seconde
            Objects = {
                {
                    name = "Téléphone",
                    pos = vector3(262.8, -1002.941, -99.0), hObj = 280.0,
                    time = 4,-- en seconde
                    Item = "robbedphone"
                },
                {
                    name = "Bang",
                    pos = vector3(259.04, -995.92, -99.0), hObj = 170.0,
                    time = 3,-- en seconde
                    Item = "bang"
                }
            },
        },
    },

    vendor = {
        position = vector3(885.0, -953.00, 39.2133)
    },

    SellPrice = {
        -- name = prix, 
        robbedphone = 600,
        jewelry = 750,
        table =  1250,
        bang = 250,
        tv = 1000
    }
}
