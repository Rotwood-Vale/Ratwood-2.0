/datum/antagonist/werewolf
	name = "维尔沃夫"
	roundend_category = "狼人"
	antagpanel_category = "狼人"
	job_rank = ROLE_WEREWOLF
	confess_lines = list(
		"我体内的野兽正在咆哮！",
		"当心那头野兽！",
		"我的狼之印记！",
	)
	rogue_enabled = TRUE
	var/special_role = ROLE_WEREWOLF
	var/transformed
	var/transforming
	var/untransforming
	var/wolfname = "维尔沃夫"

/datum/antagonist/werewolf/lesser
	name = "次级维尔沃夫"
	increase_votepwr = FALSE

/datum/antagonist/werewolf/lesser/roundend_report()
	return

/datum/antagonist/werewolf/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/werewolf/lesser))
		return span_boldnotice("一名年轻的狼族同胞。")
	if(istype(examined_datum, /datum/antagonist/werewolf))
		return span_boldnotice("一名年长的狼族同胞。")
	if(examiner.Adjacent(examined))
		if(istype(examined_datum, /datum/antagonist/vampire))
			if(transformed)
				return span_boldwarning("一名远古吸血鬼。我必须小心！")

/datum/antagonist/werewolf/on_gain()
	greet()
	owner.special_role = name
	if(increase_votepwr)
		forge_werewolf_objectives()

	wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
	return ..()

/datum/antagonist/werewolf/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("我不再是[special_role]了！"))
	owner.special_role = null
	return ..()

/datum/antagonist/werewolf/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/werewolf/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/werewolf/proc/forge_werewolf_objectives()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/werewolf/escape_objective = new
		escape_objective.owner = owner
		add_objective(escape_objective)
		return

/datum/antagonist/werewolf/greet()
	to_chat(owner.current, span_userdanger("自很久很久以前那一口咬伤之后，那位林野之神的疯狂便在我体内翻涌。待到月光降临，我将满足自己那神圣的饥渴。"))
	return ..()

/datum/antagonist/werewolf/lesser/greet()
	// leave this empty so that lesser verevolf's dont get the greeting on bite.
	// there is probably a better way to do this but this works until sm1 smarter inevitably rewrites WW.

/mob/living/carbon/human/proc/can_werewolf()
	if(!mind)
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	//No cross species pollination!!!
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/werewolf_check(werewolf_type = /datum/antagonist/werewolf/lesser)
	if(!mind)
		return
	var/already_wolfy = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(already_wolfy)
		return already_wolfy
	if(!can_werewolf())
		return
	return mind.add_antag_datum(werewolf_type)

/mob/living/carbon/human/proc/werewolf_infect_attempt()
	var/datum/antagonist/werewolf/wolfy = werewolf_check()
	if(!wolfy)
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return
	to_chat(src, span_danger("我感觉糟透了……真的糟透了……"))
	mob_timers["puke"] = world.time
	vomit(1, blood = TRUE, stun = FALSE)
	return wolfy

/mob/living/carbon/human/proc/werewolf_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("我的力量被削弱了，无法治疗自己！"))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("我不该啃食腐烂的血肉。"))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("我不该啃食被污染的血肉。"))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
			to_chat(src, span_warning("我不该啃食同族的血肉。"))
			return

	to_chat(src, span_warning("我吞食鲜嫩的血肉，感觉自己重新焕发了活力。"))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin
	slot_flags = null
	name = "维尔沃夫兽皮"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_WWOLF
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 550
	item_flags = DROPDEL

/datum/intent/simple/werewolf
	name = "利爪"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("抓挠", "撕扯", "开膛破肚")
	animname = "chop"
	hitsound = "genslash"
	penfactor = 50
	candodge = TRUE
	canparry = TRUE
	miss_text = "扑了个空！"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"

/datum/intent/mace/smash/werewolf
	name = "狂击"
	desc = "以狼人肌力发动的强力猛击，造成正常伤害，并能依照你的力量击退、减速站立目标。力量低于 10 时无效。减速与击退会随你的力量提高，最高按 15 点计算（1 到 5 格）。同一目标每 5 秒内不能连续使用。倒地目标的击退距离减半。"
	icon_state = "insmash"
	chargetime = 1
	penfactor = 60

/obj/item/rogueweapon/werewolf_claw
	name = "维尔沃夫利爪"
	desc = ""
	item_state = null
	experimental_inhand = FALSE
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 900
	max_integrity = 900
	force = 25
	block_chance = 0
	wdefense = 2
	armor_penetration = 15
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	special = /datum/special_intent/axe_swing	//Good pairing for area denial for WW's.

/obj/item/rogueweapon/werewolf_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/werewolf_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/werewolf_claw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)
