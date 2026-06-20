/mob/living/simple_animal/cockroach
	name = "蟑螂"
	desc = ""
	icon_state = "cockroach"
	icon_dead = "cockroach"
	health = 1
	maxHealth = 1
	turns_per_move = 5
	loot = list(/obj/effect/decal/cleanable/insectguts)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	response_disarm_continuous = "驱赶了"
	response_disarm_simple = "驱赶"
	response_harm_continuous = "拍扁了"
	response_harm_simple = "拍扁"
	speak_emote = list("唧唧叫")
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "唧唧叫"
	verb_ask = "好奇地唧唧叫"
	verb_exclaim = "大声地唧唧叫"
	verb_yell = "大声地唧唧叫"
	var/squish_chance = 50
	del_on_death = 1

/mob/living/simple_animal/cockroach/death(gibbed)
	..()

/mob/living/simple_animal/cockroach/Crossed(atom/movable/AM)
	if(ismob(AM))
		if(isliving(AM))
			var/mob/living/A = AM
			if(A.mob_size > MOB_SIZE_SMALL && !(A.movement_type & FLYING))
				if(prob(squish_chance))
					if(ishuman(A))
						var/mob/living/carbon/human/H = A
						if(HAS_TRAIT(H, TRAIT_PACIFISM))
							H.visible_message(span_notice("[src]躲开了碾压。"), span_warning("我避开碾压了[src]！"))
							return
					A.visible_message(span_notice("[A]踩扁了[src]。"), span_notice("我踩扁了[src]。"))
					adjustBruteLoss(1) //kills a normal cockroach
				else
					visible_message(span_notice("[src]躲开了碾压。"))
	else
		if(isstructure(AM))
			if(prob(squish_chance))
				AM.visible_message(span_notice("[src]被[AM]压扁了。"))
				adjustBruteLoss(1)
			else
				visible_message(span_notice("[src]躲开了碾压。"))

/mob/living/simple_animal/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return
