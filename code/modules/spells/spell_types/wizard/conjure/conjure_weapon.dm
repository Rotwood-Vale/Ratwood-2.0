/obj/effect/proc_holder/spell/invoked/conjure_weapon
	name = "召兵术"
	desc = "在你手中召出一件你所选择的武器。若你再次召兵，或解除法术绑定，这把武器就会消散。\n\
	若 `INT` 达到 12 或更高，则召出钢阶武器，否则召出铁阶武器。仅限近战武器。"
	overlay_state = "conjure_weapon"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 60
	chargedrain = 1
	chargetime = 2 SECONDS
	no_early_release = TRUE
	recharge_time = 5 MINUTES // Not meant to be spammed or used as a mega support spell to outfit an entire party

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 2
	spell_tier = 2 // Spellblade tier.

	invocations = list("兵刃，显现！") // I was offered Me Armare (Arm Myself) but Conjura Telum (Conjure Weapon) is more suitable.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/rogueweapon/conjured_weapon = null

	var/list/iron_weapons = list(
		"铁制短剑" = /obj/item/rogueweapon/sword/short/iron,
		"铁制弯刀" = /obj/item/rogueweapon/sword/short/messer/iron,
		"双手巨剑" = /obj/item/rogueweapon/greatsword/zwei,
		"短棍" = /obj/item/rogueweapon/mace/cudgel,
		"铁制战锤" = /obj/item/rogueweapon/mace/warhammer,
		"铁制匕首" = /obj/item/rogueweapon/huntingknife/idagger,
		"铁斧" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"铁制巨斧" = /obj/item/rogueweapon/greataxe,
		"铁制链枷" = /obj/item/rogueweapon/flail,
		"铁矛" = /obj/item/rogueweapon/spear,
		"鞭子" = /obj/item/rogueweapon/whip,
	)
	// There's no way I am putting Lucerne in iron tier I am gonna misclassify it as steel on purpose

	// Trying to keep the list manageable so 1 / 2 iconic thing from each family is fine
	var/list/steel_weapons = list(
		"钢制军刀" = /obj/item/rogueweapon/sword/sabre,
		"钢制刺剑" = /obj/item/rogueweapon/sword/rapier,
		"长剑" = /obj/item/rogueweapon/sword/long,
		"双手长剑" = /obj/item/rogueweapon/greatsword/grenz,
		"战斧" = /obj/item/rogueweapon/stoneaxe/battle,
		"钢制匕首" = /obj/item/rogueweapon/huntingknife/idagger/steel,
		"长柄斧" = /obj/item/rogueweapon/halberd,
		"钢制战锤" = /obj/item/rogueweapon/mace/warhammer/steel,
		"钢制链枷" = /obj/item/rogueweapon/flail/sflail,
		"鞭子" = /obj/item/rogueweapon/whip,
	)

/obj/effect/proc_holder/spell/invoked/conjure_weapon/cast(list/targets, mob/living/user = usr)
	var/list/weapons = iron_weapons
	if(user.STAINT >= 12)
		weapons = steel_weapons
	var/weapon_choice = input(user, "选择一件武器", "Conjure Weapon") as anything in weapons
	if(!weapon_choice)
		return
	if(src.conjured_weapon)
		qdel(src.conjured_weapon)
	weapon_choice = weapons[weapon_choice]

	var/obj/item/rogueweapon/R = new weapon_choice(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
	user.put_in_hands(R)
	src.conjured_weapon = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/conjure_weapon/Destroy()
	if(src.conjured_weapon)
		conjured_weapon.visible_message(span_warning("[conjured_weapon] 的边缘开始闪烁消退，随后彻底消失了！"))
		qdel(src.conjured_weapon)
	return ..()
