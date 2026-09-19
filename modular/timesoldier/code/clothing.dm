// TEMPERANCE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/timesoldier/shared/uniform // ts just a padded gamby 🥀
	name = "soldier's uniform"
	desc = "<span class='yellow'><i>I still remember when I first put this old tattered thing on. It has been with me for about fifteen yils now. Back then, it was slightly too big for me, but now it fits me just right.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "uniform"
	item_state = "uniform"
	shiftable = FALSE



/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor // hauberk reskin, except stronger since it's light.
	name = "fabricated armor"
	desc = "<span class='yellow'><i>Once the Engineers of the Guild of Craft finally figured out how to make cheap, easily made armor in their autosmithy, this became the norm for most of us.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "EB_armor"
	item_state = "EB_armor"
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor/Initialize(mapload)
	. = ..()
	var/datum/component/item_equipped_movement_rustle/rustle = GetComponent(/datum/component/item_equipped_movement_rustle)
	if(rustle)
		rustle.rustle_sounds = list(
			'modular/timesoldier/sounds/gear1.ogg',
			'modular/timesoldier/sounds/gear2.ogg',
			'modular/timesoldier/sounds/gear3.ogg',
			'modular/timesoldier/sounds/gear4.ogg'
		)

/obj/item/clothing/mask/rogue/facemask/steel/confessor/timesoldier/temperance/redmask // Confessor mask reskin!
	name = "Otavais Gas Mask"
	desc = "<span class='yellow'><i>The Otavans were ingenious, they've had their own masks for decades, and only recently allow us 'peasants' to have the schematics. When the Zizites started using Zizo Bane Gas Belchers and other nasty things, these were issued as standard equipment to everyone. <br>These masks are normally fitted with some steel plates for extra protection.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "redmask"
	item_state = "redmask"
	flags_inv = HIDEFACE|HIDESNOUT|HIDEFACIALHAIR

/obj/item/clothing/head/roguetown/veiled/timesoldier/temperance/veil // Nurse's veil reskin. though for some reason it's more fancy than I thought so I have to neuter some detail tags
	name = "death's shroud"
	desc = "<span class='yellow'><i>Originally, this was given to us by Pestran Plague-monks a few yils ago. A blessing for the 'marksmen', it helped us deal with the stench of decay, though, over time, the mask lost its actual functionality.<br>I'm used to the smell of death, anyway.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "veil"
	item_state = "veil"
	detail_tag = null
	altdetail_tag = null

/obj/item/clothing/cloak/poncho/timesoldier/temperance/poncho
	name = "poncho"
	desc = "<span class='yellow'><i>I once sat in a trench for over two daes. In the same spot, overlooking the same area. The only things that kept me alive were my copiettes, and this nifty thing.<br>Though, it didn't stop the rous bites.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "poncho_s"
	item_state = "poncho_s"

/obj/item/clothing/shoes/roguetown/boots/footwraps/padded/timesoldier/temperance/boots //reskinned padded footwraps
	name = "padded boots"
	desc = "<span class='yellow'><i>Although they're uncomfortable, I've grown to like my boots. Tight, but not too tight, they loosen up after standing in mud for weeks on end.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "EB_boots_wrapped"
	item_state = "EB_boots_wrapped"

// INTERWARFARE. A loving love letter to Sparrow, and Matt. Thank you for making such an amazing project.

/obj/item/clothing/suit/roguetown/armor/leather/studded/timesoldier/interwar/armorvest
	name = "armor vest"
	desc = "<span class='yellow'><i>Steel plates in a canvas carrier. It was never comfortable, but it caught shrapnel.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprite/warfare_onmob.dmi'
	icon_state = "armorvest_world"
	item_state = "armorvest_world"
	color = null

/obj/item/clothing/cloak/raincloak/timesoldier/interwar/sniper
	name = "sniper's cloak"
	desc = "<span class='yellow'><i>Dark cloth breaks up my outline and keeps the mud off my back.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/warfare_onmob.dmi'
	icon_state = "sniperworld1"
	item_state = "sniperworld1"
	color = null
	sleeved = null
	sleevetype = null
	hoodtype = /obj/item/clothing/head/hooded/rainhood/timesoldier/interwar/sniper

/obj/item/clothing/head/hooded/rainhood/timesoldier/interwar/sniper
	name = "sniper's hood"
	desc = "<span class='yellow'><i>You know, I always hated rain.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/warfare_onmob.dmi'
	icon_state = "sniperworld2"
	item_state = "sniperworld2"
	color = null

/obj/item/clothing/mask/rogue/physician/timesoldier/interwar/sniper
	name = "sniper's mask"
	desc = "<span class='yellow'><i>It keeps the worst of the smoke and rot out.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "snipermaskworld"
	item_state = "snipermaskworld"
	color = null

/obj/item/clothing/shoes/roguetown/boots/timesoldier/interwar
	name = "soldier's boots"
	desc = "<span class='yellow'><i>Mud has worked into every seam.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "redbootsworld"
	item_state = "redbootsworld"
	color = null

/obj/item/storage/belt/rogue/leather/timesoldier/interwar/medical
	name = "medical belt"
	desc = "<span class='yellow'><i>Bandages, tinctures, whatever still fits.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "redmedicalbelt"
	item_state = "redmedicalbelt"
	color = null

/obj/item/clothing/gloves/roguetown/leather/timesoldier/interwar
	name = "soldier's gloves"
	desc = "<span class='yellow'><i>Thin enough for the trigger, thick enough for the cold.</i></span>"
	icon = 'modular/timesoldier/sprites/warfare.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "redglovesworld"
	item_state = "redglovesworld"
	color = null
