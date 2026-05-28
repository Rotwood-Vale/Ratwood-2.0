// T1: (fires a bone splinter at a target; fires a significantly stronger bone lance if holding bones)

/datum/action/cooldown/spell/projectile/bone_splinter
	name = "Bone Splinter"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "profane"
	cast_range = 8
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/bone/splinter
	invocation_type = INVOCATION_NONE
	primary_resource_cost = 30
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 15
	cooldown_time = 10 SECONDS
	miracle = TRUE

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/projectile/bone/splinter
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	var/embed_prob = 10

/datum/action/cooldown/spell/projectile/bone_splinter/fire_projectile(atom/target)
	var/obj/item/held_item = owner.get_active_held_item()
	var/big_cast = FALSE
	if(istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if(bonez.use(1))
			projectile_type = /obj/projectile/bone/splinter/major
			big_cast = TRUE
	else if(istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/bone/splinter/major
		big_cast = TRUE

	. = ..()

	if(big_cast)
		owner.visible_message(span_danger("[owner] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl a vicious lance of bone at [target]!"))
	else
		owner.visible_message(span_danger("[owner] swings their arm in a wide arc, hurling a splinter of bone towards [target]!"), span_notice("I fling a shard of profaned bone at [target]!"))

	projectile_type = initial(projectile_type)

/obj/projectile/bone/splinter/on_hit(atom/target, blocked)
	. = ..()
	if(iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src] crumbles into dust..."))
	qdel(src)

/datum/action/cooldown/spell/projectile/bone_splinter
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 15
	associated_skill = /datum/skill/magic/holy
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 30

/obj/projectile/bone/splinter/major
	name = "profaned bone lance"
	damage = 35
	embed_prob = 30
