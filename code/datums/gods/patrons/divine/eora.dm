/datum/patron/divine/eora
	name = "Eora"
	domain = "爱、家庭、美丽"
	desc = "炉边夫人赐福于我们的爱情，不问那爱究竟献给谁。婚姻不过是 Astrata 的暴政侵入 Eora 领域的体现。她的追随者往往风流多情，尤其是吟游诗人。"
	worshippers = "恋人、溺爱子女的父母、吟游诗人、无可救药的浪漫主义者"
	virtues = "怜悯、美丽、艺术"
	sins = "冷漠、纵欲、施虐"
	mob_traits = list(TRAIT_EMPATH, TRAIT_EXTEROCEPTION)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/massage				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/eora_blessing			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bless_food            = CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/summon_bed			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bud					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heartweave			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/eoracurse				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/pomegranate			= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/eora		= CLERIC_T4,
	)
	confess_lines = list(
		"EORA 让我们相聚！",
		"即便在这苦难之中，她的美也依旧存在！",
		"哪怕你冒犯了我，我依然爱你！",
	)
	traits_tier = list(TRAIT_EORAN_CALM = CLERIC_T0, TRAIT_EORAN_SERENE = CLERIC_T2)
	storyteller = /datum/storyteller/eora

// Near a psycross, by an eoran sacred tree, inside the church, at the eoran shrine, holding poppy flowers, or has pacifism trait
/datum/patron/divine/eora/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的十字架打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer near eoran sacred tree
	for(var/obj/structure/eoran_pomegranate_tree in view(4, get_turf(follower)))
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer at the eoran shrine
	if(istype(get_area(follower), /area/rogue/outdoors/rtfield/eora))
		return TRUE
	// Allows Eorans to pray using flowers
	var/obj/item/held_item = follower.get_active_held_item()
	if(istype(held_item, /obj/item/reagent_containers/food/snacks/grown/rogue/poppy))
		qdel(held_item)
		return TRUE
	// Allows player to pray while wearing eoran bud.
	if(HAS_TRAIT(follower, TRAIT_EORAN_CONTENTED))
		return TRUE
	to_chat(follower, span_danger("若想让 Eora 听见我的祈祷，我必须在教堂内、psycross 附近向她献上罂粟花，或将她祝福过的花佩戴在头上……"))
	return FALSE

/datum/patron/divine/eora/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("爱的光辉在[target]周围绽放开来！")
	*message_self = span_notice("爱的温暖充盈着我，抚平了我的伤痛！")

	var/bonus = 0

	if(HAS_TRAIT(target, TRAIT_PACIFISM))
		bonus += 2.5

	if(HAS_TRAIT(user, TRAIT_EORAN_CONTENTED))
		bonus += 1.5

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE
