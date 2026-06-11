#define ROCK_CHARGE_REDUCTION 0.15
#define GEM_CHARGE_REDUCTION 0.25

/* Spellbook
Intended to be a reward or a goal for pure mage, allowing them to reset and swap out 2 spells per day, and
decreases charge time if held opened in hand, for pure mage build + aesthetics.
*/

/obj/item/book/spellbook
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	var/base_icon_state = "spellbookbrown"
	unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/skill/misc/reading
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	name = "\improper 奥术秘典"
	desc = "一本噼啪作响、泛着微光的书，满载着让人一眼望去便头痛欲裂的符文与记号。可用于解绑法术，或辅助施法者使部分投射物偏转。"
	var/picked // if the book has had it's style picked or not
	var/born_of_rock = FALSE // was a magical stone used to make it instead of a gem

/obj/item/book/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/book/spellbook/examine(mob/user)
	. = ..()
	. += span_notice("每天阅读一次，可解绑两个法术并返还其法术点。")
	if(born_of_rock)
		. += span_notice("这本魔典是用魔法石而非正统宝石制成的。将其展开握在手中时，可使法术充能时间缩短[ROCK_CHARGE_REDUCTION * 100]%。")
	else
		. += span_notice("这本魔典由宝石制成。将其展开握在手中时，可使法术充能时间缩短[GEM_CHARGE_REDUCTION * 100]%。")

/obj/item/book/spellbook/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/book/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

// Override
/obj/item/book/spellbook/read(mob/user)
	change_spells()
	return FALSE

/obj/item/book/spellbook/proc/change_spells(mob/user = usr)
	var/datum/mind/user_mind = user.mind
	if(!user_mind) return // How??
	if(user_mind.has_changed_spell)
		to_chat(user, span_warning("我今天已经解绑过法术了！"))
		return
	var/list/resettable_spells = list()
	var/list/spell_list = user_mind.spell_list
	for(var/i = 1, i <= spell_list.len, i++)
		var/obj/effect/proc_holder/spell/spell = spell_list[i]
		if(spell.refundable == TRUE)
			if(spell.cost > 0)
				resettable_spells["[spell.name]: [spell.cost]"] = spell_list[i]
	if(!resettable_spells.len)
		to_chat(user, span_warning("我没有可解绑的法术！"))
		return
	user_mind.has_changed_spell = TRUE //To pre-empt a halting duplication in the for loop here
	var/unlearn_success = FALSE
	for(var/i = 1, i <= 2, i++)
		var/choice = input(user, "最多选择两个法术进行解绑。若两次都取消，则不会消耗今日的解绑次数。") as null|anything in resettable_spells
		var/obj/effect/proc_holder/spell/item = resettable_spells[choice]
		if(!item)
			break
		if(!resettable_spells.len)
			return
		if(user_mind.RemoveSpell(item))
			user_mind.used_spell_points -= item.cost
			unlearn_success = TRUE
		resettable_spells.Remove(choice)
		user_mind.check_learnspell()
	if(!unlearn_success)
		user_mind.has_changed_spell = FALSE //If we didn't unlearn anything, reset

/obj/item/book/spellbook/proc/get_cdr()
	if(born_of_rock)
		return ROCK_CHARGE_REDUCTION
	else
		return GEM_CHARGE_REDUCTION

/obj/item/book/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown", "steel", "gem", "skin", "mimic", "wyrdbark", "sunfire", "abyssal", "cinder", "vessel", "edgebound", "sovereign")
		var/the_time = world.time
		var/design = input(user, "选择一种外观。","法术书样式") as null|anything in designlist
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"

/// Book slapcrafting

/obj/item/spellbook_unfinished
	var/pages_left = 4
	name = "装订卷轴纸"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state ="basic_book_0"
	desc = "厚实的卷轴纸在书脊处装订成册。它还缺少书页。"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/spellbook_unfinished/pre_arcyne
	name = "待成之书"
	icon_state = "spellbook_unfinished"
	desc = "一本已经完全装订好的卷纸书册。它还缺少某种奥术能量。"
	grid_width = 32
	grid_height = 64

/obj/item/natural/hide/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				playsound(loc, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("我把最初几页装进了皮革封面里......"))
				new /obj/item/spellbook_unfinished(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>你得把[src]放到桌上才能处理它。</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(pages_left > 0)
					playsound(loc, 'sound/items/book_page.ogg', 100, TRUE)
					pages_left -= 1
					to_chat(user, span_notice("还剩[pages_left+1]页......"))
					qdel(P)
				else
					playsound(loc, 'sound/items/book_open.ogg', 100, TRUE)
					if(isarcyne(user))
						to_chat(user, span_notice("书已经装订好了。现在我得找个媒介，把奥术能量导入其中。"))
					else
						to_chat(user, span_notice("我做出了一本由厚重废纸构成的空书。它甚至都没法好好翻阅！"))
					new /obj/item/spellbook_unfinished/pre_arcyne(loc)
					qdel(P)
					qdel(src)
		else
			to_chat(user, "<span class='warning'>你得把[src]放到桌上才能处理它。</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/pre_arcyne/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/roguegem))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(isarcyne(user))
					playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
					user.visible_message(span_warning("[user]捏碎了[user.p_their()]手中的[P]！粉末渗入了[src]之中。"), \
						span_notice("我将自己的奥术能量灌入晶石之中。它随即碎裂，渗入魔典封面！如今书页上已布满某种不可知语言的符文与记号......"))
					var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
					newbook.desc += " [P]留下的粉尘痕迹仍残存在页边。"
					qdel(P)
					qdel(src)
				else
					if(prob(1))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user]捏碎了[user.p_their()]手中的[P]！粉末渗入了[src]之中。"), \
							span_notice("以十神之名！那颗宝石竟然炸开了，而我那本废书竟充满了闪耀能量与奇异文字！"))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.desc += " [P]留下的粉尘痕迹仍残存在页边。"
						qdel(P)
						qdel(src)
					else
						playsound(loc, 'modular_azurepeak/sound/spellbooks/icicle.ogg', 100, TRUE)
						user.visible_message(span_warning("[user]捏碎了[user.p_their()]手中的[P]！可那粉末只是尴尬地堆在[src]表面。"), \
							span_notice("......我为什么，又是怎么，把这颗宝石砸进一本毫无价值的卷纸书里的？真是浪费mammon！"))
						qdel(P)
					return ..()
		else
			to_chat(user, "<span class='warning'>你得把[src]放到桌上才能处理它。</span>")
	else if (istype(P, /obj/item/natural/stone))
		var/obj/item/natural/stone/the_rock = P
		if (the_rock.magic_power)
			if(isturf(loc) && (found_table))
				var/crafttime = ((130 - the_rock.magic_power) - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
				if(do_after(user, crafttime, target = src))
					if (isarcyne(user))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user]捏碎了[user.p_their()]手中的[P]！粉末渗入了[src]之中。"), \
							span_notice("我将自己的奥术能量与手中魔法石的力量相融。它短暂颤动后，化作点点灰烬消散。如今书页上已布满某种不可知语言的符文与记号......"))
						to_chat(user, span_notice("......可即便对奥术之谜而言，这些字符也与我以往所见的任何东西都截然不同。它们会变得极其难懂......"))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.born_of_rock = TRUE
						newbook.desc += " 彩石留下的痕迹勾勒在书页边缘。"
						qdel(P)
						qdel(src)
					else
						if (prob(the_rock.magic_power)) // for reference, this is never higher than 15 and usually significantly lower
							playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
							user.visible_message(span_warning("[user]小心地将[the_rock]放到[src]上。起初什么也没发生，可片刻之后，萦绕石头的辉光竟如液体般流下，浸透了整本书！"), \
							span_notice("我就知道这块石头不一般！它那缤纷的魔力已经渗入了我的魔典，并赐予我神秘的馈赠！"))
							to_chat(user, span_notice("......这些涂写出来的东西到底都是什么意思？"))
							var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
							newbook.born_of_rock = TRUE
							newbook.desc += " 彩石留下的痕迹勾勒在书页边缘。"
							qdel(P)
							qdel(src)
						else
							user.visible_message(span_warning("[user]把[the_rock]放到[src]表面，满怀期待地盯着它。毫无预兆地，那石头像被踩爆的葫芦一样猛然炸开了！"), \
							span_notice("不！我珍贵的石头！它一定是不愿把自己的秘密分享给我......"))
							user.electrocute_act(5, src)
							qdel(P)
		else
			to_chat(user, span_notice("这不过是块普通石头，毫无奥术潜力。呸！"))
			return ..()
	else
		return ..()
