#ifndef TESTING
//    #define FASTLOAD
//    #define DEPLOY_TEST
//    #define ROGUEWORLD
//    #define RATWORLD // Uncomment to force Ratworld map (uses _maps/ratworld.json)
#endif

#ifdef FASTLOAD
    #ifdef RATWORLD
        #define FORCE_MAP "_maps/ratworld.json"
    #else
        #define FORCE_MAP "_maps/roguetest.json"
    #endif
// #else
//     #define FORCE_MAP "_maps/blackstone.json"
#endif

//#define WARTIME
