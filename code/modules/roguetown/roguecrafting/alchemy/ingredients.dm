

/obj/item/alch
	name = "dust"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.75

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


/obj/item/alch/blessedseedpowder
	name = "blessed seed powder"
	desc = "Luminous seed dust prepared with sanctified water. Dendor's touch lingers within it."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	color = "#BFFFC4"


/obj/item/alch/blessedseedpowder/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("blessedseed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/alch/blessedseedpowder/Destroy()
	remove_filter("blessedseed_glow")
	return ..()

//==============================================================================
// Harvest Bloomstone — ritual reward from Cat 9 Harvest Bloomstone rite.
// Functions as a 20-use blessed seed powder when held during Bless Crops.
// Each use (qdel call from blesscrop) decrements charges instead of destroying it.
// When all 20 charges are spent, the stone shatters and leaves stone dust.
//==============================================================================
/obj/item/alch/bloomstone
	name = "harvest bloomstone"
	desc = "A smooth stone suffused with the Treefather's living power. When held during while using the Bless Crops miracle it functions like blessed seed powder and spends a charge instead of being consumed — good for twenty uses before it shatters."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "cutgem_shell"
	color = "#228B22"
	var/charges = 20

/obj/item/alch/bloomstone/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#73c47a")
	add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))

/obj/item/alch/bloomstone/examine(mob/user)
	. = ..()
	. += span_info("It has [charges] charge\s remaining.")

/obj/item/alch/bloomstone/Destroy(force=FALSE)
	if(force)
		charges = 0
	remove_filter("bloomstone_glow")
	charges--
	if(charges > 0)
		// Stone survives this use; re-apply glow and stay alive.
		add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))
		return QDEL_HINT_LETMELIVE // <---- DO NOT EVER EVER EVER EVER EVER EVER EVER EVER EVER DO THIS
	// All charges spent — shatter into stone dust.
	new /obj/item/alch/stonedust(get_turf(src))
	if(loc && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, span_warning("The Harvest Bloomstone's light gutters and the stone crumbles to dust in my hand!"))
	return ..()

/obj/item/alch/runedust
	name = "raw essentia"
	icon_state = "runedust"


/obj/item/alch/coaldust
	name = "coal dust"
	icon_state = "coaldust"


/obj/item/alch/stonedust
	name = "stone dust"
	desc = "Finely ground mineral dust used for glass clay refinement."
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
	desc = "Salts that have been finely sifted to enhance their healing properties and to bolster their connection to the arcyne."
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


/obj/item/alch/matricaria
	name = "matricaria"
	icon_state = "matricaria"


/obj/item/alch/symphitum
	name = "symphitum"
	icon_state = "symphitum"


/obj/item/alch/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum"


/obj/item/alch/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia"


/obj/item/alch/paris
	name = "paris"
	icon_state = "paris"


/obj/item/alch/calendula
	name = "calendula"
	icon_state = "calendula"


/obj/item/alch/mentha
	name = "mentha"
	icon_state = "mentha"


/obj/item/alch/urtica
	name = "urtica"
	icon_state = "urtica"


/obj/item/alch/salvia
	name = "salvia"
	icon_state = "salvia"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet


/obj/item/alch/hypericum
	name = "hypericum"
	icon_state = "hypericum"


/obj/item/alch/benedictus
	name = "benedictus"
	icon_state = "benedictus"


/obj/item/alch/valeriana
	name = "valeriana"
	icon_state = "valeriana"


/obj/item/alch/artemisia
	name = "artemisia"
	icon_state = "artemisia"


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
