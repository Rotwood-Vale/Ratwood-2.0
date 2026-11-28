SUBSYSTEM_DEF(treesetup)
	name = "treesetup"
	ss_flags = SS_NO_FIRE

	var/list/initialize_me = list()

/datum/controller/subsystem/treesetup/Initialize()
	InitializeTrees()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/treesetup/proc/InitializeTrees()
	// some of these are actually newtreealt, which has the same procs
	// i hate this so much
	for(var/obj/structure/flora/newtree/T as anything in initialize_me)
		T.build_branches()
		CHECK_TICK

	for(var/obj/structure/flora/newtree/T as anything in initialize_me)
		T.build_leafs()
		CHECK_TICK

	initialize_me.Cut()
