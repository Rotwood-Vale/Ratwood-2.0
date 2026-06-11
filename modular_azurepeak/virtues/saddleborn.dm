/datum/virtue/utility/riding
	name = "骑术娴熟"
	desc = "我擅长驾驭各种动物，并与其中一只建立了格外深厚的联系，得以在远处呼唤它前来，也能在需要时将其遣走。若我珍爱的伙伴死去，我的心境将再也无法恢复。"
	custom_text = "提供一项能力，可选择一种坐骑召到身边，并为其命名。贵族角色可以选择马匹。还会获得两项能力，用于将坐骑遣走并在需要时呼回（仅限户外）。若所选坐骑死亡，本轮剩余时间内心情-10（任何情况下都无法恢复）。"
	added_traits = list(TRAIT_EQUESTRIAN)
	added_stashed_items = list("马鞍" = /obj/item/natural/saddle)
	added_skills = list(
		list(/datum/skill/misc/riding, SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_APPRENTICE)
	)

/datum/virtue/utility/riding/apply_to_human(mob/living/carbon/human/recipient)
	// neatly handles everything, when we want it, when we need it.
	recipient.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame/saddled/Initialize()
	. = ..()
	ssaddle = new /obj/item/natural/saddle(src)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/goat/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/goat/tame/saddled/Initialize()
	. = ..()
	ssaddle = new /obj/item/natural/saddle(src)
	// excuse me please fucking compile again thank you
	update_icon()
	
GLOBAL_LIST_INIT(virtue_mount_choices, (list(
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tame/saddled,
	list("goat buck", /mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame/saddled),
	list("goat doe", /mob/living/simple_animal/hostile/retaliate/rogue/goat/tame/saddled),
)))

GLOBAL_LIST_INIT(virtue_mount_choices_noble, (list(
	list("white stallion (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white/tame/saddled),
	list("white mare (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/white/tame/saddled),
	list("brown stallion (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown/tame/saddled),
	list("brown mare (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/brown/tame/saddled),
	list("black stallion (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black/tame/saddled),
	list("black mare (horse)", /mob/living/simple_animal/hostile/retaliate/rogue/horse/black/tame/saddled),
)))

/datum/stressevent/precious_mob_died
	timer = INFINITY
	stressadd = 10
	desc = span_red("再也不会有像它们那样的生灵了。它们失去了，我也一样。")

/datum/component/precious_creature
	// Who does this creature belong to?
	var/datum/weakref/owner

/datum/component/precious_creature/Initialize(mob/living/the_owner)
	if (!the_owner || !isliving(the_owner))
		return COMPONENT_INCOMPATIBLE
	
	owner = WEAKREF(the_owner)
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(precious_died))

/datum/component/precious_creature/proc/precious_died()
	var/mob/living/our_owner = owner.resolve()
	to_chat(our_owner, span_boldwarning("A quavering pang of loneliness streaks through your chest like cold lightning, sinking to the pit of your stomach. THEY ARE GONE!"))
	our_owner.add_stress(/datum/stressevent/precious_mob_died)

/mob/living/carbon/human
	/// Weakref to our bespoke Saddleborn mount (added by the virtue)
	var/datum/weakref/saddleborn_mount

/proc/setup_saddleborn_mount_move_delay(mob/living/carbon/human/user, mob/living/simple_animal/mount)
	if(!user || !istype(mount, /mob/living/simple_animal/hostile))
		return
	var/mob/living/simple_animal/hostile/hostile_mount = mount
	var/datum/component/riding/riding_datum = hostile_mount.GetComponent(/datum/component/riding)
	if(!riding_datum)
		return
	var/base_delay = hostile_mount.vars["move_to_delay"]
	if(!isnum(base_delay))
		base_delay = 3
	var/new_delay = base_delay
	if(user.mind)
		var/amt = user.get_skill_level(/datum/skill/misc/riding)
		if(amt)
			new_delay -= 5 + amt/6
		else
			new_delay -= 3
	riding_datum.vehicle_move_delay = max(1, new_delay)

/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount
	name = "选择坐骑"
	desc = "回想你那匹珍贵鞍生坐骑的形貌。"
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()
	//list of spells you can learn, it may be good to move this somewhere else eventually
	var/area/place = get_area(user.loc)
	if (!place || !place.outdoors)
		to_chat(user, span_warning("你得在户外才行！不然你要怎么指望你那匹忠诚坐骑听见你？"))
		return

	var/list/choices = list()

	var/list/mount_choices = GLOB.virtue_mount_choices.Copy()
	if (HAS_TRAIT(user, TRAIT_NOBLE))
		to_chat(user, span_info("作为受膏的贵族，你的坐骑也可以出身名种良驹。"))
		mount_choices += GLOB.virtue_mount_choices_noble

	for(var/i = 1, i <= mount_choices.len, i++)
		var/mob/living/simple_animal/honse
		if (islist(mount_choices[i])) // noble/other overrides are lists (because of how horse typing works), so hacky workaround for display's sake
			honse = mount_choices[i][2]
			choices[mount_choices[i][1]] = honse
		else
			honse = mount_choices[i]
			choices["[honse.name]"] = honse

	choices = sortList(choices)

	var/choice = input("你那匹珍爱坐骑会以何种形貌现身？") as null|anything in choices
	var/mob/living/simple_animal/our_chosen_honse = choices[choice]

	if (!our_chosen_honse)
		return

	var/has_name = alert(user, "你是否已经为这匹珍贵坐骑起名？", "Saddleborn", "是", "否")
	if (!has_name)
		has_name = "否"
	
	//spawn in our creature and set it up
	var/mob/living/simple_animal/the_real_honse = new our_chosen_honse(user.loc)
	the_real_honse.owner = user
	the_real_honse.AddComponent(/datum/component/precious_creature, user)
	user.saddleborn_mount = WEAKREF(the_real_honse)

	if (has_name == "是")
		var/honse_name = input(user, "你的坐骑叫什么名字？", "Saddleborn")
		if (honse_name)
			the_real_honse.name = honse_name
			the_real_honse.real_name = honse_name

	user.visible_message(span_info("[user]吹出一声尖锐口哨，[the_real_honse]便从远处小跑来到[user]身旁。"), span_notice("随着一声熟悉的口哨，我那匹珍爱的坐骑回到了我身边。"))
	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	if (!user.buckled)
		the_real_honse.buckle_mob(user, TRUE)
		setup_saddleborn_mount_move_delay(user, the_real_honse)
		playsound(the_real_honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)
	
	// give us all the saddleborn summon/send-away spells and all that jazz
	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/sendaway)
	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/whistle)
	qdel(src)

// dirty subtype for saddleborn spells that handles checking if we can actually do fucking anything at all
/obj/effect/proc_holder/spell/self/saddleborn/proc/check_mount(mob/living/carbon/human/user)
	if (!ishuman(user))
		return FALSE

	if (!user.saddleborn_mount)
		to_chat(user, span_warning("你没有可遣走的珍爱坐骑......"))
		qdel(src)
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	if (!honse || honse.stat == DEAD)
		to_chat(user, span_warning("它现在已经归内克拉了......"))
		return FALSE

	if (honse && honse.has_buckled_mobs())
		to_chat(user, span_warning("你得先让坐骑背上没人骑着才行！"))
		return FALSE

	var/area/place = get_area(user.loc)
	if (!place || !place.outdoors)
		to_chat(user, span_warning("你得在户外！"))
		revert_cast()
		return FALSE

	return TRUE

/obj/effect/proc_holder/spell/self/saddleborn/cast(list/targets, mob/user)
	. = ..()
	if (!check_mount(user))
		return FALSE
	else
		return TRUE

/datum/status_effect/buff/healing/saddleborn
	healing_on_tick = 0.25
	duration = 5 MINUTES
	examine_text = "SUBJECTPRONOUN看起来休息得很好！"
	outline_colour = "#f5c2c2"

/obj/effect/proc_holder/spell/self/saddleborn/sendaway
	name = "坐骑：遣走"
	desc = "在户外时，将你心爱的坐骑遣走，让它暂时自行照料自己。在更危险的地区，这可能需要更久。"
	school = "transmutation"
	recharge_time = 1 MINUTES
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if (!.)
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	if (!user.Adjacent(honse))
		to_chat(user, span_warning("你得站在坐骑身旁，才能把它遣走！"))
		return FALSE

	// otherwise, start a do_after then stasis the horse and hurl it into nullspace.
	// if they do it from town or centcomm, give the horse a healing effect

	var/area/rogue/place = get_area(user.loc)
	var/should_heal = (is_centcom_level(user.loc.z) || place.town_area || place.keep_area)
	user.visible_message(span_info("[user]开始围着[honse]忙活，准备把它遣走......"), span_notice("我开始准备把[honse]遣走，让它暂时自由又安全地四处活动......"))
	honse.Immobilize(11 SECONDS)
	honse.unbuckle_all_mobs(TRUE)
	if (do_mob(user, honse, 10 SECONDS, double_progress = TRUE) && check_mount(user))
		honse.apply_status_effect(/datum/status_effect/buff/stasis)
		honse.unbuckle_all_mobs(TRUE)
		if (!honse.has_buckled_mobs()) // just really super make sure we can't nullspace riders with this
			honse.moveToNullspace() // BANISHED TO THE NULL DIMENSION!! hopefully this doesn't cause problems
		else
			honse.visible_message(span_warning("[honse]烦躁地踏着地面，扭头看向自己背上的骑手。"))
			return FALSE
		// add sfx foley for this
		user.visible_message(span_notice("[user]轻拍[honse]的后臀，将它送走，让它小跑离去。"), span_notice("我在[honse]后臀上轻轻一拍，让它自行离开。"))
		if (should_heal)
			honse.apply_status_effect(/datum/status_effect/buff/healing/saddleborn)
			to_chat(user, span_info("在这种环境里，它应该能稍微休息并恢复一下。"))
		return TRUE
	else
		honse.SetImmobilized(0)
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/self/saddleborn/whistle
	name = "坐骑：呼哨"
	desc = "呼唤你那匹忠诚坐骑，让它在一段延迟后回到你身边。仅限户外使用。在更危险的地区，这可能需要更久。"
	school = "transmutation"
	recharge_time = 1 MINUTES
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/saddleborn/whistle/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if (!.)
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	var/back_from_the_void = (honse.loc == null)
	var/callback_time = back_from_the_void ? 20 SECONDS : 10 SECONDS // nullspace returns take a lot longer to incentivize leaving it in the world
	var/dangerous_summon = FALSE // will we try to proc an ambush upon return?

	if (get_dist(honse.loc, user.loc) <= world.view)
		to_chat(user, span_warning("你那匹忠诚坐骑就在附近！"))
		return

	var/area/rogue/place = get_area(user.loc)
	// apply alterations to our summon time based on our location: remember, this only works outdoors!
	if (place.threat_region == THREAT_REGION_MOUNT_DECAP)
		callback_time += 10 SECONDS
		dangerous_summon = TRUE
		to_chat(user, span_warning("断头山地对一匹独自行进的坐骑来说太危险了......"))
	if (place.warden_area)
		callback_time += 5 SECONDS
		to_chat(user, span_warning("谋杀林地对一匹独自行进的坐骑来说太危险了......"))
		dangerous_summon = TRUE
	if (istype(place, /area/rogue/under/underdark))
		callback_time += 30 SECONDS
		to_chat(user, span_warning("幽暗地域对一匹独自行进的坐骑来说是<b>极其</b>危险的地方......"))
		dangerous_summon = TRUE
	if (place.keep_area)
		if (HAS_TRAIT(user, TRAIT_NOBLE))
			to_chat(user, span_info("有位路过的仆从帮你把坐骑牵来了！"))
			callback_time = 3 SECONDS
		else
			callback_time -= 3 SECONDS
			to_chat(user, span_info("你的坐骑受过在城镇附近徘徊的训练，而如今守门人也习惯放单独的坐骑进出，这让你能更快把它找回来。"))
	if (place.town_area)
		callback_time -= 5 SECONDS
		to_chat(user, span_info("你的坐骑受过在城镇附近徘徊的训练，这让你能更快把它找回来。"))
	if (callback_time <= 0)
		callback_time = 1 SECONDS

	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	user.visible_message(span_danger("[user]把手指放进口中，吹出一声尖锐刺耳的口哨！"), span_info("我为自己忠诚的坐骑吹响口哨，等待它归来！"))
	var/honse_base_loc = honse.loc
	var/area/rogue/honse_place = get_area(honse.loc)
	honse.unbuckle_all_mobs(TRUE)
	if (!back_from_the_void && honse_place.outdoors)
		honse.visible_message(span_notice("[honse]听见远处的口哨后竖起耳朵，随即飞奔而去......"))
		playsound(honse, 'sound/magic/saddleborn-call.ogg', 50, FALSE) // distant spooky whistle OooOOOo
		honse.moveToNullspace() //temporarily shuffle it off into the null dimension, to reflect it running to the player
	
	if (do_after(user, callback_time))
		if (back_from_the_void) // we're summoning from nullspace, so destasis and remove the heal, if we have one
			honse.remove_status_effect(/datum/status_effect/buff/stasis)
		
		if (!back_from_the_void && honse_place && !honse_place.outdoors)
			to_chat(user, span_warning("......可什么都没来。它一定是没听见你的口哨。"))
			return TRUE
		
		honse.forceMove(user.loc)
		if (!user.buckled)
			honse.buckle_mob(user, TRUE)
			setup_saddleborn_mount_move_delay(user, honse)
		playsound(honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)

		if (dangerous_summon) // the horse dragged some attention uh-oh
			if (!user.goodluck(10)) // every point of fortune above 10 gives us a 10% chance to not summon
				user.consider_ambush(ignore_cooldown = TRUE)
		return TRUE
	else
		honse.forceMove(honse_base_loc) // put the honse back, and give some info as to what just happened for onlookers
		honse.visible_message(span_notice("[honse]带着困惑的神情又慢吞吞地走回视野中，耳朵不停转动，像是在捕捉某种声音......"))
		revert_cast()
		return FALSE
