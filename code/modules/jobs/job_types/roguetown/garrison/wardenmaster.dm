/datum/job/roguetown/wardenmaster
	title = "Master Warden"
	flag = BOGMASTER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)//I like the idea of making it set you to middle aged, but having the requirement removes it from the latejoin menu which I think is bad for visibility
	tutorial = "You are the most experienced of the Wardens, the elite rangers that patrol, scout and fiercely defend the lower city and wilderness surrounding it, attending to threats and crimes below the city's attention. Your job is to lead the aloof Wardens and wrangle the unruly vanguard, carving order out of the chaos south of the city's walls. Obey the orders of the lowtown baron, and enact their will beyond the wall as the first line of defence from threats beyond the borders of civilisation. Keep the roads safe, and hold the vanguard fortress. The Crown is counting on you."
	display_order = JDO_BOGMASTER
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	advclass_cat_rolls = list(CTAG_BOGMASTER = 20)

	give_bank_account = 50
	min_pq = 10
	max_pq = null
	job_subclasses = list(
		/datum/advclass/wardenmaster/bogmaster,
		/datum/advclass/wardenmaster/huntmaster,
		/datum/advclass/wardenmaster/bogguard
	)
//------------------------------------------------------------------------------------------------------------------------
/datum/outfit/job/roguetown/wardenmaster/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(istype(H.belt, /obj/item/storage/belt/rogue/leather))
		if(locate(/obj/item/signal_flare_gun) in H.belt)
			return
		var/obj/item/signal_flare_gun/loaded/gun = new(H.belt.loc)
		if(!SEND_SIGNAL(H.belt, COMSIG_TRY_STORAGE_INSERT, gun, null, TRUE, TRUE))
			gun.forceMove(get_turf(H))
		var/obj/item/signal_flare/spare = new(H.belt.loc)
		if(!SEND_SIGNAL(H.belt, COMSIG_TRY_STORAGE_INSERT, spare, null, TRUE, TRUE))
			spare.forceMove(get_turf(H))

/datum/outfit/job/roguetown/wardenmaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/vanguard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
	/obj/item/rogueweapon/huntingknife/idagger/warden_machete = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/wardenmaster = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/signal_horn = 1
		)

/obj/effect/proc_holder/spell/self/convertrole/vanguard
	name = "Recruit Vanguard"
	new_role = "Vanguard"
	overlay_state = "recruit_guard"
	recruitment_faction = "Vanguard"
	recruitment_message = "Serve the vanguard, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
