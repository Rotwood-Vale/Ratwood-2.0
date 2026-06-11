/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/evil
	castdrain = 25
	school = "transmutation"

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/evil/inhumenblade
	name = "异种之刃"
	desc = "召出一把异种之刃。"
	clothes_req = FALSE
	drawmessage = "我祈求一把由异种锻成的兵刃。 \
	他们应允了我的请求，以强大的神迹向我施以援手……"
	dropmessage = "当我松开手时，我看着这把利刃慢慢失去了形体……"
	overlay_state = "boundkatar"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/rogueweapon/inhumenblade

/obj/item/melee/touch_attack/rogueweapon/inhumenblade
	name = "\improper arcyne push dagger"
	desc = "这把刀刃微微搏动，半透明而泛着虹彩，幽暗能量已准备在战斗中助我一臂之力……"
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
