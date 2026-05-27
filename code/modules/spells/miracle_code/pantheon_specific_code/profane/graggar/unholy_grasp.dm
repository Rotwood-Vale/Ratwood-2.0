//T2: Unholy Grasp - Throws disappearing net made of viscera at enemy. Creates blood on impact.
/obj/effect/proc_holder/spell/invoked/projectile/unholy_grasp
	name = "Unholy Grasp"
	desc = "Unleashes a snare of external blood and guts. The viscera winds around the legs of mortals... \
	Though has little effect on simple creatures. Mortals cannot remove the net, but it decays ten seconds after landing."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_grab"
	miracle = TRUE
	devotion_cost = 50
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeascendant // this should stand out on a gaggar guy
	releasedrain = 20
	chargedrain = 0
	chargetime = 15
	recharge_time = 40 SECONDS // no running, super slow. this FUCKS people. lower it if 40 is too much.
	invocation_type = "shout"
	invocations = list("BE STILL!!") // VERY loud. do NOT add other invocations, this projectile can FUUUCK people up and needs to be telegraphed.
	sound = 'sound/magic/blood_net.ogg'
	range = 8

/obj/projectile/magic/unholy_grasp
	name = "visceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 8 // you can dodge it, see speed. lower if need be.
	speed = 1.6
	hitsound = 'sound/magic/slimesquish.ogg'

/obj/projectile/magic/unholy_grasp/on_hit(target)
	. = ..()
	if(!iscarbon(target))
		return
	if(target)
		ensnare(target)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	carbon.visible_message(span_warning("[src] ensnares [carbon] around their legs in a horrid cacophany of blood and guts!"), span_warning("I AM ENCAPTURED BY BLOOD AND GUTS! THERES A NET ON MY LEGS!"))
	carbon.apply_status_effect(/datum/status_effect/debuff/netted/vile)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)
