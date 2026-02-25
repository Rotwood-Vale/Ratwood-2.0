#define QUEST_COOLDOWN_DS (30*60*10)
#define QUEST_REWARD_FAVOR 150

#define CLERIC_PRICE_PATRON 1
#define CLERIC_PRICE_FOREIGN 3

#define MIRACLE_MP_PRICE_FLAVOR 250
#define RESEARCH_RP_PRICE_FLAVOR 100
#define ARTEFACT_PRICE_FAVOR 500

#define COST_ARTEFACTS 5
#define COST_ORG_T1 5
#define COST_ORG_T2 5
#define COST_ORG_T3 5

#define ORG_PRICE_T1 500
#define ORG_PRICE_T2 1000
#define ORG_PRICE_T3 1500

/mob/living/carbon/human
	var/miracle_points = 0
	var/church_favor = 0
	var/personal_research_points = 0
	var/unlocked_research_artefacts = FALSE
	var/unlocked_research_org_t1 = FALSE
	var/unlocked_research_org_t2 = FALSE
	var/unlocked_research_org_t3 = FALSE
	var/list/patron_relations = null
	var/list/quest_ui_entries = null
	var/quest_reroll_charges = 0
	var/quest_reroll_last_ds = 0

var/global/list/divine_miracles_cache = list()
var/global/list/inhumen_miracles_cache = list()
var/global/miracle_caches_built = FALSE

var/global/list/divine_patrons_index = list()
var/global/list/inhumen_patrons_index = list()
var/global/divine_patrons_built = FALSE
var/global/inhumen_patrons_built = FALSE

var/global/list/PATRON_ARTIFACTS = list(
	"Astrata" = list(/obj/item/artifact/astrata_star),
	"Dendor"  = list(/obj/item/artefact/dendor_hose),
	"Abyssor" = list(/obj/item/fishingrod/abyssoid),
	"Ravox"   = list(/obj/item/artifact/ravox_lens),
	"Necra"   = list(/obj/item/artefact/necra_censer),
	"Pestra"  = list(/obj/item/rogueweapon/surgery/multitool, /obj/item/needle/pestra, /obj/item/natural/worms/leech/cheele),
	"Malum"   = list(/obj/item/rogueweapon/hammer/artefact/malum),
	"Eora"    = list(/obj/item/artefact/eora_heart),
)

/proc/build_miracle_caches()
	if(miracle_caches_built) return
	build_cache_for_root(/datum/patron/divine, divine_miracles_cache)
	build_cache_for_root(/datum/patron/inhumen, inhumen_miracles_cache)
	miracle_caches_built = TRUE

/proc/build_cache_for_root(root_type, list/cache)
	for(var/p_type in typesof(root_type))
		if(p_type == root_type) continue
		var/datum/patron/P = new p_type
		if(P && length(P.miracles))
			for(var/st in P.miracles)
				cache[st] = TRUE
		qdel(P)

/proc/build_divine_patrons_index()
	if(divine_patrons_built) return
	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine) continue
		var/datum/patron/P = new p_type
		if(P && P.name)
			var/domain = ""; if("domain" in P.vars) domain = "[P.vars["domain"]]"
			var/desc = ""; if("desc" in P.vars) desc = "[P.vars["desc"]]"
			divine_patrons_index["[P.name]"] = list("path"=p_type, "domain"=domain, "desc"=desc)
		qdel(P)
	divine_patrons_built = TRUE

/proc/build_inhumen_patrons_index()
	if(inhumen_patrons_built) return
	for(var/p_type in typesof(/datum/patron/inhumen))
		if(p_type == /datum/patron/inhumen) continue
		var/datum/patron/P = new p_type
		if(P && P.name)
			var/domain = ""; if("domain" in P.vars) domain = "[P.vars["domain"]]"
			var/desc = ""; if("desc" in P.vars) desc = "[P.vars["desc"]]"
			inhumen_patrons_index["[P.name]"] = list("path"=p_type, "domain"=domain, "desc"=desc)
		qdel(P)
	inhumen_patrons_built = TRUE

/proc/get_spell_patron_names(spell_input)
	var/spell_path = null
	if(ispath(spell_input)) spell_path = spell_input
	else if(istype(spell_input, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/SN = spell_input
		spell_path = SN.type
	else
		return list()

	var/list/result = list()

	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		var/list/rec = divine_patrons_index[n]; if(!islist(rec)) continue
		var/p_type = rec["path"]; if(!p_type) continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			if(!(n in result)) result += "[n]"
		qdel(P)

	build_inhumen_patrons_index()
	for(var/n2 in inhumen_patrons_index)
		var/list/rec2 = inhumen_patrons_index[n2]; if(!islist(rec2)) continue
		var/p2 = rec2["path"]; if(!p2) continue
		var/datum/patron/P2 = new p2
		if(P2 && islist(P2.miracles) && (spell_path in P2.miracles))
			if(!(n2 in result)) result += "[n2]"
		qdel(P2)

	return result

/proc/_tier_from_patrons(spell_path)
	if(!ispath(spell_path, /obj/effect/proc_holder/spell)) return 0
	var/max_tier = 0

	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine) continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			var/v = P.miracles[spell_path]
			if(isnum(v)) max_tier = max(max_tier, v)
		qdel(P)

	for(var/p_type2 in typesof(/datum/patron/inhumen))
		if(p_type2 == /datum/patron/inhumen) continue
		var/datum/patron/P2 = new p_type2
		if(P2 && islist(P2.miracles) && (spell_path in P2.miracles))
			var/v2 = P2.miracles[spell_path]
			if(isnum(v2)) max_tier = max(max_tier, v2)
		qdel(P2)

	if(max_tier < 0) max_tier = 0
	if(max_tier > 4) max_tier = 4
	return max_tier

/proc/get_spell_tier(spell_any)
	var/obj/effect/proc_holder/spell/S = null
	var/spell_path = null

	if(istype(spell_any, /obj/effect/proc_holder/spell))
		S = spell_any
		spell_path = S.type
	else if(ispath(spell_any))
		spell_path = spell_any
	else
		return 0

	var/obj/effect/proc_holder/spell/tmp = S
	if(!tmp && spell_path) tmp = new spell_path

	var/tier_val = 0
	if(tmp)
		var/list/v = tmp.vars
		if(islist(v))
			if("tier" in v)
				var/tt = v["tier"]; if(isnum(tt)) tier_val = tt
			if(!tier_val && ("miracle_tier" in v))
				var/mt = v["miracle_tier"]; if(isnum(mt)) tier_val = mt

	if(!S && tmp) qdel(tmp)

	if(tier_val <= 0 && spell_path) tier_val = _tier_from_patrons(spell_path)
	if(!isnum(tier_val)) tier_val = 0
	if(tier_val < 0) tier_val = 0
	if(tier_val > 4) tier_val = 4
	return tier_val

/proc/allowed_tier_by_relation(level)
	if(!isnum(level) || level <= 0) return 0
	if(level == 1) return 1
	if(level == 2) return 2
	if(level == 3) return 3
	return 4

/obj/effect/proc_holder/spell/self/learnmiracle
	name = "Miracles"
	desc = "Open miracle UI."

	proc/_ensure_relations(mob/living/carbon/human/H)
		if(!H.patron_relations || !islist(H.patron_relations)) H.patron_relations = list()
		build_divine_patrons_index()
		for(var/n in divine_patrons_index)
			if(!(n in H.patron_relations)) H.patron_relations[n] = 0
		build_inhumen_patrons_index()
		if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
			var/myname = "[H.devotion.patron.vars["name"]]"
			if(length(myname)) H.patron_relations[myname] = 4
		for(var/n2 in inhumen_patrons_index)
			if(!(n2 in H.patron_relations)) H.patron_relations[n2] = 0

	proc/_update_reroll_charges(mob/living/carbon/human/H)
		if(!H) return
		if(!H.quest_reroll_last_ds) H.quest_reroll_last_ds = world.time
		var/delta = world.time - H.quest_reroll_last_ds
		if(delta < QUEST_COOLDOWN_DS) return
		var/add = round(delta / QUEST_COOLDOWN_DS)
		if(add > 0)
			H.quest_reroll_charges += add
			H.quest_reroll_last_ds += add * QUEST_COOLDOWN_DS

	proc/_build_learn_buckets(mob/living/carbon/human/H)
		if(!miracle_caches_built) build_miracle_caches()
		_ensure_relations(H)
		build_divine_patrons_index()
		build_inhumen_patrons_index()

		var/my_patron = ""
		if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
			my_patron = "[H.devotion.patron.vars["name"]]"

		var/list/already_types = list()
		if(H?.mind)
			for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
				already_types[K.type] = TRUE

		var/list/all_spell_types = list()
		for(var/st1 in divine_miracles_cache) all_spell_types[st1] = TRUE
		for(var/st2 in inhumen_miracles_cache) all_spell_types[st2] = TRUE

		var/list/buckets = list()

		for(var/st in all_spell_types)
			var/obj/effect/proc_holder/spell/S = new st
			if(!S) continue

			var/tier = get_spell_tier(S)
			var/list/owners = get_spell_patron_names(st)
			if(!islist(owners) || !owners.len)
				if(length(my_patron)) owners = list(my_patron)
				else owners = list()

			for(var/owner_name in owners)
				var/owner_rel = (owner_name == my_patron) ? 4 : (H.patron_relations && (owner_name in H.patron_relations) ? H.patron_relations[owner_name] : 0)
				var/max_allowed = allowed_tier_by_relation(owner_rel)
				if(tier > max_allowed) continue

				if(!(owner_name in buckets)) buckets[owner_name] = list()
				var/list/L = buckets[owner_name]

				var/is_learned = !!already_types[st]
				var/cost = (owner_name == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN

				L += list(list("name"=S.name, "desc"=S.desc, "tier"=tier, "cost"=cost, "type"="[st]", "learned"=is_learned))
				buckets[owner_name] = L

			qdel(S)

		return buckets

	ui_interact(mob/user, datum/tgui/ui)
		if(!istype(user, /mob/living/carbon/human)) return
		ui = SStgui.try_update_ui(user, src, ui)
		if(!ui)
			ui = new(user, src, "MiraclesUI", name)
			ui.open()

	ui_state(mob/user)
		return GLOB.always_state

	ui_static_data(mob/user)
		return list(
			"pages" = list(
				list("id"="learn", "label"="Learn", "icon"="book"),
				list("id"="research", "label"="Research", "icon"="flask"),
				list("id"="quests", "label"="Quests", "icon"="clipboard-list"),
				list("id"="upgrade", "label"="Upgrade", "icon"="arrow-up")
			),
			"MIRACLE_MP_PRICE_FLAVOR" = MIRACLE_MP_PRICE_FLAVOR,
			"RESEARCH_RP_PRICE_FLAVOR" = RESEARCH_RP_PRICE_FLAVOR
		)

	ui_data(mob/user)
		var/mob/living/carbon/human/H = user
		if(!H) return list()

		_ensure_relations(H)
		_update_reroll_charges(H)

		var/list/data = list()
		data["page"] = current_page
		data["favor"] = H.church_favor
		data["mp"] = H.miracle_points
		data["rp"] = H.personal_research_points
		data["is_fleshcrafter"] = HAS_TRAIT(H, TRAIT_FLESHCRAFTER)

		if(current_page == "learn")
			data["learn_tab"] = current_learn_tab
			data["learn_buckets"] = _build_learn_buckets(H)

		if(current_page == "research")
			data["unlocked_artefacts"] = H.unlocked_research_artefacts
			data["unlocked_org_t1"] = H.unlocked_research_org_t1
			data["unlocked_org_t2"] = H.unlocked_research_org_t2
			data["unlocked_org_t3"] = H.unlocked_research_org_t3

		if(current_page == "quests")
			if(!islist(H.quest_ui_entries) || H.quest_ui_entries.len < 1)
				H.quest_ui_entries = _rt_build_player_quest_set(H)
				if(!H.quest_reroll_last_ds) H.quest_reroll_last_ds = world.time
			data["quests"] = H.quest_ui_entries
			data["reroll_charges"] = H.quest_reroll_charges

		if(current_page == "upgrade")
			var/has_diag = FALSE
			var/has_diag_g = FALSE
			if(H?.mind)
				for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
					if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose)) has_diag = TRUE
					if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose/greater)) has_diag_g = TRUE
			data["has_diag"] = has_diag
			data["has_diag_g"] = has_diag_g

		return data

	ui_act(action, list/params, datum/tgui/ui, mob/user)
		. = ..()
		if(.) return
		var/mob/living/carbon/human/H = user
		if(!H) return

		_ensure_relations(H)

		switch(action)
			if("set_page")
				var/p = "[params["page"]]"
				if(p in list("home","learn","research","quests","upgrade")) current_page = p
				return TRUE

			if("learn_set_tab")
				current_learn_tab = "[params["tab"]]"
				return TRUE

			if("learn_spell")
				var/typepath = text2path("[params["type"]]")
				if(ispath(typepath, /obj/effect/proc_holder/spell))
					_tgui_learn_spell(H, typepath)
				return TRUE

			if("buy_rp")
				if(HAS_TRAIT(H, TRAIT_FLESHCRAFTER) && H.church_favor >= RESEARCH_RP_PRICE_FLAVOR)
					H.church_favor = max(0, H.church_favor - RESEARCH_RP_PRICE_FLAVOR)
					H.personal_research_points++
				return TRUE

			if("buy_mp")
				if(HAS_TRAIT(H, TRAIT_FLESHCRAFTER) && H.church_favor >= MIRACLE_MP_PRICE_FLAVOR)
					H.church_favor = max(0, H.church_favor - MIRACLE_MP_PRICE_FLAVOR)
					H.miracle_points++
				return TRUE

			if("quests_reroll")
				_update_reroll_charges(H)
				if(H.quest_reroll_charges > 0)
					H.quest_ui_entries = _rt_build_player_quest_set(H)
					H.quest_reroll_charges = max(0, H.quest_reroll_charges - 1)
				return TRUE

			if("quests_spawn")
				var/q_index = text2num("[params["index"]]")
				var/diff_key = lowertext("[params["diff"]]")
				_tgui_spawn_quest_item(H, q_index, diff_key)
				return TRUE

			if("upgrade_diag")
				_tgui_upgrade_diagnose(H)
				return TRUE

		return FALSE

	proc/_tgui_learn_spell(mob/living/carbon/human/H, typepath)
		var/obj/effect/proc_holder/spell/S = new typepath
		if(!S) return

		if(H?.mind)
			for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
				if(K.type == typepath)
					qdel(S)
					return

		var/my_patron = ""
		if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
			my_patron = "[H.devotion.patron.vars["name"]]"

		var/tier = get_spell_tier(S)
		var/list/owners = get_spell_patron_names(typepath)

		var/real_owner = ""
		if(length(my_patron) && islist(owners) && (my_patron in owners))
			real_owner = my_patron
		else if(islist(owners) && owners.len)
			var/best_name = ""
			var/best_rel = -1
			for(var/on in owners)
				if(!istext(on)) continue
				var/r = (H.patron_relations && (on in H.patron_relations) && isnum(H.patron_relations[on])) ? H.patron_relations[on] : 0
				if(r > best_rel)
					best_rel = r
					best_name = "[on]"
			real_owner = best_name
		else
			real_owner = my_patron

		if(!istext(real_owner) || !length(real_owner))
			qdel(S)
			return

		var/owner_rel = (real_owner == my_patron) ? 4 : (H.patron_relations && (real_owner in H.patron_relations) ? H.patron_relations[real_owner] : 0)
		var/max_allowed = allowed_tier_by_relation(owner_rel)
		if(tier > max_allowed)
			qdel(S)
			return

		var/cost = (real_owner == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN
		if(H.miracle_points < cost)
			qdel(S)
			return

		H.miracle_points = max(0, H.miracle_points - cost)
		H.mind.AddSpell(S)
		return

	proc/_tgui_spawn_quest_item(mob/living/carbon/human/H, q_index, diff_key)
		if(!isnum(q_index) || q_index < 1 || q_index > (H.quest_ui_entries?.len || 0)) return
		var/list/slot = H.quest_ui_entries[q_index]; if(!islist(slot)) return
		var/list/diffs = slot["difficulties"]; if(!islist(diffs) || !(diff_key in diffs)) return

		var/accepted_diff = slot["accepted_diff"]; if(!istext(accepted_diff)) accepted_diff = ""
		if(length(accepted_diff) && accepted_diff != diff_key) return

		var/list/D = diffs[diff_key]; if(!islist(D)) return
		if(D["spawned"]) return

		var/typepath = D["token_path"]; if(!typepath) return
		var/obj/item/quest_token/QI = new typepath(H); if(!QI) return

		var/success = FALSE
		if(ismob(H) && hascall(H, "put_in_hands")) success = call(H, "put_in_hands")(QI)
		if(!success)
			var/turf/TT = get_turf(H)
			if(TT) QI.forceMove(TT)

		if(istype(QI, /obj/item/quest_token))
			var/obj/item/quest_token/QBASE = QI
			if(D["reward"]) QBASE.reward_amount = D["reward"]

		var/list/P = D["params"]
		if(islist(P))
			if(istype(QI, /obj/item/quest_token/coin_chest))
				var/obj/item/quest_token/coin_chest/CC = QI
				if(P["required_sum"]) CC.required_sum = P["required_sum"]
			if(istype(QI, /obj/item/quest_token/skill_bless))
				var/obj/item/quest_token/skill_bless/SK = QI
				if(P["required_skills"]) SK.required_skills = P["required_skills"]
			if(istype(QI, /obj/item/quest_token/blood_draw))
				var/obj/item/quest_token/blood_draw/BD = QI
				if(P["required_race_keys"]) BD.required_race_keys = P["required_race_keys"]
			if(istype(QI, /obj/item/quest_token/ration_delivery))
				var/obj/item/quest_token/ration_delivery/RD = QI
				if(P["required_job_types"]) RD.required_job_types = P["required_job_types"]
			if(istype(QI, /obj/item/quest_token/donation_box))
				var/obj/item/quest_token/donation_box/DB = QI
				if(P["need_types"]) DB.need_types = P["need_types"]
			if(istype(QI, /obj/item/quest_token/sermon_minor))
				var/obj/item/quest_token/sermon_minor/SM = QI
				if(P["required_patron_names"]) SM.required_patron_names = P["required_patron_names"]
			if(istype(QI, /obj/item/quest_token/reliquary))
				var/obj/item/quest_token/reliquary/RL = QI
				if(P["bonus_patron_names"]) RL.bonus_patron_names = P["bonus_patron_names"]
			if(istype(QI, /obj/item/quest_token/flaw_aid))
				var/obj/item/quest_token/flaw_aid/FA = QI
				if(P["required_flaw_types"]) FA.required_flaw_types = P["required_flaw_types"]

		D["spawned"] = TRUE
		diffs[diff_key] = D
		slot["accepted_diff"] = diff_key
		slot["difficulties"] = diffs
		H.quest_ui_entries[q_index] = slot
		return

	proc/_tgui_upgrade_diagnose(mob/living/carbon/human/H)
		if(!H?.mind) return
		if(H.miracle_points < 2) return

		var/obj/effect/proc_holder/spell/baseS = null
		var/obj/effect/proc_holder/spell/greaterS = null

		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose)) baseS = S
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose/greater)) greaterS = S

		if(greaterS || !baseS) return

		if(hascall(H.mind, "RemoveSpell")) call(H.mind, "RemoveSpell")(baseS)
		else qdel(baseS)

		var/obj/effect/proc_holder/spell/invoked/diagnose/greater/N = new
		H.mind.AddSpell(N)
		H.miracle_points = max(0, H.miracle_points - 2)
		return

	cast(list/targets, mob/user)
		if(!..()) return
		if(!user) return
		ui_interact(user, null)
		return
