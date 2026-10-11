/obj/effect/proc_holder/spell/self/conjure_armor/dragonhide
	name = "Conjure Dragonhide"
	desc = "Conjure a Dragonhide Barrier. Blocks magical projectiles and fire.\n\
	It blocks two spells before it shatters."
	overlay_state = "conjure_dragonhide"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 90 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 4 // upgrade on ring, + firestack immunity pretty dang good.
	spell_tier = 2 // Spellblade tier.

	invocations = list("Equitare Draconis") // google translate latin 'ride the dragon' - If someone literate wants to change this, feel free to.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM

	ward_type = /datum/status_effect/buff/projectile_ward/dragonhide

/datum/status_effect/buff/projectile_ward/dragonhide
	id = "dragonscaled"
	alert_type = /atom/movable/screen/alert/status_effect/buff/projectile_ward/dragonhide
	examine_text = "<font color='red'>SUBJECTPRONOUN is covered in ashy scales!</font>"
	integrity = 2
	blocks_magic = TRUE
	outline_colour = "#c23d09"

/atom/movable/screen/alert/status_effect/buff/projectile_ward/dragonhide
	name = "Dragonhide"
	desc = "Flames dance at my heels, yet do not sting!"

/datum/status_effect/buff/projectile_ward/dragonhide/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)

/datum/status_effect/buff/projectile_ward/dragonhide/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	return ..()
