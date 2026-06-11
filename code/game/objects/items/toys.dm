/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Mech prizes
 *		AI core prizes
 *		Toy codex gigas
 * 		Skeleton toys
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *      Kitty toys!
 *		Snowballs
 *		Clockwork Watches
 *		Toy Daggers
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 1
	throw_range = 7
	force = 0

/*
 * Snap pops
 */

/obj/item/toy/snappop
	name = "粉包"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY
	var/ash_type = /obj/item/ash

/obj/item/toy/snappop/proc/pop_burst(n=3, c=1)
	var/datum/effect_system/spark_spread/s = new()
	s.set_up(n, c, src)
	s.start()
	new ash_type(loc)
	visible_message("<span class='warning'>[src]炸开了！</span>",
		"<span class='hear'>我听见一声爆响！</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	qdel(src)

/obj/item/toy/snappop/fire_act(added, maxstacks)
	pop_burst()

/obj/item/toy/snappop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		pop_burst()

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if(ishuman(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == MOVE_INTENT_RUN)
			to_chat(M, "<span class='danger'>我踩到了粉包！</span>")
			pop_burst(2, 0)

/obj/item/toy/snappop/phoenix
	name = "魔法粉包"
	desc = ""
	ash_type = /obj/item/ash/snappop_phoenix

/obj/item/ash/snappop_phoenix
	var/respawn_time = 300

/obj/item/ash/snappop_phoenix/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), respawn_time)

/obj/item/ash/snappop_phoenix/proc/respawn()
	new /obj/item/toy/snappop/phoenix(get_turf(src))
	qdel(src)

/obj/item/toy/cards
	resistance_flags = FLAMMABLE
	max_integrity = 50
	no_use_cd = TRUE
	var/parentdeck = null
	var/deckstyle = "syndicate"
	var/card_hitsound = null
	var/card_force = 0
	var/card_throwforce = 0
	var/card_throw_speed = 1
	var/card_throw_range = 7
	var/list/card_attack_verb = list("攻击")

/obj/item/toy/cards/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user]正用[src]割开[user.p_their()]的手腕！看来[user.p_they()]这手牌真是烂透了！</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/toy/cards/proc/apply_card_vars(obj/item/toy/cards/newobj, obj/item/toy/cards/sourceobj) // Applies variables for supporting multiple types of card deck
	if(!istype(sourceobj))
		return

/obj/item/toy/cards/proc/get_display_cardname(raw_name)
	if(!raw_name)
		return raw_name
	var/static/list/major_arcana = list(
		"The Magician" = "魔术师", "The High Priestess" = "女祭司", "The Empress" = "女皇", "The Emperor" = "皇帝",
		"The Hierophant" = "教皇", "The Lover" = "恋人", "The Chariot" = "战车", "Justice" = "正义",
		"The Hermit" = "隐者", "The Wheel of Fortune" = "命运之轮", "Strength" = "力量", "The Hanged Man" = "倒吊人",
		"Death" = "死神", "Temperance" = "节制", "The Devil" = "恶魔", "The Tower" = "高塔",
		"The Star" = "星星", "The Moon" = "月亮", "The Sun" = "太阳", "Judgement" = "审判",
		"The World" = "世界", "The Fool" = "愚者"
	)
	if(major_arcana[raw_name])
		return major_arcana[raw_name]
	var/of_pos = findtext(raw_name, " of ")
	if(of_pos)
		var/rank = copytext(raw_name, 1, of_pos)
		var/suit = copytext(raw_name, of_pos + 4)
		var/display_suit = suit
		var/display_rank = rank
		switch(suit)
			if("Hearts") display_suit = "红桃"
			if("Spades") display_suit = "黑桃"
			if("Clubs") display_suit = "梅花"
			if("Diamonds") display_suit = "方片"
			if("Pentacles") display_suit = "星币"
			if("Swords") display_suit = "宝剑"
			if("Wands") display_suit = "权杖"
			if("Cups") display_suit = "圣杯"
		switch(rank)
			if("Ace") display_rank = "A"
			if("Jack") display_rank = "杰克"
			if("Queen") display_rank = "王后"
			if("King") display_rank = "国王"
			if("Page") display_rank = "侍者"
			if("Knight") display_rank = "骑士"
		return "[display_suit][display_rank]"
	return raw_name

/obj/item/toy/cards/deck
	name = "一副纸牌"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	deckstyle = "syndicate"
	icon_state = "deck_syndicate_full"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/list/cards = list()
	grid_width = 32
	grid_height = 32

/obj/item/toy/cards/deck/examine()
	. = ..()
	. += span_smallnotice("把牌组拿在手里即可洗牌。空手点击牌组即可抽一张牌。")

/obj/item/toy/cards/deck/Initialize(mapload)
	. = ..()
	populate_deck()

///Generates all the cards within the deck.
/obj/item/toy/cards/deck/proc/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/suit in list("Hearts", "Spades", "Clubs", "Diamonds"))
		cards += "Ace of [suit]"
		for(var/i in 2 to 10)
			cards += "[i] of [suit]"
		for(var/person in list("Jack", "Queen", "King"))
			cards += "[person] of [suit]"

//ATTACK HAND IGNORING PARENT RETURN VALUE
//ATTACK HAND NOT CALLING PARENT
/obj/item/toy/cards/deck/attack_hand(mob/user)
	draw_card(user)

/obj/item/toy/cards/deck/proc/draw_card(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	var/choice = null
	if(cards.len == 0)
		to_chat(user, "<span class='warning'>已经没有牌可以抽了！</span>")
		return
	var/obj/item/toy/cards/singlecard/H = new/obj/item/toy/cards/singlecard(user.loc)
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	src.cards -= choice
	H.pickup(user)
	user.put_in_hands(H)
	user.visible_message("<span class='notice'>[user]从牌堆中抽了一张牌。</span>", "<span class='notice'>我从牌堆中抽了一张牌。</span>")
	update_icon()

/obj/item/toy/cards/deck/update_icon()
	if(cards.len > 26)
		icon_state = "deck_[deckstyle]_full"
	else if(cards.len > 10)
		icon_state = "deck_[deckstyle]_half"
	else if(cards.len > 0)
		icon_state = "deck_[deckstyle]_low"
	else if(cards.len == 0)
		icon_state = "deck_[deckstyle]_empty"

/obj/item/toy/cards/deck/attack_self(mob/user)
	if(cooldown < world.time - 25)
		cards = shuffle(cards)
		playsound(src, 'sound/items/cardshuffle.ogg', 100, TRUE)
		user.visible_message("<span class='notice'>[user]洗了洗牌。</span>", "<span class='notice'>我洗了洗牌。</span>")
		cooldown = world.time

/obj/item/toy/cards/deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard))
		var/obj/item/toy/cards/singlecard/SC = I
		if(SC.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(SC))
				to_chat(user, "<span class='warning'>这张牌黏在你手上了，没法放回牌堆！</span>")
				return
			cards += SC.cardname
			user.visible_message("<span class='notice'>[user]把一张牌塞回了牌堆底部。</span>","<span class='notice'>我把这张牌塞回了牌堆底部。</span>")
			qdel(SC)
		else
			to_chat(user, "<span class='warning'>我不能把别的牌组的牌混进来！</span>")
		update_icon()
	else if(istype(I, /obj/item/toy/cards/cardhand))
		var/obj/item/toy/cards/cardhand/CH = I
		if(CH.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(CH))
				to_chat(user, "<span class='warning'>这手牌黏在你手上了，没法放回牌堆！</span>")
				return
			cards += CH.currenthand
			user.visible_message("<span class='notice'>[user]把[user.p_their()]手里的牌放回了牌堆。</span>", "<span class='notice'>我把手里的牌放回了牌堆。</span>")
			qdel(CH)
		else
			to_chat(user, "<span class='warning'>我不能把别的牌组的牌混进来！</span>")
		update_icon()
	else
		return ..()

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, "<span class='notice'>我拿起了这副牌。</span>")

		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, "<span class='notice'>我拿起了这副牌。</span>")

	else
		to_chat(usr, "<span class='warning'>我从这儿够不着它！</span>")



/obj/item/toy/cards/cardhand
	name = "手牌"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "syndicate_hand2"
	w_class = WEIGHT_CLASS_TINY
	var/list/currenthand = list()
	var/choice = null


/obj/item/toy/cards/cardhand/attack_self(mob/user)
	user.set_machine(src)
	interact(user)

/obj/item/toy/cards/cardhand/interact(mob/user)
	var/dat = "你手上有：<BR>"
	for(var/t in currenthand)
		dat += "<A href='?src=[REF(src)];pick=[t]'>一张 [get_display_cardname(t)]。</A><BR>"
	dat += "接下来你要拿出哪张牌？"
	var/datum/browser/popup = new(user, "cardhand", "手牌", 400, 240)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.set_content(dat)
	popup.open()


/obj/item/toy/cards/cardhand/Topic(href, href_list)
	if(..())
		return
	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	if(!(cardUser.mobility_flags & MOBILITY_USE))
		return
	var/O = src
	if(href_list["pick"])
		if (cardUser.is_holding(src))
			var/choice = href_list["pick"]
			var/obj/item/toy/cards/singlecard/C = new/obj/item/toy/cards/singlecard(cardUser.loc)
			src.currenthand -= choice
			C.parentdeck = src.parentdeck
			C.cardname = choice
			C.apply_card_vars(C,O)
			C.pickup(cardUser)
			cardUser.put_in_hands(C)
			cardUser.visible_message("<span class='notice'>[cardUser]从[cardUser.p_their()]手牌中抽出了一张牌。</span>", "<span class='notice'>我从手牌里拿出了 [get_display_cardname(C.cardname)]。</span>")

			interact(cardUser)
			if(src.currenthand.len < 3)
				src.icon_state = "[deckstyle]_hand2"
			else if(src.currenthand.len < 4)
				src.icon_state = "[deckstyle]_hand3"
			else if(src.currenthand.len < 5)
				src.icon_state = "[deckstyle]_hand4"
			if(src.currenthand.len == 1)
				var/obj/item/toy/cards/singlecard/N = new/obj/item/toy/cards/singlecard(src.loc)
				N.parentdeck = src.parentdeck
				N.cardname = src.currenthand[1]
				N.apply_card_vars(N,O)
				qdel(src)
				N.pickup(cardUser)
				cardUser.put_in_hands(N)
				to_chat(cardUser, "<span class='notice'>我也把 [get_display_cardname(currenthand[1])] 一并拿出来握在手里。</span>")
				cardUser << browse(null, "window=cardhand")
		return

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == src.parentdeck)
			src.currenthand += C.cardname
			user.visible_message("<span class='notice'>[user]往[user.p_their()]手牌里添了一张牌。</span>", "<span class='notice'>我把 [get_display_cardname(C.cardname)] 加进了手牌。</span>")
			qdel(C)
			if(currenthand.len > 4)
				src.icon_state = "[deckstyle]_hand5"
			else if(currenthand.len > 3)
				src.icon_state = "[deckstyle]_hand4"
			else if(currenthand.len > 2)
				src.icon_state = "[deckstyle]_hand3"
		else
			to_chat(user, "<span class='warning'>我不能把别的牌组的牌混进来！</span>")
	else
		return ..()

/obj/item/toy/cards/cardhand/apply_card_vars(obj/item/toy/cards/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "[deckstyle]_hand2" // Another dumb hack, without this the hand is invisible (or has the default deckstyle) until another card is added.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.resistance_flags = sourceobj.resistance_flags

/obj/item/toy/cards/singlecard
	name = "纸牌"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_down_syndicate"
	w_class = WEIGHT_CLASS_TINY
	var/cardname = null
	var/flipped = 0
	pixel_x = -5


/obj/item/toy/cards/singlecard/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.is_holding(src))
			cardUser.visible_message("<span class='notice'>[cardUser]看了看[user.p_their()]手里的牌。</span>", "<span class='notice'>牌面写着：[get_display_cardname(cardname)]。</span>")
		else
			. += "<span class='warning'>你得把这张牌拿在手里才能查看！</span>"


/obj/item/toy/cards/singlecard/verb/Flip()
	set name = "翻牌"
	set hidden = 1
	set src in range(1)
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return
	if(!flipped)
		src.flipped = 1
		if (cardname)
			src.icon_state = "sc_[cardname]_[deckstyle]"
			src.name = get_display_cardname(src.cardname)
		else
			src.icon_state = "sc_Ace of Spades_[deckstyle]"
			src.name = "未知纸牌"
		src.pixel_x = 5
	else if(flipped)
		src.flipped = 0
		src.icon_state = "singlecard_down_[deckstyle]"
		src.name = "纸牌"
		src.pixel_x = -5

/obj/item/toy/cards/singlecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/))
		var/obj/item/toy/cards/singlecard/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			to_chat(user, "<span class='notice'>我把 [get_display_cardname(C.cardname)] 和 [get_display_cardname(src.cardname)] 合成了一手牌。</span>")
			qdel(C)
			qdel(src)
			H.pickup(user)
			user.put_in_active_hand(H)
		else
			to_chat(user, "<span class='warning'>我不能把别的牌组的牌混进来！</span>")

	if(istype(I, /obj/item/toy/cards/cardhand/))
		var/obj/item/toy/cards/cardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.visible_message("<span class='notice'>[user]往[user.p_their()]手牌里添了一张牌。</span>", "<span class='notice'>我把 [get_display_cardname(cardname)] 加进了手牌。</span>")
			qdel(src)
			H.interact(user)
			if(H.currenthand.len > 4)
				H.icon_state = "[deckstyle]_hand5"
			else if(H.currenthand.len > 3)
				H.icon_state = "[deckstyle]_hand4"
			else if(H.currenthand.len > 2)
				H.icon_state = "[deckstyle]_hand3"
		else
			to_chat(user, "<span class='warning'>我不能把别的牌组的牌混进来！</span>")
	else
		return ..()

/obj/item/toy/cards/singlecard/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user) || !(user.mobility_flags & MOBILITY_USE))
		return
	Flip()

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]" // Without this the card is invisible until flipped. It's an ugly hack, but it works.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.attack_verb = newobj.card_attack_verb


/*
|| Syndicate playing cards, for pretending you're Gambit and playing poker for the nuke disk. ||
*/

/obj/item/toy/cards/deck/syndicate
	name = "纸牌"
	desc = "一叠纸牌。"
	icon_state = "deck_syndicate_full"
	deckstyle = "syndicate"
	card_hitsound = 'sound/blank.ogg'
	card_force = 5
	card_throwforce = 10
	card_throw_speed = 1
	card_throw_range = 7
	card_attack_verb = list("攻击", "切开", "剁切", "劈划", "割伤")
	resistance_flags = NONE

/obj/item/toy/cards/deck/tarot
	name = "塔罗牌组"
	desc = "赛立克斯赐予凡人的代言之物。借此窥见命运。切莫折角。"
	icon_state = "deck_tarot_full"
	deckstyle = "tarot"

/obj/item/toy/cards/deck/tarot/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/suit in list("Pentacles", "Swords", "Wands", "Cups"))
		cards += "Ace of [suit]"
		for(var/i in 2 to 10)//Changed from 1 to 10, changed given 1s don't exist.
			cards += "[i] of [suit]"
		for(var/person in list("Page", "Knight", "Queen", "King"))
			cards += "[person] of [suit]"
	for(var/trump in list("The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lover", "The Chariot", "Justice", "The Hermit", "The Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World", "The Fool"))
		cards += trump

/obj/item/toy/cards/deck/tarot/majorarcana

/obj/item/toy/cards/deck/tarot/majorarcana/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/trump in list("The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lover", "The Chariot", "Justice", "The Hermit", "The Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World", "The Fool"))
		cards += trump
