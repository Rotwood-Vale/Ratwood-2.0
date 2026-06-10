SUBSYSTEM_DEF(custom_bootstrap)
	name = "Custom Bootstrap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT

/proc/get_custom_admin_verbs()
	return list(
		/client/proc/adminspell,
		/client/proc/removeadminspell,
		/client/proc/bless,
		/client/proc/god,
	)

/datum/controller/subsystem/custom_bootstrap/Initialize(timeofday)
	. = ..()
	if(!islist(GLOB.learnable_spells))
		GLOB.learnable_spells = list()
	if(GLOB.custom_learnable_spells?.len)
		GLOB.learnable_spells |= GLOB.custom_learnable_spells

	var/list/custom_admin_verbs = get_custom_admin_verbs()
	if(islist(GLOB.admin_verbs_admin))
		GLOB.admin_verbs_admin |= custom_admin_verbs
	if(islist(GLOB.admin_verbs_hideable))
		GLOB.admin_verbs_hideable |= custom_admin_verbs

	for(var/client/admin_client in GLOB.admins)
		if(!admin_client?.holder)
			continue
		admin_client.remove_admin_verbs()
		admin_client.add_admin_verbs()
