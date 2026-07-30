/obj/item/rogueweapon/surgery
	name = "手术工具"
	desc = "会撕裂你内脏的东西。"
	icon = 'icons/roguetown/items/surgery.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 175
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = null

	grid_width = 32
	grid_height = 64

/obj/item/rogueweapon/surgery/Initialize(mapload)
	. = ..()
	item_flags |= SURGICAL_TOOL //let's not stab patients for fun

/obj/item/rogueweapon/surgery/scalpel
	name = "手术刀"
	desc = "用于在病患肉体上进行精准切割的工具。"
	icon_state = "scalpel"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_SCALPEL
	smeltresult = null

/obj/item/rogueweapon/surgery/saw
	name = "骨锯"
	desc = "用于切骨的工具。"
	icon_state = "bonesaw"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	force = 16
	throwforce = 16
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_CHOP
	tool_behaviour = TOOL_SAW
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat
	name = "手术钳"
	desc = "用于夹持软组织的工具。"
	icon_state = "forceps"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_HEMOSTAT
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat/first //Three different types now to allow multiple surgical sites at once.
	name = "\improper 塔尔西斯钳"

/obj/item/rogueweapon/surgery/hemostat/second
	name = "\improper 西斯拉特钳"

/obj/item/rogueweapon/surgery/hemostat/third
	name = "\improper 梅德拉钳"

/obj/item/rogueweapon/surgery/retractor
	name = "扩张器"
	desc = "用于撑开组织以进行手术操作的工具。"
	icon_state = "speculum"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_RETRACTOR
	smeltresult = null

/obj/item/rogueweapon/surgery/bonesetter
	name = "骨钳"
	desc = "用于夹持硬组织的工具。"
	icon_state = "bonesetter"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_BONESETTER
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery
	name = "烙铁"
	desc = "用于烧灼伤口的工具。使用前先加热。"
	icon_state = "cauteryiron"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 18
	throwforce = 18
	wdefense = 3
	wbalance = WBALANCE_HEAVY	//huh?
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	/// Timer to cool down
	var/cool_timer
	/// Whether or not we are heated up
	var/heated = FALSE
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery/examine(mob/user)
	. = ..()
	if(heated)
		. += span_warning("尖端摸起来很烫。")

/obj/item/rogueweapon/surgery/cautery/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)
	if(heated)
		icon_state = "[initial(icon_state)]_hot"

/obj/item/rogueweapon/surgery/cautery/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/heating = 0
	if(istype(A, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/forge = A
		if(forge.on)
			heating = 20
	if(heating)
		user.visible_message(span_info("[user]加热了[src]。"))
		fire_act(heating)
		return TRUE
	return ..()

/obj/item/rogueweapon/surgery/cautery/fire_act(added, maxstacks)
	. = ..()
	if(!heated)
		playsound(src, 'sound/items/firelight.ogg', 100, vary = TRUE)
	update_heated(TRUE)
	if(cool_timer)
		deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(update_heated), FALSE), added SECONDS, TIMER_STOPPABLE)

/obj/item/rogueweapon/surgery/cautery/get_temperature()
	if(heated)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/rogueweapon/surgery/cautery/proc/update_heated(new_heated)
	heated = new_heated
	if(heated)
		damtype = BURN
		tool_behaviour = TOOL_CAUTERY
	else
		damtype = BRUTE
		tool_behaviour = null
	update_icon()

/obj/item/rogueweapon/surgery/cautery/branding
	name = "烙印铁"
	desc = "在肉体上留下铭文的烙铁。使用前先加热。"
	icon_state = "brandingiron"
	possible_item_intents = list(/datum/intent/use)
	var/setbranding = null
	var/branding_damage = 20
	var/branding_low_quality = FALSE
	var/branding_count = 0

/obj/item/rogueweapon/surgery/cautery/branding/slave
	name = "奴隶烙印铁"
	desc = "用于在失物上标记所有权。使用前先加热。"

/obj/item/rogueweapon/surgery/cautery/branding/crude
	name = "粗糙烙印棍"
	desc = "由煤炭、绳子和一根棍子制成。看起来在断裂之前至少能给自己烙印两次。使用前先加热。"
	icon_state = "brandingiron_crude"
	branding_damage = 10
	branding_low_quality = TRUE
	branding_count = 2

/obj/item/rogueweapon/surgery/cautery/branding/examine(mob/user)
	. = ..()
	if(!setbranding || !length(setbranding))
		. += span_warning("尚未设置烙印符号。")
	else
		. += span_warning("它将印下[setbranding]。")

/obj/item/rogueweapon/surgery/cautery/branding/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(!user.cmode)
		if(heated)
			to_chat(user, span_warning("太烫了，无法更换符号！"))
			return
		var/inputty = stripped_input(user, "你想设置什么烙印？\n例如：一幅小型的劳斯头部图画", "输入烙印描述", null, 64)
		if(inputty)
			setbranding = inputty
			to_chat(user, span_warning("我更换了[!branding_low_quality ? "铁制" : "煤炭"]尖端，它将印下[setbranding]。"))
		else
			to_chat(user, span_info("我清除了当前烙印符号。"))
			setbranding = null
	..()

/obj/item/rogueweapon/surgery/cautery/branding/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(!heated)
		return ..()
	if(!length(setbranding))
		to_chat(user, span_warning("没有可烙印的内容，先添加一些标记再使用。"))
		return TRUE
	if(!ishuman(A))
		to_chat(user, span_warning("我无法烙印 [A]."))
		return TRUE
	var/mob/living/carbon/human/target = A
	var/precise_zone = user.zone_selected // We need this up here to stay consistent past the do_after.
	var/body_zone = check_zone(precise_zone) 
	var/obj/item/bodypart/branding_part = target.get_bodypart(body_zone)
	var/branding_self = user == target
	if(!get_location_accessible(target, user.zone_selected))
		to_chat(user, span_warning("那个部位被衣服挡住了"))
		return TRUE

	// Get the area we want to brand, and then prompt the user for what to brand/whether we should brand that zone.
	var/list/zone_options = list()

	if(QDELETED(branding_part) || !istype(branding_part))
		to_chat(user, span_warning("他们没有这个部位……"))
		return TRUE

	// Construct a prompt for zone-specific branding code. If you change any of these strings, make sure they're changed in the switch case later.
	// Yes, I do want the user to always click the button for the selected part. I don't care if there's only 1 available.
	var/covered = FALSE
	var/obj/item/organ/penis/penis
	var/obj/item/organ/vagina/vagina
	var/obj/item/organ/testicles/testes
	var/obj/item/organ/breasts/tits

	switch(precise_zone)
		if(BODY_ZONE_PRECISE_GROIN)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_GROIN))
				zone_options += "Hind"
				penis = target.getorganslot(ORGAN_SLOT_PENIS)
				if(penis && penis.is_visible())
					zone_options += "Dick"
				vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
				if(vagina && vagina.is_visible())
					zone_options += "Vagina"
				testes = target.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testes && testes.is_visible() && testes.ball_size >= DEFAULT_TESTICLES_SIZE) // only allow balls to be branded if average or bigger (slit types have internal balls)
					zone_options += "Testes"
		if(BODY_ZONE_PRECISE_STOMACH)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_STOMACH))
				zone_options += "Stomach"
			else
				covered = TRUE
		if(BODY_ZONE_PRECISE_NECK)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_NECK))
				zone_options += "Neck"
			else
				covered = TRUE
		if(BODY_ZONE_PRECISE_MOUTH)
			if(!target.is_mouth_covered())
				zone_options += "Mouth"
			else
				covered = TRUE

	switch(body_zone)
		if(BODY_ZONE_CHEST)
			if(!length(zone_options) && !covered)
				tits = target.getorganslot(ORGAN_SLOT_BREASTS)
				if(tits && tits.is_visible())
					zone_options += "Breasts"
				zone_options += "Chest"
				if(get_location_accessible(target, BODY_ZONE_PRECISE_STOMACH))
					zone_options += "Stomach"
		if(BODY_ZONE_HEAD)
			if(!length(zone_options) && !covered)
				zone_options += "Head"
				if(!target.is_mouth_covered())
					zone_options += "Mouth"
				if(get_location_accessible(target, BODY_ZONE_PRECISE_NECK))
					zone_options += "Neck"
		if(BODY_ZONE_L_LEG)
			if(istype(branding_part, /obj/item/bodypart/taur))
				zone_options += "Tauric Half"
			else
				zone_options += "Left Leg"
		if(BODY_ZONE_R_LEG)
			if(istype(branding_part, /obj/item/bodypart/taur))
				zone_options += "Tauric Half"
			else
				zone_options += "Right Leg"
		if(BODY_ZONE_L_ARM)
			zone_options += "Left Arm"
		if(BODY_ZONE_R_ARM)
			zone_options += "Right Arm"

	if(length(zone_options))
		zone_options += "Cancel"
	else // failsafe
		if(covered)
			to_chat(user, span_warning("那个部位被遮挡了！"))
		else
			to_chat(user, span_warning("这个部位似乎无法烙印！"))
		return TRUE

	var/branding_text = setbranding // No switcheroos partway through.
	var/final_answer // String. The button the user clicks on when prompted which part to brand.

	// Prompt before do_after
	final_answer = tgui_alert(user, "你想烙印哪个部位？", "请在[DisplayTimeText(10 SECONDS)]内选择！", zone_options, 10 SECONDS)

	if(!final_answer || final_answer == "Cancel")
		return TRUE

	// Reject branding if disallowed by prefs. Doing it here hides less away from the user.
	if(!branding_self)
		switch(final_answer)
			if("Breasts", "Dick", "Vagina", "Testes")
				if(!target.client)
					to_chat(user, span_warning("[target]现在无法在这里接受烙印。"))
					log_combat(user, target, "Branding on offline mob blocked: \"[branding_text]\" on [final_answer]")
					return TRUE
				if(!target.client.prefs?.sensitive_brands)
					to_chat(user, span_warning("[target]已禁用敏感部位烙印。"))
					to_chat(target, span_warning("一次对我[LOWER_TEXT(final_answer)]的烙印尝试被偏好设置阻止了。"))
					log_combat(user, target, "Branding prefblocked: \"[branding_text]\" on [final_answer]")
					return TRUE
			if("Head")
				if(!target.client)
					to_chat(user, span_warning("[target]现在无法在这里接受烙印。"))
					log_combat(user, target, "Branding on offline mob blocked: \"[branding_text]\" on [final_answer]")
					return TRUE
				if(!target.client.prefs?.facial_brands)
					to_chat(user, span_warning("[target]已禁用面部烙印。"))
					to_chat(target, span_warning("一次对我[LOWER_TEXT(final_answer)]的烙印尝试被偏好设置阻止了。"))
					log_combat(user, target, "Branding prefblocked: \"[branding_text]\" on [final_answer]")
					return TRUE

	// A part has been selected, now we start printing messages to chat and showing the do_after
	var/branding_delay = HAS_TRAIT(user, TRAIT_DUNGEONMASTER) ? 7 SECONDS : (HAS_TRAIT(user, TRAIT_KNOWNCRIMINAL) ? 9 SECONDS : 14 SECONDS) // criminals/dungeoneer burn faster, while non-criminals and towners take the longest time
	if(!branding_self) 
		if(branding_low_quality)
			if(!target.compliance)  // we can only brand ourselves OR the other character must be compliant
				to_chat(user, span_warning("[target]动得太厉害了，我无法给[target.p_them()]烙印！"))
				return TRUE
			branding_delay += 3 SECONDS // if they are compliant then there will still be an added delay
		user.visible_message(span_warning("[user]缓缓将[src]移向[target]的[LOWER_TEXT(final_answer)]。"))
		to_chat(target, span_userdanger("[user]正试图在我的[LOWER_TEXT(final_answer)]上烙印！"))
	else
		if(!branding_low_quality)
			branding_delay -= 4 SECONDS // quicker to brand yourself using a good tool
		user.visible_message(span_warning("[user]缓缓将[src]移向[user.p_their()][LOWER_TEXT(final_answer)]。"))

	log_combat(user, target, "Branding attempt: \"[branding_text]\" on [final_answer] ([branding_delay]s)")

	if(!do_after(user, branding_delay, target = target))
		if(!QDELETED(target))
			log_combat(user, target, "Branding aborted: \"[branding_text]\" on [final_answer]")
		return TRUE
	if(!user.Adjacent(target) || user.stat >= UNCONSCIOUS)
		log_combat(user, target, "Branding aborted: \"[branding_text]\" on [final_answer]")
		return TRUE

	if(QDELETED(branding_part))
		log_combat(user, target, "Branding part destroyed: \"[branding_text]\" on [final_answer]")
		return TRUE

	// Attempt to re-get the part and place the brand
	var/description_recoil = target.stat < UNCONSCIOUS ? pick("缩了一下", "扭动了一下", "挣扎了一下", "痛苦不已") : "静静地躺着"
	var/apply_knockdown = TRUE	
	var/apply_message = TRUE
	switch(final_answer)
		if("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Tauric Half")
			if(length(branding_part.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			branding_part.branded_writing = branding_text
			apply_knockdown = FALSE
		if("Hind")
			var/obj/item/bodypart/chest/buttocks = branding_part
			if(length(buttocks.branded_writing_on_buttocks))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			buttocks.branded_writing_on_buttocks = branding_text
		if("Stomach")
			var/obj/item/bodypart/chest/stomach = branding_part
			if(length(stomach.branded_writing_on_stomach))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			stomach.branded_writing_on_stomach = branding_text
		if("Neck")
			var/obj/item/bodypart/head/neck = branding_part
			if(length(neck.branded_writing_on_neck))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			neck.branded_writing_on_neck = branding_text
		if("Breasts")
			if(QDELETED(tits))
				return TRUE
			if(length(tits.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			tits.branded_writing = branding_text
		if("Dick")
			if(QDELETED(penis))
				return TRUE
			if(length(penis.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			penis.branded_writing = branding_text
		if("Vagina")
			if(QDELETED(vagina))
				return TRUE
			if(length(vagina.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			vagina.branded_writing = branding_text
		if("Testes")
			if(QDELETED(testes))
				return TRUE
			if(length(testes.branded_writing))
				to_chat(user, span_warning("我在现有印记上重新烙印。"))
			testes.branded_writing = branding_text
		if("Mouth")
			user.visible_message(span_info("[target][description_recoil]，[src]烙上了[target.p_their()]的嘴唇！烙印留下了难以辨认的灼痕。"))
			target.apply_status_effect(/datum/status_effect/mouth_branded)
			to_chat(target, span_userdanger("你的嘴唇被烧焦了！"))
			apply_message = FALSE
		else // ooooops we forgot to change things here
			to_chat(user, span_warning("烙印这个部位会有问题。"))
			return TRUE

	target.branded = TRUE // makes examine check for branding marks
	target.apply_damage(branding_damage, BURN, branding_part)
	if(!branding_self && apply_knockdown)
		target.Knockdown(1 SECONDS)
	if(apply_message)
		user.visible_message(span_info("[target][description_recoil]，[src]在[target.p_their()]的[LOWER_TEXT(final_answer)]上烙下印记！崭新的烙印显示出[span_boldwarning(branding_text)]。"))
		to_chat(target, span_userdanger("你被烙印了！"))
	
	target.emote(prob(50) ? "painscream" : "scream", forced = TRUE)
	target.Stun(40)
	if(hascall(target, "fullscreen_redflash"))
		call(target, "fullscreen_redflash")("redflash2")
	else
		target.flash_fullscreen("redflash2")
	playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
	update_heated(FALSE)
	if(cool_timer)
		deltimer(cool_timer)
	log_combat(user, target, "Branded successful: \"[branding_text]\" on [final_answer]")
	if(branding_count > 0)
		branding_count--
		if(branding_count == 0)
			to_chat(user, span_warning("\The [src]在你手中断裂了，它坏了！"))
			playsound(user, 'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
	return TRUE

/datum/status_effect/mouth_branded
	id = "mouth_branded"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/mouth_branded

/atom/movable/screen/alert/status_effect/mouth_branded
	name = "烧伤的嘴"
	desc = "我感觉不到我的嘴唇了！"

/datum/status_effect/mouth_branded/on_apply()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
	to_chat(owner, span_warning("我的嘴……烧起来了！"))
	return ..()

/datum/status_effect/mouth_branded/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
	if(owner.stat == CONSCIOUS)
		to_chat(owner, span_userdanger("我几乎又能感觉到嘴唇了。"))

/obj/item/rogueweapon/surgery/hammer
	name = "检查锤"
	desc = "用于检查病人反应并诊断病情的小锤。"
	icon_state = "kneehammer"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 10
	throwforce = 8
	wdefense = 3
	wbalance = -1
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/surgery/hammer/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	if(medskill < SKILL_LEVEL_NOVICE)
		return ..()
	if(ishuman(A))
		if(A == user)
			user.visible_message("<span class='info'>[user]开始用小锤子敲打自己。</span>")
		else
			user.visible_message("<span class='info'>[user]开始用小锤子敲打[A]。</span>")
		if(do_after(user, ((medskill > SKILL_LEVEL_EXPERT) ? 1 SECONDS : 2.5 SECONDS), target = A))
			A.visible_message("<span class='info'>锤击后[A]的膝盖弹跳了一下！</span>")
			if(prob(1))
				playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)
			var/mob/living/carbon/human/human_target = A
			human_target.check_for_injuries(user)
	return ..()

////////////////////
//Improvised Tools//
////////////////////

//All are subtypes of the regular tools with worse behavior success chances.
/obj/item/rogueweapon/surgery/saw/improv
	name = "简易骨锯"
	desc = "用于切骨的粗糙工具。不如真正的骨锯那样顺畅。"
	icon_state = "bonesaw_wood"
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_SAW
	sharpness = IS_BLUNT

/obj/item/rogueweapon/surgery/hemostat/improv
	name = "简易夹具"
	desc = "用于夹持软组织的工具。比金属件差但总比没有好。"
	icon_state = "forceps_wood"
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT

/obj/item/rogueweapon/surgery/retractor/improv
	name = "简易扩张器"
	desc = "一种试探性地撑开组织以进行手术操作的工具。"
	icon_state = "speculum_wood"
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR

/obj/item/rogueweapon/surgery/scalpel/improv
	name = "简易手术刀"
	desc = "粗糙的石刀，能切割但精确度堪忧。"
	icon_state = "scalpel_wood"
	force = 8
	throwforce = 8
	wdefense = 2
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_SCALPEL
	sharpness = IS_SHARP
