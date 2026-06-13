#define MAGIC_ARCHERY_GLOW_COLOR "#8edcff"
#define MAGIC_QUIVER_FILTER "magic_quiver_outline"
#define MAGIC_ARROW_FILTER "magic_arrow_outline"

/obj/item/quiver/magic
	name = "魔法箭袋"
	desc = "一只被奥术余辉环绕的箭袋。穿戴在身上时，箭袋里的魔力会在心中凝出无尽魔矢与回收魔矢的咒式。"
	var/datum/weakref/spellbearer_ref
	var/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/granted_spell
	var/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted/granted_recycle_spell

/obj/item/quiver/magic/Initialize(mapload)
	. = ..()
	// 复用原版箭袋贴图，只额外加一圈淡蓝色描边，避免改动原始资源。
	add_filter(MAGIC_QUIVER_FILTER, 2, list("type" = "outline", "color" = MAGIC_ARCHERY_GLOW_COLOR, "alpha" = 150, "size" = 1))

/obj/item/quiver/magic/Destroy()
	clear_magic_quiver_spells()
	remove_filter(MAGIC_QUIVER_FILTER)
	return ..()

/obj/item/quiver/magic/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!ishuman(user))
		return
	// 只有真正穿戴到腰部或背部时才授予法术，拿在手上不会生效。
	if(slot_flags & slotdefine2slotbit(slot))
		grant_magic_quiver_spells(user)
	else
		clear_magic_quiver_spells(user)

/obj/item/quiver/magic/dropped(mob/user, silent = FALSE)
	. = ..()
	clear_magic_quiver_spells(user)

/obj/item/quiver/magic/proc/find_granted_spell_instance(mob/living/carbon/human/holder, spell_type)
	if(!holder?.mind)
		return null
	for(var/obj/effect/proc_holder/spell/self/spell_instance as anything in holder.mind.spell_list)
		if(spell_instance.type != spell_type)
			continue
		if(istype(spell_instance, /obj/effect/proc_holder/spell/self/endless_magic_arrows/granted))
			var/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/endless_spell = spell_instance
			if(endless_spell.get_source_quiver() == src)
				return spell_instance
			continue
		if(istype(spell_instance, /obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted))
			var/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted/recycle_spell = spell_instance
			if(recycle_spell.get_source_quiver() == src)
				return spell_instance
	return null

/obj/item/quiver/magic/proc/remove_granted_spell_instance(mob/living/carbon/human/holder, obj/effect/proc_holder/spell/self/spell_instance, spell_type)
	if(!holder?.mind)
		return

	var/obj/effect/proc_holder/spell/self/spell_to_remove = spell_instance
	if(!spell_to_remove || !(spell_to_remove in holder.mind.spell_list))
		spell_to_remove = find_granted_spell_instance(holder, spell_type)
	if(!spell_to_remove)
		return

	holder.mind.spell_list -= spell_to_remove
	qdel(spell_to_remove)

/obj/item/quiver/magic/proc/grant_magic_quiver_spells(mob/living/carbon/human/holder)
	if(!holder?.mind)
		return

	var/mob/living/carbon/human/previous_holder = spellbearer_ref?.resolve()
	if(previous_holder && previous_holder != holder)
		clear_magic_quiver_spells(previous_holder)

	granted_spell = find_granted_spell_instance(holder, /obj/effect/proc_holder/spell/self/endless_magic_arrows/granted)
	granted_recycle_spell = find_granted_spell_instance(holder, /obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted)
	if(!granted_spell)
		// 若持有者已经学会基础版无尽魔矢，则不再额外授予一份同效果法术，避免出现重复按钮。
		if(holder.mind.has_spell(/obj/effect/proc_holder/spell/self/endless_magic_arrows, TRUE))
			spellbearer_ref = WEAKREF(holder)
		else
			granted_spell = new /obj/effect/proc_holder/spell/self/endless_magic_arrows/granted
			granted_spell.bind_source_quiver(src)
			holder.mind.AddSpell(granted_spell, holder)

	if(!granted_recycle_spell)
		granted_recycle_spell = new /obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted
		granted_recycle_spell.bind_source_quiver(src)
		holder.mind.AddSpell(granted_recycle_spell, holder)

	if(previous_holder != holder)
		to_chat(holder, span_notice("魔法箭袋贴着我的身侧微微发热，两道与魔矢有关的术式同时浮现在脑海中。"))

	spellbearer_ref = WEAKREF(holder)

/obj/item/quiver/magic/proc/clear_magic_quiver_spells(mob/living/carbon/human/holder_override)
	var/mob/living/carbon/human/holder = holder_override
	if(!holder)
		holder = spellbearer_ref?.resolve()
	if(!holder?.mind)
		granted_spell = null
		granted_recycle_spell = null
		spellbearer_ref = null
		return

	remove_granted_spell_instance(holder, granted_spell, /obj/effect/proc_holder/spell/self/endless_magic_arrows/granted)
	remove_granted_spell_instance(holder, granted_recycle_spell, /obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted)
	if(holder_override && holder_override == holder)
		to_chat(holder, span_notice("离开魔法箭袋后，那两道与魔矢有关的术式也随之沉寂。"))

	granted_spell = null
	granted_recycle_spell = null
	spellbearer_ref = null

/obj/item/ammo_casing/caseless/rogue/arrow/magic
	name = "魔矢"
	desc = "由淡蓝奥术凝成的箭矢。它沿用普通箭矢的形体，却在箭身四周漾着细微的冷光。"
	projectile_type = /obj/projectile/bullet/reusable/arrow/magic
	force = 7
	var/magic_arrow_group_id

/obj/item/ammo_casing/caseless/rogue/arrow/magic/proc/bind_magic_group(group_id)
	magic_arrow_group_id = group_id

/obj/item/ammo_casing/caseless/rogue/arrow/magic/Initialize(mapload)
	. = ..()
	// 复用原版箭矢贴图，仅用描边强调这是魔法箭矢。
	add_filter(MAGIC_ARROW_FILTER, 2, list("type" = "outline", "color" = MAGIC_ARCHERY_GLOW_COLOR, "alpha" = 170, "size" = 1))
	QDEL_IN(src, 1 MINUTES)

/obj/item/ammo_casing/caseless/rogue/arrow/magic/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	. = ..()
	if(istype(BB, /obj/projectile/bullet/reusable/arrow/magic))
		var/obj/projectile/bullet/reusable/arrow/magic/magic_projectile = BB
		magic_projectile.bind_magic_group(magic_arrow_group_id)

/obj/item/ammo_casing/caseless/rogue/arrow/magic/Destroy()
	remove_filter(MAGIC_ARROW_FILTER)
	magic_arrow_group_id = null
	return ..()

/obj/projectile/bullet/reusable/arrow/magic
	name = "魔矢"
	damage = 13
	damage_type = BURN
	armor_penetration = 10
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/magic
	embedchance = 0
	woundclass = BCLASS_BURN
	flag = "magic"
	var/magic_arrow_group_id

/obj/projectile/bullet/reusable/arrow/magic/proc/bind_magic_group(group_id)
	magic_arrow_group_id = group_id

/obj/projectile/bullet/reusable/arrow/magic/proc/apply_magic_group(obj/item/ammo_casing/caseless/rogue/arrow/magic/dropped_arrow)
	if(!dropped_arrow)
		return
	dropped_arrow.bind_magic_group(magic_arrow_group_id)

/obj/projectile/bullet/reusable/arrow/magic/handle_drop()
	if(has_dropped)
		return dropped
	has_dropped = TRUE
	if(dropped)
		dropped.forceMove(get_turf(src))
	else
		var/turf/T = get_turf(src)
		dropped = new ammo_type(T)
	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/dropped_arrow = dropped
	apply_magic_group(dropped_arrow)
	return dropped

/obj/projectile/bullet/reusable/arrow/magic/on_hit(atom/target, blocked = FALSE)
	dropped = new ammo_type(src)
	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/dropped_arrow = dropped
	apply_magic_group(dropped_arrow)
	return ..()

#undef MAGIC_ARCHERY_GLOW_COLOR
#undef MAGIC_QUIVER_FILTER
#undef MAGIC_ARROW_FILTER
