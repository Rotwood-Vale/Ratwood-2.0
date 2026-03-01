//Used prevent coords collection/prefiring. See: World.dm
GLOBAL_VAR(obfs_x) //A number between -2500 and 2500
GLOBAL_VAR(obfs_y) //A number between -2500 and 2500
//Offuscate x for coord system
#define obfuscate_x(x) (x + GLOB.obfs_x)
//Offuscate y for coord system
#define obfuscate_y(y) (y + GLOB.obfs_y)
//Deoffuscate x for coord system
#define deobfuscate_x(x) (x - GLOB.obfs_x)
//Deoffuscate y for coord system
#define deobfuscate_y(y) (y - GLOB.obfs_y)
//Used to prevent coords collection/prefiring.
var/global/obfs_x = 0 //A number between -500 and 500
var/global/obfs_y = 0 //A number between -500 and 500
