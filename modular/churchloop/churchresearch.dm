#ifdef MIRACLE_RADIAL_DMI
#undef MIRACLE_RADIAL_DMI
#endif
#define MIRACLE_RADIAL_DMI 'icons/mob/actions/roguespells.dmi'

#ifndef QUEST_COOLDOWN_DS
#define QUEST_COOLDOWN_DS (10*60*20)
#endif

#ifndef CLERIC_PRICE_PATRON
#define CLERIC_PRICE_PATRON 1
#endif
#ifndef CLERIC_PRICE_FOREIGN
#define CLERIC_PRICE_FOREIGN 3
#endif

#ifndef MIRACLE_MP_PRICE_FLAVOR
#define MIRACLE_MP_PRICE_FLAVOR 200
#endif
#ifndef RESEARCH_RP_PRICE_FLAVOR
#define RESEARCH_RP_PRICE_FLAVOR 100
#endif

#ifndef RESEARCH_UNLOCK_FAVOR
#define RESEARCH_UNLOCK_FAVOR 500
#endif
#ifndef ARTEFACT_PRICE_FAVOR
#define ARTEFACT_PRICE_FAVOR 500
#endif

#ifndef PESTRA_ORGAN_T1_PRICE_FAVOR
#define PESTRA_ORGAN_T1_PRICE_FAVOR 500
#endif
#ifndef PESTRA_ORGAN_T2_PRICE_FAVOR
#define PESTRA_ORGAN_T2_PRICE_FAVOR 1000
#endif
#ifndef PESTRA_ORGAN_T3_PRICE_FAVOR
#define PESTRA_ORGAN_T3_PRICE_FAVOR 1500
#endif

#ifndef NOC_SECRET_MP_COST
#define NOC_SECRET_MP_COST 3
#endif

/mob/living/carbon/human
	var/miracle_points = 0
	var/church_favor = 0
	var/personal_research_points = 0

	var/unlocked_research_noc_secrets = FALSE
	var/unlocked_research_pestra_fleshcraft = FALSE
	var/unlocked_research_malum_craft = FALSE
	var/unlocked_research_zizo_forbidden = FALSE

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
	"Noc"     = list(/obj/item/artefact/noc_phylactery),
	"Dendor"  = list(/obj/item/artefact/dendor_hose),
	"Abyssor" = list(/obj/item/fishingrod/abyssoid),
	"Ravox"   = list(/obj/item/artifact/ravox_lens),
	"Necra"   = list(/obj/item/artefact/necra_censer),
	"Xylix"   = list(/obj/item/clothing/gloves/xylix),
	"Pestra"  = list(/obj/item/rogueweapon/surgery/multitool, /obj/item/needle/pestra, /obj/item/natural/worms/leech/cheele),
	"Malum"   = list(/obj/item/rogueweapon/hammer/artefact/malum),
	"Eora"    = list(/obj/item/artefact/eora_heart),
)

var/global/list/PESTRA_ORGAN_KEYS = list(
	"眼睛" = "eyes",
	"心脏" = "heart",
	"肺" = "lungs",
	"肝脏" = "liver",
	"胃" = "stomach"
)

var/global/list/NOC_SECRET_MIRACLES = list(
	list(
		"id" = "greater_diagnose",
		"name" = "高等诊断",
		"desc" = "精准的神圣检视：显示试剂、血量、器官状态与量化伤势。",
		"type" = /obj/effect/proc_holder/spell/invoked/diagnose/greater,
		"cost" = NOC_SECRET_MP_COST,
		"requires" = /obj/effect/proc_holder/spell/invoked/diagnose
	)
)

/// helpa

/proc/_cr_html_attr(t as text)
	if(!istext(t))
		return ""
	var/s = "[t]"
	s = replacetext(s, "&", "&amp;")
	s = replacetext(s, "<", "&lt;")
	s = replacetext(s, ">", "&gt;")
	s = replacetext(s, "\"", "&quot;")
	s = replacetext(s, "'", "&#39;")
	return s

/proc/status_yn(flag)
	return flag ? "<span style='color:#2ecc71'>已解锁</span>" : "<span style='color:#e67e22'>未解锁</span>"

/proc/_cr_patron_name_display(name)
	if(!istext(name)) return "[name]"
	switch("[name]")
		if("Astrata") return "阿斯特拉塔"
		if("Noc") return "诺克"
		if("Dendor") return "登多尔"
		if("Abyssor") return "阿比索尔"
		if("Ravox") return "拉沃克斯"
		if("Necra") return "内克拉"
		if("Xylix") return "赛利克斯"
		if("Pestra") return "佩斯特拉"
		if("Malum") return "玛勒姆"
		if("Eora") return "伊欧拉"
	return "[name]"

/proc/_cr_pestra_tier_display(tier_key)
	if(!istext(tier_key)) return "[tier_key]"
	switch(lowertext("[tier_key]"))
		if("t1") return "一阶"
		if("t2") return "二阶"
		if("t3") return "三阶"
	return "[tier_key]"

/proc/_cr_quest_diff_display(diff_key)
	if(!istext(diff_key)) return "[diff_key]"
	switch(lowertext("[diff_key]"))
		if("easy") return "简单"
		if("medium") return "中等"
		if("hard") return "困难"
	return "[diff_key]"

/proc/_pestra_tier_price(tier_key as text)
	if(tier_key == "t1")
		return PESTRA_ORGAN_T1_PRICE_FAVOR
	if(tier_key == "t2")
		return PESTRA_ORGAN_T2_PRICE_FAVOR
	if(tier_key == "t3")
		return PESTRA_ORGAN_T3_PRICE_FAVOR
	return PESTRA_ORGAN_T1_PRICE_FAVOR

/// bleh organ get

/proc/_pestra_get_organ_type(label as text, tier_key as text)
	if(!istext(label) || !istext(tier_key))
		return null
	if(!(label in PESTRA_ORGAN_KEYS))
		return null

	var/base_key = PESTRA_ORGAN_KEYS[label]
	if(!istext(base_key) || !length(base_key))
		return null

	var/path_txt = "/obj/item/organ/[base_key]/[tier_key]"
	var/typepath = text2path(path_txt)

	if(ispath(typepath, /obj/item))
		return typepath

	return null

/// INDEX STUFFFF

/proc/build_miracle_caches()
	if(miracle_caches_built)
		return
	build_cache_for_root(/datum/patron/divine, divine_miracles_cache)
	build_cache_for_root(/datum/patron/inhumen, inhumen_miracles_cache)
	miracle_caches_built = TRUE

/proc/build_cache_for_root(root_type, list/cache)
	for(var/p_type in typesof(root_type))
		if(p_type == root_type)
			continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && length(P.miracles))
			for(var/st in P.miracles)
				cache[st] = TRUE
		if(P)
			qdel(P)

/proc/build_divine_patrons_index()
	if(divine_patrons_built)
		return
	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine)
			continue
		var/datum/patron/P = new p_type
		if(P && P.name)
			var/domain_txt = ""
			var/desc_txt = ""
			if("domain" in P.vars)
				domain_txt = "[P.vars["domain"]]"
			if("desc" in P.vars)
				desc_txt = "[P.vars["desc"]]"
			divine_patrons_index["[P.name]"] = list(
				"path" = p_type,
				"domain" = domain_txt,
				"desc" = desc_txt
			)
		if(P)
			qdel(P)
	divine_patrons_built = TRUE

/proc/build_inhumen_patrons_index()
	if(inhumen_patrons_built)
		return
	for(var/p_type in typesof(/datum/patron/inhumen))
		if(p_type == /datum/patron/inhumen)
			continue
		var/datum/patron/P = new p_type
		if(P && P.name)
			var/domain_txt = ""
			var/desc_txt = ""
			if("domain" in P.vars)
				domain_txt = "[P.vars["domain"]]"
			if("desc" in P.vars)
				desc_txt = "[P.vars["desc"]]"
			inhumen_patrons_index["[P.name]"] = list(
				"path" = p_type,
				"domain" = domain_txt,
				"desc" = desc_txt
			)
		if(P)
			qdel(P)
	inhumen_patrons_built = TRUE

/proc/_get_human_patron_name(mob/living/carbon/human/H)
	if(!H)
		return ""

	if(H.devotion && H.devotion.patron)
		if(("name" in H.devotion.patron.vars) && istext(H.devotion.patron.vars["name"]))
			return "[H.devotion.patron.vars["name"]]"

	if("patron" in H.vars)
		var/p = H.vars["patron"]

		if(istext(p) && length(p))
			return "[p]"

		if(istype(p, /datum/patron))
			var/datum/patron/P = p
			if(istext(P.name) && length(P.name))
				return P.name

		if(ispath(p, /datum/patron))
			var/datum/patron/P2 = new p
			var/out = ""
			if(P2 && istext(P2.name) && length(P2.name))
				out = P2.name
			if(P2)
				qdel(P2)
			return out

	return ""

/// Tiers helpa

/proc/get_spell_patron_names(spell_input)
	var/spell_path = null
	if(ispath(spell_input))
		spell_path = spell_input
	else if(istype(spell_input, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/SN = spell_input
		spell_path = SN.type
	else
		return list()

	var/list/result = list()

	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		var/list/rec = divine_patrons_index[n]
		if(!islist(rec))
			continue
		var/p_type = rec["path"]
		if(!p_type)
			continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			if(!(n in result))
				result += "[n]"
		if(P)
			qdel(P)

	build_inhumen_patrons_index()
	for(var/n2 in inhumen_patrons_index)
		var/list/rec2 = inhumen_patrons_index[n2]
		if(!islist(rec2))
			continue
		var/p2 = rec2["path"]
		if(!p2)
			continue
		var/datum/patron/P2 = new p2
		if(P2 && islist(P2.miracles) && (spell_path in P2.miracles))
			if(!(n2 in result))
				result += "[n2]"
		if(P2)
			qdel(P2)

	return result

/proc/_tier_from_patrons(spell_path)
	if(!ispath(spell_path, /obj/effect/proc_holder/spell))
		return 0

	var/max_tier = 0

	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine)
			continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			var/v = P.miracles[spell_path]
			if(isnum(v))
				max_tier = max(max_tier, v)
		if(P)
			qdel(P)

	for(var/p_type2 in typesof(/datum/patron/inhumen))
		if(p_type2 == /datum/patron/inhumen)
			continue
		var/datum/patron/P2 = new p_type2
		if(P2 && islist(P2.miracles) && (spell_path in P2.miracles))
			var/v2 = P2.miracles[spell_path]
			if(isnum(v2))
				max_tier = max(max_tier, v2)
		if(P2)
			qdel(P2)

	if(max_tier < 0)
		max_tier = 0
	if(max_tier > 4)
		max_tier = 4
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
	if(!tmp && spell_path)
		tmp = new spell_path

	var/tier_val = 0
	if(tmp)
		if("tier" in tmp.vars)
			var/tt = tmp.vars["tier"]
			if(isnum(tt))
				tier_val = tt
		if(!tier_val && ("miracle_tier" in tmp.vars))
			var/mt = tmp.vars["miracle_tier"]
			if(isnum(mt))
				tier_val = mt

	if(!S && tmp)
		qdel(tmp)

	if(tier_val <= 0 && spell_path)
		tier_val = _tier_from_patrons(spell_path)

	if(!isnum(tier_val))
		tier_val = 0
	if(tier_val < 0)
		tier_val = 0
	if(tier_val > 4)
		tier_val = 4
	return tier_val

/proc/allowed_tier_by_relation(level)
	if(!isnum(level) || level <= 0)
		return 0
	if(level == 1)
		return 1
	if(level == 2)
		return 2
	if(level == 3)
		return 3
	return 4

/proc/_is_templar(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return FALSE

	var/list/cands = list()

	if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
		var/datum/job/J = H.mind.vars["assigned_job"]
		if(("title" in J.vars) && istext(J.vars["title"]))
			cands += lowertext("[J.vars["title"]]")
		if(("name" in J.vars) && istext(J.vars["name"]))
			cands += lowertext("[J.vars["name"]]")

	if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"]))
		cands += lowertext("[H.mind.vars["assigned_role"]]")

	if(("special_role" in H.mind.vars) && istext(H.mind.vars["special_role"]))
		cands += lowertext("[H.mind.vars["special_role"]]")

	for(var/txt in cands)
		if(findtext(txt, "templar"))
			return TRUE

	return FALSE

/proc/_is_churchling(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return FALSE

	var/list/cands = list()

	if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
		var/datum/job/J = H.mind.vars["assigned_job"]
		if(("title" in J.vars) && istext(J.vars["title"]))
			cands += lowertext("[J.vars["title"]]")
		if(("name" in J.vars) && istext(J.vars["name"]))
			cands += lowertext("[J.vars["name"]]")

	if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"]))
		cands += lowertext("[H.mind.vars["assigned_role"]]")

	if(("special_role" in H.mind.vars) && istext(H.mind.vars["special_role"]))
		cands += lowertext("[H.mind.vars["special_role"]]")

	for(var/txt in cands)
		if(findtext(txt, "churchling"))
			return TRUE

	return FALSE

/proc/_is_keeper(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return FALSE

	var/list/cands = list()

	if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
		var/datum/job/J = H.mind.vars["assigned_job"]

		if(istype(J, /datum/job/roguetown/keeper))
			return TRUE

		if(("title" in J.vars) && istext(J.vars["title"]))
			cands += lowertext("[J.vars["title"]]")
		if(("name" in J.vars) && istext(J.vars["name"]))
			cands += lowertext("[J.vars["name"]]")

	if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"]))
		cands += lowertext("[H.mind.vars["assigned_role"]]")

	if(("special_role" in H.mind.vars) && istext(H.mind.vars["special_role"]))
		cands += lowertext("[H.mind.vars["special_role"]]")

	for(var/txt in cands)
		if(findtext(txt, "keeper"))
			return TRUE

	return FALSE

/proc/_is_inhumen_patron_name(n as text)
	if(!istext(n) || !length(n))
		return FALSE
	build_inhumen_patrons_index()
	return (n in inhumen_patrons_index)

/proc/_shunned_relations_unlocked(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(_is_churchling(H))
		return TRUE
	return !!H.unlocked_research_zizo_forbidden

/proc/_update_reroll_charges(mob/living/carbon/human/H)
	if(!H)
		return
	if(!H.quest_reroll_last_ds)
		H.quest_reroll_last_ds = world.time
	var/delta = world.time - H.quest_reroll_last_ds
	if(delta < QUEST_COOLDOWN_DS)
		return
	var/add = round(delta / QUEST_COOLDOWN_DS)
	if(add > 0)
		H.quest_reroll_charges += add
		H.quest_reroll_last_ds += add * QUEST_COOLDOWN_DS

/// Day 3 share traits

/proc/_apply_t4_traits_for_patron(mob/living/carbon/human/H, patron_name as text)
	if(!H || !istext(patron_name) || !length(patron_name))
		return

	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/p_path = null

	if(patron_name in divine_patrons_index)
		var/list/rec = divine_patrons_index[patron_name]
		if(islist(rec))
			p_path = rec["path"]
	else if(patron_name in inhumen_patrons_index)
		var/list/rec2 = inhumen_patrons_index[patron_name]
		if(islist(rec2))
			p_path = rec2["path"]

	if(!p_path)
		return

	var/datum/patron/P = new p_path
	if(!P)
		return

	if(islist(P.mob_traits) && P.mob_traits.len)
		var/source = "relation_t4_[ckey(patron_name)]"
		for(var/trait in P.mob_traits)
			ADD_TRAIT(H, trait, source)

	qdel(P)

/proc/_sync_t4_relation_traits(mob/living/carbon/human/H)
	if(!H || !islist(H.patron_relations))
		return

	for(var/pn in H.patron_relations)
		var/rel = H.patron_relations[pn]
		if(isnum(rel) && rel >= 4)
			_apply_t4_traits_for_patron(H, "[pn]")

/// Main shit starts here

/obj/effect/proc_holder/spell/self/learnmiracle
	name = "神迹"
	desc = "打开神迹操作界面。"
	overlay_state = "startmiracle"

	var/current_research_tab = "pestra"
	var/current_rel_tab = "ten"
	var/current_learn_tab = "none"
	var/current_pestra_tier = "t1"

/// friendship proc

/obj/effect/proc_holder/spell/self/learnmiracle/proc/_ensure_relations(mob/living/carbon/human/H)
	if(!H)
		return

	if(!H.patron_relations || !islist(H.patron_relations))
		H.patron_relations = list()

	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		if(!(n in H.patron_relations))
			H.patron_relations[n] = 0

	var/my_patron = _get_human_patron_name(H)
	if(length(my_patron))
		H.patron_relations[my_patron] = _is_keeper(H) ? 3 : 4

	if(_shunned_relations_unlocked(H) || _is_inhumen_patron_name(my_patron))
		build_inhumen_patrons_index()
		for(var/n2 in inhumen_patrons_index)
			if(!(n2 in H.patron_relations))
				H.patron_relations[n2] = 0
		if(length(my_patron) && (my_patron in inhumen_patrons_index))
			H.patron_relations[my_patron] = _is_keeper(H) ? 3 : 4

	_sync_t4_relation_traits(H)

/// learnable proc

/obj/effect/proc_holder/spell/self/learnmiracle/proc/do_learn_miracle(mob/user)
	if(!user || !user.mind)
		return
	var/mob/living/carbon/human/H = istype(user, /mob/living/carbon/human) ? user : null
	if(!H)
		return
	if(!HAS_TRAIT(H, TRAIT_CLERGYRADICAL))
		to_chat(H, span_warning("只有教士才能沉思新的神迹。"))
		return
	if(!length(_get_human_patron_name(H)))
		to_chat(H, span_warning("你的信仰没有主神。"))
		return
	open_learn_ui(H)

/obj/effect/proc_holder/spell/self/learnmiracle/proc/_build_learn_buckets(mob/living/carbon/human/H)
	if(!miracle_caches_built)
		build_miracle_caches()

	_ensure_relations(H)
	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/my_patron = _get_human_patron_name(H)
	var/is_templar = _is_templar(H)
	var/is_churchling = _is_churchling(H)
	var/is_keeper = _is_keeper(H)

	var/list/already_types = list()
	if(H.mind)
		for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
			already_types[K.type] = TRUE

	var/list/all_spell_types = list()
	for(var/st1 in divine_miracles_cache)
		all_spell_types[st1] = TRUE
	for(var/st2 in inhumen_miracles_cache)
		all_spell_types[st2] = TRUE

	var/list/buckets = list()

	for(var/st in all_spell_types)
		var/obj/effect/proc_holder/spell/S = new st
		if(!S)
			continue

		var/tier = get_spell_tier(S)
		var/list/owners = get_spell_patron_names(st)
		if(!islist(owners) || !owners.len)
			qdel(S)
			continue

		for(var/owner_name in owners)
			if(_is_inhumen_patron_name(owner_name))
				if(!_shunned_relations_unlocked(H) && owner_name != my_patron)
					continue

			var/owner_rel = 0
			if(owner_name == my_patron)
				owner_rel = 4
			else if(H.patron_relations && (owner_name in H.patron_relations))
				owner_rel = H.patron_relations[owner_name]

			var/max_allowed = allowed_tier_by_relation(owner_rel)
			if(is_templar)
				max_allowed = min(max_allowed, 2)
			if(is_churchling)
				max_allowed = min(max_allowed, 1)
			if(is_keeper)
				max_allowed = min(max_allowed, 3)

			if(tier > max_allowed)
				continue

			if(!(owner_name in buckets))
				buckets[owner_name] = list()

			var/list/L = buckets[owner_name]
			var/is_learned = !!already_types[st]
			var/cost = (owner_name == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN

			L += list(list(
				"name" = S.name,
				"desc" = S.desc,
				"tier" = tier,
				"cost" = cost,
				"type" = st,
				"learned" = is_learned
			))
			buckets[owner_name] = L

		qdel(S)

	return buckets

/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_learn_ui(mob/living/carbon/human/H)
	if(!H)
		return

	_ensure_relations(H)
	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/list/buckets = _build_learn_buckets(H)
	var/my_patron = _get_human_patron_name(H)
	var/show_shunned_tabs = (_shunned_relations_unlocked(H) || _is_inhumen_patron_name(my_patron))

	var/list/nav = list()
	var/list/nav_shunned = list()

	if(src.current_learn_tab == "none")
		nav += "<b>无</b>"
	else
		nav += "<a href=\"?src=[REF(src)];learntab=none\">无</a>"

	var/list/names_div = list()
	for(var/pn1 in divine_patrons_index)
		names_div += "[pn1]"
	names_div = sortList(names_div)

	for(var/n in names_div)
		var/relv = 0
		if(H.patron_relations && (n in H.patron_relations))
			relv = H.patron_relations[n]

		var/tab_id = url_encode("[n]")

		if(relv > 0)
			if(src.current_learn_tab == "[n]")
				nav += "<b>[_cr_html_attr(_cr_patron_name_display(n))]</b>"
			else
				nav += "<a href=\"?src=[REF(src)];learntab=[tab_id]\">[_cr_html_attr(_cr_patron_name_display(n))]</a>"
		else
			nav += "<span style='color:#7f8c8d'>[_cr_html_attr(_cr_patron_name_display(n))]</span>"

	if(show_shunned_tabs)
		var/list/names_inh = list()
		for(var/pn2 in inhumen_patrons_index)
			names_inh += "[pn2]"
		names_inh = sortList(names_inh)

		for(var/n2 in names_inh)
			var/relv2 = 0
			if(H.patron_relations && (n2 in H.patron_relations))
				relv2 = H.patron_relations[n2]

			var/tab_id2 = url_encode("[n2]")

			if(relv2 > 0 || n2 == my_patron)
				if(src.current_learn_tab == "[n2]")
					nav_shunned += "<b>[_cr_html_attr(_cr_patron_name_display(n2))]</b>"
				else
					nav_shunned += "<a href=\"?src=[REF(src)];learntab=[tab_id2]\">[_cr_html_attr(_cr_patron_name_display(n2))]</a>"
			else
				nav_shunned += "<span style='color:#7f8c8d'>[_cr_html_attr(_cr_patron_name_display(n2))]</span>"

	if(src.current_learn_tab == "noc_secrets")
		nav += "<b>诺克秘仪</b>"
	else if(H.unlocked_research_noc_secrets)
		nav += "<a href=\"?src=[REF(src)];learntab=noc_secrets\">诺克秘仪</a>"
	else
		nav += "<span style='color:#7f8c8d'>诺克秘仪</span>"

	var/html = "<center><h3>学习神迹</h3></center><hr>"
	html += "恩眷：<b>[H.church_favor]</b> | 神迹点：<b>[H.miracle_points]</b><hr>"
	html += jointext(nav, " | ")

	if(nav_shunned.len)
		html += "<br><span style='color:#9b59b6'><b>受弃者：</b></span> "
		html += jointext(nav_shunned, " | ")

	html += "<br><br>"

	if(src.current_learn_tab == "none")
		html += "<i>请选择一位主神或诺克秘仪。</i>"
	else if(src.current_learn_tab == "noc_secrets")
		html += "<b>诺克秘仪</b><br>"
		html += "<div style='color:#95a5a6; margin-bottom:8px;'>可购买的特殊神迹。</div>"
		html += "<table width='100%' cellspacing='2' cellpadding='2'>"
		html += "<tr><th align='left'>神迹</th><th>描述</th><th width='100'>消耗</th><th width='160'>操作</th></tr>"

		for(var/entry in NOC_SECRET_MIRACLES)
			var/list/E = entry
			if(!islist(E))
				continue

			var/id2 = "[E["id"]]"
			var/nm = "[E["name"]]"
			var/ds = "[E["desc"]]"
			var/cost2 = E["cost"]
			var/type2 = E["type"]
			var/req2 = E["requires"]

			var/known_secret = FALSE
			var/has_requirement = FALSE

			if(H.mind)
				for(var/obj/effect/proc_holder/spell/SG in H.mind.spell_list)
					if(type2 && SG.type == type2)
						known_secret = TRUE
					if(req2 && SG.type == req2)
						has_requirement = TRUE

			html += "<tr>"
			html += "<td><b>[_cr_html_attr(nm)]</b></td>"
			html += "<td>[_cr_html_attr(ds)]</td>"
			html += "<td align='center'>[cost2] 神迹点</td>"
			html += "<td align='center'>"

			if(known_secret)
				html += "<span style='color:#2ecc71'>已学会</span>"
			else if(req2 && !has_requirement)
				html += "<span style='color:#7f8c8d'>缺少前置条件</span>"
			else if(H.miracle_points >= cost2)
				html += "<a href=\"?src=[REF(src)];buynoc=[id2]\">购买</a>"
			else
				html += "<span style='color:#7f8c8d'>神迹点不足</span>"

			html += "</td></tr>"

		html += "</table>"
	else
		if(!islist(buckets[src.current_learn_tab]) || !length(buckets[src.current_learn_tab]))
			html += "<i>该主神当前没有可学习的神迹。</i>"
		else
			var/list/L = buckets[src.current_learn_tab]
			html += "<b>[_cr_html_attr(_cr_patron_name_display(src.current_learn_tab))]</b><br>"
			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>神迹</th><th>描述</th><th width='50'>阶级</th><th width='100'>消耗</th><th width='140'>操作</th></tr>"

			for(var/entry2 in L)
				var/list/E2 = entry2
				var/nm2 = "[E2["name"]]"
				var/desc2 = "[E2["desc"]]"
				var/tier2 = E2["tier"]
				var/cost3 = E2["cost"]
				var/typepath_txt = "[E2["type"]]"
				var/is_learned2 = E2["learned"]

				html += "<tr>"
				html += "<td><b>[_cr_html_attr(nm2)]</b></td>"
				html += "<td>[_cr_html_attr(desc2)]</td>"
				html += "<td align='center'>[tier2]</td>"
				html += "<td align='center'>[cost3] 神迹点</td>"
				html += "<td align='center'>"

				if(is_learned2)
					html += "<span style='color:#2ecc71'>已学会</span>"
				else if(H.miracle_points >= cost3)
					html += "<a href=\"?src=[REF(src)];learnspell=[typepath_txt]\">学习</a>"
				else
					html += "<span style='color:#7f8c8d'>神迹点不足</span>"

				html += "</td></tr>"

			html += "</table>"

	var/datum/browser/B = new(H, "MIRACLE_LEARN", "学习神迹", 760, 680)
	B.set_content(html)
	B.open()

/// research!!

/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_research_ui(mob/living/carbon/human/H)
	if(!H)
		return

	_ensure_relations(H)
	_update_reroll_charges(H)
	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/html = "<center><h3>研究</h3></center><hr>"
	html += "<b>恩眷：</b> [H.church_favor]<br>"
	html += "<b>神迹点：</b> [H.miracle_points]<br>"
	html += "<b>研究点：</b> [H.personal_research_points]<br><br>"

	if(HAS_TRAIT(H, TRAIT_CLERGYRADICAL))
		if(H.church_favor >= RESEARCH_RP_PRICE_FLAVOR)
			html += "<a href='?src=[REF(src)];buyrp=1'>购买 1 点研究点（[RESEARCH_RP_PRICE_FLAVOR] 恩眷）</a><br>"
		else
			html += "<span style='color:#7f8c8d'>购买 1 点研究点（[RESEARCH_RP_PRICE_FLAVOR] 恩眷）</span><br>"

		if(H.church_favor >= MIRACLE_MP_PRICE_FLAVOR)
			html += "<a href='?src=[REF(src)];buymp=1'>购买 1 点神迹点（[MIRACLE_MP_PRICE_FLAVOR] 恩眷）</a><br>"
		else
			html += "<span style='color:#7f8c8d'>购买 1 点神迹点（[MIRACLE_MP_PRICE_FLAVOR] 恩眷）</span><br>"
	else
		html += "<span style='color:#7f8c8d'>只有教士可以购买研究点/神迹点。</span><br>"

	html += "<hr><b>研究项目</b><br>"
	html += "<table width='100%' cellspacing='2' cellpadding='2'>"
	html += "<tr><th align='left'>项目</th><th width='120'>状态</th><th width='220'>操作</th></tr>"

	/* html += "<tr><td>Secrets of Noc</td><td>[status_yn(H.unlocked_research_noc_secrets)]</td><td align='center'>"
	if(!H.unlocked_research_noc_secrets)
		if(H.church_favor >= RESEARCH_UNLOCK_FAVOR)
			html += "<a href='?src=[REF(src)];unlockresearch=noc'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</a>"
		else
			html += "<span style='color:#7f8c8d'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</span>"
	else
		html += "<span style='color:#7f8c8d'>See Learn tab</span>"
	html += "</td></tr>" */

	html += "<tr><td>佩斯特拉血肉塑造</td><td>[status_yn(H.unlocked_research_pestra_fleshcraft)]</td><td align='center'>"
	if(!H.unlocked_research_pestra_fleshcraft)
		if(H.church_favor >= RESEARCH_UNLOCK_FAVOR)
			html += "<a href='?src=[REF(src)];unlockresearch=pestra'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</a>"
		else
			html += "<span style='color:#7f8c8d'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</span>"
	else
		html += "<span style='color:#7f8c8d'>已解锁</span>"
	html += "</td></tr>"

	html += "<tr><td>玛勒姆工艺</td><td>[status_yn(H.unlocked_research_malum_craft)]</td><td align='center'>"
	if(!H.unlocked_research_malum_craft)
		if(H.church_favor >= RESEARCH_UNLOCK_FAVOR)
			html += "<a href='?src=[REF(src)];unlockresearch=malum'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</a>"
		else
			html += "<span style='color:#7f8c8d'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</span>"
	else
		html += "<span style='color:#7f8c8d'>已解锁</span>"
	html += "</td></tr>"

	html += "<tr><td>齐佐禁忌知识</td><td>[status_yn(H.unlocked_research_zizo_forbidden)]</td><td align='center'>"
	if(!H.unlocked_research_zizo_forbidden)
		if(H.church_favor >= RESEARCH_UNLOCK_FAVOR)
			html += "<a href='?src=[REF(src)];unlockresearch=zizo'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</a>"
		else
			html += "<span style='color:#7f8c8d'>解锁（[RESEARCH_UNLOCK_FAVOR] 恩眷）</span>"
	else
		html += "<span style='color:#7f8c8d'>已解锁</span>"
	html += "</td></tr>"

	html += "</table><hr>"

	var/list/rnav = list()
	rnav += (src.current_research_tab == "pestra") ? "<b>佩斯特拉血肉塑造</b>" : "<a href='?src=[REF(src)];researchtab=pestra'>佩斯特拉血肉塑造</a>"
	rnav += (src.current_research_tab == "malum") ? "<b>玛勒姆工艺</b>" : "<a href='?src=[REF(src)];researchtab=malum'>玛勒姆工艺</a>"
	rnav += (src.current_research_tab == "zizo") ? "<b>齐佐禁忌知识</b>" : "<a href='?src=[REF(src)];researchtab=zizo'>齐佐禁忌知识</a>"
	html += jointext(rnav, " | ")
	html += "<hr>"

	if(src.current_research_tab == "pestra")
		html += "<b>佩斯特拉血肉塑造</b><br>"
		html += "状态：[status_yn(H.unlocked_research_pestra_fleshcraft)]<br><br>"

		if(!H.unlocked_research_pestra_fleshcraft)
			html += "<span style='color:#7f8c8d'>请先在上方解锁此研究。</span>"
		else
			var/list/pnav = list()
			pnav += (src.current_pestra_tier == "t1") ? "<b>一阶</b>" : "<a href='?src=[REF(src)];pestratier=t1'>一阶</a>"
			pnav += (src.current_pestra_tier == "t2") ? "<b>二阶</b>" : "<a href='?src=[REF(src)];pestratier=t2'>二阶</a>"
			pnav += (src.current_pestra_tier == "t3") ? "<b>三阶</b>" : "<a href='?src=[REF(src)];pestratier=t3'>三阶</a>"

			var/current_price = _pestra_tier_price(src.current_pestra_tier)

			html += jointext(pnav, " | ")
			html += "<br><span style='color:#95a5a6'>当前所选阶级价格：[current_price] 恩眷</span><br><br>"

			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>器官</th><th width='180'>操作</th></tr>"

			for(var/label in PESTRA_ORGAN_KEYS)
				html += "<tr><td>[label]（[_cr_pestra_tier_display(src.current_pestra_tier)]）</td><td align='center'>"
				if(HAS_TRAIT(H, TRAIT_CLERGYRADICAL) && H.church_favor >= current_price)
					html += "<a href='?src=[REF(src)];buyorg=[label];tier=[src.current_pestra_tier]'>购买（[current_price] 恩眷）</a>"
				else
					html += "<span style='color:#7f8c8d'>购买（[current_price] 恩眷）</span>"
				html += "</td></tr>"

			html += "</table>"

	else if(src.current_research_tab == "malum")
		html += "<b>玛勒姆工艺</b><br>"
		html += "状态：[status_yn(H.unlocked_research_malum_craft)]<br><br>"

		if(!H.unlocked_research_malum_craft)
			html += "<span style='color:#7f8c8d'>请先在上方解锁此研究。</span>"
		else
			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>圣物</th><th width='160'>主神</th><th width='180'>操作</th></tr>"

			var/list/pnames = list()
			for(var/pn in PATRON_ARTIFACTS)
				pnames += "[pn]"
			pnames = sortList(pnames)

			for(var/pn2 in pnames)
				var/list/art_list = PATRON_ARTIFACTS[pn2]
				if(!islist(art_list))
					continue

				for(var/T in art_list)
					var/name_txt = "[T]"
					var/obj/O = new T
					if(O && istext(O.name) && length(O.name))
						name_txt = O.name
					if(O)
						qdel(O)

					html += "<tr>"
					html += "<td>[_cr_html_attr(name_txt)]</td>"
					html += "<td align='center'>[_cr_html_attr(_cr_patron_name_display("[pn2]"))]</td>"
					html += "<td align='center'>"

					if(HAS_TRAIT(H, TRAIT_CLERGYRADICAL) && H.church_favor >= ARTEFACT_PRICE_FAVOR)
						html += "<a href='?src=[REF(src)];buyart=[T]'>购买（[ARTEFACT_PRICE_FAVOR] 恩眷）</a>"
					else
						html += "<span style='color:#7f8c8d'>购买（[ARTEFACT_PRICE_FAVOR] 恩眷）</span>"

					html += "</td></tr>"

			html += "</table>"

	else if(src.current_research_tab == "zizo")
		html += "<b>齐佐禁忌知识</b><br>"
		html += "状态：[status_yn(H.unlocked_research_zizo_forbidden)]<br><br>"

		if(!H.unlocked_research_zizo_forbidden)
			html += "<span style='color:#7f8c8d'>请先在上方解锁此研究。</span>"
		else
			html += "<span style='color:#2ecc71'>已解锁受弃者关系。</span>"

	html += "<hr>"

	var/list/nav_bits = list()
	nav_bits += (src.current_rel_tab == "ten") ? "<b>十神</b>" : "<a href='?src=[REF(src)];reltab=ten'>十神</a>"
	if(_shunned_relations_unlocked(H))
		nav_bits += (src.current_rel_tab == "shunned") ? "<b>受弃者</b>" : "<a href='?src=[REF(src)];reltab=shunned'>受弃者</a>"
	else
		nav_bits += "<span style='color:#7f8c8d'>受弃者</span>"

	html += jointext(nav_bits, " | ")
	html += "<br><br>"

	var/is_templar = _is_templar(H)
	var/is_churchling = _is_churchling(H)
	var/is_keeper = _is_keeper(H)
	var/rel_cap = is_templar ? 2 : (is_churchling ? 1 : (is_keeper ? 3 : 4))

	if(src.current_rel_tab == "ten" || (src.current_rel_tab == "shunned" && _shunned_relations_unlocked(H)))
		var/list/idx = (src.current_rel_tab == "shunned") ? inhumen_patrons_index : divine_patrons_index
		if(idx && idx.len)
			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>主神</th><th>领域</th><th width='80'>等级</th><th width='220'>操作</th></tr>"

			var/list/names = list()
			for(var/n in idx)
				names += "[n]"
			names = sortList(names)

			var/my_patron = _get_human_patron_name(H)

			for(var/nm in names)
				var/list/rec = idx[nm]
				var/dom = "[rec["domain"]]"
				var/cur = 0
				if(H.patron_relations && (nm in H.patron_relations))
					cur = H.patron_relations[nm]
				if(cur > rel_cap)
					cur = rel_cap

				html += "<tr>"
				html += "<td><b>[_cr_html_attr(_cr_patron_name_display(nm))]</b></td>"
				html += "<td>[_cr_html_attr(dom)]</td>"
				html += "<td align='center'><b>[cur]</b>/[rel_cap]</td>"
				html += "<td align='center'>"

				if(length(my_patron) && (nm == my_patron))
					html += "<span style='color:#2ecc71'>本命主神（已满）</span>"
				else if(cur >= rel_cap)
					html += "<span style='color:#2ecc71'>已满级</span>"
				else
					var/next = cur + 1
					if(next > rel_cap)
						next = rel_cap
					var/cost4 = (next == 1) ? 1 : (next == 2) ? 2 : (next == 3) ? 3 : 4

					if(H.personal_research_points >= cost4)
						html += "<a href='?src=[REF(src)];relten_up=[nm]'>提升到 [next]（[cost4] 研究点）</a>"
					else
						html += "<span style='color:#7f8c8d'>提升到 [next]（[cost4] 研究点）</span>"

				html += "</td></tr>"

			html += "</table>"
		else
			html += "<i>未找到主神。</i>"

	var/datum/browser/B = new(H, "MIRACLE_RESEARCH", "研究", 820, 900)
	B.set_content(html)
	B.open()

/// quests

/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_quests_ui(mob/living/carbon/human/H)
	if(!H)
		return

	var/init_needed = TRUE
	if(islist(H.quest_ui_entries) && H.quest_ui_entries.len >= 1)
		init_needed = FALSE

	if(init_needed)
		H.quest_ui_entries = _rt_build_player_quest_set(H)
		if(!H.quest_reroll_last_ds)
			H.quest_reroll_last_ds = world.time

	_update_reroll_charges(H)

	var/charges = H.quest_reroll_charges
	var/next_left_ds = max(0, QUEST_COOLDOWN_DS - (world.time - H.quest_reroll_last_ds))
	var/left_s = round(next_left_ds / 10)
	var/mins = left_s / 60
	var/secs = left_s % 60
	var/secs_str = (secs < 10) ? "0[secs]" : "[secs]"

	var/html = "<center><h3 style='color:#3498db;margin:6px 0;'>教区任务</h3>"
	if(charges >= 1)
		html += "<div style='margin-top:6px;'><a href='?src=[REF(src)];q_reroll=1' style='background:#8e44ad;color:#fff;padding:3px 8px;border-radius:6px;text-decoration:none;'><b>重掷（次数：[charges]）</b></a></div>"
	else
		html += "<div style='margin-top:6px;color:#9b59b6;'>下次恢复次数还需：<b>[mins]:[secs_str]</b></div>"

	html += "<div style='color:#e74c3c; text-align:center; margin:6px 0;'>"
	html += "<b>规则说明：</b><br>"
	html += "你会获得三种不同的任务主题。<br>"
	html += "每个任务可能拥有 <u>简单 / 中等 / 困难</u> 三种变体，或仅有一种特殊任务。<br>"
	html += "当你在某一行点击 <b>领取特殊物品</b> 时，该任务会锁定在该难度，并发放一件任务物品。<br>"
	html += "同一任务的其他难度会一直锁定，直到重掷。<br>"
	html += "任务物品为一次性道具，可以交给他人使用，但完成奖励仍归属于所有者。"
	html += "</u>任务物品可以交给其他玩家</u>。"
	html += "非战斗模式下，目标必须自愿接受；战斗模式下，任务会被强制施加并立刻完成。<br>"
	html += "</div></center><hr>"

	var/quest_count = islist(H.quest_ui_entries) ? H.quest_ui_entries.len : 0

	for(var/i = 1, i <= quest_count, i++)
		var/list/slot = H.quest_ui_entries[i]
		if(!islist(slot))
			continue

		var/quest_title = "[slot["title"]]"
		var/accepted_diff = slot["accepted_diff"]
		if(!istext(accepted_diff))
			accepted_diff = ""

		html += "<div style='padding:10px;'>"
		html += "<center><b style='font-size:14px; color:#ecf0f1; background:#34495e; padding:2px 8px; border-radius:6px;'>[_cr_html_attr(quest_title)]</b></center><br>"
		html += "<table width='100%' cellspacing='2' cellpadding='2' style='text-align:center;'>"
		html += "<tr style='background:#2c3e50;color:#ecf0f1;'><th>难度</th><th>任务</th><th>奖励</th><th>操作</th></tr>"

		var/list/diffs = slot["difficulties"]
		if(islist(diffs))
			var/list/diff_order = list()
			if("easy" in diffs)
				diff_order += "easy"
			if("medium" in diffs)
				diff_order += "medium"
			if("hard" in diffs)
				diff_order += "hard"
			for(var/other in diffs)
				if(!(other in diff_order))
					diff_order += other

			for(var/diff_key in diff_order)
				if(!(diff_key in diffs))
					continue
				var/list/D = diffs[diff_key]
				if(!islist(D))
					continue

				var/diff_label = _cr_quest_diff_display("[diff_key]")
				var/desc_txt = "[D["desc"]]"
				var/reward_txt = "[D["reward"]]"
				var/spawned = D["spawned"]
				var/locked = (length(accepted_diff) && (accepted_diff != diff_key))

				html += "<tr>"
				html += "<td><b>[diff_label]</b></td>"
				html += "<td>[desc_txt]</td>"
				html += "<td style='color:#2ecc71'><b>[reward_txt]</b> 恩眷</td>"
				html += "<td>"

				if(locked)
					html += "<span style='display:inline-block; padding:4px 10px; border-radius:6px; background:#7f8c8d; color:#ecf0f1;'>已锁定</span>"
				else if(spawned)
					html += "<span style='display:inline-block; padding:4px 10px; border-radius:6px; background:#7f8c8d; color:#ecf0f1;'>已生成物品</span>"
				else
					html += "<a href='?src=[REF(src)];q_spawn=[i];diff=[diff_key]' style='display:inline-block; padding:4px 10px; border-radius:6px; background:#1abc9c; color:#ffffff; text-decoration:none;'>领取特殊物品</a>"

				html += "</td></tr>"

		html += "</table></div>"

		if(i < quest_count)
			html += "<hr style='border-color:#2c3e50;'>"

	var/datum/browser/B2 = new(H, "MIRACLE_QUESTS", "任务", 760, 780)
	B2.set_content(html)
	B2.open()

/// topic

/obj/effect/proc_holder/spell/self/learnmiracle/Topic(href, href_list)
	. = ..()
	if(!usr || !istype(usr, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = usr
	_ensure_relations(H)

	if(href_list["researchtab"])
		var/tbr = lowertext(href_list["researchtab"])
		if(tbr in list("pestra", "malum", "zizo"))
			src.current_research_tab = tbr
		open_research_ui(H)
		return

	if(href_list["pestratier"])
		var/pt = lowertext(href_list["pestratier"])
		if(pt in list("t1", "t2", "t3"))
			src.current_pestra_tier = pt
		open_research_ui(H)
		return

	if(href_list["reltab"])
		var/tb = lowertext(href_list["reltab"])
		if(tb == "ten")
			src.current_rel_tab = "ten"
		else if(tb == "shunned" && _shunned_relations_unlocked(H))
			src.current_rel_tab = "shunned"
		open_research_ui(H)
		return

	if(href_list["learntab"])
		var/tb2 = href_list["learntab"]
		if(tb2 == "none")
			src.current_learn_tab = "none"
		else if(tb2 == "noc_secrets")
			if(H.unlocked_research_noc_secrets)
				src.current_learn_tab = "noc_secrets"
		else
			build_divine_patrons_index()
			build_inhumen_patrons_index()

			var/allowed_tab = FALSE
			var/my_patron2 = _get_human_patron_name(H)

			if(tb2 in divine_patrons_index)
				allowed_tab = TRUE
			else if(tb2 in inhumen_patrons_index)
				if(_shunned_relations_unlocked(H) || tb2 == my_patron2)
					allowed_tab = TRUE

			if(allowed_tab)
				var/relv = 0
				if(H.patron_relations && (tb2 in H.patron_relations))
					relv = H.patron_relations[tb2]
				if(relv > 0 || tb2 == my_patron2)
					src.current_learn_tab = "[tb2]"

		open_learn_ui(H)
		return

	if(href_list["buyrp"])
		if(HAS_TRAIT(H, TRAIT_CLERGYRADICAL) && H.church_favor >= RESEARCH_RP_PRICE_FLAVOR)
			H.church_favor = max(0, H.church_favor - RESEARCH_RP_PRICE_FLAVOR)
			H.personal_research_points++
			to_chat(H, span_notice("你获得了 +1 点研究点。"))
		open_research_ui(H)
		return

	if(href_list["buymp"])
		if(HAS_TRAIT(H, TRAIT_CLERGYRADICAL) && H.church_favor >= MIRACLE_MP_PRICE_FLAVOR)
			H.church_favor = max(0, H.church_favor - MIRACLE_MP_PRICE_FLAVOR)
			H.miracle_points++
			to_chat(H, span_notice("你获得了 +1 点神迹点。"))
		open_research_ui(H)
		return

	if(href_list["unlockresearch"])
		var/which = lowertext(href_list["unlockresearch"])
		if(H.church_favor < RESEARCH_UNLOCK_FAVOR)
			open_research_ui(H)
			return

		if(which == "noc")
			H.unlocked_research_noc_secrets = TRUE
		else if(which == "pestra")
			H.unlocked_research_pestra_fleshcraft = TRUE
		else if(which == "malum")
			H.unlocked_research_malum_craft = TRUE
		else if(which == "zizo")
			H.unlocked_research_zizo_forbidden = TRUE
			build_inhumen_patrons_index()
			if(!islist(H.patron_relations))
				H.patron_relations = list()
			for(var/n in inhumen_patrons_index)
				if(!(n in H.patron_relations))
					H.patron_relations[n] = 0
		else
			open_research_ui(H)
			return

		H.church_favor = max(0, H.church_favor - RESEARCH_UNLOCK_FAVOR)
		to_chat(H, span_notice("研究已解锁。"))
		open_research_ui(H)
		return

	if(href_list["buyart"])
		if(!H.unlocked_research_malum_craft)
			open_research_ui(H)
			return
		if(!HAS_TRAIT(H, TRAIT_CLERGYRADICAL))
			open_research_ui(H)
			return
		if(H.church_favor < ARTEFACT_PRICE_FAVOR)
			open_research_ui(H)
			return

		var/item_txt = href_list["buyart"]
		var/item_path = text2path(item_txt)
		if(!ispath(item_path, /obj/item))
			to_chat(H, span_warning("无效的圣物类型。"))
			open_research_ui(H)
			return

		var/valid = FALSE
		for(var/pn in PATRON_ARTIFACTS)
			var/list/art_list = PATRON_ARTIFACTS[pn]
			if(islist(art_list) && art_list.Find(item_path))
				valid = TRUE
				break

		if(!valid)
			to_chat(H, span_warning("未知圣物。"))
			open_research_ui(H)
			return

		var/turf/T1 = get_step(H, H.dir)
		if(!T1)
			T1 = get_turf(H)
		new item_path(T1)
		H.church_favor = max(0, H.church_favor - ARTEFACT_PRICE_FAVOR)
		to_chat(H, span_notice("圣物已购入。"))
		open_research_ui(H)
		return

	if(href_list["buyorg"])
		if(!H.unlocked_research_pestra_fleshcraft)
			open_research_ui(H)
			return
		if(!HAS_TRAIT(H, TRAIT_CLERGYRADICAL))
			open_research_ui(H)
			return

		var/label = href_list["buyorg"]
		var/tier_key = lowertext("[href_list["tier"]]")
		if(!(tier_key in list("t1", "t2", "t3")))
			tier_key = "t1"

		var/organ_price = _pestra_tier_price(tier_key)
		if(H.church_favor < organ_price)
			open_research_ui(H)
			return

		var/typepath2 = _pestra_get_organ_type(label, tier_key)
		if(!typepath2)
			to_chat(H, span_warning("未找到[label]对应的[_cr_pestra_tier_display(tier_key)]器官类型。"))
			open_research_ui(H)
			return

		var/turf/T2 = get_step(H, H.dir)
		if(!T2)
			T2 = get_turf(H)

		new typepath2(T2)
		H.church_favor = max(0, H.church_favor - organ_price)
		to_chat(H, span_notice("[label]的[_cr_pestra_tier_display(tier_key)]器官已购入。"))
		open_research_ui(H)
		return

	if(href_list["buynoc"])
		to_chat(H, span_warning("诺克秘仪当前已被禁用。"))
		open_learn_ui(H)
		return

	if(href_list["learnspell"])
		var/txt = href_list["learnspell"]
		var/typepath = text2path(txt)
		if(!ispath(typepath, /obj/effect/proc_holder/spell))
			open_learn_ui(H)
			return

		var/obj/effect/proc_holder/spell/Snew = new typepath
		if(!Snew)
			open_learn_ui(H)
			return

		if(H.mind)
			for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
				if(K.type == typepath)
					qdel(Snew)
					to_chat(H, span_warning("你已经学会这个了。"))
					open_learn_ui(H)
					return

		var/my_patron = _get_human_patron_name(H)
		var/tier = get_spell_tier(Snew)
		var/list/owners = get_spell_patron_names(typepath)
		var/real_owner = ""

		if(length(my_patron) && islist(owners) && (my_patron in owners))
			real_owner = my_patron
		else if(islist(owners) && owners.len)
			var/best_name = ""
			var/best_rel = -1
			for(var/on in owners)
				if(!istext(on))
					continue
				var/r = 0
				if(H.patron_relations && (on in H.patron_relations) && isnum(H.patron_relations[on]))
					r = H.patron_relations[on]
				if(r > best_rel)
					best_rel = r
					best_name = "[on]"
			real_owner = best_name
		else
			real_owner = my_patron

		if(!istext(real_owner) || !length(real_owner))
			qdel(Snew)
			open_learn_ui(H)
			return

		var/owner_rel = (real_owner == my_patron) ? 4 : (H.patron_relations && (real_owner in H.patron_relations) ? H.patron_relations[real_owner] : 0)
		var/max_allowed = allowed_tier_by_relation(owner_rel)
		if(_is_templar(H))
			max_allowed = min(max_allowed, 2)
		if(_is_churchling(H))
			max_allowed = min(max_allowed, 1)
		if(_is_keeper(H))
			max_allowed = min(max_allowed, 3)

		if(tier > max_allowed)
			qdel(Snew)
			to_chat(H, span_warning("你与该主神的关系等级不足以学习这个神迹。"))
			open_learn_ui(H)
			return

		var/cost5 = (real_owner == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN
		if(H.miracle_points < cost5)
			qdel(Snew)
			to_chat(H, span_warning("神迹点不足。"))
			open_learn_ui(H)
			return

		H.miracle_points = max(0, H.miracle_points - cost5)
		H.mind.AddSpell(Snew)
		to_chat(H, span_notice("你学会了[Snew.name]。"))
		open_learn_ui(H)
		return

	if(href_list["relten_up"])
		var/god = href_list["relten_up"]
		build_divine_patrons_index()
		build_inhumen_patrons_index()

		if(!(god in divine_patrons_index) && !(god in inhumen_patrons_index))
			open_research_ui(H)
			return

		if((god in inhumen_patrons_index) && !_shunned_relations_unlocked(H))
			open_research_ui(H)
			return

		var/myname = _get_human_patron_name(H)
		if(length(myname) && god == myname)
			open_research_ui(H)
			return

		var/cur = 0
		if(H.patron_relations && (god in H.patron_relations) && isnum(H.patron_relations[god]))
			cur = H.patron_relations[god]

		if(_is_templar(H) && cur >= 2)
			open_research_ui(H)
			return
		if(_is_churchling(H) && cur >= 1)
			open_research_ui(H)
			return
		if(_is_keeper(H) && cur >= 3)
			open_research_ui(H)
			return
		if(cur >= 4)
			open_research_ui(H)
			return

		var/next = cur + 1
		if(_is_templar(H) && next > 2)
			open_research_ui(H)
			return
		if(_is_churchling(H) && next > 1)
			open_research_ui(H)
			return
		if(_is_keeper(H) && next > 3)
			open_research_ui(H)
			return

		var/cost6 = (next == 1) ? 1 : (next == 2) ? 2 : (next == 3) ? 3 : 4
		if(H.personal_research_points < cost6)
			open_research_ui(H)
			return

		H.personal_research_points = max(0, H.personal_research_points - cost6)
		H.patron_relations[god] = next

		if(next >= 4)
			_apply_t4_traits_for_patron(H, god)

		to_chat(H, span_notice("你与[_cr_patron_name_display(god)]的关系提升至[next]。"))
		open_research_ui(H)
		return

	if(href_list["q_reroll"])
		_update_reroll_charges(H)
		if(H.quest_reroll_charges <= 0)
			open_quests_ui(H)
			return
		H.quest_ui_entries = _rt_build_player_quest_set(H)
		H.quest_reroll_charges = max(0, H.quest_reroll_charges - 1)
		to_chat(H, span_notice("任务已重掷。剩余次数：[H.quest_reroll_charges]。"))
		open_quests_ui(H)
		return

	if(href_list["q_spawn"])
		var/q_index = text2num(href_list["q_spawn"])
		var/diff_key = lowertext(href_list["diff"])

		if(!isnum(q_index))
			open_quests_ui(H)
			return
		if(!islist(H.quest_ui_entries))
			open_quests_ui(H)
			return
		if(q_index < 1 || q_index > H.quest_ui_entries.len)
			open_quests_ui(H)
			return

		var/list/slot = H.quest_ui_entries[q_index]
		if(!islist(slot))
			open_quests_ui(H)
			return

		var/list/diffs = slot["difficulties"]
		if(!islist(diffs) || !(diff_key in diffs))
			open_quests_ui(H)
			return

		var/accepted_diff = slot["accepted_diff"]
		if(!istext(accepted_diff))
			accepted_diff = ""

		if(length(accepted_diff) && accepted_diff != diff_key)
			to_chat(H, span_warning("该任务已经锁定在[_cr_quest_diff_display(accepted_diff)]难度。"))
			open_quests_ui(H)
			return

		var/list/D = diffs[diff_key]
		if(!islist(D))
			open_quests_ui(H)
			return
		if(D["spawned"])
			to_chat(H, span_warning("该任务物品已经发放过了。"))
			open_quests_ui(H)
			return

		var/typepath_q = D["token_path"]
		if(!typepath_q)
			to_chat(H, span_warning("未找到信物类型。"))
			open_quests_ui(H)
			return

		var/obj/item/quest_token/QI = new typepath_q(H)
		if(!QI)
			to_chat(H, span_warning("生成任务物品失败。"))
			open_quests_ui(H)
			return

		QI.set_owner(H)

		var/success = FALSE
		if(hascall(H, "put_in_hands"))
			success = call(H, "put_in_hands")(QI)
		if(!success)
			var/turf/TT = get_turf(H)
			if(TT)
				QI.forceMove(TT)

		var/obj/item/quest_token/QBASE = QI
		if(D["reward"])
			QBASE.reward_amount = D["reward"]

		var/list/P = D["params"]
		if(islist(P))
			if(istype(QI, /obj/item/quest_token/coin_chest))
				var/obj/item/quest_token/coin_chest/CC = QI
				if(P["required_sum"])
					CC.required_sum = P["required_sum"]
			if(istype(QI, /obj/item/quest_token/skill_bless))
				var/obj/item/quest_token/skill_bless/SK = QI
				if(P["required_skills"])
					SK.required_skills = P["required_skills"]
			if(istype(QI, /obj/item/quest_token/blood_draw))
				var/obj/item/quest_token/blood_draw/BD = QI
				if(P["required_race_keys"])
					BD.required_race_keys = P["required_race_keys"]
			if(istype(QI, /obj/item/quest_token/ration_delivery))
				var/obj/item/quest_token/ration_delivery/RD = QI
				if(P["required_job_types"])
					RD.required_job_types = P["required_job_types"]
			if(istype(QI, /obj/item/quest_token/donation_box))
				var/obj/item/quest_token/donation_box/DB = QI
				if(P["need_types"])
					DB.need_types = P["need_types"]
			if(istype(QI, /obj/item/quest_token/sermon_minor))
				var/obj/item/quest_token/sermon_minor/SM = QI
				if(P["required_patron_names"])
					SM.required_patron_names = P["required_patron_names"]
			if(istype(QI, /obj/item/quest_token/reliquary))
				var/obj/item/quest_token/reliquary/RL = QI
				if(P["bonus_patron_names"])
					RL.bonus_patron_names = P["bonus_patron_names"]
			if(istype(QI, /obj/item/quest_token/sermon_witness))
				var/obj/item/quest_token/sermon_witness/SW = QI
				if(P["required_effect_types"])
					SW.required_effect_types = P["required_effect_types"]
			if(istype(QI, /obj/item/quest_token/flaw_aid))
				var/obj/item/quest_token/flaw_aid/FA = QI
				if(P["required_flaw_types"])
					FA.required_flaw_types = P["required_flaw_types"]

		var/base_desc = "[D["desc"]]"
		var/use_desc = " 一次性任务物品。"

		if(istype(QI, /obj/item/quest_token/coin_chest) || istype(QI, /obj/item/quest_token/donation_box) || istype(QI, /obj/item/quest_token/reliquary))
			use_desc = " 可由自己完成的任务物品。"
		else
			use_desc = " 和平使用给予赐福，战斗模式使用则强制接受并施加鄙斥。"

		QI.desc = "[base_desc] 奖励归信物所有者所有（[QBASE.reward_amount] 点恩眷）。[use_desc]"

		D["spawned"] = TRUE
		diffs[diff_key] = D
		slot["accepted_diff"] = diff_key
		slot["difficulties"] = diffs
		H.quest_ui_entries[q_index] = slot

		to_chat(H, span_notice("已发放特殊任务物品：[QI.name]。"))
		open_quests_ui(H)
		return

/// radualk stuff

/obj/effect/proc_holder/spell/self/learnmiracle/cast(list/targets, mob/user)
	if(!..())
		return
	if(!user)
		return

	var/list/rad = list()
	rad["学习"] = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "recruit_acolyte")
	rad["研究"] = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "book1")
	rad["任务"] = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "astrata")

	var/choice = show_radial_menu(user, user, rad, require_near = FALSE)
	if(choice == "学习")
		do_learn_miracle(user)
	else if(choice == "研究")
		open_research_ui(user)
	else if(choice == "任务")
		open_quests_ui(user)
	return

/// slop spells start here

/obj/effect/proc_holder/spell/invoked/diagnose/greater
	name = "高等诊察"
	desc = "精确的神圣检视：显示试剂、血量、器官状态与量化伤害。"
	overlay_state = "diagnose"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 8 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/diagnose/greater/cast(list/targets, mob/living/user)
	if(!targets || !targets.len)
		revert_cast()
		return FALSE

	var/target = targets[1]
	if(!ishuman(target))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = target

	if(hascall(H, "check_for_injuries"))
		H.check_for_injuries(user)

	to_chat(user, span_notice("--- 对[H]进行的神圣诊察 ---"))

	if(H.reagents && H.reagents.reagent_list && H.reagents.reagent_list.len)
		to_chat(user, span_info("检测到试剂："))
		for(var/datum/reagent/R as anything in H.reagents.reagent_list)
			if(!R || R.volume <= 0)
				continue
			to_chat(user, "• [R.name]：[round(R.volume, 0.1)]u")
	else
		to_chat(user, span_notice("未检测到试剂。"))

	var/blood_amt = 0
	if(isnum(H.blood_volume) && H.blood_volume > 0)
		blood_amt = H.blood_volume
	else if(H.reagents && hascall(H.reagents, "get_reagent_amount"))
		blood_amt = H.reagents.get_reagent_amount(/datum/reagent/blood)

	to_chat(user, span_info("血量：[round(blood_amt, 0.1)]u"))

	var/tox = _dg_safe_num(H, list("toxloss"))
	var/oxy = _dg_safe_num(H, list("oxyloss", "oxygen_loss"))
	to_chat(user, span_info("毒素伤害：[tox]"))
	to_chat(user, span_info("缺氧伤害：[oxy]"))

	if(islist(H.bodyparts) && H.bodyparts.len)
		to_chat(user, span_info("身体部位伤害："))
		for(var/obj/item/bodypart/B as anything in H.bodyparts)
			var/br = _dg_safe_num(B, list("brute_dam", "brute_damage", "brute"))
			var/bu = _dg_safe_num(B, list("burn_dam", "burn_damage", "burn"))
			if(br > 0 || bu > 0)
				to_chat(user, "• [B.name]：钝击 [br]，灼烧 [bu]")
	else
		to_chat(user, span_notice("无可用的身体部位伤害数据。"))

	if(islist(H.internal_organs) && H.internal_organs.len)
		to_chat(user, span_info("内脏器官："))
		for(var/obj/item/organ/O as anything in H.internal_organs)
			var/od = 0

			if(hascall(H, "get_organ_loss"))
				if(("slot" in O.vars))
					var/slotv = O.vars["slot"]
					var/tmp_loss = call(H, "get_organ_loss")(slotv)
					if(isnum(tmp_loss))
						od = tmp_loss

			if(!od)
				var/base = _dg_safe_num(O, list("damage", "organ_damage"))
				var/brorg = _dg_safe_num(O, list("brute_dam", "brute_damage"))
				var/buorg = _dg_safe_num(O, list("burn_dam", "burn_damage"))
				od = base + brorg + buorg

			to_chat(user, "• [O.name]：伤害 [od]")
	else
		to_chat(user, span_notice("无可用的内脏器官数据。"))

	return TRUE

/proc/_dg_safe_num(datum/D, list/keys)
	if(!D || !islist(keys))
		return 0
	for(var/k in keys)
		if(k in D.vars)
			var/v = D.vars[k]
			if(isnum(v))
				return v
	return 0
