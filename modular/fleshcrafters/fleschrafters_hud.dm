#ifndef QUEST_COOLDOWN_DS
#define QUEST_COOLDOWN_DS (30*60*10)
#endif

#ifndef RESEARCH_RP_PRICE_FLAVOR
#define RESEARCH_RP_PRICE_FLAVOR 100
#endif

#ifndef MIRACLE_MP_PRICE_FLAVOR
#define MIRACLE_MP_PRICE_FLAVOR 250
#endif

/obj/effect/proc_holder/spell/self/learnmiracle/proc/_tgui_unlock_study(mob/living/carbon/human/H, key)
	if(!H) return

	var/need = 0
	key = lowertext("[key]")
	if     (key == "artefacts") need = 5
	else if(key == "org_t1")    need = 10
	else if(key == "org_t2")    need = 15
	else if(key == "org_t3")    need = 20
	else return
	
	if(H.personal_research_points < need) return

	H.personal_research_points = max(0, H.personal_research_points - need)

	if     (key == "artefacts") H.unlocked_research_artefacts = TRUE
	else if(key == "org_t1")    H.unlocked_research_org_t1   = TRUE
	else if(key == "org_t2")    H.unlocked_research_org_t2   = TRUE
	else if(key == "org_t3")    H.unlocked_research_org_t3   = TRUE

	return

/obj/effect/proc_holder/spell/self/learnmiracle
    var/current_page = "home"
    var/current_learn_tab = "none"
    var/current_rel_tab = "none"
    var/current_art_tab = "none"
    var/current_org_tab = "none"

/obj/effect/proc_holder/spell/self/learnmiracle/ui_interact(mob/user, datum/tgui/ui)
    if(!istype(user, /mob/living/carbon/human)) return
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "MiraclesUI", name)
        ui.open()

/obj/effect/proc_holder/spell/self/learnmiracle/ui_state(mob/user)
    return GLOB.always_state

/obj/effect/proc_holder/spell/self/learnmiracle/ui_static_data(mob/user)
    return list(
        "pages" = list(
            list("id"="learn","label"="Learn","icon"="book"),
            list("id"="research","label"="Research","icon"="flask"),
            list("id"="quests","label"="Quests","icon"="clipboard-list"),
            list("id"="upgrade","label"="Upgrade","icon"="arrow-up")
        )
    )

/obj/effect/proc_holder/spell/self/learnmiracle/ui_data(mob/user)
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
    data["QUEST_COOLDOWN_DS"] = QUEST_COOLDOWN_DS
    data["RESEARCH_RP_PRICE_FLAVOR"] = RESEARCH_RP_PRICE_FLAVOR
    data["MIRACLE_MP_PRICE_FLAVOR"] = MIRACLE_MP_PRICE_FLAVOR

    if(current_page == "learn")
        data["learn_tab"] = current_learn_tab
        data["learn_buckets"] = _build_learn_buckets(H, FALSE)

    if(current_page == "research")
        data["unlocked_artefacts"] = H.unlocked_research_artefacts
        data["unlocked_org_t1"] = H.unlocked_research_org_t1
        data["unlocked_org_t2"] = H.unlocked_research_org_t2
        data["unlocked_org_t3"] = H.unlocked_research_org_t3
        data["rel_tab"] = current_rel_tab
        data["org_tab"] = current_org_tab
        data["art_tab"] = current_art_tab

    if(current_page == "quests")
        if(!islist(H.quest_ui_entries) || !H.quest_ui_entries.len)
            H.quest_ui_entries = _rt_build_player_quest_set(H)
            if(!H.quest_reroll_last_ds) H.quest_reroll_last_ds = world.time
        data["quests"] = H.quest_ui_entries
        data["reroll_charges"] = H.quest_reroll_charges
        data["next_charge_ds"] = max(0, QUEST_COOLDOWN_DS - (world.time - H.quest_reroll_last_ds))

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

/obj/effect/proc_holder/spell/self/learnmiracle/ui_act(action, list/params, datum/tgui/ui, mob/user)
    . = ..()
    if(.) return
    var/mob/living/carbon/human/H = user
    if(!H) return

    _ensure_relations(H)

    switch(action)
        if("set_page")
            current_page = "[params["page"]]"
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
                H.church_favor -= RESEARCH_RP_PRICE_FLAVOR
                H.personal_research_points++
            return TRUE

        if("buy_mp")
            if(HAS_TRAIT(H, TRAIT_FLESHCRAFTER) && H.church_favor >= MIRACLE_MP_PRICE_FLAVOR)
                H.church_favor -= MIRACLE_MP_PRICE_FLAVOR
                H.miracle_points++
            return TRUE

        if("unlock_study")
            _tgui_unlock_study(H, lowertext("[params["key"]]"))
            return TRUE

        if("quests_reroll")
            _update_reroll_charges(H)
            if(H.quest_reroll_charges > 0)
                H.quest_ui_entries = _rt_build_player_quest_set(H)
                H.quest_reroll_charges--
            return TRUE

        if("quests_spawn")
            _tgui_spawn_quest_item(H, text2num("[params["index"]]"), lowertext("[params["diff"]]"))
            return TRUE

        if("upgrade_diag")
            _tgui_upgrade_diagnose(H)
            return TRUE

    return FALSE
