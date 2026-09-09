/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon
	castdrain = 25
	school = "transmutation"

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon
	name = "Blade of Psydon"
	desc = "The manifestation of the higher concept of a blade itself. Said to be drawn upon from Noc's treasury of wisdom, each casting a poor facsimile of the perfect weapon He once held. This spell requires a Warscholar's mask to be cast."
	clothes_req = FALSE
	drawmessage = "I imagine the perfect weapon, forged by arcyne knowledge, its edge flawless. \
	I feel it in my mind's eye -- but it's just out of reach. I pull away it's shadow, a bad copy, and yet it is one of a great weapon nonetheless... "
	dropmessage = "Letting go, I watch the blade lose its form, unable to stay stable without my energy rooting it to this world..."
	overlay_state = "boundkatar"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	req_items = list(/obj/item/clothing/mask/rogue/lordmask/naledi)

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	name = "\improper arcyne push dagger"
	desc = "This blade throbs, translucent and iridiscent, blueish arcyne energies running through its semi-transparent surface..."
	catchphrase = null
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	force = 24
	charges = 999
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 500
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 0 // Like other katar meant to be used with unarmed parry
	wbalance = WBALANCE_SWIFT
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/attack_self()
	attached_spell.remove_hand()
