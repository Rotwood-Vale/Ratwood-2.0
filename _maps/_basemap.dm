//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.
#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		// just the basic map, none of the extra levels
		#include "map_files\roguetest\roguetest.dmm"
		#include "map_files\deserttown\deserttown.dmm"
		#include "map_files\dun_world\dun_world.dmm"
		#include "map_files\rockhill\rockhill.dmm"
		#include "map_files\byos\byos.dmm"
	#endif

	#ifdef ALL_TEMPLATES
		#include "templates.dm"
	#endif
#endif
