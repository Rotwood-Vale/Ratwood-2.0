#define SHIELD_BASH		/datum/intent/shield/bash
#define SHIELD_BLOCK		/datum/intent/shield/block
#define SHIELD_BASH_METAL 	/datum/intent/shield/bash/metal
#define SHIELD_BLOCK_METAL 	/datum/intent/shield/block/metal
#define SHIELD_SMASH 		/datum/intent/mace/smash/shield
#define SHIELD_SMASH_METAL 	/datum/intent/mace/smash/shield/metal
#define SHIELD_BANG_COOLDOWN (3 SECONDS)

/obj/item/rogueweapon/shield
	name = ""
	desc = ""
	icon_state = ""
	icon = 'icons/roguetown/weapons/shields32.dmi'
	slot_flags = ITEM_SLOT_BACK
	flags_1 = null
	force = 10
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	block_chance = 0
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	resistance_flags = FLAMMABLE
	can_parry = TRUE
	associated_skill = /datum/skill/combat/shields		//Trained via blocking or attacking dummys with; makes better at parrying w/ shields.
	wdefense = 10										//should be pretty baller
	var/coverage = 50
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 100
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	COOLDOWN_DECLARE(shield_bang)


/obj/item/rogueweapon/shield/attackby(obj/item/attackby_item, mob/user, params)

	// Shield banging
	if(src == user.get_inactive_held_item())
		if(istype(attackby_item, /obj/item/rogueweapon))
			if(!COOLDOWN_FINISHED(src, shield_bang))
				return
			user.visible_message(span_danger("[user]用[attackby_item]猛砸[src]！"))
			playsound(user.loc, 'sound/combat/shieldbang.ogg', 50, TRUE)
			COOLDOWN_START(src, shield_bang, SHIELD_BANG_COOLDOWN)
			return

	return ..()

/obj/item/rogueweapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item)) // can't trust mob -> item assignments
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken) // No blocking with a broken shield you fool
			return FALSE
		if((owner.client?.chargedprog == 100 && owner.used_intent?.tranged) || prob(coverage))
			owner.visible_message(span_danger("[owner]用[src]熟练地挡下了[hitby]！"))
			src.take_damage(floor(damage / 4))
			return TRUE
	return FALSE

/datum/intent/shield/bash
	name = "盾击"
	icon_state = "inbash"
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/shield/bash/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/shield/block
	name = "格挡"
	icon_state = "inblock"
	tranged = 1 //we can't attack directly with this intent, but we can charge it
	tshield = 1
	chargetime = 1
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	warnie = "shieldwarn"
	item_d_type = "blunt"
	charge_pointer = 'icons/effects/mousemice/charge/shield_charging.dmi'
	charged_pointer = 'icons/effects/mousemice/charge/shield_charged.dmi'

/datum/intent/shield/block/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield
	hitsound = list('sound/combat/shieldbash_wood.ogg')

/datum/intent/mace/smash/shield/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/obj/item/rogueweapon/shield/wood
	name = "木盾"
	desc = "一面结实的木盾。能挡下你能想到的任何东西。"
	icon_state = "woodsh"
	dropshrink = 0.8
	anvilrepair = /datum/skill/craft/carpentry
	coverage = 30
	smeltresult = /obj/item/ash
	dropshrink = 0.8

/obj/item/rogueweapon/shield/attack_right(mob/user)
	if(overlays.len)
		..()
		return

	var/icon/J = new('icons/roguetown/weapons/shield_heraldry.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(!findtext(icon_s, "[icon_state]_"))
			istates.Remove(icon_s)
			continue
		istates.Add(replacetextEx(icon_s, "[icon_state]_", ""))
		istates.Remove(icon_s)

	if(!istates.len)
		..()
		return

	var/picked_name = input(user, "选择纹章", "纹章", name) as null|anything in sortList(istates)
	if(!picked_name)
		picked_name = "none"
	var/mutable_appearance/M = mutable_appearance('icons/roguetown/weapons/shield_heraldry.dmi', "[icon_state]_[picked_name]")
	M.appearance_flags = NO_CLIENT_COLOR
	add_overlay(M)
	if(alert("你满意这面纹章吗？", "纹章", "满意", "重选") != "满意")
		cut_overlays()

	update_icon()

/obj/item/rogueweapon/shield/wood/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower
	name = "塔盾"
	desc = "一面覆盖全身的巨型铁加固盾牌，仿制自逝去年代的亚斯玛盾式。"
	icon_state = "shield_tower"
	force = 6
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	wlength = WLENGTH_NORMAL
	resistance_flags = FLAMMABLE
	var/swapped = FALSE
	wdefense = 10
	coverage = 40
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/shield/tower/holysee
	name = "圣座塔盾"
	desc = "对抗黑暗的最后一道坚固防线。因为对持盾者而言，真正重要的不是身前之敌，而是身后之家。"
	icon_state = "gsshield"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 11
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 330
	sellprice = 30
	smeltresult = /obj/item/ingot/steelholy

/obj/item/rogueweapon/shield/tower/holysee/MiddleClick(mob/user, params)
	. = ..()
	swapped = !swapped
	update_icon()

/obj/item/rogueweapon/shield/tower/holysee/update_icon()
	. = ..()
	if(swapped)
		icon_state = "gsshielddark"
	else
		icon_state = "gsshield"


/obj/item/rogueweapon/shield/tower/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/metal
	name = "鸢盾"
	desc = "一面鸢形铁盾。可靠而坚固。"
	icon_state = "kitesh"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 12
	coverage = 60
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 300
	sellprice = 30
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/shield/tower/metal/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/shield/tower/metal/ancient
	name = "远古盾"
	desc = "一面覆有抛光吉尔青铜的古老方盾。它是不死军团士兵最亲密的伙伴；无论箭矢还是弩矢，都会被它冷酷无情地弹开。它只是无数提醒中的一个，宣告她的野心无人能阻。"
	icon_state = "ancientsh"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/tower/metal/ancient/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.8,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/shield/tower/metal/ancient/decrepit
	name = "破旧盾"
	desc = "一面由磨损青铜打造的沉重塔盾。其上缠着干枯海藻，散发咸腥海味，让人不禁以为它是从某艘沉没已久的战船残骸里打捞出来的……连同它昔日的主人一起。"
	max_integrity = 120
	wdefense = 9
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null

/obj/item/rogueweapon/shield/tower/metal/psy
	name = "圣约"
	desc = "普赛顿之民忍耐不屈。普赛顿之民保全自身。普赛顿之民守护祂的羊群。"
	icon_state = "psyshield"
	force = 15
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 14
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 350
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/shield/tower/metal/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = -3,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 1,\
	)

/obj/item/rogueweapon/shield/tower/zyb
	name = "骑盾"
	desc = "一面齐班提风格的盾牌。木材、铁与皮革被巧妙结合，使其足以应对各类武器。"
	icon_state = "desert_rider"
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK)
	force = 25
	throwforce = 25 //for cosplaying captain Zybantine
	wdefense = 11
	max_integrity = 220 //not fully metal but not fully wood either
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/iron
	dropshrink = 0.75

/obj/item/rogueweapon/shield/tower/zyb/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/spidershield
	name = "蜘蛛盾"
	desc = "一面由尖刺般的金属条熔接而成的厚重盾牌。它的纹样让人联想到的绝不是安全与庇护。"
	icon_state = "spidershield"
	coverage = 55

/obj/item/rogueweapon/shield/buckler
	name = "小圆盾"
	desc = "一面结实的小圆盾。能挡下你能想到的任何东西。"
	icon_state = "bucklersh"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	dropshrink = 0.8
	resistance_flags = null
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wdefense = 9
	coverage = 10
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 130
	associated_skill = /datum/skill/combat/shields
	grid_width = 32
	grid_height = 64
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/shield/buckler/equipped(mob/user, slot, initial)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_GNARLYDIGITS))
		to_chat(user, span_danger("糟了！[src]的握把太小，我抓不住！"))
		forceMove(user.loc)

/obj/item/rogueweapon/shield/buckler/examine(mob/living/user)
	. = ..()
	. += "小圆盾会使用你当前主手武器的招架技能；否则改用你的盾牌技能。"

/obj/item/rogueweapon/shield/buckler/proc/bucklerskill(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/bucklerer = user
	var/obj/item/mainhand = bucklerer.get_active_held_item()
	var/weapon_parry = FALSE
	if(mainhand)
		if(mainhand.can_parry)
			weapon_parry = TRUE
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		associated_skill = /datum/skill/combat/shields
	if(weapon_parry && mainhand.associated_skill && ispath(mainhand.associated_skill, /datum/skill/combat))
		associated_skill = mainhand.associated_skill
	else
		associated_skill = /datum/skill/combat/shields

/obj/item/rogueweapon/shield/buckler/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/buckler/ancient
	name = "远古小圆盾"
	desc = "它曾领先于时代，如今却已被时代抛下。工匠锤击留下的痕迹仍在斑驳表面上可见，然而 \
	锈蚀与腐朽连这点记忆都不肯放过。"
	icon_state = "ancient_buckler"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/buckler/ancient/decrepit
	name = "破旧的小圆盾"
	desc = "它曾领先于时代，如今却已被时代抛下。工匠锤击留下的痕迹仍在斑驳表面上可见，然而 \
	锈蚀与腐朽连这点记忆都不肯放过。"
	force = 12
	throwforce = 6
	max_integrity = 40

/obj/item/rogueweapon/shield/heater
	name = "熨斗盾"
	desc = "一面结实的木皮盾。设计上尽量减轻负担，同时仍能提供不错的防护。"
	icon_state = "heatersh"
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 30
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 220
	smeltresult = /obj/item/ash

/obj/item/rogueweapon/shield/heater/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/rogueweapon/shield/iron
	name = "铁盾"
	desc = "一面沉重的铁盾。它比钢盾便宜，但也更累赘。"
	icon_state = "ironsh"
	force = 20
	throwforce = 25 // "I can do this all day."
	dropshrink = 0.8
	coverage = 30
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	possible_item_intents = list(SHIELD_SMASH_METAL, SHIELD_BLOCK) // No SHIELD_BASH. Too heavy to swing quickly, or something.
	max_integrity = 220
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/shield/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

#undef SHIELD_BANG_COOLDOWN

/obj/item/rogueweapon/shield/iron/steppesman
	name = "草原民铁盾"
	desc = "一面饰有传统阿夫尼配色的箍铁盾牌，常见于草原民手中。"
	icon_state = "ironsh_steppeman"
	max_integrity = 250 //+30

/obj/item/rogueweapon/shield/iron/nomad
	name = "游牧盾"
	desc = "一面纤薄的盾牌，似乎同时以吉布兰泽与铁打造而成。那是种不祥的组合。 \
	它的工艺仿佛来自另一个时代，自第一纪元后便再未现世。"
	icon_state = "ironsh_nomad"//Temp, but it works.
	coverage = 40//+10
	max_integrity = 200//-20

/*/obj/item/rogueweapon/shield/buckler/freelancer
	name = "击剑披布"
	desc = "一块传统的伊特鲁里亚绗缝方布，外覆羊毛。它可以凭借鲜艳色彩与垂挂钢球来晃花并干扰对手。"
	force = 10
	throwforce = 10
	coverage = 15
	max_integrity = 200
	possible_item_intents = list(SHIELD_BLOCK, FENCER_DAZE) */

/obj/item/rogueweapon/shield/capbuckler // unique, better buckler for knight captain
	name = "“秩序”"
	desc = "一面为卫队长打造的特制黑钢小圆盾，饰有谷地徽记。"
	icon_state = "capbuckler"
	icon = 'icons/roguetown/weapons/special/captain.dmi'
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	dropshrink = 0.8
	resistance_flags = null
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wdefense = 10
	coverage = 10
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 215 // more integrity cuz blacksteel
	blade_dulling = DULLING_SHAFT_METAL
	associated_skill = /datum/skill/combat/shields
	grid_width = 32
	grid_height = 64
	sellprice = 100 // lets not make it too profitable
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/shield/capbuckler/examine(mob/living/user)
	. = ..()
	. += "小圆盾会使用你当前主手武器的招架技能；否则改用你的盾牌技能。"

/obj/item/rogueweapon/shield/capbuckler/proc/bucklerskill(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/bucklerer = user
	var/obj/item/mainhand = bucklerer.get_active_held_item()
	var/weapon_parry = FALSE
	if(mainhand)
		if(mainhand.can_parry)
			weapon_parry = TRUE
	if(istype(mainhand, /obj/item/rogueweapon/shield/capbuckler))
		associated_skill = /datum/skill/combat/shields
	if(weapon_parry && mainhand.associated_skill)
		associated_skill = mainhand.associated_skill
	else
		associated_skill = /datum/skill/combat/shields

/obj/item/rogueweapon/shield/capbuckler/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/rogueweapon/shield/steam
	name = "蒸汽盾"
	desc = "一面被工匠大幅改造过的结实木盾。其内部似乎嵌入了多根管道与齿轮。"
	icon_state = "artificershield"
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 60
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 200
	var/smoke_path = /obj/effect/particle_effect/smoke
	var/cooldowny
	var/cdtime = 30 SECONDS

/obj/item/rogueweapon/shield/steam/attack_self(mob/user)
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("[src]发出微弱的嘶响，它还在积攒蒸汽！"))
			return
	if(prob(25))
		smoke_path = /obj/effect/particle_effect/smoke/bad
	else
		smoke_path = /obj/effect/particle_effect/smoke
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	user.visible_message(span_notice("[src]内部传出刺耳的齿轮嗡鸣与蒸汽嘶响。"))
	to_chat(user, span_warning("[user]启动了[src]上的一个机关！"))
	sleep(15)
	playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src,PROC_REF(steamready), user), cdtime)
	for(var/atom/movable/AM in view(1, user))
		thrownatoms += AM
	for(var/turf/T in oview(2, user))
		new smoke_path(T) //smoke everywhere!

	for(var/atom/movable/AM as anything in thrownatoms)
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)

		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustFireLoss(25)
				to_chat(M, span_danger("我被[user]猛地砸倒在地！"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.adjustFireLoss(25)
				to_chat(M, span_danger("我被[user]猛地掀飞了出去！"))
			AM.safe_throw_at(throwtarget, 4, 2, user, TRUE, force = MOVE_FORCE_OVERPOWERING)

/obj/item/rogueweapon/shield/steam/proc/steamready(mob/user)
	playsound(user, 'sound/items/steamcreation.ogg', 100, FALSE, -1)
	to_chat(user, span_warning("[src]已经可以再次使用了！"))
/obj/item/rogueweapon/shield/steam/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
