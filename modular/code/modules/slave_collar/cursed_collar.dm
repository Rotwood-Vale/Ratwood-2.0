/obj/item/clothing/neck/roguetown/cursed_collar
	name = "诅咒项圈"
	always_show_examine_link = TRUE
	desc = "一只镶着红宝石饰钉、外观阴森的项圈，似乎正散发着黑暗能量。 \n看起来你得让别人帮忙才能把它取下来。"
	// Credit regarding sprites to Necbro
	// https://github.com/StoneHedgeSS13/StoneHedge/commit/9ddc09d4cb91903beff6d523c91aef75312d5163
	icon = 'modular_stonehedge/icons/clothing/armor/neck.dmi'
	mob_overlay_icon = 'modular_stonehedge/icons/clothing/armor/onmob/neck.dmi'
	icon_state = "cursed_collar"
	item_state = "cursed_collar"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	resistance_flags = INDESTRUCTIBLE
	leashable = TRUE
	var/mob/living/carbon/human/victim = null
	var/datum/mind/collar_master = null
	var/silenced = FALSE
	var/applying = FALSE
	/// Round-persistent counter for non-self ejaculation events received by the current wearer.
	var/received_cum_count = 0

/obj/item/clothing/neck/roguetown/cursed_collar/examine(mob/user)
	. = ..()
	if(received_cum_count == 1)
		. += span_notice("项圈的金属表面刻着1道划痕。")
	else if(received_cum_count > 1)
		. += span_notice("项圈的金属表面刻着[received_cum_count]道划痕。")

/obj/item/clothing/neck/roguetown/cursed_collar/proc/record_nonself_ejaculation(mob/living/carbon/human/source, mob/living/carbon/human/wearer)
	if(!source || !wearer)
		return FALSE
	if(source == wearer)
		return FALSE
	if(loc != wearer)
		return FALSE
	var/added = get_tally_increment_for_source(source)
	received_cum_count += added
	var/tally_msg = added == 1 ? "短暂传来一阵金属刮擦声，[wearer]的项圈上突然多出了一道划痕。" : "短暂传来一阵金属刮擦声，[wearer]的项圈上突然多出了两道划痕。"
	for(var/mob/M in viewers(1, wearer))
		to_chat(M, span_notice(tally_msg))
	return TRUE

/obj/item/clothing/neck/roguetown/cursed_collar/proc/get_tally_increment_for_source(mob/living/carbon/human/source)
	return tally_increment_for_ejaculation_source(source)

/obj/item/clothing/neck/roguetown/cursed_collar/proc/reset_received_cum_count()
	received_cum_count = 0

/obj/item/clothing/neck/roguetown/cursed_collar/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()

	if(!target.client?.prefs?.cursed_collarable)
		to_chat(user, span_warning("[target]的脖子上已经戴着东西了！"))
		return

	if(target.get_item_by_slot(SLOT_NECK))
		to_chat(user, span_warning("[target] is already wearing something around their neck!"))
		return

	var/obj/item/chastity/existing_chastity = target.chastity_device
	if(istype(existing_chastity) && existing_chastity.chastity_cursed)
		to_chat(user, span_warning("[target]已经被诅咒贞操装置束缚了。"))
		return

	var/datum/mind/master_mind = collar_master
	if(!master_mind)
		master_mind = user?.mind
		collar_master = master_mind
	if(!master_mind)
		to_chat(user, span_warning("这只项圈拒绝在没有烙印主人的情况下进行绑定。"))
		return

	if(applying)
		return

	var/surrender_mod = 1
	if(target.surrendering || target.compliance)
		surrender_mod = 0.5

	applying = TRUE
	if(!do_mob(user, target, 50 * surrender_mod))
		applying = FALSE
		return

	if(tgui_alert(target, "Submit to the collar's control?", "Cursed Collar", list("Yes!", "No")) != "Yes!")
		user.visible_message(span_warning("[target] resists the collar's control."))
		to_chat(target, span_warning("Your defiant will prevents the collar from binding to you!"))
		applying = FALSE
		return

	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

	// Get or create collar master datum first
	var/datum/component/collar_master/CM = master_mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		CM = master_mind.AddComponent(/datum/component/collar_master)

	// Try to equip
	if(!target.equip_to_slot_if_possible(src, SLOT_NECK, TRUE, TRUE))
		to_chat(user, span_warning("你没能把项圈锁在[target]的脖子上！"))
		applying = FALSE
		return

	// Add pet to the master's list before sending collar signals
	if(!CM.add_pet(target))
		to_chat(user, span_warning("项圈未能绑定[target]。"))
		target.dropItemToGround(src, force = TRUE)
		applying = FALSE
		return

	SEND_SIGNAL(target, COMSIG_CARBON_COLLAR_BOUND, collar_master, src)
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	log_combat(user, target, "tried to collar", addition="with [src]")
	applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/attack_self(mob/user)
	. = ..()
	if(!user?.mind)
		return
	if(tgui_alert(user, "要成为这只项圈的主人吗？", "诅咒项圈", list("是", "否")) != "是")
		return
	var/datum/component/collar_master/CM = user.mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		user.mind.AddComponent(/datum/component/collar_master)
	collar_master = user.mind
	to_chat(user, span_userdanger("你感觉这只项圈烙印下了你的意志。"))


/obj/item/clothing/neck/roguetown/cursed_collar/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != SLOT_NECK)
		return

	if(applying)
		return

	if(!collar_master)
		return

	// Defer one tick so equip state is fully settled before prompt/lock logic.
	addtimer(CALLBACK(src, PROC_REF(handle_equip), user), 0.1 SECONDS)

/obj/item/clothing/neck/roguetown/cursed_collar/proc/handle_equip(mob/living/carbon/human/user)
	if(istype(user, /mob/living/carbon/human/dummy))
		return

	if(user?.mind && collar_master && user.mind == collar_master)
		to_chat(user, span_warning("这只项圈拒绝自我束缚。它必须由另一位主人为你戴上。"))
		user.dropItemToGround(src, force = TRUE)
		return

	if(!user.mind)
		user.visible_message(span_warning("[src]没能锁在[user]的脖子上。"))
		user.dropItemToGround(src, force = TRUE)
		return

	var/obj/item/chastity/existing_chastity = user.chastity_device
	if(istype(existing_chastity) && existing_chastity.chastity_cursed)
		to_chat(user, span_warning("这只项圈对已束缚着你的诅咒贞操装置产生了排斥。"))
		user.dropItemToGround(src, force = TRUE)
		return

	if(SEND_SIGNAL(user, COMSIG_CARBON_COLLAR_BIND_ATTEMPT, collar_master, src) & COMPONENT_COLLAR_BIND_BLOCK)
		to_chat(user, span_warning("这只项圈此刻拒绝完成绑定。"))
		user.dropItemToGround(src, force = TRUE)
		return

	if(tgui_alert(user, "要向这只项圈的控制屈服吗？", "诅咒项圈", list("是！", "否")) != "是！")
		user.visible_message(span_warning("[user]抗拒了项圈的控制。"))
		to_chat(user, span_warning("你反抗的意志阻止了项圈绑定到你身上！"))
		user.dropItemToGround(src, force = TRUE)
		return

	var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master)
	if(!CM)
		CM = collar_master.AddComponent(/datum/component/collar_master)
	if(!CM || !CM.add_pet(user))
		to_chat(user, span_warning("项圈未能绑定到你身上。"))
		user.dropItemToGround(src, force = TRUE)
		return

	SEND_SIGNAL(user, COMSIG_CARBON_COLLAR_BOUND, collar_master, src)
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	user.visible_message(span_warning("[user]脖子上的诅咒项圈咔哒一声锁死了！"), \
							span_userdanger("你脖子上的诅咒项圈咔哒一声锁死了！"))
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

	// Only send the gain signal once master is set
	addtimer(CALLBACK(src, PROC_REF(send_collar_signal), user), 2)

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	reset_received_cum_count()
	if(!user)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)

	// Use the stored collar_master reference directly instead of iterating the entire global list.
	// This avoids an O(n) scan over all active masters on every collar drop.
	if(collar_master)
		var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master)
		if(CM && (user in CM.my_pets))
			CM.remove_pet(user)

	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/cursed_collar/canStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	// Some strip call sites may not pass owner; infer from loc when possible.
	if(!owner && ishuman(loc))
		owner = loc

	if(stripper?.mind == collar_master)
		return TRUE

	return ..()

/obj/item/clothing/neck/roguetown/cursed_collar/doStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	if(!owner && ishuman(loc))
		owner = loc

	if(stripper?.mind == collar_master)
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		if(owner)
			SEND_SIGNAL(owner, COMSIG_CARBON_LOSE_COLLAR)
		return owner ? owner.dropItemToGround(src, force = TRUE) : FALSE

	return ..()

/obj/item/clothing/neck/roguetown/cursed_collar/proc/send_collar_signal(mob/living/carbon/human/user)
	if(!collar_master) // Don't send signal if no master
		SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_GAIN_COLLAR, src)
