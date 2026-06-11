/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon
	castdrain = 25
	school = "transmutation"

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon
	name = "普赛顿之刃"
	desc = "刀刃这一更高概念本身的显化。据说它取自诺克的智慧宝库，而每次施展都只是祂曾持有的完美兵器的拙劣仿制。此法术需佩戴战学者面具方可施放。"
	clothes_req = FALSE
	drawmessage = "我在脑海中勾勒那柄由奥术知识锻成的完美兵器，其锋刃无可挑剔。\
	我能用心眼感知到它，却始终差之毫厘。于是我拽出它的影子——一件拙劣的仿品，然而终究仍是一柄伟大武器的映照……"
	dropmessage = "当我松手时，刀刃渐渐失去形体；若无我的能量将其锚定于此世，它便无法稳定存在……"
	overlay_state = "boundkatar"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	req_items = list(/obj/item/clothing/mask/rogue/lordmask/naledi)

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	name = "\improper 奥术推匕"
	desc = "这柄刀刃微微搏动，半透明而流彩，淡蓝色的奥术能量正沿着其通透的表面流淌......"
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
