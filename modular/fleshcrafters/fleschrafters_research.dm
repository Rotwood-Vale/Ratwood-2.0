#ifdef MIRACLE_RADIAL_DMI
#undef  MIRACLE_RADIAL_DMI
#endif
#define MIRACLE_RADIAL_DMI 'icons/mob/actions/roguespells.dmi'

//  CONFIG Me BAlancerS
#ifndef QUEST_COOLDOWN_DS
#define QUEST_COOLDOWN_DS (30*60*10)
#endif
#ifndef QUEST_REWARD_FAVOR
#define QUEST_REWARD_FAVOR 150
#endif

#ifndef CLERIC_PRICE_PATRON
#define CLERIC_PRICE_PATRON 1
#endif
#ifndef CLERIC_PRICE_FOREIGN
#define CLERIC_PRICE_FOREIGN 3
#endif

#ifndef MIRACLE_MP_PRICE_FLAVOR
#define MIRACLE_MP_PRICE_FLAVOR 250
#endif
#ifndef RESEARCH_RP_PRICE_FLAVOR
#define RESEARCH_RP_PRICE_FLAVOR 100
#endif
#ifndef ARTEFACT_PRICE_FAVOR
#define ARTEFACT_PRICE_FAVOR 500
#endif

#ifndef COST_ARTEFACTS
#define COST_ARTEFACTS   5
#endif
#ifndef COST_ORG_T1
#define COST_ORG_T1      5
#endif
#ifndef COST_ORG_T2
#define COST_ORG_T2      5
#endif
#ifndef COST_ORG_T3
#define COST_ORG_T3      500
#endif

#ifndef ORG_PRICE_T1
#define ORG_PRICE_T1 500
#endif
#ifndef ORG_PRICE_T2
#define ORG_PRICE_T2 1000
#endif
#ifndef ORG_PRICE_T3
#define ORG_PRICE_T3 1500
#endif

#ifndef UNLOCK_SHUNNED_RP
#define UNLOCK_SHUNNED_RP 5
#endif

// MOB dont blame me im a retard
/mob/living/carbon/human
	var/miracle_points = 0
	var/church_favor = 0
	var/personal_research_points = 0


	var/unlocked_research_artefacts = FALSE
	var/unlocked_research_org_t1   = FALSE
	var/unlocked_research_org_t2   = FALSE
	var/unlocked_research_org_t3   = FALSE


	var/list/patron_relations = null


	var/list/quest_ui_entries = null
	var/quest_reroll_charges = 0
	var/quest_reroll_last_ds = 0

// GLOB
var/global/list/divine_miracles_cache  = list()
var/global/list/inhumen_miracles_cache = list()
var/global/miracle_caches_built = FALSE

var/global/list/divine_patrons_index = list()
var/global/list/inhumen_patrons_index = list()
var/global/divine_patrons_built = FALSE
var/global/inhumen_patrons_built = FALSE

var/global/list/PATRON_ARTIFACTS = list(
	"Astrata" = list(/obj/item/artifact/astrata_star),
/*	"Noc"     = list(/obj/item/artefact/noc_phylactery), */
	"Dendor"  = list(/obj/item/artefact/dendor_hose),
	"Abyssor" = list(/obj/item/fishingrod/abyssoid),
	"Ravox"   = list(/obj/item/artifact/ravox_lens),
	"Necra"   = list(/obj/item/artefact/necra_censer),
/*	"Xylix"   = list(/obj/item/clothing/gloves/xylix), */
	"Pestra"  = list(/obj/item/rogueweapon/surgery/multitool, /obj/item/needle/pestra, /obj/item/natural/worms/leech/cheele),
	"Malum"   = list(/obj/item/rogueweapon/hammer/artefact/malum),
	"Eora"    = list(/obj/item/artefact/eora_heart),
)

//HE:LP
/proc/build_miracle_caches()
	if(miracle_caches_built) return
	build_cache_for_root(/datum/patron/divine,  divine_miracles_cache)
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

/obj/effect/proc_holder/spell/self/learnmiracle/proc/do_learn_miracle(mob/user)
	if(!user || !user.mind) return
	var/mob/living/carbon/human/H = istype(user, /mob/living/carbon/human) ? user : null
	if(!H) return
	if(!HAS_TRAIT(user, TRAIT_CLERGY)) { to_chat(user, span_warning("Only clergy may contemplate new miracles.")); return }
	if(!H.devotion || !H.devotion.patron) { to_chat(user, span_warning("Your faith has no patron.")); return }
	open_learn_ui(H)

/proc/build_divine_patrons_index()
	if(divine_patrons_built) return
	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine) continue
		var/datum/patron/P = new p_type
		if(P && P.name)
			var/domain = ""; if("domain" in P.vars) domain = "[P.vars["domain"]]"
			var/desc   = ""; if("desc"   in P.vars) desc   = "[P.vars["desc"]]"
			divine_patrons_index["[P.name]"] = list(
				"path"   = p_type,
				"domain" = domain,
				"desc"   = desc
			)
		qdel(P)
	divine_patrons_built = TRUE

/proc/build_inhumen_patrons_index()
	if(inhumen_patrons_built) return
	for(var/p_type in typesof(/datum/patron/inhumen))
		if(p_type == /datum/patron/inhumen) continue
		var/datum/patron/P_inh_idx = new p_type
		if(P_inh_idx && P_inh_idx.name)
			var/domain = ""; if("domain" in P_inh_idx.vars) domain = "[P_inh_idx.vars["domain"]]"
			var/desc   = ""; if("desc"   in P_inh_idx.vars) desc   = "[P_inh_idx.vars["desc"]]"
			inhumen_patrons_index["[P_inh_idx.name]"] = list(
				"path"   = p_type,
				"domain" = domain,
				"desc"   = desc
			)
		qdel(P_inh_idx)
	inhumen_patrons_built = TRUE

/proc/is_divine_spell(obj/effect/proc_holder/spell/S)
	if(!miracle_caches_built) build_miracle_caches()
	return !!divine_miracles_cache[S.type]

/proc/is_inhumen_spell(obj/effect/proc_holder/spell/S)
	if(!miracle_caches_built) build_miracle_caches()
	return !!inhumen_miracles_cache[S.type]

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

	// divine
	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		var/list/rec = divine_patrons_index[n]; if(!islist(rec)) continue
		var/p_type = rec["path"]; if(!p_type) continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			if(!(n in result)) result += "[n]"
		qdel(P)

	// inhumen
	build_inhumen_patrons_index()
	for(var/n2 in inhumen_patrons_index)
		var/list/rec2 = inhumen_patrons_index[n2]; if(!islist(rec2)) continue
		var/p2 = rec2["path"]; if(!p2) continue
		var/datum/patron/P_inh2 = new p2
		if(P_inh2 && islist(P_inh2.miracles) && (spell_path in P_inh2.miracles))
			if(!(n2 in result)) result += "[n2]"
		qdel(P_inh2)

	return result
/proc/status_yn(flag)
	return flag ? "<span style='color:#2ecc71'>Unlocked</span>" : "<span style='color:#e67e22'>Locked</span>"

/proc/html_attr(t as text)
	if(!istext(t)) return ""
	var/s = "[t]"
	s = replacetext(s, "&", "&amp;")
	s = replacetext(s, "<", "&lt;")
	s = replacetext(s, ">", "&gt;")
	s = replacetext(s, "\"", "&quot;")
	s = replacetext(s, "'", "&#39;")
	return s

/proc/_is_templar(mob/living/carbon/human/H)
	if(!H || !H.mind) return FALSE
	var/list/cands = list()
	if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
		var/datum/job/J = H.mind.vars["assigned_job"]
		if(("title" in J.vars) && istext(J.vars["title"])) cands += lowertext("[J.vars["title"]]")
		if(("name"  in J.vars) && istext(J.vars["name" ])) cands += lowertext("[J.vars["name"]]")
	if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"])) cands += lowertext("[H.mind.vars["assigned_role"]]")
	if(("special_role" in H.mind.vars)  && istext(H.mind.vars["special_role"]))  cands += lowertext("[H.mind.vars["special_role"]]")
	for(var/txt in cands)
		if(findtext(txt, "templar"))
			return TRUE
	return FALSE

/proc/_is_churchling(mob/living/carbon/human/H)
	if(!H || !H.mind) return FALSE
	var/list/cands = list()
	if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
		var/datum/job/J = H.mind.vars["assigned_job"]
		if(("title" in J.vars) && istext(J.vars["title"])) cands += lowertext("[J.vars["title"]]")
		if(("name"  in J.vars) && istext(J.vars["name" ])) cands += lowertext("[J.vars["name"]]")
	if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"])) cands += lowertext("[H.mind.vars["assigned_role"]]")
	if(("special_role" in H.mind.vars)  && istext(H.mind.vars["special_role"]))  cands += lowertext("[H.mind.vars["special_role"]]")
	for(var/txt in cands)
		if(findtext(txt, "churchling"))
			return TRUE
	return FALSE

//T0-T4 or T1-T4 probably the first one coz its related to spells
/proc/_tier_from_patrons(spell_path)
	if(!ispath(spell_path, /obj/effect/proc_holder/spell)) return 0
	var/max_tier = 0
	// divine
	for(var/p_type in typesof(/datum/patron/divine))
		if(p_type == /datum/patron/divine) continue
		var/datum/patron/P = new p_type
		if(P && islist(P.miracles) && (spell_path in P.miracles))
			var/v = P.miracles[spell_path]
			if(isnum(v)) max_tier = max(max_tier, v)
		qdel(P)
	// inhumen
	for(var/i_type in typesof(/datum/patron/inhumen))
		if(i_type == /datum/patron/inhumen) continue
		var/datum/patron/P_inh = new i_type
		if(P_inh && islist(P_inh.miracles) && (spell_path in P_inh.miracles))
			var/vi = P_inh.miracles[spell_path]
			if(isnum(vi)) max_tier = max(max_tier, vi)
		qdel(P_inh)
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
	if(!tmp && spell_path)
		tmp = new spell_path

	var/tier_val = 0
	if(tmp)
		var/list/v = tmp.vars
		if(islist(v))
			if("tier" in v)
				var/tt = v["tier"]
				if(isnum(tt)) tier_val = tt
			if(!tier_val && ("miracle_tier" in v))
				var/mt = v["miracle_tier"]
				if(isnum(mt)) tier_val = mt
	if(!S && tmp) qdel(tmp)

	if(tier_val <= 0 && spell_path)
		tier_val = _tier_from_patrons(spell_path)

	if(!isnum(tier_val)) tier_val = 0
	if(tier_val < 0) tier_val = 0
	if(tier_val > 4) tier_val = 4
	return tier_val

// 0 → -1 (nuffin), 1 → 1, 2 → 2, 3 → 3, 4 → 4
/proc/allowed_tier_by_relation(level)
	if(!isnum(level) || level <= 0)
		return 0      // 0  →  tier 0

	if(level == 1)
		return 1      //  1 → T1
	if(level == 2)
		return 2      //  2 → T2
	if(level == 3)
		return 3      // 3 → T3

	return 4          // 4 →  T4

/proc/get_spell_patron_name(spell_input)
	var/spell_path = null
	if(ispath(spell_input))
		spell_path = spell_input
	else if(istype(spell_input, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/SN = spell_input
		spell_path = SN.type
	else
		return ""

	// divine
	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		var/list/rec = divine_patrons_index[n]
		if(!islist(rec)) continue
		var/p_type = rec["path"]; if(!p_type) continue
		var/datum/patron/P = new p_type
		var/found = (P && islist(P.miracles) && (spell_path in P.miracles))
		qdel(P)
		if(found) return "[n]"

	// inhumen
	build_inhumen_patrons_index()
	for(var/n2 in inhumen_patrons_index)
		var/list/rec2 = inhumen_patrons_index[n2]
		if(!islist(rec2)) continue
		var/p2 = rec2["path"]; if(!p2) continue
		var/datum/patron/P_inh2 = new p2
		var/f2 = (P_inh2 && islist(P_inh2.miracles) && (spell_path in P_inh2.miracles))
		qdel(P_inh2)
		if(f2) return "[n2]"

	return ""

/proc/_is_inhumen_patron_name(n as text)
	if(!istext(n) || !length(n)) return FALSE
	build_inhumen_patrons_index()
	return (n in inhumen_patrons_index)

// I forgot what it does but probably it unlocks shunned relations
/proc/_shunned_relations_unlocked(mob/living/carbon/human/H)
	if(!H) return FALSE
	if(_is_churchling(H)) return TRUE
	build_inhumen_patrons_index()
	if(!islist(H.patron_relations)) return FALSE
	for(var/n in inhumen_patrons_index)
		if(n in H.patron_relations)
			return TRUE
	return FALSE

// REROLL PROC
/proc/_update_reroll_charges(mob/living/carbon/human/H)
	if(!H) return
	if(!H.quest_reroll_last_ds) H.quest_reroll_last_ds = world.time
	var/delta = world.time - H.quest_reroll_last_ds
	if(delta < QUEST_COOLDOWN_DS) return
	var/add = round(delta / QUEST_COOLDOWN_DS)
	if(add > 0)
		H.quest_reroll_charges += add
		H.quest_reroll_last_ds += add * QUEST_COOLDOWN_DS

// CODE DONT MIND
/obj/item/church_artefact
	name = "sacred artefact"
	desc = "A token blessed by a patron."
	var/patron_name = ""

/obj/item/church_artefact/New(loc, p_name)
	. = ..()
	if(istext(p_name))
		patron_name = p_name
		name = "Sacred Artefact of [p_name]"

// SPELL
/obj/effect/proc_holder/spell/self/learnmiracle
	name = "Miracles"
	desc = "Open miracle actions."
	overlay_state = "startmiracle"

	var/current_org_tab = "none"   // none | t1 | t2 | t3
	var/current_art_tab = "none"
	var/current_rel_tab = "none"   // none | ten | shunned
	var/current_learn_tab = "none" // none | patron_name

/obj/effect/proc_holder/spell/self/learnmiracle/proc/_ensure_relations(mob/living/carbon/human/H)
	if(!H.patron_relations || !islist(H.patron_relations))
		H.patron_relations = list()

	build_divine_patrons_index()
	for(var/n in divine_patrons_index)
		if(!(n in H.patron_relations))
			H.patron_relations[n] = 0

	build_inhumen_patrons_index()
	if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
		var/myname = "[H.devotion.patron.vars["name"]]"
		if(length(myname))
			H.patron_relations[myname] = 4

	if(_shunned_relations_unlocked(H))
		for(var/sn in inhumen_patrons_index)
			if(!(sn in H.patron_relations))
				H.patron_relations[sn] = 0

//  LEARN

/obj/effect/proc_holder/spell/self/learnmiracle/proc/_build_learn_buckets(mob/living/carbon/human/H, include_inhumen = FALSE)
	if(!miracle_caches_built) build_miracle_caches()
	_ensure_relations(H)
	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/my_patron = ""
	if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
		my_patron = "[H.devotion.patron.vars["name"]]"

	var/is_templar = _is_templar(H)
	var/is_churchling = _is_churchling(H)

	// I-know-what-you-have-already
	var/list/already_types = list()
	if(H?.mind)
		for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
			already_types[K.type] = TRUE

	// ***  divine + inhumen double soul cultivation into SET
	var/list/all_spell_types = list()
	for(var/st1 in divine_miracles_cache)  all_spell_types[st1] = TRUE
	for(var/st2 in inhumen_miracles_cache) all_spell_types[st2] = TRUE

	var/list/buckets = list() // patron_name -> list(entries)

	for(var/st in all_spell_types)
		var/obj/effect/proc_holder/spell/S = new st
		if(!S) continue

		var/tier = get_spell_tier(S)

		// *** all
		var/list/owners = get_spell_patron_names(st)

		// *** set your own
		if(!islist(owners) || !owners.len)
			if(length(my_patron)) owners = list(my_patron)
			else owners = list()

		for(var/owner_name in owners)
			// *** inhumen unlocks “Shunned”
			if(_is_inhumen_patron_name(owner_name) && !_shunned_relations_unlocked(H))
				continue

			var/owner_rel = (owner_name == my_patron) ? 4 : (H.patron_relations && (owner_name in H.patron_relations) ? H.patron_relations[owner_name] : 0)
			var/max_allowed = allowed_tier_by_relation(owner_rel)
			if(is_templar) max_allowed = min(max_allowed, 2)
			if(is_churchling) max_allowed = min(max_allowed, 1)

			if(tier > max_allowed) continue

			if(!(owner_name in buckets)) buckets[owner_name] = list()
			var/list/L = buckets[owner_name]

			var/is_learned = !!already_types[st]
			var/cost = (owner_name == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN

			L += list(list(
				"name"    = S.name,
				"desc"    = S.desc,
				"tier"    = tier,
				"cost"    = cost,
				"type"    = st,
				"learned" = is_learned // ***
			))
			buckets[owner_name] = L

		qdel(S)

	return buckets

// AAAAAAAAAAAAAAAAA LEARN UI

/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_learn_ui(mob/living/carbon/human/H)
	var/list/buckets = _build_learn_buckets(H, FALSE)

	build_divine_patrons_index()
	build_inhumen_patrons_index()

	var/list/names_div = list()
	for(var/pn1 in divine_patrons_index) names_div += "[pn1]"
	names_div = sortList(names_div)

	var/list/names_inh = list()
	for(var/pn2 in inhumen_patrons_index) names_inh += "[pn2]"
	names_inh = sortList(names_inh)

	var/sh_unl = _shunned_relations_unlocked(H)

	var/html = "<center><h3>Learn Miracles</h3></center><hr>"
	html += "Favor: <b>[H.church_favor]</b> | MP: <b>[H.miracle_points]</b><hr>"

	var/list/nav = list()

	// None
	if(src.current_learn_tab == "none")
		nav += "<b>None</b>"
	else
		nav += "<a href='?src=[REF(src)];learntab=none'>None</a>"

	// --- divine
	for(var/n in names_div)
		var/relv = H.patron_relations && (n in H.patron_relations) ? H.patron_relations[n] : 0
		if(relv > 0)
			nav += (src.current_learn_tab == "[n]") ? "<b>[n]</b>" : "<a href='?src=[REF(src)];learntab=[n]'>[n]</a>"
		else
			nav += "<span style='color:#7f8c8d'>[n]</span>"

	// --- inhumen
	for(var/n2 in names_inh)
		var/relv2 = H.patron_relations && (n2 in H.patron_relations) ? H.patron_relations[n2] : 0
		if(sh_unl && relv2 > 0)
			nav += (src.current_learn_tab == "[n2]") ? "<b>[n2]</b>" : "<a href='?src=[REF(src)];learntab=[n2]'>[n2]</a>"
		else
			nav += "<span style='color:#7f8c8d'>[n2]</span>"

	html += jointext(nav, " | ") + "<br><br>"

	var/list/show_list = list()

	if(src.current_learn_tab != "none")
		if(islist(buckets[src.current_learn_tab]) && length(buckets[src.current_learn_tab]))
			show_list += src.current_learn_tab

	if(!show_list.len)
		if(src.current_learn_tab == "none")
			html += "<i>Select a patron above to see their miracles.</i>"
		else
			html += "<i>No miracles available for this patron.</i>"
	else
		for(var/pn3 in show_list)
			var/list/L = buckets[pn3]
			if(!islist(L) || !L.len) continue
			html += "<b>[html_attr(pn3)]</b><br>"
			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>Miracle</th><th>Description</th><th width='50'>Tier</th><th width='100'>Cost</th><th width='140'>Action</th></tr>"

			for(var/entry in L)
				var/list/E = entry
				var/nm     = "[E["name"]]"
				var/desc   = "[E["desc"]]"
				var/tier   = E["tier"]
				var/cost   = E["cost"]
				var/txtpath= "[E["type"]]"
				var/is_learned = E["learned"] // ***

				html += "<tr>"
				html += "<td><b>[html_attr(nm)]</b></td>"
				html += "<td>[html_attr(desc)]</td>"
				html += "<td align='center'>[tier]</td>"
				html += "<td align='center'>[cost] MP</td>"
				html += "<td align='center'>"

				if(is_learned)
					html += "<span style='color:#2ecc71'>Learned</span>"
				else if(H.miracle_points >= cost)
					html += "<a href='?src=[REF(src)];learnspell=[txtpath]'>Learn</a>"
				else
					html += "<span style='color:#7f8c8d'>Not enough MP</span>"

				html += "</td></tr>"
			html += "</table><br>"

	var/datum/browser/B = new(H, "MIRACLE_LEARN", "", 720, 620)
	B.set_content(html)
	B.open()

// ------- RESEARCH UI --
/obj/effect/proc_holder/spell/self/learnmiracle/proc/_organs_shop_block(mob/living/carbon/human/H)
	var/html = ""
	var/any_unlocked = (H.unlocked_research_org_t1 || H.unlocked_research_org_t2 || H.unlocked_research_org_t3)
	if(!any_unlocked)
		return html

	html += "<hr><b>Organs</b><br>"

	var/list/navO = list()
	if(src.current_org_tab == "none") navO += "<b>None</b>"
	else navO += "<a href='?src=[REF(src)];orgtab=none'>None</a>"

	if(H.unlocked_research_org_t1)
		navO += (src.current_org_tab == "t1") ? "<b>T1</b>" : "<a href='?src=[REF(src)];orgtab=t1'>T1</a>"
	if(H.unlocked_research_org_t2)
		navO += (src.current_org_tab == "t2") ? "<b>T2</b>" : "<a href='?src=[REF(src)];orgtab=t2'>T2</a>"
	if(H.unlocked_research_org_t3)
		navO += (src.current_org_tab == "t3") ? "<b>T3</b>" : "<a href='?src=[REF(src)];orgtab=t3'>T3</a>"

	html += jointext(navO, " | ") + "<br><br>"

	if(src.current_org_tab == "none")
		html += "<i>Choose a tier to buy organs.</i>"
		return html

	var/price = 0
	if(src.current_org_tab == "t1") price = ORG_PRICE_T1
	else if(src.current_org_tab == "t2") price = ORG_PRICE_T2
	else if(src.current_org_tab == "t3") price = ORG_PRICE_T3

	html += "<table width='100%' cellspacing='2' cellpadding='2'>"
	html += "<tr><th align='left'>Organ</th><th width='180'>Action</th></tr>"

	var/list/labels = list("eyes","stomach","liver","heart","lungs")
	for(var/L in labels)
		html += "<tr><td>[capitalize(L)]</td><td align='center'>"
		if(HAS_TRAIT(H, TRAIT_CLERGY) && H.church_favor >= price)
			html += "<a href='?src=[REF(src)];buyorg=[src.current_org_tab];item=[L]'>Buy ([price] Favor)</a>"
		else
			html += "<span style='color:#7f8c8d'>Buy ([price] Favor)</span>"
		html += "</td></tr>"

	html += "</table>"
	return html

/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_research_ui(mob/user)
	var/mob/living/carbon/human/H = istype(user, /mob/living/carbon/human) ? user : null
	if(!H) return
	_ensure_relations(H)
	_update_reroll_charges(H)

	var/rp = H.personal_research_points
	var/fv = H.church_favor
	var/mp = H.miracle_points

	var/html = "<center><h3>Miracle Research</h3></center><hr>"
	html += "<b>Research Points:</b> [rp]<br>"
	html += "<b>Favor:</b> [fv]<br>"
	html += "<b>Miracle Points:</b> [mp]<br>"
	html += "<hr>"

	// Miracle point gimme
	if(HAS_TRAIT(H, TRAIT_CLERGY))
		if(fv >= RESEARCH_RP_PRICE_FLAVOR) html += "<a href='?src=[REF(src)];buyrp=1'>Buy 1 RP ([RESEARCH_RP_PRICE_FLAVOR] Favor)</a><br>"
		else html += "<span style='color:#7f8c8d'>Buy 1 RP ([RESEARCH_RP_PRICE_FLAVOR] Favor)</span><br>"

		if(fv >= MIRACLE_MP_PRICE_FLAVOR) html += "<a href='?src=[REF(src)];buymp=1'>Buy 1 MP ([MIRACLE_MP_PRICE_FLAVOR] Favor)</a><br>"
		else html += "<span style='color:#7f8c8d'>Buy 1 MP ([MIRACLE_MP_PRICE_FLAVOR] Favor)</span><br>"
	else
		html += "<span style='color:#7f8c8d'>Only clergy can buy RP/MP.</span><br>"

	// Studies general shit
	html += "<hr><b>Studies</b><br>"
	html += "<table width='100%' cellspacing='2' cellpadding='2'>"
	html += "<tr><th align='left'>Study</th><th width='110'>Status</th><th width='220'>Action</th></tr>"

	// Artefacts
	html += "<tr><td>Artefacts</td><td>[status_yn(H.unlocked_research_artefacts)]</td><td align='center'>"
	if(!H.unlocked_research_artefacts)
		if(rp >= COST_ARTEFACTS)	html += "<a href='?src=[REF(src)];unlock=artefacts'>Unlock ([COST_ARTEFACTS] RP)</a>"
		else						html += "<span style='color:#7f8c8d'>Unlock ([COST_ARTEFACTS] RP)</span>"
	else
		html += "<span style='color:#7f8c8d'>-</span>"
	html += "</td></tr>"

	// Organs slops
	html += "<tr><td>Organs T1</td><td>[status_yn(H.unlocked_research_org_t1)]</td><td align='center'>"
	if(!H.unlocked_research_org_t1)
		if(rp >= COST_ORG_T1)	html += "<a href='?src=[REF(src)];unlock=org_t1'>Unlock ([COST_ORG_T1] RP)</a>"
		else					html += "<span style='color:#7f8c8d'>Unlock ([COST_ORG_T1] RP)</span>"
	else html += "<span style='color:#7f8c8d'>-</span>"
	html += "</td></tr>"

	html += "<tr><td>Organs T2</td><td>[status_yn(H.unlocked_research_org_t2)]</td><td align='center'>"
	if(!H.unlocked_research_org_t2)
		if(rp >= COST_ORG_T2)	html += "<a href='?src=[REF(src)];unlock=org_t2'>Unlock ([COST_ORG_T2] RP)</a>"
		else					html += "<span style='color:#7f8c8d'>Unlock ([COST_ORG_T2] RP)</span>"
	else html += "<span style='color:#7f8c8d'>-</span>"
	html += "</td></tr>"

	html += "<tr><td>Organs T3</td><td>[status_yn(H.unlocked_research_org_t3)]</td><td align='center'>"
	if(!H.unlocked_research_org_t3)
		if(rp >= COST_ORG_T3)	html += "<a href='?src=[REF(src)];unlock=org_t3'>Unlock ([COST_ORG_T3] RP)</a>"
		else					html += "<span style='color:#7f8c8d'>Unlock ([COST_ORG_T3] RP)</span>"
	else html += "<span style='color:#7f8c8d'>-</span>"
	html += "</td></tr>"

	// Unlockshynned
	var/sh_unl = _shunned_relations_unlocked(H)
	html += "<tr><td>Shunned Knowledges</td><td>[status_yn(sh_unl)]</td><td align='center'>"
	if(!sh_unl)
		if(H.personal_research_points >= UNLOCK_SHUNNED_RP)
			html += "<a href='?src=[REF(src)];unlock_shunned_rel=1'>Unlock ([UNLOCK_SHUNNED_RP] RP)</a>"
		else
			html += "<span style='color:#7f8c8d'>Unlock ([UNLOCK_SHUNNED_RP] RP)</span>"
	else
		html += "<span style='color:#7f8c8d'>-</span>"
	html += "</td></tr>"

	html += "</table>"

	// THIS SHIT RELATED TO FEAR AND HUNGER STARTS HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	var/list/nav_bits = list()
	nav_bits += (src.current_rel_tab == "none") ? "<b>Relations: None</b>" : "<a href='?src=[REF(src)];reltab=none'>Relations: None</a>"
	nav_bits += (src.current_rel_tab == "ten")  ? "<b>Ten</b>" : "<a href='?src=[REF(src)];reltab=ten'>Ten</a>"

	// + shunned
	if(_shunned_relations_unlocked(H))
		nav_bits += (src.current_rel_tab == "shunned") ? "<b>Ascendants</b>" : "<a href='?src=[REF(src)];reltab=shunned'>Shunned</a>"
	else
		nav_bits += "<span style='color:#7f8c8d'>Ascendants</span>"

	html += "<hr>" + jointext(nav_bits, " | ") + "<br>"

	var/is_templar = _is_templar(H)
	var/is_churchling = _is_churchling(H)
	var/rel_cap = is_templar ? 2 : (is_churchling ? 1 : 4)
	//CHURCHLING PART ENDS

	// - Relations content STARTS HERE OH MY GOD I HATE BLANCE
	if(src.current_rel_tab == "ten" || (src.current_rel_tab == "shunned" && _shunned_relations_unlocked(H)))
		var/list/idx = (src.current_rel_tab == "shunned") ? inhumen_patrons_index : divine_patrons_index
		if(idx && idx.len)
			// To be or not to be
			html += "<br><b>[src.current_rel_tab == "shunned" ? "Shunned" : "Ten"] - Patron Relationships</b><br>"
			html += "<div style='margin:6px 0; padding:8px; background:#222831; border-radius:6px;'>"
			html += "<div><i>Relation chart (0..[rel_cap]):</i></div>"

			var/list/names_chart = list()
			for(var/nc in idx) names_chart += "[nc]"
			names_chart = sortList(names_chart)

			// MY PATRON YIPPIE
			var/my_patron = ""
			if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
				my_patron = "[H.devotion.patron.vars["name"]]"

			for(var/gn in names_chart)
				var/curv = H.patron_relations && (gn in H.patron_relations) ? H.patron_relations[gn] : 0
				if(curv > rel_cap) curv = rel_cap
				var/perc = round((curv * 100) / rel_cap)
				if(perc < 0) perc = 0
				if(perc > 100) perc = 100
				var/bar_color = (gn == my_patron) ? "#2ecc71" : "#3498db"

				html += "<div style='margin:6px 0;'>"
				html += "<div style='font-size:12px;color:#ecf0f1;'>[html_attr(gn)] - <b>[curv]</b>/[rel_cap]</div>"
				html += "<div style='background:#2c3e50;height:10px;border-radius:6px;overflow:hidden;'>"
				html += "<div style='width:[perc]%;height:10px;background:[bar_color];'></div>"
				html += "</div></div>"

			html += "</div><br>"

			// Upgraded Yus
			html += "<table width='100%' cellspacing='2' cellpadding='2'>"
			html += "<tr><th align='left'>Patron</th><th>Domain</th><th width='80'>Level</th><th width='220'>Action</th></tr>"

			var/list/names = list()
			for(var/n in idx) names += "[n]"
			names = sortList(names)

			for(var/n in names)
				var/list/rec = idx[n]
				var/dom = "[rec["domain"]]"
				var/cur = H.patron_relations && (n in H.patron_relations) ? H.patron_relations[n] : 0
				if(cur > rel_cap) cur = rel_cap

				html += "<tr>"
				html += "<td><b>[html_attr(n)]</b></td>"
				html += "<td>[html_attr(dom)]</td>"
				html += "<td align='center'><b>[cur]</b>/[rel_cap]</td>"
				html += "<td align='center'>"

				if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars) && ("[H.devotion.patron.vars["name"]]" == n))
					html += "<span style='color:#2ecc71'>Own patron (max).</span>"
				else
					if(cur >= rel_cap)
						html += "<span style='color:#2ecc71'>Maxed</span>"
					else
						var/next = cur + 1
						if(next > rel_cap) next = rel_cap
						var/cost = (next == 1) ? 1 : (next == 2) ? 2 : (next == 3) ? 3 : 4
						var/can = TRUE
						if(src.current_rel_tab == "shunned" && !_shunned_relations_unlocked(H)) can = FALSE
						if(can && H.personal_research_points >= cost)
							html += "<a href='?src=[REF(src)];relten_up=[n]'>Upgrade to [next] ([cost] RP)</a>"
						else
							html += "<span style='color:#7f8c8d'>Upgrade to [next] ([cost] RP)</span>"

				html += "</td></tr>"

			html += "</table>"
		else
			html += "<i>No patrons found.</i>"
	else
		html += "<i>Relations hidden (None).</i>"

	// Artefacts
	if(H.unlocked_research_artefacts)
		build_divine_patrons_index()
		if(divine_patrons_index && length(divine_patrons_index))
			html += "<hr><b>Artefacts</b><br>"

			var/list/nav = list()
			if(src.current_art_tab == "none") nav += "<b>None</b>"
			else nav += "<a href='?src=[REF(src)];arttab=none'>None</a>"

			var/list/names2 = list()
			for(var/n2 in divine_patrons_index) names2 += "[n2]"
			names2 = sortList(names2)

			for(var/n2 in names2)
				if(src.current_art_tab == "[n2]") nav += "<b>[n2]</b>"
				else nav += "<a href='?src=[REF(src)];arttab=[n2]'>[n2]</a>"

			html += jointext(nav, " | ") + "<br><br>"

			if(src.current_art_tab == "none")
				html += "<i>Artefacts list hidden (None).</i>"
			else
				var/rec2 = divine_patrons_index[src.current_art_tab]
				if(rec2)
					var/domain2 = "[rec2["domain"]]"
					var/desc2   = "[rec2["desc"]]"

					html += "<b>[src.current_art_tab]</b><br>"
					if(length(domain2)) html += "<i>[domain2]</i><br>"
					if(length(desc2))   html += "<div style='color:#7f8c8d'>[desc2]</div>"
					html += "<br>"

					var/list/art_list = PATRON_ARTIFACTS ? PATRON_ARTIFACTS[src.current_art_tab] : null
					if(islist(art_list) && art_list.len)
						html += "<table width='100%' cellspacing='2' cellpadding='2'>"
						html += "<tr><th align='left'>Artefact</th><th width='160'>Action</th></tr>"
						for(var/T in art_list)
							var/name_txt = "[T]"
							var/obj/O = new T
							if(O && length(O.name)) name_txt = O.name
							if(O) qdel(O)
							html += "<tr><td>[html_attr(name_txt)]</td><td align='center'>"
							if(HAS_TRAIT(H, TRAIT_CLERGY))
								if(H.church_favor >= ARTEFACT_PRICE_FAVOR)
									html += "<a href='?src=[REF(src)];buyart=[src.current_art_tab];item=[T]'>Buy ([ARTEFACT_PRICE_FAVOR] Favor)</a>"
								else
									html += "<span style='color:#7f8c8d'>Buy ([ARTEFACT_PRICE_FAVOR] Favor)</span>"
							else
								html += "<span style='color:#7f8c8d'>Only clergy may buy artefacts.</span>"
							html += "</td></tr>"
						html += "</table>"
					else
						html += "<i>No artefacts listed for this patron.</i>"

	// Organs slop
	html += _organs_shop_block(H)

	var/datum/browser/B = new(user, "MIRACLE_RESEARCH", "", 740, 860)
	B.set_content(html)
	B.open()

// ---- QUESTS UI
/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_quests_ui(mob/user)
	var/mob/living/carbon/human/H = istype(user, /mob/living/carbon/human) ? user : null
	if(!H) return

	var/init_needed = TRUE
	if(islist(H.quest_ui_entries))
		if(H.quest_ui_entries.len >= 1)
			init_needed = FALSE

	if(init_needed)
		H.quest_ui_entries = _rt_build_player_quest_set(H) // see quests.dm
		if(!H.quest_reroll_last_ds) H.quest_reroll_last_ds = world.time
	_update_reroll_charges(H)

	var/charges = H.quest_reroll_charges
	var/next_left_ds = max(0, QUEST_COOLDOWN_DS - (world.time - H.quest_reroll_last_ds))
	var/left_s  = round(next_left_ds / 10)
	var/mins    = left_s / 60
	var/secs    = left_s % 60
	var/secs_str = (secs < 10) ? "0[secs]" : "[secs]"

	var/html = "<center><h3 style='color:#3498db;margin:6px 0;'>Parish Assignments</h3>"
	if(charges >= 1)
		html += "<div style='margin-top:6px;'><a href='?src=[REF(src)];q_reroll=1' style='background:#8e44ad;color:#fff;padding:3px 8px;border-radius:6px;text-decoration:none;'><b>Reroll (charges: [charges])</b></a></div>"
	else
		html += "<div style='margin-top:6px;color:#9b59b6;'>Next charge in: <b>[mins]:[secs_str]</b></div>"

	html += "<div style='color:#e74c3c; text-align:center; margin:6px 0;'>"
	html += "<b>How it works:</b><br>"
	html += "You get three different quest themes.<br>"
	html += "Each quest can have <u>Easy / Medium / Hard</u> variants, or just one special task.<br>"
	html += "When you click <b>Get special item</b> on one row, you lock that quest to that difficulty and receive a quest item.<br>"
	html += "Other rows for that quest lock until reroll.<br>"
	html += "Use the item under listed conditions to gain Favor. The item self-destructs in ~3 minutes."
	html += "</div></center><hr>"

	// *** BYOND says we cannot have at home "?.len" . Like the code works well ok buttttttttttttttttttttttttttttttttt
	var/quest_count = islist(H.quest_ui_entries) ? H.quest_ui_entries.len : 0

	for(var/i = 1, i <= quest_count, i++)
		var/list/slot = H.quest_ui_entries[i]
		if(!islist(slot)) continue

		var/quest_title = "[slot["title"]]"
		var/accepted_diff = slot["accepted_diff"]; if(!istext(accepted_diff)) accepted_diff = ""

		html += "<div style='padding:10px;'>"
		html += "<center><b style='font-size:14px; color:#ecf0f1; background:#34495e; padding:2px 8px; border-radius:6px;'>[quest_title]</b></center>"
		html += "<br>"

		html += "<table width='100%' cellspacing='2' cellpadding='2' style='text-align:center;'>"
		html += "<tr style='background:#2c3e50;color:#ecf0f1;'><th>Difficulty</th><th>Task</th><th>Reward</th><th>Action</th></tr>"

		var/list/diffs = slot["difficulties"]
		if(islist(diffs))
			var/list/diff_order = list()
			if("easy" in diffs)   diff_order += "easy"
			if("medium" in diffs) diff_order += "medium"
			if("hard" in diffs)   diff_order += "hard"
			for(var/other in diffs) if(!(other in diff_order)) diff_order += other

			for(var/diff_key in diff_order)
				if(!(diff_key in diffs)) continue
				var/list/D = diffs[diff_key]; if(!islist(D)) continue

				var/diff_label = uppertext("[diff_key]")
				var/desc_txt   = "[D["desc"]]"
				var/reward_txt = "[D["reward"]]"
				var/spawned    = D["spawned"]
				var/locked = (length(accepted_diff) && (accepted_diff != diff_key))

				html += "<tr>"
				html += "<td><b>[diff_label]</b></td>"
				html += "<td>[desc_txt]</td>"
				html += "<td style='color:#2ecc71'><b>[reward_txt]</b> Favor</td>"
				html += "<td>"

				if(locked)
					html += "<span style='display:inline-block; padding:4px 10px; border-radius:6px; background:#7f8c8d; color:#ecf0f1;'>Locked</span>"
				else
					if(spawned)
						html += "<span style='display:inline-block; padding:4px 10px; border-radius:6px; background:#7f8c8d; color:#ecf0f1;'>Item spawned</span>"
					else
						html += "<a href='?src=[REF(src)];q_spawn=[i];diff=[diff_key]' style='display:inline-block; padding:4px 10px; border-radius:6px; background:#1abc9c; color:#ffffff; text-decoration:none;'>Get special item</a>"

				html += "</td></tr>"

		html += "</table>"
		html += "</div>"

		if(i < quest_count)
			html += "<hr style='border-color:#2c3e50;'>"

	var/datum/browser/B2 = new(user, "MIRACLE_QUESTS", "", 720, 780)
	B2.set_content(html)
	B2.open()

// -- UPGRADE UI
/obj/effect/proc_holder/spell/self/learnmiracle/proc/open_upgrade_ui(mob/user)
	if(!istype(user, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = user

	var/has_diag = FALSE
	var/has_diag_g = FALSE

	if(H?.mind)
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose)) has_diag = TRUE
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose/greater)) has_diag_g = TRUE

	var/html = "<center><h3>Upgrades</h3></center><hr>"
	html += "<b>Diagnose → Greater Diagnose</b><br>"

	if(has_diag_g) html += "<span style='color:#2ecc71'>Already upgraded.</span>"
	else if(has_diag)
		if(H.miracle_points >= 2)
			html += "<a href='?src=[REF(src)];upgrade_diag=1'>Upgrade now (2 MP)</a>"
		else
			html += "<span style='color:#7f8c8d'>Upgrade now (2 MP)</span>"
	else html += "<span style='color:#7f8c8d'>You must learn \"Diagnose\" first.</span>"

	var/datum/browser/B = new(user, "MIRACLE_UPGRADES", "", 420, 200)
	B.set_content(html)
	B.open()

// -------------------- TOPIC --------------------
/obj/effect/proc_holder/spell/self/learnmiracle/Topic(href, href_list)
	. = ..()
	if(!usr || !istype(usr, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = usr
	_ensure_relations(H)

	// REJOYCE MORE THAN 1 REROLL
	if(href_list["q_reroll"])
		_update_reroll_charges(H)
		if(H.quest_reroll_charges <= 0)
			open_quests_ui(H)
			return
		H.quest_ui_entries = _rt_build_player_quest_set(H)
		H.quest_reroll_charges = max(0, H.quest_reroll_charges - 1)
		to_chat(H, span_notice("Quests rerolled. Charges left: [H.quest_reroll_charges]."))
		open_quests_ui(H)
		return

	if(href_list["q_spawn"])
		var/q_index = text2num(href_list["q_spawn"])
		var/diff_key = lowertext(href_list["diff"])
		if(!isnum(q_index) || q_index < 1 || q_index > (H.quest_ui_entries?.len || 0)) { open_quests_ui(H); return }
		var/list/slot = H.quest_ui_entries[q_index]; if(!islist(slot)) { open_quests_ui(H); return }
		var/list/diffs = slot["difficulties"]; if(!islist(diffs) || !(diff_key in diffs)) { open_quests_ui(H); return }

		var/accepted_diff = slot["accepted_diff"]; if(!istext(accepted_diff)) accepted_diff = ""
		if(length(accepted_diff) && accepted_diff != diff_key)
			to_chat(H, span_warning("This quest is already locked to [uppertext(accepted_diff)]."))
			open_quests_ui(H); return

		var/list/D = diffs[diff_key]; if(!islist(D)) { open_quests_ui(H); return }
		if(D["spawned"]) { to_chat(H, span_warning("The quest item has already been granted.")); open_quests_ui(H); return }

		var/typepath = D["token_path"]; if(!typepath) { to_chat(H, span_warning("Token type not found.")); open_quests_ui(H); return }
		var/obj/item/quest_token/QI = new typepath(H); if(!QI) { to_chat(H, span_warning("Failed to spawn the quest item.")); open_quests_ui(H); return }

		var/success = FALSE
		if(ismob(H) && hascall(H, "put_in_hands")) success = call(H, "put_in_hands")(QI)
		if(!success) { var/turf/TT = get_turf(H); if(TT) QI.forceMove(TT) }

		if(istype(QI, /obj/item/quest_token))
			var/obj/item/quest_token/QBASE = QI
			if(D["reward"]) QBASE.reward_amount = D["reward"]

		var/list/P = D["params"]
		if(islist(P))
			// YES WE KEEP PARAM WIRING FOR EXISTING TOKENS
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
		slot["difficulties"]  = diffs
		H.quest_ui_entries[q_index] = slot

		to_chat(H, span_notice("A special quest item has been granted: [QI.name]."))
		open_quests_ui(H)
		return

	// Relations tab switch html shit
	if(href_list["reltab"])
		var/tb = lowertext(href_list["reltab"])
		if(tb == "ten") src.current_rel_tab = "ten"
		else if(tb == "shunned")
			if(_shunned_relations_unlocked(H)) src.current_rel_tab = "shunned"
			else src.current_rel_tab = "none"
		else src.current_rel_tab = "none"
		open_research_ui(H); return

	// Relation upgrade html shit
	if(href_list["relten_up"])
		var/god = href_list["relten_up"]
		build_divine_patrons_index()
		build_inhumen_patrons_index()
		if(!(god in divine_patrons_index) && !(god in inhumen_patrons_index)) { open_research_ui(H); return }

		// YES OR YES NO OR NO
		if((god in inhumen_patrons_index))
			if(!_shunned_relations_unlocked(H))
				if(!(H.devotion && H.devotion.patron && "[H.devotion.patron.vars["name"]]" == god))
					open_research_ui(H); return

		if(H.devotion && H.devotion.patron && ("name" in H.devotion.patron.vars))
			var/myname = "[H.devotion.patron.vars["name"]]"
			if(god == myname) { open_research_ui(H); return }

		var/cur = H.patron_relations[god]
		if(!isnum(cur)) cur = 0

		// ***************  hard cap templar relations at 2 *****
		if(_is_templar(H) && cur >= 2) { open_research_ui(H); return }
		//CHURCHLING PART STARTS
		if(_is_churchling(H) && cur >= 1) { open_research_ui(H); return }
		//CHURCHLING PART ENDS

		if(cur >= 4) { open_research_ui(H); return }

		var/next = cur + 1

		// *************** block upgrade above 2 for templars *****
		if(_is_templar(H) && next > 2) { open_research_ui(H); return }
		//CHURCHLING PART STARTS
		if(_is_churchling(H) && next > 1) { open_research_ui(H); return }
		//CHURCHLING PART ENDS

		var/cost = (next == 1) ? 1 : (next == 2) ? 2 : (next == 3) ? 3 : 4
		if(H.personal_research_points < cost) { open_research_ui(H); return }

		H.personal_research_points = max(0, H.personal_research_points - cost)
		H.patron_relations[god] = next
		to_chat(H, span_notice("Relations with [god] increased to [next]."))
		open_research_ui(H)
		return

	// --- Learn tabs ---
	if(href_list["learntab"])
		var/tb2 = href_list["learntab"]

		// if None Then None I use It to hide issues not un block it
		if(tb2 == "none")
			src.current_learn_tab = "none"
			open_learn_ui(H)
			return

		build_divine_patrons_index()
		build_inhumen_patrons_index()

		var/can_select = FALSE

		// divine
		if(tb2 in divine_patrons_index)
			var/relv = H.patron_relations && (tb2 in H.patron_relations) ? H.patron_relations[tb2] : 0
			if(relv > 0) can_select = TRUE

		// inhumen
		if(!can_select && (tb2 in inhumen_patrons_index))
			if(_shunned_relations_unlocked(H))
				var/relv2 = H.patron_relations && (tb2 in H.patron_relations) ? H.patron_relations[tb2] : 0
				if(relv2 > 0) can_select = TRUE

		if(can_select)
			src.current_learn_tab = "[tb2]"

		open_learn_ui(H)
		return

	// --- Learn click ---
	if(href_list["learnspell"])
		var/txt = href_list["learnspell"]
		var/typepath = text2path(txt)
		if(!ispath(typepath, /obj/effect/proc_holder/spell))
			open_learn_ui(H)
			return

		var/obj/effect/proc_holder/spell/S = new typepath
		if(!S)
			open_learn_ui(H)
			return

		//no duplication exploit I want to say slur word
		if(H?.mind)
			for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
				if(K.type == typepath)
					qdel(S)
					to_chat(H, span_warning("You already know this one!"))
					open_learn_ui(H)
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
			open_learn_ui(H)
			return

		var/owner_rel = (real_owner == my_patron) ? 4 : (H.patron_relations && (real_owner in H.patron_relations) ? H.patron_relations[real_owner] : 0)
		var/max_allowed = allowed_tier_by_relation(owner_rel)
		if(_is_templar(H))
			max_allowed = min(max_allowed, 2)
		//CHURCHLING PART STARTS
		if(_is_churchling(H))
			max_allowed = min(max_allowed, 1)
		//CHURCHLING PART ENDS

		if(tier > max_allowed)
			qdel(S)
			to_chat(H, span_warning("You lack the relation level for this miracle."))
			open_learn_ui(H)
			return

		var/cost = (real_owner == my_patron) ? CLERIC_PRICE_PATRON : CLERIC_PRICE_FOREIGN
		if(H.miracle_points < cost)
			qdel(S)
			open_learn_ui(H)
			return

		if(alert(H, "[S.desc]", "[S.name]", "Learn", "Cancel") != "Learn")
			qdel(S)
			open_learn_ui(H)
			return

		if(H.miracle_points < cost)
			qdel(S)
			to_chat(H, span_warning("Not enough Miracle Points."))
			open_learn_ui(H)
			return

		// Second no duplication exploit if GOOD GUYS figured out how to use HREF exploits
		if(H?.mind)
			for(var/obj/effect/proc_holder/spell/K in H.mind.spell_list)
				if(K.type == typepath)
					qdel(S)
					to_chat(H, span_warning("You already know this one!"))
					open_learn_ui(H)
					return

		H.miracle_points = max(0, H.miracle_points - cost)
		H.mind.AddSpell(S)
		to_chat(H, span_notice("You have learned [S.name]."))
		open_learn_ui(H)
		return

	// --- Organs nav ---
	if(href_list["orgtab"])
		var/tbo = href_list["orgtab"]
		if(tbo == "none" || tbo == "t1" || tbo == "t2" || tbo == "t3") src.current_org_tab = tbo
		open_research_ui(H); return

	// --- Artefact nav ---
	if(href_list["arttab"])
		var/tbA = href_list["arttab"]
		if(tbA == "none") src.current_art_tab = "none"
		else
			build_divine_patrons_index()
			if(divine_patrons_index && (tbA in divine_patrons_index)) src.current_art_tab = "[tbA]"
			else src.current_art_tab = "none"
		open_research_ui(H); return

	// --- BUY / UNLOCK ---
	if(href_list["buyart"])
		if(!HAS_TRAIT(H, TRAIT_CLERGY)) { open_research_ui(H); return }
		var/god2 = href_list["buyart"]
		var/item_txt = href_list["item"]
		build_divine_patrons_index()
		if(!(god2 in divine_patrons_index)) { open_research_ui(H); return }
		if(item_txt)
			var/item_path = text2path(item_txt)
			if(!ispath(item_path, /obj/item)) { to_chat(H, span_warning("Invalid artefact type.")); open_research_ui(H); return }
			var/list/art_list = PATRON_ARTIFACTS ? PATRON_ARTIFACTS[god2] : null
			if(!islist(art_list) || !art_list.Find(item_path)) { to_chat(H, span_warning("This artefact does not belong to [god2].")); open_research_ui(H); return }
			if(H.church_favor < ARTEFACT_PRICE_FAVOR) { open_research_ui(H); return }
			if(alert(H, "Buy [item_txt] of [god2] for [ARTEFACT_PRICE_FAVOR] Favor?", "Confirm", "Buy", "Cancel") != "Buy") { open_research_ui(H); return }
			var/turf/T1 = get_step(H, H.dir); if(!T1) T1 = get_turf(H)
			new item_path(T1)
			H.church_favor = max(0, H.church_favor - ARTEFACT_PRICE_FAVOR)
			to_chat(H, span_notice("You acquired an artefact of [god2]."))
			open_research_ui(H); return
		open_research_ui(H); return

	if(href_list["buyorg"])
		if(!HAS_TRAIT(H, TRAIT_CLERGY)) { open_research_ui(H); return }
		var/tier = lowertext(href_list["buyorg"])
		var/label = lowertext(href_list["item"])
		if(!(label in list("eyes","stomach","liver","heart","lungs"))) { open_research_ui(H); return }
		var/unlocked = FALSE
		var/price = 0
		if     (tier == "t1") { unlocked = H.unlocked_research_org_t1; price = ORG_PRICE_T1 }
		else if(tier == "t2") { unlocked = H.unlocked_research_org_t2; price = ORG_PRICE_T2 }
		else if(tier == "t3") { unlocked = H.unlocked_research_org_t3; price = ORG_PRICE_T3 }
		else { open_research_ui(H); return }
		if(!unlocked || H.church_favor < price) { open_research_ui(H); return }
		var/path_text = "/obj/item/organ/[label]/[tier]"
		var/typepath2 = text2path(path_text)
		if(!typepath2) { to_chat(H, span_warning("Organ type not found: [path_text]")); open_research_ui(H); return }
		var/turf/T2 = get_step(H, H.dir); if(!T2) T2 = get_turf(H)
		new typepath2(T2)
		H.church_favor = max(0, H.church_favor - price)
		to_chat(H, span_notice("[capitalize(label)] [uppertext(tier)] spawned for [price] Favor."))
		open_research_ui(H); return

	if(href_list["buyrp"])
		if(!HAS_TRAIT(H, TRAIT_CLERGY) || H.church_favor < RESEARCH_RP_PRICE_FLAVOR) { open_research_ui(H); return }
		H.church_favor = max(0, H.church_favor - RESEARCH_RP_PRICE_FLAVOR)
		H.personal_research_points++
		to_chat(H, span_notice("You gained +1 Research Point."))
		open_research_ui(H); return

	if(href_list["buymp"])
		if(!HAS_TRAIT(H, TRAIT_CLERGY) || H.church_favor < MIRACLE_MP_PRICE_FLAVOR) { open_research_ui(H); return }
		H.church_favor = max(0, H.church_favor - MIRACLE_MP_PRICE_FLAVOR)
		H.miracle_points++
		to_chat(H, span_notice("You gained +1 Miracle Point."))
		open_research_ui(H); return

	if(href_list["unlock"])
		var/key = lowertext(href_list["unlock"])
		var/need = 0
		if     (key == "artefacts") need = COST_ARTEFACTS
		else if(key == "org_t1")    need = COST_ORG_T1
		else if(key == "org_t2")    need = COST_ORG_T2
		else if(key == "org_t3")    need = COST_ORG_T3
		else { open_research_ui(H); return }
		if(H.personal_research_points < need) { open_research_ui(H); return }
		H.personal_research_points = max(0, H.personal_research_points - need)
		if     (key == "artefacts") H.unlocked_research_artefacts = TRUE
		else if(key == "org_t1")    H.unlocked_research_org_t1   = TRUE
		else if(key == "org_t2")    H.unlocked_research_org_t2   = TRUE
		else if(key == "org_t3")    H.unlocked_research_org_t3   = TRUE
		to_chat(H, span_notice("Study unlocked: [key]."))
		open_research_ui(H); return

	// --- Unlock shunned
	if(href_list["unlock_shunned_rel"])
		if(H.personal_research_points < UNLOCK_SHUNNED_RP) { open_research_ui(H); return }
		H.personal_research_points = max(0, H.personal_research_points - UNLOCK_SHUNNED_RP)
		build_inhumen_patrons_index()
		if(!islist(H.patron_relations)) H.patron_relations = list()
		for(var/n in inhumen_patrons_index)
			if(!(n in H.patron_relations))
				H.patron_relations[n] = 0
		to_chat(H, span_notice("Shunned knowledges unlocked."))
		open_research_ui(H); return

	// --- Upgrade: Diagnose (2 MP) -
	if(href_list["upgrade_diag"])
		if(!istype(H) || !H?.mind) { open_upgrade_ui(H); return }
		if(H.miracle_points < 2) { to_chat(H, span_warning("Not enough Miracle Points.")); open_upgrade_ui(H); return }
		var/obj/effect/proc_holder/spell/baseS = null
		var/obj/effect/proc_holder/spell/greaterS = null
		for(var/obj/effect/proc_holder/spell/S in H.mind.spell_list)
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose)) baseS = S
			if(istype(S, /obj/effect/proc_holder/spell/invoked/diagnose/greater)) greaterS = S
		if(greaterS) { to_chat(H, span_info("You already know Greater Diagnose.")); open_upgrade_ui(H); return }
		if(!baseS) { to_chat(H, span_warning("You must learn Diagnose first.")); open_upgrade_ui(H); return }
		if(hascall(H.mind, "RemoveSpell")) call(H.mind, "RemoveSpell")(baseS)
		else qdel(baseS)
		var/obj/effect/proc_holder/spell/invoked/diagnose/greater/N = new
		H.mind.AddSpell(N)
		H.miracle_points = max(0, H.miracle_points - 2)
		to_chat(H, span_notice("Your Diagnose has been upgraded to Greater Diagnose (-2 MP)."))
		open_upgrade_ui(H); return

// DONT CHANGE IT PLEASE1111
/obj/effect/proc_holder/spell/self/learnmiracle/cast(list/targets, mob/user)
	if(!..()) return
	if(!user) return

	var/list/rad = list()
	rad["Learn"]    = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "learnmiracle")
	rad["Upgrade"]  = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "upgrademiracle")
	rad["Quests"]   = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "questmiracle")
	rad["Research"] = icon(icon = MIRACLE_RADIAL_DMI, icon_state = "researchmiracle")

	var/choice = show_radial_menu(user, user, rad, require_near = FALSE)
	if(choice == "Learn")        do_learn_miracle(user)
	else if(choice == "Research") open_research_ui(user)
	else if(choice == "Quests")   open_quests_ui(user)
	else if(choice == "Upgrade")  open_upgrade_ui(user)
	return