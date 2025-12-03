/obj/item
	var/list/alchemy_effects = list()
	var/filling_color = "#d4c5a9"
	var/list/tastes
	
/obj/item/alch
	name = "dust"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE	

/obj/item/alch/Initialize()
	. = ..()

/obj/item/alch/examine(mob/user)
	. = ..()
	if(user.mind)
		var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
		var/perint = 0
		if(isliving(user))
			var/mob/living/lmob = user
			perint = FLOOR((lmob.STAPER + lmob.STAINT)/2,1)
			// Show alchemy effect smells based on skill level
			if(alchemy_effects && alchemy_effects.len)
				if(alch_skill >= SKILL_LEVEL_NOVICE || perint >= 6)
					var/effect_count = 0
					for(var/effect in alchemy_effects)
						effect_count++
						var/smell = get_effect_smell(effect)
						// Show effects based on skill - higher skill reveals more
						if(effect_count == 1 && (alch_skill >= SKILL_LEVEL_NOVICE || perint >= 6))
							. += span_notice(" Smells strongly of [smell].")
						else if(effect_count == 2 && (alch_skill >= SKILL_LEVEL_APPRENTICE || perint >= 10))
							. += span_notice(" Also smells of [smell].")
						else if(effect_count >= 3 && (alch_skill >= SKILL_LEVEL_JOURNEYMAN || perint >= 13))
							. += span_notice(" Faintly smells of [smell].")
						else if(effect_count >= 4 && (alch_skill >= SKILL_LEVEL_MASTER || perint >= 17))
							. += span_notice(" Subtley smells of [smell].")
/obj/item/alch/viscera
	name = "viscera"
	icon_state = "viscera"

/obj/item/alch/waterdust
	name = "water essentia"
	icon_state = "water_runedust"

/obj/item/alch/bonemeal
	name = "bone meal"
	icon_state = "bonemeal"

/obj/item/alch/seeddust
	name = "seed dust"
	icon_state = "seeddust"

/obj/item/alch/runedust
	name = "raw essentia"
	icon_state = "runedust"

/obj/item/alch/coaldust
	name = "coal dust"
	icon_state = "coaldust"

/obj/item/alch/silverdust
	name = "silver dust"
	icon_state = "silverdust"
	is_silver = TRUE

/obj/item/alch/magicdust
	name = "pure essentia"
	icon_state = "magic_runedust"

/obj/item/alch/firedust
	name = "fire essentia"
	icon_state = "fire_runedust"

/obj/item/alch/sinew
	name = "sinew"
	icon_state = "sinew"
	dropshrink = 0.9

/obj/item/alch/irondust
	name = "iron dust"
	icon_state = "irondust"

/obj/item/alch/airdust
	name = "air essentia"
	icon_state = "air_runedust"

/obj/item/alch/swampdust
	name = "swampweed dust"
	icon_state = "swampdust"

/obj/item/alch/tobaccodust
	name = "westleach dust"
	icon_state = "tobaccodust"

/obj/item/alch/earthdust
	name = "earth essentia"
	icon_state = "earth_runedust"

/obj/item/alch/bone
	name = "tail bone"
	icon_state = "bone"
	desc = "The only bone in creachers with alchemical properties."
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64

/obj/item/alch/horn
	name = "troll horn"
	icon_state = "horn"
	desc = "The horn of a bog troll."
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 64
	grid_height = 64

/obj/item/alch/golddust
	name = "gold dust"
	icon_state = "golddust"
/obj/item/alch/feaudust
	name = "feau dust"
	icon_state = "feaudust"

/obj/item/alch/ozium
	name = "alchemical ozium"
	desc = "Alchemical processing has left it unfit for consumption."
	icon_state = "darkredpowder"

/obj/item/alch/transisdust
	name = "sui dust"
	desc = "A long mix of herbs resulting in a special dust. For you. Use it while held."
	icon_state = "transisdust"

/obj/item/alch/transisdust/attack_self(mob/living/user)
	..()

	if(alert("Do you wish to change your self?", "Dust of Self", "Yes", "No") != "Yes")
		return
	user.visible_message(
		span_warn("[user] begins to use [src]."),
		span_warn("I begin to apply [src] on myself.")
	)
	if(!do_after(user, 5 SECONDS))
		return

	var/p_input = input(user, "Choose your character's pronouns", "Pronouns") as null|anything in GLOB.pronouns_list
	if(p_input)
		user.pronouns = p_input
	if(alert("Do you wish to change your frame?", "Body Type", "Yes", "No") == "Yes")
		user.gender = "male" ? "female" : "male"

	if(!do_after(user, 5 SECONDS))
		return

	user.regenerate_icons()
	to_chat(user, span_notice("Tis' complete."))
	qdel(src)

/obj/item/alch/puresalt
	name = "purified salts"
	desc = "Salts that have been finely sifted to enchance their healing properties and to bolster its connection to the arcyne."
	icon_state = "puresalt"

/obj/item/alch/mineraldust
	name = "mineral dusts"
	desc = "Elements of gems ground and sifted of impurities to help draw out its useful alchemical minerals."
	icon_state = "mineraldust"

/obj/item/alch/infernaldust
	name = "infernal dust"
	desc = "The remains of an abyssal tether to this plane, banished or slain. Best handled with gloves."
	icon_state = "infernaldust"

/obj/item/alch/solardust
	name = "solar dust"
	desc = "A pinch of Astrata worked into radiant matter. Looking at it hurts your eyes."
	icon_state = "solardust"

/obj/item/alch/berrypowder
	name = "berry powder"
	desc = "Berries ground and dried into a soft fragrant powder."
	icon_state = "berrypowder"

//BEGIN THE HERBS

/obj/item/alch/atropa
	name = "atropa"
	icon_state = "atropa"
	alchemy_effects = list(EFFECT_DAMAGE_TOX, EFFECT_DRAIN_STAMINA, EFFECT_WEAKNESS, EFFECT_PARALYZE)

/obj/item/alch/matricaria
	name = "matricaria"
	icon_state = "matricaria"
	alchemy_effects = list(EFFECT_DAMAGE_TOX, EFFECT_WEAKEN_SPEED, EFFECT_WEAKNESS, EFFECT_NAUSEA)

/obj/item/alch/symphitum
	name = "symphitum"
	icon_state = "symphitum"
	alchemy_effects = list(EFFECT_HEAL_BRUTE, EFFECT_HEAL_BURN, EFFECT_RESTORE_BLOOD, EFFECT_WEAKNESS)

/obj/item/alch/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum"
	alchemy_effects = list(EFFECT_HEAL_TOX, EFFECT_RESTORE_STAMINA, EFFECT_FORTIFY_CONSTITUTION, EFFECT_WEAKNESS)

/obj/item/alch/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia"
	alchemy_effects = list(EFFECT_FORTIFY_PERCEPTION, EFFECT_HEAL_TOX, EFFECT_FORTIFY_LUCK, EFFECT_BLINDNESS)

/obj/item/alch/paris
	name = "paris"
	icon_state = "paris"
	alchemy_effects = list(EFFECT_DRAIN_STAMINA, EFFECT_DAMAGE_TOX, EFFECT_PARALYZE, EFFECT_SILENCE)

/obj/item/alch/calendula
	name = "calendula"
	icon_state = "calendula"
	alchemy_effects = list(EFFECT_HEAL_BRUTE, EFFECT_FORTIFY_ENDURANCE, EFFECT_RESTORE_BLOOD, EFFECT_DRAIN_STAMINA)

/obj/item/alch/mentha
	name = "mentha"
	icon_state = "mentha"
	alchemy_effects = list(EFFECT_FORTIFY_PERCEPTION, EFFECT_FORTIFY_INTELLIGENCE, EFFECT_RESTORE_STAMINA, EFFECT_WEAKEN_SPEED)

/obj/item/alch/urtica
	name = "urtica"
	icon_state = "urtica"
	alchemy_effects = list(EFFECT_HEAL_BURN, EFFECT_RESTORE_MANA, EFFECT_FORTIFY_ENDURANCE, EFFECT_DAMAGE_TOX)

/obj/item/alch/salvia
	name = "salvia"
	icon_state = "salvia"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet
	alchemy_effects = list(EFFECT_RESTORE_BLOOD, EFFECT_RESTORE_STAMINA, EFFECT_HEAL_BRUTE, EFFECT_DRAIN_STAMINA)

/obj/item/alch/hypericum
	name = "hypericum"
	icon_state = "hypericum"
	alchemy_effects = list(EFFECT_FORTIFY_STRENGTH, EFFECT_FORTIFY_CONSTITUTION, EFFECT_RESTORE_BLOOD, EFFECT_WEAKNESS)

/obj/item/alch/benedictus
	name = "benedictus"
	icon_state = "benedictus"
	alchemy_effects = list(EFFECT_RESTORE_STAMINA, EFFECT_RESTORE_MANA, EFFECT_FORTIFY_CONSTITUTION, EFFECT_WEAKEN_SPEED)

/obj/item/alch/valeriana
	name = "valeriana"
	icon_state = "valeriana"
	alchemy_effects = list(EFFECT_FORTIFY_LUCK, EFFECT_FORTIFY_ENDURANCE, EFFECT_HEAL_TOX, EFFECT_NAUSEA)

/obj/item/alch/artemisia
	name = "artemisia"
	icon_state = "artemisia"
	alchemy_effects = list(EFFECT_FORTIFY_INTELLIGENCE, EFFECT_FORTIFY_SPEED, EFFECT_RESTORE_MANA, EFFECT_DRAIN_MANA)

/obj/item/alch/manabloompowder
	name = "manabloom powder"
	icon_state = "bluepowder"

/obj/item/alch/manabloompowder
	name = "manabloom powder"
	icon_state = "bluepowder"

/obj/item/alch/rosa
	name = "rosa"
	icon_state = "rosa"
	item_state = "rosa"
	desc = "It is said that these were white - until Graggar bled on its fields."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	muteinmouth = FALSE
	alternate_worn_layer  = 8.9 //On top of helmet
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	alchemy_effects = list(EFFECT_HEAL_BURN, EFFECT_RESTORE_BLOOD, EFFECT_FORTIFY_CONSTITUTION, EFFECT_WEAKNESS)

/obj/item/alch/rosa/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_MOUTH)
		icon_state = "rosa_mouth"
		user.update_inv_mouth()
	else
		icon_state = "rosa"
		user.update_icon()

//dust mix crafting
/datum/crafting_recipe/roguetown/alch/feaudust
	name = "feau dust"
	result = list(/obj/item/alch/feaudust,
				/obj/item/alch/feaudust)
	reqs = list(/obj/item/alch/irondust = 2,
				/obj/item/alch/golddust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0

/datum/crafting_recipe/roguetown/alch/magicdust
	name = "pure essentia"
	result = list(/obj/item/alch/magicdust)
	reqs = list(/obj/item/alch/waterdust = 1, /obj/item/alch/firedust = 1,
				/obj/item/alch/airdust = 1, /obj/item/alch/earthdust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
