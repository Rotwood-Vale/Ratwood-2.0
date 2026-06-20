/mob/living/simple_animal/hostile/retaliate/bat
	name = "蝙蝠"
	desc = ""
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help_continuous = "拂过"
	response_help_simple = "拂过"
	response_disarm_continuous = "拍打"
	response_disarm_simple = "拍打"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 50
	health = 50
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "咬了"
	attack_verb_simple = "咬"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	movement_type = FLYING
	speak_emote = list("吱吱叫")
	base_intents = list(/datum/intent/bite)
	sight = SEE_SELF
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

	var/fly_time = 3 SECONDS //Less than this and it's impossible to deal with

	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/bat/Initialize(mapload)
	. = ..()
	verbs += list(/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_up,
	/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_down,
	/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw,
	/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance)


/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance()
	set category = "Winged Form"
	set name = "切换姿态"
	sitting = !sitting
	update_icon()

/mob/living/simple_animal/hostile/retaliate/bat/crow/update_icon_state()
	icon_state = sitting ? "crow" : "crow_flying"

/mob/living/simple_animal/hostile/retaliate/bat/crow/Move()
	if(sitting)
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw()
	set category = "Winged Form"
	set name = "鸣叫"
	emote("caw", intentional = TRUE, animal = TRUE)

/mob/living/simple_animal/hostile/retaliate/bat/crow/get_sound(input)
	if(input == "caw")
		return pick('sound/vo/mobs/bird/CROW_01.ogg', 'sound/vo/mobs/bird/CROW_02.ogg', 'sound/vo/mobs/bird/CROW_03.ogg')

/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_up()
	set category = "Winged Form"
	set name = "起飞"

	if(src.pulledby != null)
		to_chat(src, span_notice("我被抓着没法飞走！"))
		return
	src.visible_message(span_notice("[src]开始上升！"), span_notice("你起飞了……"))
	if(do_after(src, fly_time, target))
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("我飞上去了。"))
		else
			to_chat(src, span_notice("我被抓着没法飞走！"))

/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_down()
	set category = "Winged Form"
	set name = "降落"

	if(src.pulledby != null)
		to_chat(src, span_notice("我被抓着没法飞走！"))
		return
	src.visible_message(span_notice("[src]开始下降！"), span_notice("你起飞了……"))
	if(do_after(src, fly_time, target))
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("我飞下来了。"))
		else
			to_chat(src, span_notice("我被抓着没法飞走！"))

/mob/living/simple_animal/hostile/retaliate/bat/crow
	name = "扎德"
	desc = ""
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow1"
	icon_gib = "crow1"
	speak_emote = list("呱呱叫")
	base_intents = list(/datum/intent/unarmed/help)
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	remains_type = /obj/effect/decal/remains/crow
	fly_time = 3 SECONDS // slowing down crow for witches
	var/sitting = FALSE

/obj/effect/decal/remains/crow
	name = "扎德残骸"
	desc = "永不复还……"
	gender = PLURAL
	icon_state = "crow1"
	icon = 'icons/roguetown/mob/monster/crow.dmi'
