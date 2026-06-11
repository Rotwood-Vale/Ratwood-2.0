/obj/item/clothing/mask/rogue/MiddleClick(mob/user)
	if((user.zone_selected == BODY_ZONE_PRECISE_NOSE) && (cansnout == TRUE))
		if(snouting == TRUE)
			snouting = FALSE
		else
			snouting = TRUE
		to_chat(user, span_info("我[snouting ? "给\the [src]留出吻部空间" : "把\the [src]戴得更紧"]."))
		if(snouting)
			icon_state = "[initial(icon_state)]_snout"
		else
			icon_state = "[initial(icon_state)]"
		user.update_inv_wear_mask()
	else
		overarmor = !overarmor
		to_chat(user, span_info("我[overarmor ? "把\the [src]戴在头发下面" : "把\the [src]戴在头发外面"]."))
		if(overarmor)
			alternate_worn_layer = HOOD_LAYER //Below Hair Layer
		else
			alternate_worn_layer = BACK_LAYER //Above Hair Layer
		user.update_inv_wear_mask()

/obj/item/clothing/mask/rogue
	name = ""
	icon = 'icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/masks.dmi'
	body_parts_covered = FACE
	slot_flags = ITEM_SLOT_MASK
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	var/overarmor = TRUE

/obj/item/clothing/mask/rogue/AltRightClick(mob/user)
	if(!istype(loc, /mob/living/carbon))
		return
	var/mob/living/carbon/H = user
	if(icon_state == "[initial(icon_state)]_snout")
		icon_state = initial(icon_state)
		H.update_inv_wear_mask()
		update_icon()
		return

	var/icon/J = new('icons/roguetown/clothing/onmob/masks.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(findtext(icon_s, "[icon_state]_snout"))
			icon_state += "_snout"
			H.update_inv_wear_mask()
			update_icon()
			return

/obj/item/clothing/mask/rogue/examine()
	. = ..()

/obj/item/clothing/mask/rogue/spectacles
	name = "眼镜"
	icon_state = "glasses"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 20
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	nudist_approved = TRUE
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
//	block2add = FOV_BEHIND

/obj/item/clothing/mask/rogue/spectacles/inq
	name = "奥塔瓦夜影镜片"
	icon_state = "bglasses"
	desc = "它既为耐用而造，也注定会在奥塔瓦那少数蒙受诺克圣恩之人中引发争论。究竟该不该在诺克之光下夜行？这些镜片看起来可以用右手食指小心一拨便移开。"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 300
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
	anvilrepair = /datum/skill/craft/armorsmithing
	var/lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/inq/spawnpair
	lensmoved = TRUE

/obj/item/clothing/mask/rogue/spectacles/inq/equipped(mob/user, slot)
	..()

	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/mask/rogue/spectacles/inq/update_icon(mob/user, slot)
	cut_overlays()
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		var/mutable_appearance/redlenses = mutable_appearance(mob_overlay_icon, "bglasses_glow")
		redlenses.layer = 19
		redlenses.plane = 20
		user.add_overlay(redlenses)

/obj/item/clothing/mask/rogue/spectacles/inq/attack_right(mob/user, slot)
	..()

	if(!lensmoved)
		to_chat(user, span_info("你悄悄将内层镜片拨到一边。"))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		return
	to_chat(user, span_info("你悄悄将内层镜片拨回原位。"))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/inq/dropped(mob/user, slot)
	..()
	if(slot != SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return
		lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden
	name = "金色眼镜"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing
	var/active_item = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden/equipped(mob/user, slot)
	..()
	if(active_item)
		return
	else if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "[type]")
		if (user.get_skill_level(/datum/skill/craft/engineering) >= 2)
			ADD_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[type]")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
			to_chat(user, span_notice("该开工了。"))
			active_item = TRUE
			return
		else
			to_chat(user, span_notice("我看不懂眼前这些文字和数字。"))
			return
	else
		return



/obj/item/clothing/mask/rogue/spectacles/golden/dropped(mob/user, slot)
	..()
	if(HAS_TRAIT(src, TRAIT_SANDSTORM_GOGGLES))
		REMOVE_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "[type]")
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[type]")
		user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
		to_chat(user, span_notice("该停工了。"))

/obj/item/clothing/mask/rogue/spectacles/Initialize(mapload)
	..()
	AddComponent(/datum/component/spill, null, 'sound/blank.ogg')

/obj/item/clothing/mask/rogue/spectacles/Crossed(mob/crosser)
	if(isliving(crosser) && !obj_broken)
		take_damage(11, BRUTE, "blunt", 1)
	..()

/obj/item/clothing/mask/rogue/spectacles/goggles
	name = "防沙护目镜"
	icon_state = "goggles_sandstorm"
	desc = "一副样式较旧的护目镜，用来保护佩戴者免受沙暴侵袭。"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/mask/rogue/spectacles/goggles/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "generic")
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/spectacles/goggles/dropped(mob/user)
	..()
	if(HAS_TRAIT(user, TRAIT_SANDSTORM_GOGGLES))
		REMOVE_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "generic")
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/eyepatch
	name = "眼罩"
	desc = "一只适配右眼的眼罩。"
	icon_state = "eyepatch"
	max_integrity = 20
	integrity_failure = 0.5
	block2add = FOV_RIGHT
	body_parts_covered = EYES
	sewrepair = TRUE
	nudist_approved = TRUE

/obj/item/clothing/mask/rogue/eyepatch/left
	desc = "一只适配左眼的眼罩。"
	icon_state = "eyepatch_l"
	block2add = FOV_LEFT

/obj/item/clothing/mask/rogue/lordmask
	name = "金色半面具"
	desc = "仿佛半张脸都化作了黄金。"
	icon_state = "lmask"
	sellprice = 50
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/rogue/lordmask/l
	icon_state = "lmask_l"

/obj/item/clothing/mask/rogue/lordmask/tarnished
	name = "斑驳金色半面具"
	desc = "这些符文与护印本为恶魔而设；黄金却以一种违背常理的方式锈蚀，仿佛承受着不可能存在的痛苦。如今这黄金已不值分文，但纳莱迪人佩戴它们的理由从来不在这里。"
	sellprice = 20

/obj/item/clothing/mask/rogue/sack
	name = "麻袋面具"
	desc = "一个挖了眼洞的棕色麻袋。"
	icon_state = "sackmask"
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	max_integrity = 200
	prevent_crits = list(BCLASS_BLUNT)
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEEARS
	body_parts_covered = FACE|HEAD
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	armor = ARMOR_PADDED
	sewrepair = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/mask/rogue/sack/psy
	name = "普希顿麻袋面具"
	desc = "一个普通的棕色麻袋。这一个被挖出了眼洞，表面还粗糙地用粉笔画着普希顿的教十字，看上去足以令大多数人不安。"
	icon_state = "sackmask_psy"

/obj/item/clothing/mask/rogue/facemask/steel/confessor
	name = "古怪面具"
	desc = "据说这副面具的最初版本曾在圣赛勒斯提亚帝国覆灭前用于隐秘仪式，如今则被重新用作奥塔瓦正教密探的遮面之物。<br> <br>也有人说它本身就是一件异端之物，却又是必要之恶，能让佩戴者免遭左道邪法侵害。每当你呼吸时，口中都会泛起一股铜味。"
	icon_state = "confessormask"
	max_integrity = 200
	equip_sound = 'sound/items/confessormaskon.ogg'
	smeltresult = /obj/item/ingot/steel
	var/worn = FALSE
	slot_flags = ITEM_SLOT_MASK

/obj/item/clothing/mask/rogue/facemask/steel/confessor/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.wear_mask == src)
		worn = TRUE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/dropped(mob/user)
	. = ..()
	if(worn)
		playsound(user, 'sound/items/confessormaskoff.ogg', 80)
		worn = FALSE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/clothing/mask/rogue/spectacles/inq))
		user.visible_message(span_warning("[user]开始把[I]的镜片装进[src]里。"))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/P = new /obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(I)
		else
			user.visible_message(span_warning("[user]停止把镜片装进[src]里。"))
		return

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed
	name = "更古怪面具"
	desc = "据说这副面具的最初版本曾在圣赛勒斯提亚帝国覆灭前用于隐秘仪式，如今则被重新用作奥塔瓦正教密探的遮面之物。<br> <br>也有人说它本身就是一件异端之物，却又是必要之恶，能让佩戴者免遭左道邪法侵害。每当你呼吸时，口中都会泛起一股铜味。"
	icon_state = "confessormask_lens"
	var/lensmoved = TRUE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/attack_right(mob/user, slot)
	..()
	if(!lensmoved)
		to_chat(user, span_info("你悄悄将内层镜片拨到一边。"))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		return
	to_chat(user, span_info("你悄悄将内层镜片拨回原位。"))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/dropped(mob/user, slot)
	..()
	if(slot != SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/mask/rogue/wildguard
	name = "荒野守卫"
	desc = "一副仿照登多尔咆哮野兽制成的面具。"
	icon_state = "wildguard"
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = 100
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	sewrepair = FALSE

/obj/item/clothing/mask/rogue/facemask
	name = "铁面具"
	icon_state = "imask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	sewrepair = FALSE

/obj/item/clothing/mask/rogue/facemask/equipped(mob/user, slot)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_fov_angles()

/obj/item/clothing/mask/rogue/facemask/dropped(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_fov_angles()

/obj/item/clothing/mask/rogue/facemask/shadowfacemask
	name = "蛛骑士面具"
	desc = "一副饰有蛛形纹样的金属面具。阴森的面容，出自阴森的种族之手。"
	icon_state = "shadowfacemask"

/obj/item/clothing/mask/rogue/facemask/ancient
	name = "远古面具"
	desc = "打磨光亮的吉尔布兰泽被塑成一张威吓十足的面容。指尖触及面颊时，它温热得宛如血肉。但那并不是血肉。至少现在还不是。"
	max_integrity = 200
	icon_state = "ancientmask"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/mask/rogue/facemask/ancient/decrepit
	name = "破旧面具"
	desc = "磨损的青铜被塑成一张永不眨眼的面容。唯有那些深埋于断首山腹地的雕像，才与它同样有着起皱的嘴角与冷酷发号施令的讥笑。"
	max_integrity = 75
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/mask/rogue/facemask/copper
	name = "铜面具"
	icon_state = "cmask"
	desc = "一副厚重的铜面具，能遮蔽并保护面部，只是效果算不上好。"
	armor = ARMOR_PLATE_BAD
	smeltresult = /obj/item/ingot/copper

/obj/item/clothing/mask/rogue/facemask/hound
	name = "猎犬面具"
	icon_state = "imask_snout"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/mask/rogue/facemask/psydonmask
	name = "普希顿面具"
	desc = "一副银制面具，永远凝固着一种无可置疑的欢愉神情。圣赛利克斯教团至今拿不准，它究竟象征着普希顿的“欢悦”、“戏剧性”，还是二者难以捉摸的交融。"
	icon_state = "psydonmask"
	item_state = "psydonmask"

/*
/obj/item/clothing/mask/rogue/facemask/prisoner
	name = "cursed mask"
	icon_state = "cursemask"
	desc = "An iron mask that seals around the head, making it impossible to remove. It seems to be enchanted with some kind of vile magic..."
	body_parts_covered = NONE //So that surgery can be done through the mask.
	var/active_item
	var/bounty_amount
	cansnout = TRUE

/obj/item/clothing/mask/rogue/facemask/prisoner/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/mask/rogue/facemask/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "cursedmask")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "cursedmask")
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/mask/rogue/facemask/prisoner/proc/timerup(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "cursedmask")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "cursedmask")
	visible_message(span_warning("The cursed mask opens with a click, falling off of [user]'s face and clambering apart on the ground, their penance complete."))
	say("YOUR PENANCE IS COMPLETE.")
	for(var/name in GLOB.outlawed_players)
		if(user.real_name == name)
			GLOB.outlawed_players -= user.real_name
			priority_announce("[user.real_name] has completed their penance. Justice has been served in the eyes of Ravox.", "PENANCE", 'sound/misc/bell.ogg')
	playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/mask/rogue/facemask/prisoner/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_WEAR_MASK)
		active_item = TRUE
		to_chat(user, span_warning("This accursed mask pacifies me!"))
		ADD_TRAIT(user, TRAIT_PACIFISM, "cursedmask")
		ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "cursedmask")
		if(HAS_TRAIT(user, TRAIT_RITUALIST))
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
		var/timer = 5 MINUTES //Base timer is 5 minutes, additional time added per bounty amount

		if(bounty_amount >= 10)
			var/additional_time = bounty_amount * 0.1 // 10 mammon = 1 minute
			additional_time = round(additional_time)
			timer += additional_time MINUTES

		var/timer_minutes = timer / 600

		addtimer(CALLBACK(src, PROC_REF(timerup), user), timer)
		say("YOUR PENANCE WILL BE COMPLETE IN [timer_minutes] MINUTES.")
	return
*/

/obj/item/clothing/mask/rogue/facemask/steel
	name = "钢面具"
	icon_state = "smask"
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/mask/rogue/facemask/steel/hound
	name = "钢猎犬面具"
	desc = "一副为有吻部者打造的钢面具，可保护眼睛、鼻子与口鼻，同时遮住面容。"
	icon_state = "smask_snout"

/obj/item/clothing/mask/rogue/facemask/steel/steppesman
	name = "草原人战面具"
	desc = "一副钢制面具，被塑造成一张颇具魅力的汉子面孔！高耸的颧骨、挺直的鼻梁，还有一撇醒目的大胡子。不过嘛，阿夫纳尔以外的人多半不会觉得戴上它的你有多迷人。"
	max_integrity = 250
	icon_state = "steppemask"
	layer = HEAD_LAYER

/obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro
	name = "草原人兽面具"
	desc = "一副钢制面具，被塑造成一张颇具魅力的兽人面孔！高耸的颧骨、鼻梁，以及充作胡须的细小尖刺一应俱全。不过嘛，阿夫纳尔以外的人多半不会觉得戴上它的你有多迷人。"
	icon_state = "steppemask_snout"

/obj/item/clothing/mask/rogue/facemask/steel/steppesman
	name = "草原人战面具"
	desc = "一副钢制面具，被塑造成一张颇具魅力的汉子面孔！高耸的颧骨、挺直的鼻梁，还有一撇醒目的大胡子。不过嘛，阿夫纳尔以外的人多半不会觉得戴上它的你有多迷人。"
	max_integrity = 250
	icon_state = "steppemask"
	layer = HEAD_LAYER

/obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro
	name = "草原人兽面具"
	desc = "一副钢制面具，被塑造成一张颇具魅力的兽人面孔！高耸的颧骨、鼻梁，以及充作胡须的细小尖刺一应俱全。不过嘛，阿夫纳尔以外的人多半不会觉得戴上它的你有多迷人。"
	icon_state = "steppebeast"

/obj/item/clothing/mask/rogue/facemask/goldmask
	name = "黄金面具"
	icon_state = "goldmask"
	max_integrity = 150
	sellprice = 100
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/mask/rogue/facemask/yoruku_oni
	name = "鬼面具"
	desc = "一副木制面具，雕成据说游荡于卡曾郡山中的恶鬼模样。"
	icon_state = "oni"

/obj/item/clothing/mask/rogue/facemask/yoruku_kitsune
	name = "狐面具"
	desc = "一副木制面具，雕成据说在卡曾郡森林中施展恶作剧的狐灵模样。"
	icon_state = "kitsune"

/obj/item/clothing/mask/rogue/facemask/steel/kazengun
	name = "士兵半面具"
	desc = "战争的第一课，就是若能和平度日便再好不过。"
	block2add = null
	armor = ARMOR_PLATE_BAD // because it's only half
	icon_state = "kazengunmouthguard"
	item_state = "kazengunmouthguard"

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full
	name = "食人魔面具"
	desc = "第二课：富人做梦，穷人为让梦成真而死。"
	icon_state = "kazengunfaceguard"
	item_state = "kazengunfaceguard"

/obj/item/clothing/mask/rogue/shepherd
	name = "半面具"
	icon_state = "shepherd"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	block2add = null
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE
	nudist_approved = TRUE

/obj/item/clothing/mask/rogue/shepherd/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/shepherd/shadowmask
	name = "紫色半面具"
	icon_state = "shadowmask"
	desc = "适合那些以王冠之名行龌龊勾当时遮住自己面孔的人。"

/obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	desc = "前方点缀着细小的白色染斑，像极了牙齿，仿佛有一道笑容自阴影中狞望而来。"

/obj/item/clothing/mask/rogue/physician
	name = "瘟疫面具"
	desc = "还有什么实验室，能比血流成河的战场更合适呢？"
	icon_state = "physmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	body_parts_covered = FACE|EYES|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	nudist_approved = TRUE

/obj/item/clothing/mask/rogue/physician/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(user, TRAIT_NOSTINK, "[type]")

/obj/item/clothing/mask/rogue/physician/dropped(mob/living/carbon/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_NOSTINK, "[type]")

/obj/item/clothing/mask/rogue/skullmask
	name = "骷髅面具"
	desc = "一副骷髅造型的面具，专为恫吓旁人而制。"
	icon_state = "skullmask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PADDED_BAD
	prevent_crits = null
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	smeltresult = /obj/item/natural/bone
	salvage_result = /obj/item/natural/bone
	salvage_amount = 1
	nudist_approved = TRUE
	sewrepair = FALSE

/obj/item/clothing/mask/rogue/ragmask
	name = "碎布面具"
	icon_state = "ragmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE
	cansnout = TRUE
	nudist_approved = TRUE

/obj/item/clothing/mask/rogue/ragmask/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/ragmask/red //predyed mask for NPCs
	color = CLOTHING_RED

/obj/item/clothing/mask/rogue/ragmask/azure  //predyed mask for gang
	color = CLOTHING_AZURE

/obj/item/clothing/mask/rogue/ragmask/black
	color = CLOTHING_BLACK

/obj/item/clothing/mask/rogue/lordmask/naledi
	name = "战学者面具"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "这些符文与护印本为恶魔而设；黄金却以一种违背常理的方式锈蚀，仿佛承受着不可能存在的痛苦。其间最醒目的刻痕，是纳莱迪教十字的形状。它经过装甲加固，可保护佩戴者的面部。"
	max_integrity = 100
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/mask/rogue/lordmask/naledi/sojourner
	name = "旅者面具"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "一副黄金面具，因灯灵腐化所带来的长期痛苦而扭曲变形；但只要其上的纳莱迪咒印仍在，佩戴者也会同样存续。两侧以手工贴合的甲片加固，用以弹开来袭打击。</br>'……典型的旅者总带着毫无预警便会突然消失的刻板印象，他们也始终在追求让自己的学识更加多元。有人会为了学习本地女巫净化颠茄萃取物的配方而来到此地，并在社区里耗费多年试图掌握它；也有人会与当地正教教团并肩作战，斩杀一位莱克领主以换取其藏书档案，却又在第二天悄然无踪……'"
	max_integrity = 150
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	sellprice = 0

/obj/item/clothing/mask/rogue/exoticsilkmask
	name = "异域丝绸面具"
	icon_state = "exoticsilkmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	adjustable = CAN_CADJUST
	toggle_icon_state = FALSE
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/mask/rogue/exoticsilkmask/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/blindfold
	name = "蒙眼布"
	desc = "一条系在眼前、用来遮蔽视线的布条。"
	icon_state = "blindfold"
	item_state = "blindfold"
	body_parts_covered = EYES
	sewrepair = TRUE
	tint = 3
	nudist_approved = TRUE
	mob_overlay_icon = 'icons/mob/clothing/eyes.dmi'
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/clothing/mask/rogue/blindfold/fake
	desc = "一条系在眼前的布条，但过于透薄，挡不住视线。"
	tint = 0

/obj/item/clothing/mask/rogue/duelmask
	name = "决斗者面具"
	desc = "一副供蒙面决斗者佩戴的黑布面具，虽然不给任何防护，却不知怎地既遮住了你的眼睛，也遮住了你的身份……"
	icon_state = "duelmask"
	flags_inv = HIDEFACE
	body_parts_covered = EYES
	slot_flags = ITEM_SLOT_MASK
	color = COLOR_ALMOST_BLACK
	detail_tag = "_detail"
	detail_color = COLOR_SILVER
	sewrepair = TRUE
	nudist_approved = TRUE

/obj/item/clothing/mask/rogue/horsey
	name = "头部遮眼具"
	desc = "让佩戴者专注于前方。由加固皮革制成。"
	icon_state = "hblinders"
	item_state = "hblinders"
	body_parts_covered = HEAD
	sewrepair = TRUE

//gemcarved masks from Vanderlin

/obj/item/clothing/mask/rogue/facemask/carved
	name = "雕刻面具"
	icon_state = "ancientmask"
	desc = "你本不该看到这个。"
	max_integrity = 50
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	anvilrepair = /datum/skill/craft/armorsmithing //Maybe these shouldn't be repairable, someone else can do that if they want.
	clothing_flags = CANT_SLEEP_IN
	sellprice = 70
	smeltresult = null
	salvage_result = null

/obj/item/clothing/mask/rogue/facemask/carved/jademask
	name = "玉面具"
	icon_state = "mask_jade"
	desc = "一副既能遮蔽又能保护面部的玉面具。"
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/jademask
	name = "玉面具"
	icon_state = "mask_jade"
	desc = "一副既能遮蔽又能保护面部的玉面具。"
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/turqmask
	name = "天青石面具"
	icon_state = "mask_turq"
	desc = "一副既能遮蔽又能保护面部的天青石面具。"
	sellprice = 95

/obj/item/clothing/mask/rogue/facemask/carved/rosemask
	name = "玫瑰石面具"
	icon_state = "mask_rose"
	desc = "一副既能遮蔽又能保护面部的玫瑰石面具。"
	sellprice = 35

/obj/item/clothing/mask/rogue/facemask/carved/shellmask
	name = "贝壳面具"
	icon_state = "mask_shell"
	desc = "一副既能遮蔽又能保护面部的贝壳面具。"
	sellprice = 30

/obj/item/clothing/mask/rogue/facemask/carved/coralmask
	name = "心石面具"
	icon_state = "mask_coral"
	desc = "一副既能遮蔽又能保护面部的心石面具。"
	sellprice = 80

/obj/item/clothing/mask/rogue/facemask/carved/ambermask
	name = "琥珀面具"
	icon_state = "mask_amber"
	desc = "一副既能遮蔽又能保护面部的琥珀面具。"
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/onyxamask
	name = "缟玛瑙面具"
	icon_state = "mask_onyxa"
	desc = "一副既能遮蔽又能保护面部的缟玛瑙面具。"
	sellprice = 50

/obj/item/clothing/mask/rogue/facemask/carved/opalmask
	name = "欧泊面具"
	icon_state = "mask_opal"
	desc = "一副既能遮蔽又能保护面部的欧泊面具。"
	sellprice = 100

/obj/item/clothing/mask/rogue/xylixmask
	name = "丑角面具"
	item_state = "xylixmask"
	icon_state = "xylixmask"
	desc = "一副陶制面具，永远凝固着其所侍神明偏爱的欢快笑容。Alt+右键切换样式，Shift+右键切换吻部形态，Shift+中键切换身份隐藏。"
	max_integrity = 50
	armor = null
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = null
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	smeltresult = null
	anvilrepair = /datum/skill/craft/ceramics
	sewrepair = FALSE
	sellprice = 0
	var/hide_identity = TRUE
	var/next_honk = 0
	var/static/list/xylixmask_base_states = list("xylixmask", "xylixmask2", "xylixmask3", "xylixmask4", "xylixmask5", "xylixmask6")
	var/static/list/xylixmask_snout_states = list("xylixmask_snout", "xylixmask_snout2", "xylixmask_snout3", "xylixmask_snout4", "xylixmask_snout5", "xylixmask_snout6")
	var/static/list/xylixmask_special_states = list("xylixmask3", "xylixmask4", "xylixmask_snout3", "xylixmask_snout4")

/obj/item/clothing/mask/rogue/xylixmask/proc/is_special_state()
	return (icon_state in xylixmask_special_states)

/obj/item/clothing/mask/rogue/xylixmask/proc/update_identity_flags(mob/user)
	flags_inv = hide_identity ? (HIDEFACE|HIDESNOUT) : NONE
	block2add = hide_identity ? FOV_BEHIND : null
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wear_mask()
		H.update_fov_angles()
		H.update_vision_cone()

/obj/item/clothing/mask/rogue/xylixmask/proc/toggle_identity(mob/user)
	hide_identity = !hide_identity
	update_identity_flags(user)
	to_chat(user, span_notice("我用\the [src][hide_identity ? "隐藏" : "显露"]自己的身份。"))
	return TRUE

/obj/item/clothing/mask/rogue/xylixmask/proc/apply_mask_style(style, mob/user)
	if(!style)
		return
	icon_state = style
	item_state = style
	update_icon()
	update_identity_flags(user)


/obj/item/clothing/mask/rogue/xylixmask/proc/open_style_menu(mob/user)
	var/list/states = xylixmask_base_states
	var/list/radial_choices = list()
	for(var/state in states)
		radial_choices[state] = icon(icon = 'icons/roguetown/clothing/masks.dmi', icon_state = state)

	var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return
	apply_mask_style(choice, user)

/obj/item/clothing/mask/rogue/xylixmask/AltRightClick(mob/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	open_style_menu(user)

/obj/item/clothing/mask/rogue/xylixmask/ShiftRightClick(mob/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	if(findtext(icon_state, "_snout"))
		var/snout_index = xylixmask_snout_states.Find(icon_state)
		if(!snout_index)
			return ..()
		var/base_state = xylixmask_base_states[snout_index]
		apply_mask_style(base_state, user)
		return
	var/base_index = xylixmask_base_states.Find(icon_state)
	if(!base_index)
		return ..()
	var/snout_state = xylixmask_snout_states[base_index]
	apply_mask_style(snout_state, user)
	return

/obj/item/clothing/mask/rogue/xylixmask/attack_right(mob/user)
	if(!is_special_state())
		return ..()
	if(world.time < next_honk)
		return
	next_honk = world.time + 1 SECONDS
	playsound(src, 'sound/misc/honkmask.ogg', 70, TRUE)
	to_chat(user, span_notice("面具的鼻子被捏了一下，发出吱吱的鸣响。"))
/obj/item/clothing/mask/rogue/xylixmask/dropped(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		hide_identity = initial(hide_identity)
		block2add = initial(block2add)
		H.update_fov_angles()
		H.update_vision_cone()
/obj/item/clothing/mask/rogue/xylixmask/MiddleClick(mob/user, params)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		if(toggle_identity(user))
			return
	return ..()

/obj/item/clothing/mask/rogue/xylixmask/examine(mob/user)
	. = ..()
	. += span_notice("按下 Alt+右键可打开样式环形菜单。")
	. += span_notice("按下 Shift+右键可切换所选样式的吻部版本。")
	. += span_notice("按下 Shift+中键可切换身份隐藏。")
	. += span_notice("使用丑角样式时：右键可以按响喇叭。")
