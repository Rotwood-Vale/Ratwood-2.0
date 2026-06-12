/obj/item/storage/magebag
	name = "学者药囊"
	desc = "一个可装少量召唤与炼金材料的袋子。"
	icon_state = "summoning"
	item_state = "summoning"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/magebag

/obj/item/storage/magebag/examine(mob/user)
	. = ..()
	if(contents.len)
		. += span_notice("袋中有[contents.len]件东西。")

/obj/item/storage/magebag/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/magebag/update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL
	else
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/magebag/associate
	populate_contents = list(
		/obj/item/magic/manacrystal,
		/obj/item/magic/manacrystal,
		/obj/item/magic/manacrystal,
		/obj/item/magic/obsidian,
		/obj/item/magic/obsidian,
		/obj/item/magic/obsidian,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/grown/manabloom
	)

/obj/item/storage/magebag/alchemist
	name = "炼金师药囊"
	desc = "一个可装少量炼金材料的袋子。"
	color = "#dddebf"
	populate_contents = list(
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/magic/manacrystal,
		/obj/item/magic/obsidian,
		/obj/item/alch/viscera,
		/obj/item/alch/viscera,
		/obj/item/alch/urtica,
		/obj/item/alch/taraxacum,
		/obj/item/alch/puresalt,
		/obj/item/alch/paris,
		/obj/item/alch/mentha,
		/obj/item/alch/hypericum,
		/obj/item/alch/salvia,
		/obj/item/alch/calendula,
		/obj/item/seeds/swampweed = 1,
		/obj/item/seeds/pipeweed = 1,
	)

/obj/item/storage/magebag/witch
	name = "巫师药囊"
	desc = "一个可装少量炼金材料的袋子。"
	color = "#210f0c"
	populate_contents = list(
		/obj/item/alch/viscera,
		/obj/item/alch/viscera,
		/obj/item/alch/viscera,
		/obj/item/alch/urtica,
		/obj/item/alch/taraxacum,
		/obj/item/alch/puresalt,
		/obj/item/alch/paris,
		/obj/item/alch/mentha,
		/obj/item/alch/hypericum,
		/obj/item/alch/salvia,
		/obj/item/alch/calendula,
		/obj/item/seeds/swampweed = 1,
		/obj/item/seeds/pipeweed = 1,
		)

/obj/item/chalk
	name = "粉笔"
	desc = "一根雪白的粉笔，或许是由流银制成。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "chalk"
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	force = 1
	w_class = WEIGHT_CLASS_TINY
	var/rune_to_scribe = null
	var/amount = 8

/obj/item/chalk/examine(mob/user)
	. = ..()
	desc += "还剩[amount]次使用次数。"

/obj/item/chalk/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		if(amount < 8)
			amount = 8
			to_chat(user, span_notice("我将奥术魔力注入[M]，其中的红色晶体熔成流银，迅速渗入[src]。"))
	else
		return ..()


/obj/item/chalk/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))//We'll set up other items for other types of rune rituals
		to_chat(user, span_cult("我想不出能用这根粉笔画出什么。"))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "符文", "1级与2级符文") as null|anything in GLOB.t2rune_types
	testing("runenameinput [runenameinput]")
	pickrune = GLOB.rune_types[runenameinput]
	rune_to_scribe = pickrune
	if(rune_to_scribe == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("这里已经有一个符文了。"))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, rune_to_scribe)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("有结构、符文或墙壁挡住了位置。"))
		return
	var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))

	user.visible_message(span_notice("[user]开始拖动[user.p_their()]的[name]划过[Turf]，在圆环中描绘复杂的符号与印记。"), span_notice("我开始用[name]划过[Turf]，在圆环中描绘复杂的符号与印记。"))
	playsound(loc, 'sound/magic/chalkdraw.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(span_warning("[user]用[user.p_their()]的[name]绘出了奥术符文！"), \
		span_notice("我用[name]完成了繁复符号与圆环的描绘，留下了一个仪式符文。"))
		src.amount --
		new rune_to_scribe(Turf)
	if(amount == 0)
		qdel(src)

/obj/item/chalk/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue

		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE


/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	name = "奥术银匕"
	desc = "这把匕首泛着淡淡紫光，流银沿着刃面游走。"
	var/is_bled = FALSE
	var/obj/effect/decal/cleanable/roguerune/rune_to_scribe = null
	var/chosen_keyword

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/Initialize(mapload)
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/rogueweapon/huntingknife/idagger/silver/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		var/crafttime = (6 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane))* 0.5 SECONDS))
		if(do_after(user, crafttime, target = src))
			playsound(loc, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("我将奥术魔力注入刀刃，它随即涌动起深紫色的脉光……"))
			var/obj/arcyne_knife = new /obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/attack_self(mob/living/carbon/human/user)

	if(!isarcyne(user))
		return
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user]划开了[user.p_their()]的手掌！"), \
			span_cult("我划开了自己的手掌！"))
		if(user.blood_volume)
			var/obj/effect/decal/cleanable/roguerune/rune = rune_to_scribe
			user.apply_damage(initial(rune.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "符文", "4级符文") as null|anything in GLOB.t4rune_types
	testing("runenameinput [runenameinput]")
	pickrune = GLOB.rune_types[runenameinput]
	rune_to_scribe = pickrune
	if(rune_to_scribe == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("这里已经有一个符文了。"))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, rune_to_scribe)
	if(structures_in_way)
		to_chat(user, span_cult("有结构、符文或墙壁挡住了位置。"))
		return
	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(user, "新符文的关键词", "4级符文", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))

	user.visible_message(span_notice("[user]开始用[user.p_their()]的[name]刻画奥术符文。"), \
		span_notice("我开始拖动刀刃刻出符号与印记的形状。"))
	playsound(loc, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(
			span_warning("[user]用[user.p_their()]的[name]刻出了奥术符文！"), \
			span_notice("我完成了刀刃勾勒的符号与圆环，留下了一个仪式符文。")
		)
		new rune_to_scribe(Turf, chosen_keyword)

/obj/item/rogueweapon/huntingknife/idagger/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue

		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE


/obj/item/mimictrinket
	name = "拟态饰物"
	desc = "一只被奥术驯服的小拟态怪。它能变成自己碰到的大多数东西。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "mimic_trinket"
	dropshrink = 0.6
	possible_item_intents = list(/datum/intent/use)
	var/duration = 10 MINUTES
	var/oldicon
	var/oldicon_state
	var/olddesc
	var/oldname
	var/ready = TRUE
	var/timing_id

/obj/item/mimictrinket/attack_self(mob/living/carbon/human/user)
	revert()

/obj/item/mimictrinket/proc/revert()
	if(oldicon == null || oldicon_state == null || oldname == null || olddesc == null)
		return
	to_chat(usr, span_notice("[src]恢复成了原本的模样。"))
	icon = oldicon
	icon_state = oldicon_state
	name = oldname
	desc = olddesc
	ready = TRUE
	if(timing_id)
		deltimer(timing_id)
		timing_id = null

/obj/item/mimictrinket/attack_obj(obj/target, mob/living/user)
	if(ready)
		to_chat(user,span_notice("[src]变成了[target]的样子！"))
		oldicon = icon
		oldicon_state = icon_state
		olddesc = desc
		oldname = name
		icon = target.icon
		icon_state = target.icon_state
		name = target.name
		desc = target.desc
		ready = FALSE
		timing_id = addtimer(CALLBACK(src, PROC_REF(revert), user), duration,TIMER_STOPPABLE) // Minus two so we play the sound and decap faster


/obj/item/hourglass/temporal
	name = "时序沙漏"
	desc = "一只注入了奥术力量、散发魔法微光的沙漏。"
	icon = 'icons/obj/hourglass.dmi'
	icon_state = "hourglass_idle"
	var/turf/target
	var/mob/living/victim

/obj/item/hourglass/temporal/toggle(mob/user)
	if(!timing_id)
		to_chat(user,span_notice("我翻转了[src]。"))
		start()
		flick("hourglass_flip",src)
		target = get_turf(src)
		victim = user
	else
		to_chat(user,span_notice("我停下了[src]。")) //Sand magically flows back because that's more convinient to use.
		stop()

/obj/item/hourglass/temporal/stop()
	..()
	do_teleport(victim, target, channel = TELEPORT_CHANNEL_QUANTUM)

/obj/item/natural/feather/infernal
	name = "炼狱羽毛"
	icon_state = "hellfeather"
	possible_item_intents = list(/datum/intent/use)
	desc = "一根蓬松的羽毛。"

/obj/item/flashlight/flare/torch/lantern/voidlamptern
	name = "虚空提灯"
	icon_state = "voidlamp"
	item_state = "voidlamp"
	desc = "一盏古老的提灯，你看得越久，它就显得越发幽暗。"
	light_outer_range = 8
	light_color = "#000000"
	light_power = -3
	on = FALSE

/obj/item/clothing/ring/active/shimmeringlens
	name = "辉光透镜"
	desc = "一枚泛着炫目光辉的魔法透镜。透过它看东西会让人有些头痛。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "lens"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	cdtime = 10 MINUTES
	activetime = 30 SECONDS

/obj/item/clothing/ring/active/shimmeringlens/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("它微弱地脉动着，仍在重新汇聚奥术能量。"))
			return
	user.visible_message(span_warning("[user]透过[src]向外窥视！"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	activate(user)

/obj/item/clothing/ring/active/shimmeringlens/activate(mob/user)
	ADD_TRAIT(user, TRAIT_XRAY_VISION, "[type]")

/obj/item/clothing/ring/active/shimmeringlens/demagicify()
	var/mob/living/user = usr
	REMOVE_TRAIT(user, TRAIT_XRAY_VISION, "[type]")
	active = FALSE

/obj/item/sendingstonesummoner/Initialize(mapload)
	. = ..()
	var/mob/living/user = usr
	var/obj/item/natural/stone/sending/item1 = new /obj/item/natural/stone/sending
	var/obj/item/natural/stone/sending/item2 = new /obj/item/natural/stone/sending
	item1.paired_with = item2
	item2.paired_with = item1
	item1.icon_state = "whet"
	item2.icon_state = "whet"
	item1.color = "#d8aeff"
	item2.color = "#d8aeff"
	user.put_in_hands(item1, FALSE)
	user.put_in_hands(item2, FALSE)
	qdel(src)

/obj/item/natural/stone/sending
	name = "传讯石"
	desc = "一对传讯石中的其中一块。"
	var/obj/item/natural/stone/sending/paired_with

/obj/item/natural/stone/sending/attack_self(mob/user)
	var/input_text = input(user, "输入你要传送的话语：", "传讯")
	if(input_text)
		paired_with.say(input_text)

/obj/item/clothing/neck/roguetown/collar/leather/nomagic
	name = "束魔项圈"
	desc = "一条舒适的皮项圈，上面镶着红色宝石。"
	icon_state = "manabindingcollar"
	color = null
	slot_flags = ITEM_SLOT_NECK
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	unequip_delay_self = 1200

/obj/item/clothing/neck/roguetown/collar/leather/nomagic/Initialize(mapload)
	. = ..()
	var/datum/magic_item/mundane/nomagic/effect = new
	AddComponent(/datum/component/magic_item, effect)

/obj/item/clothing/gloves/roguetown/nomagic
	icon_state = "manabindinggloves"
	bloody_icon_state = "bloodyhands"
	name = "镶宝束魔手套"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	allow_self_unequip = FALSE	//Can not remove these without help
	equip_delay_self = 60
	equip_delay_other = 60
	strip_delay = 300

/obj/item/clothing/gloves/roguetown/nomagic/Initialize(mapload)
	. = ..()
	var/datum/magic_item/mundane/nomagic/effect = new
	AddComponent(/datum/component/magic_item, effect)

/obj/item/rope/chain/bindingshackles
	name = "位面束缚镣铐"
	desc = "注入奥术的镣铐，用于将异界生物的心智束缚在此世。它们不会任你驱使，想让其效力仍需谈判。"
	var/mob/living/fam
	var/tier = 1
	var/being_used = FALSE
	var/sentience_type = SENTIENCE_ORGANIC
	var/chosen_name
	var/binding = FALSE

/obj/item/rope/chain/bindingshackles/Initialize(mapload)
	. = ..()
	src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/rope/chain/bindingshackles/t2
	name = "高阶位面束缚镣铐"
	tier = 2

/obj/item/rope/chain/bindingshackles/t3
	name = "编织位面束缚镣铐"
	tier = 3

/obj/item/rope/chain/bindingshackles/t4
	name = "汇流位面束缚镣铐"
	tier = 4

/obj/item/rope/chain/bindingshackles/t5
	name = "畸异位面束缚镣铐"
	tier = 5

/obj/item/rope/chain/bindingshackles/attack(mob/living/simple_animal/hostile/retaliate/rogue/captive, mob/living/user)
	var/list/summon_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph,
		/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk,
		/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon)

	if(!(captive.type in summon_types))
		to_chat(user, span_warning("[captive]无法被这些镣铐束缚！"))
		return
	if(captive.summon_tier > tier)
		to_chat(user, span_warning("[src]的力量不足以束缚[captive]！"))
		return

	var/mob/living/simple_animal/hostile/retaliate/rogue/target = captive
	target.visible_message(span_warning("[src]正试图束缚[target.real_name]！"))
	if(do_after(user, 50, target = src) && binding == FALSE)
		if(!target.ckey) //player is not inside body or has refused, poll for candidates
			to_chat(user, span_notice("我试图将目标召唤物束缚在此世。"))
			binding = TRUE
			target.visible_message(span_warning("[target.real_name]的身体被发光的锁链缠住了……"), runechat_message = TRUE)
			var/list/candidates = pollCandidatesForMob("你想扮演一名法师的召唤物吗？", null, null, null, 100, target, POLL_IGNORE_MAGE_SUMMON)

			// theres at least one candidate
			if(LAZYLEN(candidates))
				var/mob/C = pick(candidates)
				target.awaken_summon(user, C.ckey)
				target.visible_message(span_warning("[target.real_name]的双眼亮起智慧的光芒，祂已在此世彻底苏醒。"), runechat_message = TRUE)
				custom_name(user,target)
				target.name = chosen_name
				binding = FALSE
			//no candidates, raise as npc
			else
				to_chat(user, span_notice("[captive]怀着无智的仇恨瞪视着你。束缚未能唤出它的心智！"))
				binding = FALSE
		else
			target.visible_message(span_notice("这只召唤物已经被束缚在此世了。"))
			return FALSE
		return FALSE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/proc/awaken_summon(mob/living/carbon/human/master, ckey)
	if(!master)
		return FALSE
	if(ckey) //player
		src.ckey = ckey
	to_chat(src, span_userdanger("我的召唤者是[master.real_name]。他们得说服我，我才会服从。"))
	to_chat(src, span_notice("[summon_primer]"))

	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE//easiest way to give mage summons proper darksight, although I'm wracking my brain for other angles since admin-spawned guys might happen

/obj/item/rope/chain/bindingshackles/proc/custom_name(mob/awakener, mob/chosen_one, iteration = 1)
	if(iteration > 5)
		return  // The spirit of indecision
	chosen_name = sanitize_name(stripped_input(chosen_one, "你叫什么名字？"))
	if(!chosen_name) // with the way that sanitize_name works, it'll actually send the error message to the awakener as well.
		to_chat(awakener, span_warning("你的召唤物没有选定有效名字！请稍候，让它再试一次。")) // more verbose than what sanitize_name might pass in it's error message
		return custom_name(awakener, iteration++)
	return chosen_name
