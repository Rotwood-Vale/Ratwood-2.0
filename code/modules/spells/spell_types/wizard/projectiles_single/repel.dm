/obj/effect/proc_holder/spell/invoked/projectile/repel
	name = "Repel"
	desc = "Shoot out a magical bolt that pushes out the target struck away from the caster, or throw something held in the caster's hand if toss intent is enabled - this gains 20% extra damage per rank in the associated skill. Only skilled practitioners can use this spell while being grabbed."
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/repel
	overlay_state = ""
	sound = list('sound/magic/unmagnet.ogg')
	active = FALSE
	releasedrain = 7
	chargedrain = 0
	chargetime = 0
	recharge_time = 15 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	overlay_state = "fetch"
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Exmoveo!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW
	cost = 2 // Same as fetch, make it discounted to account for being less useful
	xp_gain = TRUE

/obj/projectile/magic/repel
	name = "bolt of repeling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	range = 15

/obj/effect/proc_holder/spell/invoked/projectile/repel/cast_check(skipcharge, mob/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if (human_user && human_user.pulledby != null && human_user.get_skill_level(associated_skill) < 5)
			to_chat(human_user, span_warning("You can't make the proper hand movements while being grabbed! Despair!"))
			return FALSE

/obj/effect/proc_holder/spell/invoked/projectile/repel/cast(list/targets, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/proj = H.get_active_held_item()
		if(isobj(proj))
			var/obj/I = proj
			if(I && H.in_throw_mode)
				var/atom/throw_target = get_edge_target_turf(H, get_dir(user,get_step(user,user.dir)))
				if(throw_target)
					H.dropItemToGround(I)
					if(I)	//In case it's something that gets qdel'd on drop
						I.throwforce *= 1 + (H.get_skill_level(associated_skill) * (0.20)) // 20% extra throwforce per skill rank, 120% at rank 6
						I.throw_at(throw_target, 7, 4)
						H.throw_mode_off()
						charge_counter = (recharge_time / 3) * 2 // immediately refund 66% of the cooldown if we're using the spell to throw something, makes it match other damage spells
						I.throwforce = initial(I.throwforce)
						return TRUE // cancel out so we don't also fire the repel projectile at the same time
	. = ..()

/obj/projectile/magic/repel/on_hit(target)

	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target)) //ill be real I got no idea why this worked.
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
		L.throw_at(throw_target, 7, 4)
		new /datum/magic_throw_slip_watcher(L)
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_edge_target_turf(firer, get_dir(firer, target))
			I.throw_at(throw_target, 7, 4)
