
/obj/structure/fluff/testportal
	name = "传送门"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	max_integrity = 0
	var/aportalloc = "a"

/obj/structure/fluff/testportal/Initialize(mapload)
	name = aportalloc
	..()

/obj/structure/fluff/testportal/attack_hand(mob/user)
	var/fou
	for(var/obj/structure/fluff/testportal/T in shuffle(GLOB.testportals))
		if(T.aportalloc == aportalloc)
			if(T == src)
				continue
			to_chat(user, "<b>我被传送到了[T]！</b>")
			playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>这个传送门没有通往任何地方。</b>")
	. = ..()


/obj/structure/fluff/traveltile
	name = "旅行点"
	icon_state = "travel"
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0
	var/aportalid = "REPLACETHIS"
	var/aportalgoesto = "REPLACETHIS"
	var/aallmig
	var/required_trait = null

/obj/structure/fluff/traveltile/Initialize(mapload)
	GLOB.traveltiles += src
	. = ..()

/obj/structure/fluff/traveltile/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/proc/return_connected_turfs()
	if(!aportalgoesto)
		return list()

	var/list/travels = list()
	for(var/obj/structure/fluff/traveltile/travel in shuffle(GLOB.traveltiles))
		if(travel == src)
			continue
		if(travel.aportalid != aportalgoesto)
			continue
		travels |= get_turf(travel)
	return travels

/obj/structure/fluff/traveltile/attack_ghost(mob/dead/observer/user)
	if(!aportalgoesto)
		return
	var/fou
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>没有可前往的目的地。</b>")

/atom/movable
	var/recent_travel = 0
//  var/last_client_interact = 0  // See mob_defines.dm.

/obj/structure/fluff/traveltile/attack_hand(mob/user)
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>没有可前往的目的地。</b>")
	. = ..()

/obj/structure/fluff/traveltile/Crossed(atom/movable/AM)
	. = ..()
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(AM, "<b>没有可前往的目的地。</b>")

/obj/structure/fluff/traveltile/proc/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!can_go(L))
		return FALSE
	if(L.pulledby)
		return FALSE
	to_chat(L, "<b>我开始准备前往那里……</b>")
	if(do_after(L, 50, needhand = FALSE, target = src))
		if(L.pulledby)
			to_chat(L, span_warning("被拖拽时我没法使用这个入口。"))
			return FALSE
		perform_travel(T, L)
		return TRUE
	return FALSE

/obj/structure/fluff/traveltile/proc/perform_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!L.restrained(ignore_grab = TRUE)) // heavy-handedly prevents using prisoners to metagame camp locations. pulledby would stop this but prisoners can also be kicked/thrown into the tile repeatedly
		for(var/mob/living/carbon/human/H in hearers(6,src))
			if(!H.IsUnconscious() && H.stat == CONSCIOUS && !HAS_TRAIT(H, TRAIT_PARALYSIS) && !HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
				to_chat(H, "<b>[L.name? L : "某人"]消失在了入口之中！</b>")
				if(!(H.m_intent == MOVE_INTENT_SNEAK))
					to_chat(L, "<b>[H.name ? H : "某人"]注意到了我进入入口。</b>")
				ADD_TRAIT(H, required_trait, TRAIT_GENERIC)

	var/atom/movable/pullingg = L.pulling

	// handle unknotting
	if(ishuman(L))
		var/mob/living/carbon/human/knot_haver = L
		if(knot_haver.sexcon.knotted_status)
			knot_haver.sexcon.knot_remove()

	L.recent_travel = world.time
	if(pullingg)
		if(ishuman(pullingg)) // also check if pulled mob is knotted
			var/mob/living/carbon/human/H = pullingg
			if(H.sexcon.knotted_status)
				H.sexcon.knot_remove()
		pullingg.recent_travel = world.time
		pullingg.forceMove(T.loc)

	L.forceMove(T.loc)

	if(pullingg)
		L.start_pulling(pullingg, supress_message = TRUE)

	return

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	. = TRUE
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			. = FALSE
	if(. && required_trait && isliving(AM))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, required_trait))
			if(world.time > L.last_client_interact + 0.3 SECONDS)
				return FALSE // we will only be travelling of our own volition (anti-afk-abuse)
			return TRUE
		else
			to_chat(L, "<b>我无法使用这个入口。</b>")
			return FALSE
/obj/structure/fluff/traveltile/dungeoneer
	required_trait = TRAIT_DUNGEONMASTER_LABOR_CAMP
/obj/structure/fluff/traveltile/bandit
	required_trait = TRAIT_BANDITCAMP
/obj/structure/fluff/traveltile/vampire
	required_trait = TRAIT_VAMPMANSION
/obj/structure/fluff/traveltile/wretch
	required_trait = TRAIT_ZURCH //I'd tie this to trait_outlaw but unfortunately the heresiarch virtue exists so we're making a new trait instead.
/obj/structure/fluff/traveltile/inq
	required_trait = TRAIT_INQUISITION
/obj/structure/fluff/traveltile/lich
	desc = "一扇通往某处隐秘巢穴的入口，散发着不祥气息。"
	color = "#fcff5e"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	required_trait = TRAIT_LICHLAIR

/obj/structure/fluff/traveltile/dungeon
	name = "地城入口"
	desc = "一处通往地下深处的入口，踏入其中便会前往另一片区域。"
	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	bound_width = 96
	appearance_flags = NONE
	opacity = FALSE

/obj/structure/fluff/traveltile/magicportal
	desc = "一扇闪烁着奥术辉光的传送门。"
	name = "魔法传送门"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"

/obj/structure/fluff/traveltile/magicportal/unstable
	desc = "一扇不稳定的传送门，能量正剧烈翻涌。"
	name = "不稳定传送门"
	color = "#ff0d00"

/obj/structure/fluff/traveltile/rockhillentrance
	desc = "一处通往 Rockhill 的入口。"
	name = "前往 Rockhill"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"

/obj/structure/fluff/traveltile/eventarea
