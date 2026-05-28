/datum/action/cooldown/spell/summonrogueweapon/evil
	castdrain = 25
	school = "transmutation"

/datum/action/cooldown/spell/summonrogueweapon/evil/inhumenblade
	name = "Inhumen Blade"
	desc = "Summon an inhumen blade."
	clothes_req = FALSE
	drawmessage = "I ask for a weapon forged by the inhumen. \
	They grant my request and aid me, for their miracles are potent... "
	dropmessage = "Letting go, I watch the blade lose it's form..."
	overlay_state = "boundkatar"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/rogueweapon/inhumenblade

/obj/item/melee/touch_attack/rogueweapon/inhumenblade
	name = "\improper arcyne push dagger"
	desc = "This blade throbs, translucent and iridiscent, dark energy ready to aid me in combat..."
	catchphrase = null
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_evil"
	charges = 30 // Inhumen influence is strong
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 999
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 4
	wbalance = WBALANCE_SWIFT

/obj/item/melee/touch_attack/rogueweapon/attack_self()
	attached_spell.remove_hand()
