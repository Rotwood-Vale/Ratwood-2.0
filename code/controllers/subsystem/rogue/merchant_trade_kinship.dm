// Ratwood deviation: AP uses /datum/virtue/origin/O with an origin_name var; ES keeps origin virtues
// as flat /datum/virtue/<subtype> and exposes the display name via the base .name var instead.
// See code/modules/client/preferences.dm (virtue_origin) and modular_azurepeak/_virtue.dm.

/datum/controller/subsystem/merchant_trade/proc/origin_name_to_realm_id(origin_name)
	if(!origin_name)
		return null
	switch(origin_name)
		if("Avar")
			return REALM_AAVNR
		if("Raneshan")
			return REALM_RANESHEN
		if("Grenzelhoft")
			return REALM_GRENZELHOFT
		if("Otava")
			return REALM_OTAVA
		if("Kazengun")
			return REALM_KAZENGUN
		if("Hammerhold")
			return REALM_HAMMERHOLD
		if("Etrusca")
			return REALM_ETRUSCA
		if("Gronn")
			return REALM_GRONN
		if("Lirvas")
			return REALM_LIRVAS
		if("Lingyue")
			return REALM_LINGYUE
		if("Naledi")
			return REALM_NALEDI
	return null

/datum/controller/subsystem/merchant_trade/proc/try_claim_kinship_for(mob/living/carbon/human/H)
	if(!H?.client?.prefs)
		return
	// Ratwood deviation: no origin virtue slot; match either picked virtue against the realm table
	var/datum/virtue/O = H.client.prefs.virtue
	var/new_realm = istype(O) ? origin_name_to_realm_id(O.name) : null
	if(!new_realm)
		O = H.client.prefs.virtuetwo
		if(istype(O))
			new_realm = origin_name_to_realm_id(O.name)
	if(new_realm == current_kinship_realm)
		return
	current_kinship_realm = new_realm
	current_kinship_origin_name = new_realm ? O.name : null
	if(new_realm && (new_realm in realms))
		ensure_kin_ship_available(new_realm)

/datum/controller/subsystem/merchant_trade/proc/ensure_kin_ship_available(realm_id)
	var/list/available_kin = list()
	var/list/available_other = list()
	for(var/datum/trade_ship/ship in all_ships)
		if(ship.dock_state != TRADE_SHIP_STATE_AVAILABLE)
			continue
		if(ship.realm_id == realm_id)
			available_kin += ship
		else
			available_other += ship
	if(length(available_kin))
		return
	if(!length(available_other))
		generate_ship(realm_id)
		return
	var/datum/trade_ship/swap_out = pick(available_other)
	all_ships -= swap_out
	qdel(swap_out)
	generate_ship(realm_id)

/datum/controller/subsystem/merchant_trade/proc/get_kinship_sell_mult(realm_id)
	if(realm_id && current_kinship_realm && realm_id == current_kinship_realm)
		return KINSHIP_SELL_MULT
	return 1

/datum/controller/subsystem/merchant_trade/proc/get_kinship_buy_mult(realm_id)
	if(realm_id && current_kinship_realm && realm_id == current_kinship_realm)
		return KINSHIP_BUY_MULT
	return 1

/datum/controller/subsystem/merchant_trade/proc/get_agent_kinship_buy_mult(realm_id, mob/living/carbon/human/H)
	if(!realm_id || !ishuman(H))
		return 1
	var/is_agent = (H.job == "Shophand") || HAS_TRAIT(H, TRAIT_AGENT_MERCHANT)
	if(!is_agent || !H.client?.prefs)
		return 1
	var/agent_realm = get_pref_origin_realm(H)
	if(!agent_realm)
		return 1
	if(agent_realm && agent_realm == realm_id)
		return KINSHIP_BUY_MULT
	return 1

/datum/controller/subsystem/merchant_trade/proc/get_effective_buy_mult(realm_id, mob/user)
	return min(get_kinship_buy_mult(realm_id), get_agent_kinship_buy_mult(realm_id, user))

/datum/controller/subsystem/merchant_trade/proc/get_agent_personal_kinship_realm(mob/living/carbon/human/H)
	if(!ishuman(H) || !H.client?.prefs)
		return null
	var/is_agent = (H.job == "Shophand") || HAS_TRAIT(H, TRAIT_AGENT_MERCHANT)
	if(!is_agent)
		return null
	return get_pref_origin_realm(H)

// Ratwood deviation: no dedicated origin-virtue pref slot; derive a realm from either picked virtue.
/datum/controller/subsystem/merchant_trade/proc/get_pref_origin_realm(mob/living/carbon/human/H)
	if(!H?.client?.prefs)
		return null
	var/datum/virtue/O = H.client.prefs.virtue
	var/realm = istype(O) ? origin_name_to_realm_id(O.name) : null
	if(!realm)
		O = H.client.prefs.virtuetwo
		if(istype(O))
			realm = origin_name_to_realm_id(O.name)
	return realm
