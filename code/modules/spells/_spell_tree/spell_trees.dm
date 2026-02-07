#define TALENT_TRAIT "talent"

/datum/talent_node/arcane
	talent_tree_id = "arcane"
	name = "spell"
	desc = "spell"
	icon_state = "prestidigitation"
	var/special = FALSE

/datum/talent_node/arcane/New()
	if(!special && spell_type)
		name = "[spell_type.name] ([talent_cost] Points)"
		desc = spell_type.desc
		if(!desc)
			desc = " "
		icon_state = spell_type.overlay_state

/datum/talent_node/arcane/prestidigitation
	name = "Prestidigitation"
	desc = "Basic arcane attunement. Reduces arcane spell energy cost."
	talent_cost = 0
	node_x = 0
	node_y = 0
	is_passive = TRUE
	special = TRUE
	spell_type = /obj/effect/proc_holder/spell/targeted/touch/prestidigitation

/datum/talent_node/arcane/prestidigitation/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("arcane", 1)
			to_chat(user, span_notice("The mysteries of the Arcane unveil themselves to you."))

/datum/talent_node/arcane/light
	talent_cost = 1
	node_x = 0
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/prestidigitation)
	spell_type = /obj/effect/proc_holder/spell/self/light

/datum/talent_node/arcane/message
	talent_cost = 1
	node_x = 150
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/prestidigitation)
	spell_type = /obj/effect/proc_holder/spell/self/message

/datum/talent_node/arcane/mending
	talent_cost = 1
	node_x = 0
	node_y = 150
	prerequisites = list(/datum/talent_node/arcane/prestidigitation)
	spell_type = /obj/effect/proc_holder/spell/invoked/mending

/datum/talent_node/arcane/create_campfire
	talent_cost = 1
	node_x = -150
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/prestidigitation)
	spell_type = /obj/effect/proc_holder/spell/invoked/create_campfire

/datum/talent_node/arcane/darkvision
	talent_cost = 2
	node_x = -50
	node_y = -220
	prerequisites = list(/datum/talent_node/arcane/light)
	spell_type = /obj/effect/proc_holder/spell/invoked/darkvision

/datum/talent_node/arcane/guidance
	talent_cost = 2
	node_x = 50
	node_y = -220
	prerequisites = list(/datum/talent_node/arcane/light)
	spell_type = /obj/effect/proc_holder/spell/invoked/guidance

/datum/talent_node/arcane/lesserknock
	talent_cost = 2
	node_x = 50
	node_y = 220
	prerequisites = list(/datum/talent_node/arcane/mending)
	spell_type = /obj/effect/proc_holder/spell/targeted/touch/lesserknock

/datum/talent_node/arcane/magicians_brick
	talent_cost = 2
	node_x = -50
	node_y = 220
	prerequisites = list(/datum/talent_node/arcane/mending)
	spell_type = /obj/effect/proc_holder/spell/self/magicians_brick

/datum/talent_node/arcane/fire_fundamentals
	name = "Fire Fundamentals (2 Points)"
	desc = "Attune to flame. Reduces fire spell energy cost."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = -300
	node_y = -100
	prerequisites = list(/datum/talent_node/arcane/create_campfire)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/fire_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("fire", 1)
			to_chat(user, span_notice("The flames dance at your command."))

/datum/talent_node/arcane/spitfire
	talent_cost = 3
	node_x = -400
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/fire_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/spitfire

/datum/talent_node/arcane/rebuke
	talent_cost = 3
	node_x = -400
	node_y = -50
	prerequisites = list(/datum/talent_node/arcane/fire_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/rebuke

/datum/talent_node/arcane/fire_advanced
	name = "Fire Mastery (5 Points)"
	desc = "Master the flames. Further reduces fire spell energy cost and increases fire spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = -500
	node_y = -100
	prerequisites = list(/datum/talent_node/arcane/fire_fundamentals)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/fire_advanced/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("fire", 2)
			to_chat(user, span_notice("Fire bends to your will completely."))

/datum/talent_node/arcane/fireball
	talent_cost = 7
	node_x = -600
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/fire_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/fireball

/datum/talent_node/arcane/greater_fireball
	talent_cost = 10
	node_x = -700
	node_y = -200
	prerequisites = list(/datum/talent_node/arcane/fireball)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater

/datum/talent_node/arcane/meteor_storm
	talent_cost = 12
	node_x = -800
	node_y = -250
	prerequisites = list(/datum/talent_node/arcane/greater_fireball)
	spell_type = /obj/effect/proc_holder/spell/invoked/meteor_storm

/datum/talent_node/arcane/ice_fundamentals
	name = "Ice Fundamentals (2 Points)"
	desc = "Attune to frost. Reduces ice spell energy cost."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = -300
	node_y = 100
	prerequisites = list(/datum/talent_node/arcane/create_campfire)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/ice_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("ice", 1)
			to_chat(user, span_notice("Cold seeps into your very being."))

/datum/talent_node/arcane/frostbolt
	talent_cost = 3
	node_x = -400
	node_y = 150
	prerequisites = list(/datum/talent_node/arcane/ice_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/frostbolt

/datum/talent_node/arcane/ice_advanced
	name = "Ice Mastery (5 Points)"
	desc = "Master the frost. Further reduces ice spell energy cost and increases ice spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = -500
	node_y = 100
	prerequisites = list(/datum/talent_node/arcane/ice_fundamentals)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/ice_advanced/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("ice", 2)
			to_chat(user, span_notice("Ice answers to you alone."))

/datum/talent_node/arcane/snap_freeze
	talent_cost = 8
	node_x = -600
	node_y = 150
	prerequisites = list(/datum/talent_node/arcane/ice_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/snap_freeze

/datum/talent_node/arcane/lightning_fundamentals
	name = "Lightning Fundamentals (2 Points)"
	desc = "Attune to storm. Reduces lightning spell energy cost."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = 0
	node_y = -300
	prerequisites = list(/datum/talent_node/arcane/light)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/lightning_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("lightning", 1)
			to_chat(user, span_notice("Lightning crackles through your veins."))

/datum/talent_node/arcane/lightningbolt
	talent_cost = 3
	node_x = 0
	node_y = -400
	prerequisites = list(/datum/talent_node/arcane/lightning_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt

/datum/talent_node/arcane/lightning_advanced
	name = "Lightning Mastery (5 Points)"
	desc = "Master the storm. Further reduces lightning spell energy cost and increases lightning spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = 0
	node_y = -500
	prerequisites = list(/datum/talent_node/arcane/lightning_fundamentals)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/lightning_advanced/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("lightning", 2)
			to_chat(user, span_notice("The fury of storms courses through you."))

/datum/talent_node/arcane/thunderstrike
	talent_cost = 8
	node_x = -100
	node_y = -600
	prerequisites = list(/datum/talent_node/arcane/lightning_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/thunderstrike

/datum/talent_node/arcane/sundering_lightning
	talent_cost = 11
	node_x = 100
	node_y = -600
	prerequisites = list(/datum/talent_node/arcane/lightning_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/sundering_lightning

/datum/talent_node/arcane/arcane_fundamentals
	name = "Arcane Fundamentals (2 Points)"
	desc = "Strengthen arcane forces. Reduces arcane spell energy cost."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = 300
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/message)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/arcane_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("arcane", 1)
			to_chat(user, span_notice("Arcane forces bend to your focus."))

/datum/talent_node/arcane/arcynebolt
	talent_cost = 3
	node_x = 400
	node_y = -100
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt

/datum/talent_node/arcane/blade_burst
	talent_cost = 3
	node_x = 400
	node_y = 100
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/blade_burst

/datum/talent_node/arcane/fetch
	talent_cost = 2
	node_x = 500
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/fetch

/datum/talent_node/arcane/repel
	talent_cost = 2
	node_x = 500
	node_y = 150
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/repel

/datum/talent_node/arcane/forcewall
	talent_cost = 3
	node_x = 600
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/forcewall

/datum/talent_node/arcane/repulse
	talent_cost = 3
	node_x = 600
	node_y = 150
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/repulse

/datum/talent_node/arcane/nondetection
	talent_cost = 1
	node_x = 400
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/targeted/touch/nondetection

/datum/talent_node/arcane/mindlink
	talent_cost = 4
	node_x = 500
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/mindlink

/datum/talent_node/arcane/arcane_advanced
	name = "Arcane Mastery (5 Points)"
	desc = "Master arcane forces. Further reduces arcane spell energy cost and increases arcane spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = 500
	node_y = -50
	prerequisites = list(/datum/talent_node/arcane/arcane_fundamentals)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/arcane_advanced/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("arcane", 2)
			to_chat(user, span_notice("Arcane power flows through you completely."))

/datum/talent_node/arcane/greater_forcewall
	talent_cost = 5
	node_x = 700
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/forcewall)
	spell_type = /obj/effect/proc_holder/spell/invoked/forcewall/greater

/datum/talent_node/arcane/arcyne_prison
	talent_cost = 8
	node_x = 800
	node_y = -150
	prerequisites = list(/datum/talent_node/arcane/greater_forcewall)
	spell_type = /obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison

/datum/talent_node/arcane/counterspell
	talent_cost = 4
	node_x = 600
	node_y = 0
	prerequisites = list(/datum/talent_node/arcane/arcane_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/counterspell

/datum/talent_node/arcane/conjuration_fundamentals
	name = "Conjuration Fundamentals (2 Points)"
	desc = "Attune to summoning."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = 0
	node_y = 300
	prerequisites = list(/datum/talent_node/arcane/mending)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/conjuration_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("conjuration", 1)
			to_chat(user, span_notice("Reality bends to summon your will."))

/datum/talent_node/arcane/conjure_weapon
	talent_cost = 2
	node_x = -100
	node_y = 400
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/conjure_weapon

/datum/talent_node/arcane/enchant_weapon
	talent_cost = 3
	node_x = -100
	node_y = 500
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/enchant_weapon

/datum/talent_node/arcane/conjure_armor
	talent_cost = 2
	node_x = 100
	node_y = 400
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/self/conjure_armor

/datum/talent_node/arcane/conjure_dragonhide
	talent_cost = 4
	node_x = 100
	node_y = 500
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/self/conjure_armor/dragonhide

/datum/talent_node/arcane/findfamiliar
	talent_cost = 2
	node_x = 0
	node_y = 400
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/self/findfamiliar

/datum/talent_node/arcane/conjure_primordial
	talent_cost = 8
	node_x = 0
	node_y = 500
	prerequisites = list(/datum/talent_node/arcane/conjuration_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/conjure_primordial

/datum/talent_node/arcane/transmutation_fundamentals
	name = "Transmutation Fundamentals (2 Points)"
	desc = "Attune to change."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = 210
	node_y = 210
	prerequisites = list(/datum/talent_node/arcane/mending)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/transmutation_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("transmutation", 1)
			to_chat(user, span_notice("Reality shifts at your touch."))

/datum/talent_node/arcane/featherfall
	talent_cost = 2
	node_x = 280
	node_y = 280
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/featherfall

/datum/talent_node/arcane/leap
	talent_cost = 2
	node_x = 350
	node_y = 210
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/leap

/datum/talent_node/arcane/blink
	talent_cost = 3
	node_x = 420
	node_y = 280
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/blink

/datum/talent_node/arcane/longstrider
	talent_cost = 2
	node_x = 280
	node_y = 140
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/longstrider

/datum/talent_node/arcane/haste
	talent_cost = 4
	node_x = 350
	node_y = 140
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/haste

/datum/talent_node/arcane/enlarge
	talent_cost = 2
	node_x = 140
	node_y = 280
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/enlarge

/datum/talent_node/arcane/aerosolize
	talent_cost = 3
	node_x = 210
	node_y = 350
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/aerosolize

/datum/talent_node/arcane/acidsplash
	talent_cost = 3
	node_x = 350
	node_y = 350
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/acidsplash

/datum/talent_node/arcane/transmutation_advanced
	name = "Transmutation Mastery (5 Points)"
	desc = "Master transmutation. Further reduces transmutation spell energy cost and increases transmutation spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = 280
	node_y = 420
	prerequisites = list(/datum/talent_node/arcane/transmutation_fundamentals)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/transmutation_advanced/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("transmutation", 2)
			to_chat(user, span_notice("Reality reshapes at your whim."))

/datum/talent_node/arcane/recall
	talent_cost = 8
	node_x = 420
	node_y = 420
	prerequisites = list(/datum/talent_node/arcane/transmutation_advanced)
	spell_type = /obj/effect/proc_holder/spell/self/recall

/datum/talent_node/arcane/illusion_fundamentals
	name = "Illusion Fundamentals (2 Points)"
	desc = "Attune to deception."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = -210
	node_y = 210
	prerequisites = list(/datum/talent_node/arcane/create_campfire)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/illusion_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("illusion", 1)
			to_chat(user, span_notice("Reality bends to your perception."))

/datum/talent_node/arcane/mirror_transform
	talent_cost = 1
	node_x = -280
	node_y = 140
	prerequisites = list(/datum/talent_node/arcane/prestidigitation)
	spell_type = /obj/effect/proc_holder/spell/invoked/mirror_transform

/datum/talent_node/arcane/invisibility
	talent_cost = 2
	node_x = -280
	node_y = 280
	prerequisites = list(/datum/talent_node/arcane/illusion_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/invisibility

/datum/talent_node/arcane/enhancement_fundamentals
	name = "Enhancement Fundamentals (2 Points)"
	desc = "Attune to empowerment."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = 210
	node_y = -210
	prerequisites = list(/datum/talent_node/arcane/light)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/enhancement_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("enhancement", 1)
			to_chat(user, span_notice("Power surges through your being."))

/datum/talent_node/arcane/fortitude
	talent_cost = 3
	node_x = 280
	node_y = -280
	prerequisites = list(/datum/talent_node/arcane/enhancement_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/fortitude

/datum/talent_node/arcane/stoneskin
	talent_cost = 3
	node_x = 350
	node_y = -350
	prerequisites = list(/datum/talent_node/arcane/enhancement_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/stoneskin

/datum/talent_node/arcane/hawks_eyes
	talent_cost = 2
	node_x = 350
	node_y = -210
	prerequisites = list(/datum/talent_node/arcane/enhancement_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/hawks_eyes

/datum/talent_node/arcane/giants_strength
	talent_cost = 4
	node_x = 280
	node_y = -140
	prerequisites = list(/datum/talent_node/arcane/enhancement_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/giants_strength

/datum/talent_node/arcane/binding_fundamentals
	name = "Binding Fundamentals (2 Points)"
	desc = "Attune to restraint."
	icon_state = "spell_default"
	talent_cost = 2
	node_x = -210
	node_y = -210
	prerequisites = list(/datum/talent_node/arcane/create_campfire)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/binding_fundamentals/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("binding", 1)
			to_chat(user, span_notice("Ethereal chains form at your will."))

/datum/talent_node/arcane/ensnare
	talent_cost = 4
	node_x = -280
	node_y = -280
	prerequisites = list(/datum/talent_node/arcane/binding_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/ensnare

/datum/talent_node/arcane/gravity_control
	talent_cost = 3
	node_x = -350
	node_y = -210
	prerequisites = list(/datum/talent_node/arcane/binding_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/gravity

/datum/talent_node/arcane/arcyne_affinity_t1
	name = "Arcyne Affinity I (10 Points)"
	desc = "Your connection to the arcyne deepens."
	icon_state = "spell_default"
	talent_cost = 10
	node_x = -400
	node_y = 400
	prerequisites = list()
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/arcyne_affinity_t1/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		ADD_TRAIT(user, TRAIT_ARCYNE_T2, TALENT_TRAIT)
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T1))
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T1, TALENT_TRAIT)
		to_chat(user, span_notice("The arcyne flows more freely through you."))

/datum/talent_node/arcane/arcyne_affinity_t2
	name = "Arcyne Affinity II (20 Points)"
	desc = "Your mastery of the arcyne grows stronger."
	icon_state = "spell_default"
	talent_cost = 20
	node_x = -400
	node_y = 500
	prerequisites = list(/datum/talent_node/arcane/arcyne_affinity_t1)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/arcyne_affinity_t2/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		ADD_TRAIT(user, TRAIT_ARCYNE_T3, TALENT_TRAIT)
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T2))
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T2, TALENT_TRAIT)
		to_chat(user, span_notice("The arcyne resonates powerfully within your being."))

/datum/talent_node/arcane/arcyne_affinity_t3
	name = "Arcyne Affinity III (40 Points)"
	desc = "You have become one with the arcyne."
	icon_state = "spell_default"
	talent_cost = 40
	node_x = -400
	node_y = 600
	prerequisites = list(/datum/talent_node/arcane/arcyne_affinity_t2)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/arcane/arcyne_affinity_t3/on_talent_learned(mob/user)
	..()
	if(ishuman(user))
		ADD_TRAIT(user, TRAIT_ARCYNE_T4, TALENT_TRAIT)
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T3))
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T3, TALENT_TRAIT)
		to_chat(user, span_notice("The arcyne bends to your will as an extension of yourself."))

/datum/talent_tree/arcane
	name = "Arcane Magic"
	desc = "Master the fundamental forces of magic"
	tree_identifier = "arcane"
	tree_nodes = list(
		/datum/talent_node/arcane/prestidigitation,
		/datum/talent_node/arcane/arcyne_affinity_t1,
		/datum/talent_node/arcane/arcyne_affinity_t2,
		/datum/talent_node/arcane/arcyne_affinity_t3,
		/datum/talent_node/arcane/light,
		/datum/talent_node/arcane/message,
		/datum/talent_node/arcane/mending,
		/datum/talent_node/arcane/create_campfire,
		/datum/talent_node/arcane/darkvision,
		/datum/talent_node/arcane/guidance,
		/datum/talent_node/arcane/lesserknock,
		/datum/talent_node/arcane/magicians_brick,
		/datum/talent_node/arcane/fire_fundamentals,
		/datum/talent_node/arcane/fire_advanced,
		/datum/talent_node/arcane/spitfire,
		/datum/talent_node/arcane/rebuke,
		/datum/talent_node/arcane/fireball,
		/datum/talent_node/arcane/greater_fireball,
		/datum/talent_node/arcane/meteor_storm,
		/datum/talent_node/arcane/ice_fundamentals,
		/datum/talent_node/arcane/ice_advanced,
		/datum/talent_node/arcane/frostbolt,
		/datum/talent_node/arcane/snap_freeze,
		/datum/talent_node/arcane/lightning_fundamentals,
		/datum/talent_node/arcane/lightning_advanced,
		/datum/talent_node/arcane/lightningbolt,
		/datum/talent_node/arcane/thunderstrike,
		/datum/talent_node/arcane/sundering_lightning,
		/datum/talent_node/arcane/arcane_fundamentals,
		/datum/talent_node/arcane/arcane_advanced,
		/datum/talent_node/arcane/arcynebolt,
		/datum/talent_node/arcane/blade_burst,
		/datum/talent_node/arcane/fetch,
		/datum/talent_node/arcane/repel,
		/datum/talent_node/arcane/repulse,
		/datum/talent_node/arcane/forcewall,
		/datum/talent_node/arcane/greater_forcewall,
		/datum/talent_node/arcane/arcyne_prison,
		/datum/talent_node/arcane/counterspell,
		/datum/talent_node/arcane/nondetection,
		/datum/talent_node/arcane/mindlink,
		/datum/talent_node/arcane/conjuration_fundamentals,
		/datum/talent_node/arcane/conjure_weapon,
		/datum/talent_node/arcane/enchant_weapon,
		/datum/talent_node/arcane/conjure_armor,
		/datum/talent_node/arcane/conjure_dragonhide,
		/datum/talent_node/arcane/findfamiliar,
		/datum/talent_node/arcane/conjure_primordial,
		/datum/talent_node/arcane/transmutation_fundamentals,
		/datum/talent_node/arcane/transmutation_advanced,
		/datum/talent_node/arcane/featherfall,
		/datum/talent_node/arcane/longstrider,
		/datum/talent_node/arcane/haste,
		/datum/talent_node/arcane/leap,
		/datum/talent_node/arcane/blink,
		/datum/talent_node/arcane/recall,
		/datum/talent_node/arcane/enlarge,
		/datum/talent_node/arcane/aerosolize,
		/datum/talent_node/arcane/acidsplash,
		/datum/talent_node/arcane/illusion_fundamentals,
		/datum/talent_node/arcane/invisibility,
		/datum/talent_node/arcane/mirror_transform,
		/datum/talent_node/arcane/enhancement_fundamentals,
		/datum/talent_node/arcane/fortitude,
		/datum/talent_node/arcane/stoneskin,
		/datum/talent_node/arcane/hawks_eyes,
		/datum/talent_node/arcane/giants_strength,
		/datum/talent_node/arcane/binding_fundamentals,
		/datum/talent_node/arcane/ensnare,
		/datum/talent_node/arcane/gravity_control
	)

/datum/talent_node/necromancy
	talent_tree_id = "necromancy"
	name = "spell"
	desc = "spell"
	icon_state = "prestidigitation"
	var/special = FALSE

/datum/talent_node/necromancy/New()
	if(!special && spell_type)
		name = "[spell_type.name] ([talent_cost] Points)"
		desc = spell_type.desc
		if(!desc)
			desc = " "
		icon_state = spell_type.overlay_state

/datum/talent_node/necromancy/necromancy_fundamentals
	name = "Necromancy Fundamentals"
	desc = "Learn the basics of necromantic magic. Reduces necromancy spell energy cost."
	icon_state = "spell_default"
	talent_cost = 0
	node_x = 0
	node_y = 0
	is_passive = TRUE

/datum/talent_node/necromancy/necromancy_fundamentals/on_talent_learned(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("necromancy", 1)
			to_chat(user, span_notice("The void whispers Her secrets."))

/datum/talent_node/necromancy/ray_of_sickness
	talent_cost = 2
	node_x = -80
	node_y = -80
	prerequisites = list(/datum/talent_node/necromancy/necromancy_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/projectile/sickness

/datum/talent_node/necromancy/silence
	talent_cost = 3
	node_x = 80
	node_y = -80
	prerequisites = list(/datum/talent_node/necromancy/necromancy_fundamentals)
	spell_type = /obj/effect/proc_holder/spell/invoked/silence

/datum/talent_node/necromancy/wither
	talent_cost = 3
	node_x = -120
	node_y = -160
	prerequisites = list(/datum/talent_node/necromancy/ray_of_sickness)
	spell_type = /obj/effect/proc_holder/spell/invoked/wither

/datum/talent_node/necromancy/necromancy_advanced
	name = "Necromancy Mastery (5 Points)"
	desc = "Master the dark arts. Further reduces necromancy spell energy cost and increases necromancy spell damage."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = 0
	node_y = -160
	prerequisites = list(/datum/talent_node/necromancy/ray_of_sickness, /datum/talent_node/necromancy/silence)
	is_passive = TRUE

/datum/talent_node/necromancy/necromancy_advanced/on_talent_learned(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.set_spell_mastery("necromancy", 2)
			to_chat(user, span_notice("Before you, is eternity. Her gaze is upon you."))

/datum/talent_node/necromancy/raise_deadite
	talent_cost = 3
	node_x = -80
	node_y = -240
	prerequisites = list(/datum/talent_node/necromancy/wither, /datum/talent_node/necromancy/necromancy_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/raise_deadite

/datum/talent_node/necromancy/eyebite
	talent_cost = 3
	node_x = 80
	node_y = -240
	prerequisites = list(/datum/talent_node/necromancy/necromancy_advanced)
	spell_type = /obj/effect/proc_holder/spell/invoked/eyebite

/datum/talent_node/necromancy/bonechill
	talent_cost = 3
	node_x = 0
	node_y = -320
	prerequisites = list(/datum/talent_node/necromancy/raise_deadite, /datum/talent_node/necromancy/eyebite)
	spell_type = /obj/effect/proc_holder/spell/invoked/bonechill

/datum/talent_node/necromancy/undead_dominion
	name = "Undead Dominion (5 Points)"
	desc = "Command, tame, and mark allies for your undead servants. Grants Command Undead, Gravemark, and Tame Undead."
	icon_state = "spell_default"
	talent_cost = 5
	node_x = 0
	node_y = -400
	prerequisites = list(/datum/talent_node/necromancy/bonechill)
	is_passive = TRUE
	special = TRUE

/datum/talent_node/necromancy/undead_dominion/on_talent_learned(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_guard)
			to_chat(user, span_notice("She lends you Her forces to bend to your will."))

/datum/talent_node/necromancy/tame_undead
	talent_cost = 2
	node_x = -80
	node_y = -480
	prerequisites = list(/datum/talent_node/necromancy/undead_dominion)
	spell_type = /obj/effect/proc_holder/spell/invoked/tame_undead

/datum/talent_node/necromancy/raise_undead_formation
	talent_cost = 6
	node_x = 80
	node_y = -480
	prerequisites = list(/datum/talent_node/necromancy/undead_dominion)
	spell_type = /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer

/datum/talent_tree/necromancy
	name = "Necromancy"
	desc = "Seek eternity in Her name"
	tree_identifier = "necromancy"
	max_talent_points = 100
	tree_nodes = list(
		/datum/talent_node/necromancy/necromancy_fundamentals,
		/datum/talent_node/necromancy/necromancy_advanced,
		/datum/talent_node/necromancy/ray_of_sickness,
		/datum/talent_node/necromancy/silence,
		/datum/talent_node/necromancy/wither,
		/datum/talent_node/necromancy/bonechill,
		/datum/talent_node/necromancy/eyebite,
		/datum/talent_node/necromancy/raise_deadite,
		/datum/talent_node/necromancy/undead_dominion,
		/datum/talent_node/necromancy/tame_undead,
		/datum/talent_node/necromancy/raise_undead_formation
	)
