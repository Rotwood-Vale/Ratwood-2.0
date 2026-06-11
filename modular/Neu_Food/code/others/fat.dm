// -------------- FAT -----------------
/obj/item/reagent_containers/food/snacks/fat
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	name = "脂肪"
	desc = "一团动物脂肪。"
	icon_state = "fat"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	possible_item_intents = list(/datum/intent/food, /datum/intent/splash)
	fat_yield = 20

/obj/item/reagent_containers/food/snacks/fat/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/fat/attack(mob/living/M, mob/user, proximity)
	if(user.used_intent.type == /datum/intent/food)
		return ..()

	if(!isliving(M) || (M != user))
		return ..()

	user.visible_message("[user]开始往[M]身上抹油", "你开始往[M]身上抹油")
	if(!do_after(user, 5 SECONDS, M))
		return
	M.apply_status_effect(/datum/status_effect/buff/oiled)

/obj/item/reagent_containers/food/snacks/fat/examine()
	. = ..()
	. += span_info("以泼洒意图对自己使用可给自己抹油，使你在暴露时变得滑溜、更难被抓住。赤脚会降低滑倒几率。")

// TALLOW is used as an intermediate crafting ingredient for other recipes.
/obj/item/reagent_containers/food/snacks/tallow
	name = "板油"
	desc = "从被宰杀的生物身上取下脂肪组织，炼去筋膜后制成一种坚硬且易于保存的 \
	油脂。"
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	icon_state = "tallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1)
	obj_flags = CAN_BE_HIT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fat_yield = 5 // 5 per animal fat
	bitesize = 1
	dropshrink = 0.75

/obj/item/reagent_containers/food/snacks/tallow/red
	name = "审判庭板油"
	desc = "从被宰杀的生物身上取下脂肪组织，炼去筋膜后制成一种坚硬且易于保存的 \
	油脂。随后再浸入鲜血或某种近似鲜血的东西，使其成为一种取材容易却相当阴森的蜡替代品，深受审判庭青睐。正如奥塔瓦人所说，尽情享用。"
	icon_state = "redtallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1, "血"=1,)

/obj/item/reagent_containers/food/snacks/tallow/soft
	name = "软板油"
	desc = "加入额外脂肪软化后的炼制板油，更便于涂抹封缄。它看起来与审判庭板油相似，但没有它那份神圣认可。"
	icon_state = "softtallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1)

/obj/item/reagent_containers/food/snacks/tallow/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.full)
				if(alert(user, "要把板油浸进去吗？", "只是血而已", "要", "不要") != "不要")
					success = TRUE
					IND.fullreset(user)
				else
					return	
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/tallow/red, user)		
