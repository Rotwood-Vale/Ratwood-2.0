/obj/item/rogueweapon/greatsword/moonlight_greatsword
	name = "月光大剑"
	desc = "过去背叛同胞的“无鳞”古龙 - 白龙希斯，其尾巴化成的武器。稀少的龙武器之一。为魔法始祖希斯的魔力结晶，那股力量能化为月光波动释放出来。"
	icon = 'modular_z121/assets/weapons/frostgreatsword.dmi'
	icon_state = "frostgreatsword"
	force = 18
	force_wielded = 30
	max_integrity = 400
	max_blade_int = 400
	wdefense = 6
	minstr = 10
	light_system = MOVABLE_LIGHT
	light_power = 3
	light_outer_range = 3
	light_on = FALSE
	light_color = "#6ecfff"
	smeltresult = null
	sellprice = 250
	var/moonlight_active = FALSE
	var/moonlight_prompt_sent = FALSE
	var/datum/weakref/spellbearer_ref
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave/granted_wave_spell
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing/granted_blessing_spell

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/get_moonlight_base_icon_state()
	return moonlight_active ? "frostgreatsword_active" : "frostgreatsword"

/obj/item/rogueweapon/greatsword/moonlight_greatsword/update_icon()
	icon_state = "[get_moonlight_base_icon_state()][wielded ? "1" : ""]"
	return ..()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	update_moonlight_state()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/Destroy()
	clear_moonlight_spells()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/process()
	update_moonlight_state()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/is_moonlight_night()
	return GLOB.tod == "night"

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/get_moonlight_holder()
	if(!ishuman(loc))
		return null
	var/mob/living/carbon/human/H = loc
	if(H.get_active_held_item() == src || H.get_inactive_held_item() == src)
		return H
	return null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/find_moonlight_spell_instance(mob/living/carbon/human/holder, spell_type)
	if(!holder?.mind)
		return null
	for(var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell as anything in holder.mind.spell_list)
		if(spell.type != spell_type)
			continue
		if(spell.get_source_weapon() == src)
			return spell
	return null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/remove_moonlight_spell_instance(mob/living/carbon/human/holder, obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell_instance, spell_type)
	if(!holder?.mind)
		return
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell_to_remove = spell_instance
	if(!spell_to_remove || !(spell_to_remove in holder.mind.spell_list) || spell_to_remove.get_source_weapon() != src)
		spell_to_remove = find_moonlight_spell_instance(holder, spell_type)
	if(!spell_to_remove)
		return
	holder.mind.spell_list -= spell_to_remove
	qdel(spell_to_remove)

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/clear_moonlight_spells(mob/living/carbon/human/holder_override)
	var/mob/living/carbon/human/holder = holder_override
	if(!holder)
		holder = spellbearer_ref?.resolve()
	if(holder?.mind)
		remove_moonlight_spell_instance(holder, granted_wave_spell, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave)
		remove_moonlight_spell_instance(holder, granted_blessing_spell, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing)
	if(holder_override && holder_override == holder)
		to_chat(holder_override, span_notice("月光大剑中的秘术重新归于沉寂。"))
	granted_wave_spell = null
	granted_blessing_spell = null
	spellbearer_ref = null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/sync_moonlight_spells()
	var/mob/living/carbon/human/current_holder = get_moonlight_holder()
	var/mob/living/carbon/human/previous_holder = spellbearer_ref?.resolve()

	if(previous_holder && previous_holder != current_holder)
		clear_moonlight_spells(previous_holder)

	if(!moonlight_active || !current_holder?.mind)
		if(previous_holder == current_holder && previous_holder)
			clear_moonlight_spells(previous_holder)
		return

	granted_wave_spell = find_moonlight_spell_instance(current_holder, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave)
	granted_blessing_spell = find_moonlight_spell_instance(current_holder, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing)

	if(!granted_wave_spell && !current_holder.mind.has_spell(/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave))
		granted_wave_spell = new /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave(src)
		current_holder.mind.AddSpell(granted_wave_spell, current_holder)
	if(!granted_blessing_spell && !current_holder.mind.has_spell(/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing))
		granted_blessing_spell = new /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing(src)
		current_holder.mind.AddSpell(granted_blessing_spell, current_holder)

	if(previous_holder != current_holder)
		to_chat(current_holder, span_notice("月色沿着剑身流淌，两道古老的月光秘术在我心中浮现。"))
	spellbearer_ref = WEAKREF(current_holder)

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/update_moonlight_state()
	var/should_be_active = is_moonlight_night()
	var/was_active = moonlight_active
	var/mob/living/carbon/human/holder = get_moonlight_holder()

	if(should_be_active)
		moonlight_active = TRUE
		force = 26
		force_wielded = 40
		obj_integrity = max_integrity
		blade_int = max_blade_int
		if(obj_broken)
			obj_fix()
			obj_integrity = max_integrity
			blade_int = max_blade_int
		if(holder)
			set_light_range(3, 3)
			set_light_power(3)
			set_light_color("#6ecfff")
			set_light_on(TRUE)
		else
			set_light_on(FALSE)
		if(!was_active)
			moonlight_prompt_sent = FALSE
	else
		moonlight_active = FALSE
		force = 18
		force_wielded = 30
		set_light_on(FALSE)
		moonlight_prompt_sent = FALSE

	update_icon()

	sync_moonlight_spells()

	if(moonlight_active && !moonlight_prompt_sent)
		if(holder)
			to_chat(holder, span_notice("月光大剑似乎在吸收月光的力量，剑身愈发明亮。"))
			moonlight_prompt_sent = TRUE
