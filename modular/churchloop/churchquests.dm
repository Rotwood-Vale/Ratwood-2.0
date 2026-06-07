//===================================================
// churchquests.dm
//=============================================
// -----------------------------------------------------
// HELP ME
// -----------------------------------------------

/proc/html_attr(t as text)
	if(!istext(t))
		return ""
	var/s = "[t]"
	s = replacetext(s, "&", "&amp;")
	s = replacetext(s, "<", "&lt;")
	s = replacetext(s, ">", "&gt;")
	s = replacetext(s, "\"", "&quot;")
	s = replacetext(s, "'", "&#39;")
	return s

/proc/_is_digit_string(t)
	if(!istext(t)) return FALSE
	if(length(t) != 4) return FALSE
	for(var/i = 1, i <= 4, i++)
		var/c = copytext(t, i, i + 1)
		if(c < "0" || c > "9") return FALSE
	return TRUE

/proc/_digit_count(txt, dc)
	var/n = 0
	for(var/i = 1, i <= length(txt), i++)
		if(copytext(txt, i, i + 1) == dc)
			n++
	return n

/proc/_has_quest_lock(H)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	var/mob/living/carbon/human/HH = H
	return HH.has_status_effect(/datum/status_effect/debuff/quest_lock)

/proc/_apply_quest_lock(H)
	if(!istype(H, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/HH = H
	if(!HH.has_status_effect(/datum/status_effect/debuff/quest_lock))
		HH.apply_status_effect(/datum/status_effect/debuff/quest_lock)

/proc/_apply_parish_boon(H)
	if(!istype(H, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/HH = H
	if(!HH.has_status_effect(/datum/status_effect/buff/parish_boon))
		HH.apply_status_effect(/datum/status_effect/buff/parish_boon)

/proc/_apply_parish_scorn(H)
	if(!istype(H, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/HH = H
	if(!HH.has_status_effect(/datum/status_effect/debuff/parish_scorn))
		HH.apply_status_effect(/datum/status_effect/debuff/parish_scorn)

/proc/_has_quest_target_mark(H)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	var/mob/living/carbon/human/HH = H
	if(HH.has_status_effect(/datum/status_effect/buff/parish_boon))
		return TRUE
	if(HH.has_status_effect(/datum/status_effect/debuff/parish_scorn))
		return TRUE
	return FALSE

/proc/_quest_user_in_combat_mode(mob/M)
	if(!M) return FALSE

	if("combat_mode" in M.vars)
		var/v1 = M.vars["combat_mode"]
		if(v1) return TRUE

	if("cmode" in M.vars)
		var/v2 = M.vars["cmode"]
		if(v2) return TRUE

	if("c_mode" in M.vars)
		var/v3 = M.vars["c_mode"]
		if(v3) return TRUE

	return FALSE

/proc/_is_antagonist(H)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	var/mob/living/carbon/human/HH = H
	if(!HH.mind) return FALSE

	if("antag_datums" in HH.mind.vars)
		var/list/L = HH.mind.vars["antag_datums"]
		if(islist(L) && L.len)
			return TRUE

	if("special_role" in HH.mind.vars)
		var/sr = HH.mind.vars["special_role"]
		if(istext(sr) && length(sr))
			return TRUE

	return FALSE

/proc/_rt_type_display_name(T)
	if(!ispath(T)) return "[T]"
	var/obj/O = new T
	var/n = "[T]"
	if(istype(O, /obj) && istext(O.name) && length(O.name))
		n = O.name
	qdel(O)
	return n

/proc/_race_satisfies(mob/living/carbon/human/H, key)
	if(!istype(H, /mob/living/carbon/human)) return FALSE

	var/k = lowertext("[key]")

	if(k == "northern_human") return is_species(H, /datum/species/human/northern)
	if(k == "dwarf")          return is_species(H, /datum/species/dwarf)
	if(k == "dwarf_mountain") return is_species(H, /datum/species/dwarf/mountain)
	if(k == "elf")            return is_species(H, /datum/species/elf)
	if(k == "dark_elf")       return is_species(H, /datum/species/elf/dark)
	if(k == "wood_elf")       return is_species(H, /datum/species/elf/wood)
	if(k == "half_elf")       return is_species(H, /datum/species/human/halfelf)
	if(k == "tiefling")       return is_species(H, /datum/species/tieberian)
	if(k == "dullahan")       return is_species(H, /datum/species/dullahan)
	if(k == "half_orc")       return is_species(H, /datum/species/halforc)
	if(k == "lizard")         return is_species(H, /datum/species/lizardfolk)
	if(k == "goblin")         return is_species(H, /datum/species/goblinp)
	if(k == "kobold")         return is_species(H, /datum/species/kobold)
	if(k == "aasimar")        return is_species(H, /datum/species/aasimar)
	if(k == "halfkin")        return is_species(H, /datum/species/demihuman)
	if(k == "wildkin")        return is_species(H, /datum/species/anthromorph)
	if(k == "critter")        return is_species(H, /datum/species/anthromorphsmall)
	if(k == "axian")          return is_species(H, /datum/species/akula)
	if(k == "lamia")          return is_species(H, /datum/species/lamia)
	if(k == "dracon")         return is_species(H, /datum/species/dracon)
	if(k == "lupian")         return is_species(H, /datum/species/lupian)
	if(k == "moth")           return is_species(H, /datum/species/moth)
	if(k == "tabaxi")         return is_species(H, /datum/species/tabaxi)
	if(k == "vulp")           return is_species(H, /datum/species/vulpkanin)
	if(k == "harpy")          return is_species(H, /datum/species/harpy)

	return FALSE

/proc/_rt_effect_type_name(T)
	if(!ispath(T, /datum/status_effect))
		return "[T]"
	var/datum/status_effect/E = new T
	var/n = "[T]"
	if(E && ("id" in E.vars) && istext(E.vars["id"]) && length(E.vars["id"]))
		n = "[E.vars["id"]]"
	if(E) qdel(E)
	return capitalize(n)

/proc/_safe_has_skill_expert(H, skill_type)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!ispath(skill_type, /datum/skill)) return FALSE

	var/mob/living/carbon/human/HH = H

	if(hascall(HH, "get_skill_level"))
		var/level = call(HH, "get_skill_level")(skill_type)
		return isnum(level) && level >= 4

	if("skill_levels" in HH.vars)
		var/list/L = HH.vars["skill_levels"]
		if(islist(L) && (skill_type in L))
			var/val = L[skill_type]
			if(isnum(val) && val >= 4)
				return TRUE

	return FALSE

/proc/_is_leaf_type(typepath)
	if(!ispath(typepath))
		return FALSE
	var/list/subs = typesof(typepath)
	return (!islist(subs) || subs.len <= 1)

/proc/_target_has_flaw(H, flaw_type)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	var/mob/living/carbon/human/HH = H
	if(!ispath(flaw_type, /datum/charflaw)) return FALSE

	if(hascall(HH, "has_flaw"))
		return !!call(HH, "has_flaw")(flaw_type)

	if("charflaws" in HH.vars)
		var/list/L = HH.vars["charflaws"]
		if(islist(L))
			for(var/datum/charflaw/F in L)
				if(istype(F, flaw_type))
					return TRUE

	return FALSE

/proc/_patron_matches(mob/living/carbon/human/H, required_patron_name as text)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!istext(required_patron_name) || !length(required_patron_name)) return FALSE
	if(!("patron" in H.vars)) return FALSE

	var/need_name = lowertext(trim("[required_patron_name]"))
	var/p = H.vars["patron"]

	if(istext(p))
		return lowertext(trim("[p]")) == need_name

	if(ispath(p, /datum/patron))
		var/datum/patron/Pt = new p
		var/match = FALSE
		if(("name" in Pt.vars) && istext(Pt.vars["name"]))
			match = (lowertext(trim("[Pt.vars["name"]]")) == need_name)
		qdel(Pt)
		return match

	if(istype(p, /datum/patron))
		var/datum/patron/P = p
		if(("name" in P.vars) && istext(P.vars["name"]))
			return lowertext(trim("[P.vars["name"]]")) == need_name
		return FALSE

	return FALSE

/proc/_patron_matches_any(mob/living/carbon/human/H, list/names)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!islist(names) || !names.len) return FALSE
	for(var/n in names)
		if(_patron_matches(H, "[n]"))
			return TRUE
	return FALSE

//--------------------------------------------------
// I HATE FEET KNIGHT SO MUCH
//--------------------------------------------------

/proc/_rt_job_display_name(jobtype)
	if(!ispath(jobtype, /datum/job))
		return "[jobtype]"

	var/datum/job/Jtmp = new jobtype
	var/name_out = "[jobtype]"

	if(Jtmp)
		if(("title" in Jtmp.vars) && istext(Jtmp.vars["title"]) && length(Jtmp.vars["title"]))
			name_out = Jtmp.vars["title"]
		else if(("name" in Jtmp.vars) && istext(Jtmp.vars["name"]) && length(Jtmp.vars["name"]))
			name_out = Jtmp.vars["name"]

	qdel(Jtmp)
	return name_out

/proc/_mob_matches_any_job(mob/living/carbon/human/H, list/required_job_types)
	if(!istype(H, /mob/living/carbon/human))
		return FALSE
	if(!islist(required_job_types) || !required_job_types.len)
		return FALSE
	var/list/req_titles = list()
	for(var/T in required_job_types)
		if(ispath(T, /datum/job))
			var/title_txt = lowertext(trim(_rt_job_display_name(T)))
			if(length(title_txt))
				req_titles += title_txt

	var/datum/job/J = null
	if(H.mind)
		if(("assigned_job" in H.mind.vars) && istype(H.mind.vars["assigned_job"], /datum/job))
			J = H.mind.vars["assigned_job"]

		if(!J && ("current_job" in H.mind.vars) && istype(H.mind.vars["current_job"], /datum/job))
			J = H.mind.vars["current_job"]

	if(J)
		for(var/T2 in required_job_types)
			if(ispath(T2, /datum/job))
				if(istype(J, T2))
					return TRUE

	var/list/candidate_strings = list()

	if(J)
		if(("title" in J.vars) && istext(J.vars["title"]) && length(J.vars["title"]))
			candidate_strings += lowertext(trim("[J.vars["title"]]"))
		if(("name" in J.vars) && istext(J.vars["name"]) && length(J.vars["name"]))
			candidate_strings += lowertext(trim("[J.vars["name"]]"))

	if(H.mind)
		if(("assigned_role" in H.mind.vars) && istext(H.mind.vars["assigned_role"]))
			candidate_strings += lowertext(trim("[H.mind.vars["assigned_role"]]"))
		if(("special_role" in H.mind.vars) && istext(H.mind.vars["special_role"]))
			candidate_strings += lowertext(trim("[H.mind.vars["special_role"]]"))

	for(var/cs in candidate_strings)
		if(!istext(cs) || !length(cs))
			continue

		for(var/rt in req_titles)
			if(!istext(rt) || !length(rt))
				continue

			if(cs == rt)
				return TRUE

			if(findtext(cs, rt))
				return TRUE
			if(findtext(rt, cs))
				return TRUE

	return FALSE

/proc/_rt_mob_has_antag_datum(mob/living/carbon/human/H, datumpath)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!H.mind) return FALSE

	var/datum/mind/M = H.mind

	if(hascall(M, "has_antag_datum"))
		if(call(M, "has_antag_datum")(datumpath))
			return TRUE

	if("antag_datums" in M.vars)
		var/list/L = M.vars["antag_datums"]
		if(islist(L))
			for(var/datum/antagonist/A in L)
				if(istype(A, datumpath))
					return TRUE

	return FALSE

/proc/_rt_is_bandit_or_wretch(mob/living/carbon/human/H)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!H.mind) return FALSE

	if("assigned_role" in H.mind.vars && istext(H.mind.vars["assigned_role"]))
		var/rn = lowertext("[H.mind.vars["assigned_role"]]")
		if(findtext(rn, "bandit") || findtext(rn, "wretch"))
			return TRUE

	return FALSE

/proc/_rt_antag_tier(mob/living/carbon/human/H)
	if(_rt_mob_has_antag_datum(H, /datum/antagonist/lich)) return 3
	if(_rt_mob_has_antag_datum(H, /datum/antagonist/werewolf)) return 2
	if(_rt_is_bandit_or_wretch(H)) return 1
	return 0

/proc/_rt_pick_unique(list/src_list, count)
	var/list/candidates = list()
	if(islist(src_list))
		for(var/X in src_list)
			candidates += X

	var/list/out = list()
	var/left = count
	while(left > 0 && candidates.len)
		var/ch = pick(candidates)
		out += ch
		candidates -= ch
		left--
	return out

/proc/_rt_skill_names(list/type_list)
	var/list/names = list()
	if(islist(type_list))
		for(var/T in type_list)
			if(!ispath(T, /datum/skill)) continue
			if(!_is_leaf_type(T)) continue

			var/datum/skill/SK = new T
			if(SK && istext(SK.name) && length(SK.name))
				names += SK.name
			else
				names += "[T]"
			if(SK) qdel(SK)
	return names

/proc/_rt_flaw_names(list/type_list)
	var/list/names = list()
	if(islist(type_list))
		for(var/T in type_list)
			if(!ispath(T, /datum/charflaw)) continue
			if(!_is_leaf_type(T)) continue

			var/datum/charflaw/F = new T
			if(F && istext(F.name) && length(F.name))
				names += F.name
			else
				names += "[T]"
			if(F) qdel(F)
	return names

/proc/_rt_all_job_types_master()
	var/list/L = list(
		/datum/job/roguetown/jester,
		/datum/job/roguetown/veteran,
		/datum/job/roguetown/clerk,
		/datum/job/roguetown/wapprentice,
		/datum/job/roguetown/servant,
		/datum/job/roguetown/butler,
		/datum/job/roguetown/apothecary,
		/datum/job/roguetown/magician,
		/datum/job/roguetown/prince,
		/datum/job/roguetown/councillor,
		/datum/job/roguetown/physician,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/captain,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/knight,
		/datum/job/roguetown/lady,
		/datum/job/roguetown/lord,
		/datum/job/roguetown/steward,
		/datum/job/roguetown/villager,
		/datum/job/roguetown/nightmaiden,
		/datum/job/roguetown/beggar,
		/datum/job/roguetown/cook,
		/datum/job/roguetown/knavewench,
		/datum/job/roguetown/lunatic,
		/datum/job/roguetown/farmer,
		/datum/job/roguetown/orphan,
		/datum/job/roguetown/shophand,
		/datum/job/roguetown/niteman,
		/datum/job/roguetown/archivist,
		/datum/job/roguetown/barkeep,
		/datum/job/roguetown/guildmaster,
		/datum/job/roguetown/guildsman,
		/datum/job/roguetown/tailor,
		/datum/job/roguetown/merchant,
		/datum/job/roguetown/pilgrim,
		/datum/job/roguetown/adventurer,
		/datum/job/roguetown/mercenary,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/dungeoneer,
		/datum/job/roguetown/manorguard,
		/datum/job/roguetown/squire,
		/datum/job/roguetown/guardsman
	)

	var/list/out = list()
	for(var/T in L)
		if(!(T in out))
			out += T
	return out

// GLOBAL
var/global/list/Q_WITNESS_EFFECTS = list(
	/datum/status_effect/buff/sermon,
	/datum/status_effect/buff/drunk,
	/datum/status_effect/buff/greatsnackbuff,
	/datum/status_effect/buff/snackbuff,
	/datum/status_effect/buff/ozium,
	/datum/status_effect/buff/moondust,
	/datum/status_effect/buff/murkwine,
	/datum/status_effect/buff/sweet,
	/datum/status_effect/buff/moondust_purest,
	/datum/status_effect/buff/starsugar,
	/datum/status_effect/buff/weed
)

// ---------------------------------------------------------------------
//
//  THE QUEST TOKEN TREE SHIT STARTS HERE
//
// ---------------------------------------------------------------------

/obj/item/quest_token
	name = "quest token"
	desc = "A token tied to a task."
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY

	var/owner_ckey = ""
	var/owner_name = ""
	var/reward_amount = 250
	var/in_use = FALSE

/obj/item/quest_token/Initialize()
	. = ..()
	if(!length(owner_name))
		owner_name = "unknown"

/obj/item/quest_token/proc/set_owner(mob/living/carbon/human/H)
	if(!H) return
	if(H.client)
		owner_ckey = H.client.ckey
	else if(istext(H.key))
		owner_ckey = ckey(H.key)
	owner_name = H.real_name || H.name || owner_ckey

/obj/item/quest_token/proc/_find_owner_mob()
	if(!length(owner_ckey))
		return null
	for(var/mob/living/carbon/human/H in world)
		if(H.client && H.client.ckey == owner_ckey)
			return H
	return null

/obj/item/quest_token/proc/_payout(amount, mob/living/carbon/human/completer)
	if(!amount) return
	if(!istype(completer, /mob/living/carbon/human)) return

	var/mob/living/carbon/human/receiver = _find_owner_mob()

	if(!receiver)
		to_chat(completer, span_warning("Owner of this quest token is absent. No favor is awarded."))
		return

	receiver.church_favor += amount

	if(receiver == completer)
		to_chat(receiver, span_notice("+[amount] Favor for completing a miracle quest."))
	else
		to_chat(completer, span_notice("The reward is credited to [owner_name]."))
		to_chat(receiver, span_notice("+[amount] Favor from a completed quest token you created."))

/obj/item/quest_token/proc/_ensure_attacker(user)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	if(in_use)
		return FALSE
	return TRUE

/obj/item/quest_token/proc/_ensure_target_player(H, user)
	if(!istype(H, /mob/living/carbon/human))
		to_chat(user, span_warning("Target must be a person."))
		return FALSE
	var/mob/living/carbon/human/HH = H
	if(!HH.client)
		to_chat(user, span_warning("Target must be a player."))
		return FALSE
	if(HAS_TRAIT(HH, TRAIT_CLERGYRADICAL))
		to_chat(user, span_warning("Radical clergy cannot be used as quest targets."))
		return FALSE
	if(_has_quest_target_mark(HH))
		to_chat(user, span_warning("This target is already marked by a previous quest."))
		return FALSE

	return TRUE

/obj/item/quest_token/proc/_check_distance(mob/living/user, mob/living/target)
	if(!user || !target) return FALSE
	if(get_dist(user, target) > 1)
		to_chat(user, span_warning("Too far away."))
		return FALSE
	return TRUE

/obj/item/quest_token/proc/_complete_target_quest(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!istype(H, /mob/living/carbon/human)) return FALSE
	if(!istype(user, /mob/living/carbon/human)) return FALSE
	if(QDELETED(src)) return FALSE

	if(!_check_distance(user, H))
		return FALSE

	if(_has_quest_target_mark(H))
		to_chat(user, span_warning("This target is already marked by a previous quest."))
		return FALSE

	if(H == user)
		_apply_parish_boon(H)
		_payout(reward_amount, user)
		qdel(src)
		return TRUE

	if(_quest_user_in_combat_mode(user))
		user.visible_message(
			span_warning("[user] forces [src] upon [H]."),
			span_warning("I force [src] upon [H].")
		)
		_apply_parish_scorn(H)
		_payout(reward_amount, user)
		qdel(src)
		return TRUE

	var/answer = alert(H, "[user] offers [src.name]. Accept it?", src.name, "Accept", "Refuse")
	if(QDELETED(src)) return FALSE

	if(answer != "Accept")
		to_chat(user, span_warning("[H] refuses."))
		to_chat(H, span_notice("You refuse [src.name]."))
		return FALSE

	if(!_check_distance(user, H))
		return FALSE

	if(_has_quest_target_mark(H))
		to_chat(user, span_warning("This target is already marked by a previous quest."))
		return FALSE

	_apply_parish_boon(H)
	_payout(reward_amount, user)
	qdel(src)
	return TRUE

// ---------------------------------------------------------------------
// QUEST TOKENS
// ---------------------------------------------------------------------

/obj/item/quest_token/skill_bless
	name = "mark of craft"
	desc = "Find a target who is expert in one of the listed skills. Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questflaw"
	var/list/required_skills = list()

/obj/item/quest_token/skill_bless/attack(target, user)
	if(!istype(target, /mob/living/carbon/human)) return ..()
	if(!_ensure_attacker(user)) return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U)) return

	if(!islist(required_skills) || !required_skills.len)
		to_chat(U, span_warning("This token is misconfigured. (no skills set)"))
		return

	var/is_ok = FALSE
	for(var/st in required_skills)
		if(_safe_has_skill_expert(H, st))
			is_ok = TRUE
			break

	if(!is_ok)
		to_chat(U, span_warning("They are not an EXPERT of the required skills."))
		return

	in_use = TRUE
	if(!do_after(U, 15 SECONDS, H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
	return

/obj/item/quest_token/blood_draw
	name = "sanctified lancet"
	desc = "Use on a target of one of the listed bloodlines. Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questblood"
	var/list/required_race_keys = list()

/obj/item/quest_token/blood_draw/attack(target, user)
	if(!istype(target, /mob/living/carbon/human)) return ..()
	if(!_ensure_attacker(user)) return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U)) return

	if(!islist(required_race_keys) || !required_race_keys.len)
		to_chat(U, span_warning("This token is misconfigured. (no race keys set)"))
		return

	var/matchrace = FALSE
	for(var/rk in required_race_keys)
		if(_race_satisfies(H, rk))
			matchrace = TRUE
			break

	if(!matchrace)
		to_chat(U, span_warning("They are not of the required bloodline(s)."))
		return

	in_use = TRUE
	if(!do_after(U, 15 SECONDS, H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
	return

/obj/item/quest_token/coin_chest
	name = "tithe chest"
	desc = "Feed it with mammon. It is consumed only when the tithe is completed."
	icon_state = "questbox"
	var/sum = 0
	var/required_sum = 250

/obj/item/quest_token/coin_chest/attackby(I, user, params)
	if(!I) return
	if(!_ensure_attacker(user)) return
	var/mob/living/carbon/human/U = user

	if(_has_quest_target_mark(U))
		to_chat(U, span_warning("You are already marked by a previous quest."))
		return

	if(istype(I, /obj/item/roguecoin/gilbranze)) return
	if(istype(I, /obj/item/roguecoin/inqcoin)) return

	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		sum += C.get_real_price()
		qdel(C)

		to_chat(U, span_notice("Deposited. Current tithe: [sum]."))

		if(sum >= required_sum)
			to_chat(U, span_notice("The chest accepts the tithe."))
			_payout(reward_amount, U)
			qdel(src)
		return

	..()

/obj/item/quest_token/reliquary
	name = "sealed reliquary"
	desc = "Solve the code. It does not expire."
	icon_state = "questbox"

	var/code = "0000"
	var/list/bonus_patron_names = list()
	var/next_attempt_ds = 0

/obj/item/quest_token/reliquary/Initialize()
	. = ..()

	if(!length(code) || code == "0000")
		code = generate_reliquary_code()
	else
		if(!(code in GLOB.generated_reliquary_codes))
			GLOB.generated_reliquary_codes += code

	if(!islist(bonus_patron_names) || !bonus_patron_names.len)
		var/list/fallback = list("Astrata","Noc","Dendor","Abyssor","Ravox","Necra","Xylix","Pestra","Malum","Eora")
		bonus_patron_names = list(pick(fallback))

	next_attempt_ds = world.time

/obj/item/quest_token/reliquary/examine(mob/user)
	. = ..()

	if(!islist(bonus_patron_names) || !bonus_patron_names.len)
		return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(_patron_matches_any(H, bonus_patron_names))
			. += "<br><span class='notice'>Divine insight: <b>[code]</b></span>"
		else
			. += "<br><span class='info'>Followers of [jointext(bonus_patron_names, ", ")] see the code clearly.</span>"

/obj/item/quest_token/reliquary/proc/_ensure_ui_access(mob/living/user)
	if(!user) return FALSE
	if(!user.canUseTopic(src, TRUE)) return FALSE
	if(get_dist(user, src) > 1) return FALSE
	return TRUE

/obj/item/quest_token/reliquary/attack_hand(mob/living/user)
	. = ..()
	if(!_ensure_attacker(user)) return
	if(!_ensure_ui_access(user)) return

	user.set_machine(src)

	var/locked = (world.time < next_attempt_ds)
	var/left = max(0, next_attempt_ds - world.time)
	var/left_s = round(left / 10)
	var/m = left_s / 60
	var/s = left_s % 60
	var/s2 = (s < 10) ? "0[s]" : "[s]"

	var/html = "<center><b>Sealed Reliquary</b></center><hr>"
	html += "Enter the 4-digit code to open the box.<br>"
	html += "<b>Attempts:</b> once every <b>20 seconds</b>.<br>"
	html += "<b>Hint:</b> <span style='color:#2ecc71'>green</span> = correct place, "
	html += "<span style='color:#f1c40f'>yellow</span> = correct digit wrong place.<br><br>"

	if(locked)
		html += "<span style='color:#7f8c8d'>Next attempt in [m]:[s2]</span>"
	else
		html += "<a href='?src=[REF(src)];trycode=1'>Try code</a>"

	var/datum/browser/B = new(user, "RELIQUARY_UI", "Sealed Reliquary", 360, 220)
	B.set_content(html)
	B.open()
	return TRUE

/obj/item/quest_token/reliquary/Topic(href, href_list)
	. = ..()
	if(!usr) return
	if(!_ensure_attacker(usr)) return
	if(!_ensure_ui_access(usr)) return

	var/mob/living/carbon/human/U = usr

	if(_has_quest_target_mark(U))
		to_chat(U, span_warning("You are already marked by a previous quest."))
		return

	if(href_list["trycode"])
		if(world.time < next_attempt_ds)
			attack_hand(U)
			return

		var/guess = input(U, "Enter 4 digits (0-9).", "Reliquary") as null|text
		if(isnull(guess))
			attack_hand(U)
			return

		guess = copytext(guess, 1, 5)
		if(!_is_digit_string(guess) || length(guess) != 4)
			to_chat(U, span_warning("Needs exactly four digits 0-9."))
			attack_hand(U)
			return

		var/correct_pos = 0
		for(var/i = 1 to 4)
			if(copytext(code, i, i + 1) == copytext(guess, i, i + 1))
				correct_pos++

		var/correct_digit = 0
		for(var/d = 0 to 9)
			var/ds = "[d]"
			var/nc = _digit_count(code, ds)
			var/ng = _digit_count(guess, ds)
			correct_digit += min(nc, ng)
		correct_digit -= correct_pos

		next_attempt_ds = world.time + (20 SECONDS)

		if(guess == code)
			to_chat(U, span_notice("The reliquary opens."))
			_payout(reward_amount, U)
			qdel(src)
			return
		else
			to_chat(U, "<span class='notice'>Feedback - <span style='color:#2ecc71'>green</span>: [correct_pos], <span style='color:#f1c40f'>yellow</span>: [correct_digit]</span>")

		attack_hand(U)
		return

/obj/item/quest_token/ration_delivery
	name = "charity ration"
	desc = "Give this to a target of one of the listed professions. Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questration"
	var/list/required_job_types = list()

/obj/item/quest_token/ration_delivery/attack(target, user)
	if(!istype(target, /mob/living/carbon/human)) return ..()
	if(!_ensure_attacker(user)) return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U)) return

	if(!islist(required_job_types) || !required_job_types.len)
		to_chat(U, span_warning("This ration is misconfigured. (no job list set)"))
		return

	if(!_mob_matches_any_job(H, required_job_types))
		to_chat(U, span_warning("They are not in any of the required professions."))
		return

	in_use = TRUE
	if(!do_after(U, 15 SECONDS, H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
		return

	var/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice/B = new /obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice(get_turf(H))
	if(hascall(H, "put_in_hands"))
		var/success = call(H, "put_in_hands")(B)
		if(!success)
			B.forceMove(get_turf(H))
	else
		B.forceMove(get_turf(H))
	return

/obj/item/quest_token/donation_box
	name = "offering coffer"
	desc = "Accepts one designated offering."
	icon_state = "questbox"
	var/list/need_types = list()
	var/collected = FALSE

/obj/item/quest_token/donation_box/attackby(I, user, params)
	if(collected || !I) return
	if(!_ensure_attacker(user)) return

	var/mob/living/carbon/human/U = user
	if(_has_quest_target_mark(U))
		to_chat(U, span_warning("You are already marked by a previous quest."))
		return

	for(var/T in need_types)
		if(istype(I, T))
			qdel(I)
			collected = TRUE
			to_chat(U, span_notice("The offering is accepted."))
			_payout(reward_amount, U)
			qdel(src)
			return

	to_chat(U, span_warning("This is not an acceptable offering."))

/obj/item/quest_token/sermon_minor
	name = "sermon token"
	desc = "Use on a follower of the listed patron(s). Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questflaw"
	var/list/required_patron_names = list()

/obj/item/quest_token/sermon_minor/Initialize()
	. = ..()
	if(!islist(required_patron_names) || !required_patron_names.len)
		var/list/fallback = list("Astrata","Noc","Dendor","Abyssor","Ravox","Necra","Xylix","Pestra","Malum","Eora")
		required_patron_names = list(pick(fallback))

/obj/item/quest_token/sermon_minor/examine(mob/user)
	. = ..()
	if(islist(required_patron_names) && required_patron_names.len)
		. += "<br><span class='info'>This sermon seeks a follower of: <b>[jointext(required_patron_names, ", ")]</b>.</span>"

/obj/item/quest_token/sermon_minor/attack(mob/living/target, mob/living/user)
	if(!istype(target, /mob/living/carbon/human))
		return ..()
	if(!_ensure_attacker(user))
		return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U))
		return

	if(!islist(required_patron_names) || !required_patron_names.len)
		to_chat(U, span_warning("This token is misconfigured. (no patron list set)"))
		return

	if(!_patron_matches_any(H, required_patron_names))
		to_chat(U, span_warning("They do not follow any required patron."))
		return

	U.visible_message(
		span_notice("[U] begins a brief sermon to [H]."),
		span_notice("I begin a brief sermon to [H].")
	)

	in_use = TRUE
	if(!do_after(U, 15 SECONDS, target = H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
		return

	U.visible_message(
		span_notice("[U] finishes the sermon for [H]."),
		span_notice("I finish the sermon for [H].")
	)
	return TRUE

/obj/item/quest_token/sermon_witness
	name = "pharmacology probe"
	desc = "Use on a target bearing one of the listed effects. Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questflaw"
	var/list/required_effect_types = list()

/obj/item/quest_token/sermon_witness/Initialize()
	. = ..()
	if(!islist(required_effect_types) || !required_effect_types.len)
		if(islist(Q_WITNESS_EFFECTS) && Q_WITNESS_EFFECTS.len)
			required_effect_types = Q_WITNESS_EFFECTS.Copy()
		else
			required_effect_types = list(/datum/status_effect/buff/sermon)

/obj/item/quest_token/sermon_witness/attack(target, user)
	if(!istype(target, /mob/living/carbon/human))
		return ..()
	if(!_ensure_attacker(user))
		return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U))
		return

	if(!islist(required_effect_types) || !required_effect_types.len)
		to_chat(U, span_warning("This token is misconfigured. (no effect list set)"))
		return

	var/matched = FALSE
	for(var/T in required_effect_types)
		if(ispath(T, /datum/status_effect))
			if(H.has_status_effect(T))
				matched = TRUE
				break

	if(!matched)
		to_chat(U, span_warning("They do not bear any of the required effects."))
		return

	in_use = TRUE
	if(!do_after(U, 10 SECONDS, H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
	return

/obj/item/quest_token/flaw_aid
	name = "mercy charm"
	desc = "Use on a target bearing one of the listed flaws. Peaceful use gives Boon, combat-mode use gives Scorn."
	icon_state = "questflaw"
	var/list/required_flaw_types = list()

/obj/item/quest_token/flaw_aid/attack(target, user)
	if(!istype(target, /mob/living/carbon/human)) return ..()
	if(!_ensure_attacker(user)) return

	var/mob/living/carbon/human/H = target
	var/mob/living/carbon/human/U = user
	if(!_ensure_target_player(H, U)) return

	if(!islist(required_flaw_types) || !required_flaw_types.len)
		to_chat(U, span_warning("This charm is misconfigured. (no flaw list set)"))
		return

	var/matched = FALSE
	for(var/ft in required_flaw_types)
		if(_target_has_flaw(H, ft))
			matched = TRUE
			break

	if(!matched)
		to_chat(U, span_warning("Target does not bear any of the required flaws."))
		return

	in_use = TRUE
	if(!do_after(U, 15 SECONDS, H))
		in_use = FALSE
		return

	if(!_check_distance(U, H))
		in_use = FALSE
		return

	if(!_complete_target_quest(H, U))
		in_use = FALSE
	return

// ---------------------------------------------------------------------
// quest fliff
// ---------------------------------------------------------------------

/proc/_rt_patron_name_pool()
	build_divine_patrons_index()
	var/list/pool = list()
	if(divine_patrons_index && divine_patrons_index.len)
		for(var/n in divine_patrons_index)
			pool += "[n]"
	else
		pool = list("Astrata","Noc","Dendor","Abyssor","Ravox","Necra","Xylix","Pestra","Malum","Eora")
	return pool

/proc/_rt_build_full_quest_set(mob/living/carbon/human/H)
	if(!H) return list()
	var/list/archetypes = list()

	var/list/skill_cands = list()
	var/list/blocked_skills = list(
		/datum/skill/combat/staves,
		/datum/skill/magic/blood
	)

	for(var/t in typesof(/datum/skill))
		if(t == /datum/skill)
			continue
		if(!_is_leaf_type(t))
			continue
		if(t in blocked_skills)
			continue

		var/datum/skill/SK = new t
		if(SK && istext(SK.name) && length(SK.name))
			skill_cands += t
		if(SK)
			qdel(SK)

	var/list/race_keys_master = list(
		"northern_human","dwarf","dark_elf","wood_elf","half_elf","half_orc",
		"goblin","kobold","lizard","aasimar","tiefling","halfkin","wildkin",
		"golem","doll","vermin","dracon","axian","tabaxi","vulp","lupian",
		"moth","lamia"
	)

	var/list/candidate_types_master = list(
		/obj/item/ingot/iron,
		/obj/item/ingot/steel,
		/obj/item/rogueweapon/spear/billhook,
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/reagent_containers/powder/spice,
		/obj/item/reagent_containers/glass/cup/ceramic/fancy,
		/obj/item/polishing_cream,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/roguegem/green,
		/obj/item/roguegem/violet,
		/obj/item/roguegem/amethyst
	)
	if(!candidate_types_master.len)
		candidate_types_master = list(/obj/item/ingot/iron)

	var/list/patron_pool = _rt_patron_name_pool()
	var/list/job_pool = _rt_all_job_types_master()

	var/list/flaw_cands = list()
	for(var/t2 in typesof(/datum/charflaw))
		if(t2 != /datum/charflaw)
			flaw_cands += t2

	var/list/diff_generic = list(
		"easy"   = list("count" = 5, "reward" = 100),
		"medium" = list("count" = 3, "reward" = 150),
		"hard"   = list("count" = 1, "reward" = 200)
	)

	var/list/diff_tithe = list(
		"easy"   = list("required_sum" = 100, "reward" = 100),
		"medium" = list("required_sum" = 150, "reward" = 150),
		"hard"   = list("required_sum" = 200, "reward" = 200)
	)

	var/list/tithe_diffs = list()
	for(var/dn4 in diff_tithe)
		var/list/D4 = diff_tithe[dn4]
		var/need_sum = D4["required_sum"]
		var/rew4 = D4["reward"]

		tithe_diffs[dn4] = list(
			"diff"       = dn4,
			"desc"       = "Donate at least [need_sum] mammon into the chest.",
			"reward"     = rew4,
			"token_path" = /obj/item/quest_token/coin_chest,
			"params"     = list("required_sum" = need_sum),
			"spawned"    = FALSE
		)

	archetypes += list(list(
		"kind"          = "coin_chest",
		"title"         = "Tithe",
		"accepted_diff" = "",
		"difficulties"  = tithe_diffs
	))

	var/list/skill_diffs = list()
	for(var/dn2 in diff_generic)
		var/list/D2 = diff_generic[dn2]
		var/ccount2 = D2["count"]
		var/rew2 = D2["reward"]

		var/list/picked_skills = _rt_pick_unique(skill_cands, ccount2)
		if(!picked_skills.len) continue

		var/list/skill_names = _rt_skill_names(picked_skills)
		var/skills_desc_txt = html_attr(jointext(skill_names, ", "))

		skill_diffs[dn2] = list(
			"diff"       = dn2,
			"desc"       = "Bless an EXPERT of ANY of skills: [skills_desc_txt].",
			"reward"     = rew2,
			"token_path" = /obj/item/quest_token/skill_bless,
			"params"     = list("required_skills" = picked_skills),
			"spawned"    = FALSE
		)

	if(skill_diffs.len)
		archetypes += list(list(
			"kind"          = "skill_bless",
			"title"         = "Find Expertise",
			"accepted_diff" = "",
			"difficulties"  = skill_diffs
		))

	var/list/blood_diffs = list()
	for(var/dn3 in diff_generic)
		var/list/D3 = diff_generic[dn3]
		var/ccount3 = D3["count"]
		var/rew3 = D3["reward"]

		var/list/picked_races = _rt_pick_unique(race_keys_master, ccount3)
		if(!picked_races.len) continue

		var/list/races_upper = list()
		for(var/R in picked_races)
			races_upper += uppertext("[R]")

		var/races_desc_txt = html_attr(jointext(races_upper, ", "))

		blood_diffs[dn3] = list(
			"diff"       = dn3,
			"desc"       = "Take blood from ANY of: [races_desc_txt].",
			"reward"     = rew3,
			"token_path" = /obj/item/quest_token/blood_draw,
			"params"     = list("required_race_keys" = picked_races),
			"spawned"    = FALSE
		)

	if(blood_diffs.len)
		archetypes += list(list(
			"kind"          = "blood_draw",
			"title"         = "Blood Research",
			"accepted_diff" = "",
			"difficulties"  = blood_diffs
		))

	var/list/ration_diffs = list()
	for(var/dn6 in diff_generic)
		var/list/D6 = diff_generic[dn6]
		var/ccount6 = D6["count"]
		var/rew6 = D6["reward"]

		var/list/picked_jobs = _rt_pick_unique(job_pool, ccount6)
		if(!picked_jobs.len) continue

		var/list/job_names = list()
		for(var/JT in picked_jobs)
			job_names += html_attr(_rt_job_display_name(JT))

		var/jobs_desc_txt = jointext(job_names, ", ")

		ration_diffs[dn6] = list(
			"diff"       = dn6,
			"desc"       = "Deliver a ration to ANY of: [jobs_desc_txt].",
			"reward"     = rew6,
			"token_path" = /obj/item/quest_token/ration_delivery,
			"params"     = list("required_job_types" = picked_jobs),
			"spawned"    = FALSE
		)

	if(ration_diffs.len)
		archetypes += list(list(
			"kind"          = "ration_delivery",
			"title"         = "Deliver Ration",
			"accepted_diff" = "",
			"difficulties"  = ration_diffs
		))

	var/list/donate_diffs = list()
	for(var/dn7 in diff_generic)
		var/list/D7 = diff_generic[dn7]
		var/ccount7 = D7["count"]
		var/rew7 = D7["reward"]

		var/list/picked_types = _rt_pick_unique(candidate_types_master, ccount7)
		if(!picked_types.len) continue

		var/list/item_names = list()
		for(var/T in picked_types)
			item_names += html_attr(_rt_type_display_name(T))
		var/items_desc_txt = jointext(item_names, ", ")

		donate_diffs[dn7] = list(
			"diff"       = dn7,
			"desc"       = "Place ONE offering into the coffer - ANY of: [items_desc_txt].",
			"reward"     = rew7,
			"token_path" = /obj/item/quest_token/donation_box,
			"params"     = list("need_types" = picked_types),
			"spawned"    = FALSE
		)

	if(donate_diffs.len)
		archetypes += list(list(
			"kind"          = "donation_box",
			"title"         = "Offering of Supplies",
			"accepted_diff" = "",
			"difficulties"  = donate_diffs
		))

	var/list/sermon_minor_diffs = list()
	for(var/dn8 in diff_generic)
		var/list/D8 = diff_generic[dn8]
		var/ccount8 = D8["count"]
		var/rew8 = D8["reward"]

		var/list/picked_patrons = _rt_pick_unique(patron_pool, ccount8)
		if(!picked_patrons.len) continue

		var/patrons_desc_txt = html_attr(jointext(picked_patrons, ", "))

		sermon_minor_diffs[dn8] = list(
			"diff"       = dn8,
			"desc"       = "Deliver a Minor Sermon to a follower of ANY of: [patrons_desc_txt].",
			"reward"     = rew8,
			"token_path" = /obj/item/quest_token/sermon_minor,
			"params"     = list("required_patron_names" = picked_patrons),
			"spawned"    = FALSE
		)

	if(sermon_minor_diffs.len)
		archetypes += list(list(
			"kind"          = "sermon_minor",
			"title"         = "Minor Sermon",
			"accepted_diff" = "",
			"difficulties"  = sermon_minor_diffs
		))

	var/list/box_diffs = list()
	for(var/dn5 in diff_generic)
		var/list/D5 = diff_generic[dn5]
		var/ccount5 = D5["count"]
		var/rew5 = D5["reward"]

		var/list/picked_patrons2 = _rt_pick_unique(patron_pool, ccount5)
		if(!picked_patrons2.len) continue

		var/patrons_hint_txt = html_attr(jointext(picked_patrons2, ", "))

		box_diffs[dn5] = list(
			"diff"       = dn5,
			"desc"       = "Solve a 4-digit code (followers of [patrons_hint_txt] can see it).",
			"reward"     = rew5,
			"token_path" = /obj/item/quest_token/reliquary,
			"params"     = list("bonus_patron_names" = picked_patrons2),
			"spawned"    = FALSE
		)

	if(box_diffs.len)
		archetypes += list(list(
			"kind"          = "reliquary",
			"title"         = "The Riddle of the Box",
			"accepted_diff" = "",
			"difficulties"  = box_diffs
		))

	var/list/witness_diffs = list()
	for(var/dn9 in diff_generic)
		var/list/D9 = diff_generic[dn9]
		var/rew9 = D9["reward"]

		var/cn9 = 1
		if("count" in D9 && isnum(D9["count"]))
			cn9 = D9["count"]

		var/list/pool = (islist(Q_WITNESS_EFFECTS) && Q_WITNESS_EFFECTS.len) ? Q_WITNESS_EFFECTS : list(/datum/status_effect/buff/sermon)
		var/list/picked = _rt_pick_unique(pool, max(1, cn9))

		var/list/names = list()
		for(var/T in picked)
			names += html_attr(_rt_effect_type_name(T))
		var/effects_desc_txt = jointext(names, ", ")

		witness_diffs[dn9] = list(
			"diff"       = dn9,
			"desc"       = "Record the reaction: target must bear ANY of: [effects_desc_txt].",
			"reward"     = rew9,
			"token_path" = /obj/item/quest_token/sermon_witness,
			"params"     = list("required_effect_types" = picked),
			"spawned"    = FALSE
		)

	archetypes += list(list(
		"kind"          = "sermon_witness",
		"title"         = "Record the Reaction",
		"accepted_diff" = "",
		"difficulties"  = witness_diffs
	))

	var/list/flaw_diffs = list()
	for(var/dn10 in diff_generic)
		var/list/D10 = diff_generic[dn10]
		var/ccount10 = D10["count"]
		var/rew10 = D10["reward"]

		var/list/picked_flaws = _rt_pick_unique(flaw_cands, ccount10)
		if(!picked_flaws.len) continue

		var/list/flaw_names = _rt_flaw_names(picked_flaws)
		var/flaws_desc_txt = html_attr(jointext(flaw_names, ", "))

		flaw_diffs[dn10] = list(
			"diff"       = dn10,
			"desc"       = "Soothe a player bearing ANY of: [flaws_desc_txt].",
			"reward"     = rew10,
			"token_path" = /obj/item/quest_token/flaw_aid,
			"params"     = list("required_flaw_types" = picked_flaws),
			"spawned"    = FALSE
		)

	if(flaw_diffs.len)
		archetypes += list(list(
			"kind"          = "flaw_aid",
			"title"         = "Mercy",
			"accepted_diff" = "",
			"difficulties"  = flaw_diffs
		))

	return archetypes

/proc/_rt_shuffle_list(list/L)
	if(!islist(L))
		return list()
	var/list/out = L.Copy()
	if(out.len <= 1)
		return out
	for(var/i = 1, i <= out.len - 1, i++)
		var/j = rand(i, out.len)
		if(j != i)
			var/tmp = out[i]
			out[i] = out[j]
			out[j] = tmp
	return out

/proc/_rt_build_player_quest_set(mob/living/carbon/human/H)
	if(!H) return list()
	var/list/full = _rt_build_full_quest_set(H)
	if(!islist(full) || !full.len)
		return list()
	full = _rt_shuffle_list(full)

	var/list/final_list = list()
	var/list/used_kinds = list()

	for(var/i = 1, i <= full.len && final_list.len < 3, i++)
		var/list/arch = full[i]
		if(!islist(arch)) continue
		var/k = arch["kind"]
		if(!istext(k) || !length(k))
			k = "[arch["title"]]"
		if(used_kinds.Find(k))
			continue
		used_kinds[k] = TRUE
		arch["accepted_diff"] = ""
		var/list/diffs = arch["difficulties"]
		if(islist(diffs))
			for(var/dkey in diffs)
				var/list/D = diffs[dkey]
				if(!islist(D)) continue
				D["spawned"] = FALSE
				diffs[dkey] = D
			arch["difficulties"] = diffs

		final_list += list(arch)

	return final_list

//BUFFS

/datum/status_effect/buff/parish_boon
	id = "parish_boon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/parish_boon
	effectedstats = list("perception" = 1, "intelligence" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/parish_boon
	name = "Boon of the Parish"
	desc = "You accepted a research willingly and bear a modest blessing."
	icon_state = "buff"

/datum/status_effect/debuff/parish_scorn
	id = "parish_scorn"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/parish_scorn
	effectedstats = list("perception" = -1, "intelligence" = -1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/debuff/parish_scorn
	name = "Scorn of the Parish"
	desc = "A research was forced upon you."
	icon_state = "debuff"

/datum/status_effect/debuff/quest_lock
	id = "quest_lock"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/quest_lock
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/debuff/quest_lock
	name = "Edict of the Ten"
	desc = "A legacy status effect kept for compatibility."
	icon_state = "debuff"
