/obj/item/quicksilver
	name = "速银敷膏"
	icon_state = "quicksilver"
	possible_item_intents = list(/datum/intent/use)
	icon = 'modular_azurepeak/icons/obj/items/quicksilver.dmi'
	desc = "这是一种大胆混合了炼金术、异变之血与神圣白银的产物。这种万灵药会以受祝福的银尘强化受膏者的身体，使其免受吸血与狼化诅咒侵袭。"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 1
	drop_sound = 'sound/items/gem.ogg'
	resistance_flags = FIRE_PROOF
	is_silver = TRUE
	var/miracle_use = 0
	var/success = 0

/obj/item/quicksilver/luxinfused
	name = "赦罪银"
	icon_state = "quicksilverlux"
	desc = "这是一种大胆混合了微量净化灵辉、异变之血与神圣白银的产物。这种万灵药会以受祝福的银尘强化受膏者的身体，使其免受吸血与狼化诅咒侵袭。"

/obj/item/quicksilver/examine(mob/user)
	. = ..()
	if(miracle_use)
		. += span_notice("出于某种奇迹般的缘故，它还够再用一次。")

/obj/item/quicksilver/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	anoint(M, user)

/obj/item/quicksilver/proc/anoint(mob/living/carbon/human/M, mob/living/carbon/human/user) //Time to deconvert some antagonists
	var/inquisitor = FALSE
	if(!user.mind)
		return
	if(HAS_TRAIT(user, TRAIT_PURITAN))
		inquisitor = TRUE
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && HAS_TRAIT(user, TRAIT_INQUISITION) && HAS_TRAIT(user, TRAIT_SILVER_BLESSED))
		inquisitor = TRUE

	if(!M.mind) //Stopping null lookup runtimes
		to_chat(user, span_warning("[M]没有足以承受神圣涂敷的心智。"))
		return

	if(HAS_TRAIT(M, TRAIT_SILVER_BLESSED))
		to_chat(user, span_warning("仔细一看，[M]已经接受过速银涂敷了。"))
		return

	if(!inquisitor && !user.get_skill_level(/datum/skill/magic/holy) >= SKILL_EXP_EXPERT)
		to_chat(user, span_warning("我并不具备正确施用[src]所需的神圣知识。"))
		return

	if(user.patron in ALL_INHUMEN_PATRONS)
		to_chat(user, span_warning("这整套涂敷仪式听起来就是TEN派胡言乱语。为什么要阻止混乱？再说，这膏药还烧手。"))
		return

	if(user == M)
		to_chat(user, span_warning("我不能用这个给自己施膏。我必须找别人来完成仪式。"))
		return

	if(M.stat == DEAD)
		to_chat(user, span_warning("他们体内的灵辉既已离去，这仪式便无法再作用于他们，只会白白浪费。"))
		return

	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("我需要附近有一座圣十字，才能正确施用这东西。")) //Like Anastasis
		return

	var/datum/antagonist/werewolf/Were = M.mind.has_antag_datum(/datum/antagonist/werewolf/)
	var/datum/antagonist/werewolf/lesser/Wereless = M.mind.has_antag_datum(/datum/antagonist/werewolf/lesser/)
	var/datum/antagonist/vampire/Vamp = M.mind.has_antag_datum(/datum/antagonist/vampire)

	user.visible_message(span_notice("[user]开始用[src]为[M]施膏。"))
	if(do_after(user, 10 SECONDS, target = M))
		if(!Were && !Vamp)
			user.visible_message(span_notice("[user]用[src]涂抹了[M]的额头。"))
			ADD_TRAIT(M, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			success = 1
		else
			to_chat(M, span_userdanger("这银质药膏灼烧着我！它要把我毁掉！"))
			M.emote("agony", forced = TRUE)
			M.adjustFireLoss(25)
			M.fire_act(3,3) //Not too bad, but not a single pat to put out.
			user.visible_message(span_danger("[src]在[M]额头上猛然燃起火焰，而[user]仍试图完成施膏。"))
			if(do_after(user, 10 SECONDS, target = M))
				user.visible_message(span_danger("[user]用[src]涂抹了[M]的额头。"))
				success = 1
	if(!success)
		return

	//Delete the item, or if you're the inquisitor, you squeeze another dose out of it.
	miracle_use += 1
	if((miracle_use && !inquisitor) || miracle_use > 1)
		to_chat(user, span_notice("敷膏已经用尽了，只剩下包裹它的布。"))
		new /obj/item/natural/cloth(user.loc)
		qdel(src)
	else
		icon_state = "[initial(icon_state)]_half"
		to_chat(user, span_notice("我的审判官训练让我勉强还留出了足够再施一次膏的分量。"))


	//Werewolf deconversion
	if(Were && !Wereless) //The roundstart elder/alpha werewolf, it cannot be saved
		to_chat(M, span_userdanger("这可憎的银沉甸甸地压在我额头上。登多尔的祝福可没那么容易离我而去。"))
		user.visible_message(span_danger("速银敷膏从[M]的额头上沸腾着蒸散开来，本能般地抗拒着神圣施膏。"))
		M.Stun(30)
		M.Knockdown(30)
		return

	else if(Wereless) //A lesser werewolf can be deconverted
		if(Wereless.transformed == TRUE)
			var/mob/living/carbon/human/I = M.stored_mob
			to_chat(M, span_userdanger("这污秽的银！我的身体正被撕裂开来！"))
			M.werewolf_untransform()
			Wereless.on_removal()
			ADD_TRAIT(I, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			ADD_TRAIT(I, TRAIT_PACIFISM, POULTICE_TRAIT)
			I.emote("agony", forced = TRUE)
			I.Stun(30)
			I.Knockdown(30)
			I.Jitter(30)
			return
		else
			M.flash_fullscreen("redflash3")
			M.emote("agony", forced = TRUE)
			to_chat(M, span_userdanger("这污秽的银！它烧到了我的骨子里！"))
			Were.on_removal()
			ADD_TRAIT(M, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			M.poultice_pacify()
			M.Stun(30)
			M.Knockdown(30)
			M.Jitter(30)
			return

	else if(Vamp)
		if(Vamp.generation >= GENERATION_METHUSELAH || HAS_TRAIT(M, TRAIT_BLOODPOOL_BORN)) //Vampire Lords + their bloodpool summons cannot be deconverted.
			to_chat(M, span_userdanger("这可憎的银沉甸甸地压在我额头上。这份羞辱，直到我死去也不会忘记。"))
			user.visible_message(span_danger("速银敷膏毫不费力地从[M]的额头上沸散开来，本能般地抗拒着神圣施膏。"))
			M.Stun(30)
			M.Knockdown(30)
			return

		if(alert(M, "这敷膏正把我的本性从血脉中烧出去！我要抗拒这次施膏吗？", "银质敷膏", "屈服", "抗拒") == "抗拒") //Opt in convert, opt in deconvert
			to_chat(M, span_userdanger("这可憎的银沉甸甸地压在我额头上。但我仍归属于自己的迷醉，而我的心依旧静止。"))
			user.visible_message(span_danger("速银敷膏凶狠地从[M]的额头上沸散开来，本能般地抗拒着神圣施膏。"))
			M.Stun(30)
			M.Knockdown(30)
			return
		else
			M.flash_fullscreen("redflash3")
			M.emote("agony", forced = TRUE)
			to_chat(M, span_userdanger("这污秽的银！我那停滞的心脏竟再次跳动起来！"))
			Vamp.on_removal()
			ADD_TRAIT(M, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			M.poultice_pacify()
			M.Stun(30)
			M.Knockdown(30)
			M.Jitter(30)
			return


//A letter to give info on how to make this thing.
/obj/item/paper/inquisition_poultice_info
	name = "宗教裁判所公函"
	desc = "一封来自奥塔瓦大教堂的书信。它散发着烟卷味。"
	info = {"
		<font face=\"Segoe Script\" color=#00000>Greetings to ye, distant missionaries in these lands<br><br>This missive serves to inform of a breakthrough of alchemy.
		Enclosed is a substance, <b>Quicksilver</b>, that may be of keen use in the preservation of lyfe against those unholy creechers that are repelled by divine silver.
		We speak of the werevolf and the vampyre. Herein lies the method.<br><br>Gather an ore of silver, a vessel of blessed water- a bottle's worth shall suffice, and a
		simple strip of cloth to add structure to the poultice. Take the warm bud of a fyritius flower, and immerse it in the bleeding wound of an unholy creecher. The warmth
		of the bud will congeal this foul ichor- but make haste, as it doth soon burn itself to ash. Induce the bloodied flower to your materials- grind the silver ore into dust
		via the mortar and pestle. Any expert of the craft of alchemy may intuit the process.<br><br>The ritual anointment is complex, and must be performed by a learned holy
		cleric in proximity of a cross of the pantheon. Inquisitor, your training doth empower you, as well. When the work is finished, the recipient now is inundated with holy
		silver- and shall be fortified against the fell turning of these unholy creechers.<br><br>Take heed! This act may also salvage the lyfe of unfortunate souls who have
		recently been turned to beast. Their body's accursed resistance excites the Quicksilver to fire- but complete the rite, and they too are saved. All, except the eldest
		of Vampyre and Werevolf- we ascertain even this method cannot save them, and it will be a waste! (Albeit humbling.)<br><br>Share of this missive with any agents or
		employs that need direction in this rite.<br><br><b>PSYDON ENDURES,</b><br><i>Holy Fellowship of Research, the Grand Cathedral, the Sovereignty of Otava.</i></font>
		"}

//Pacifism callback, like adventurer spawn

/mob/living/carbon/human/proc/poultice_pacify()
	to_chat(src, span_warning("我的心智被一片银色迷雾笼罩......我无法鼓起战斗的意志。"))
	ADD_TRAIT(src, TRAIT_PACIFISM, POULTICE_TRAIT)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, poultice_unpacify)), 30 MINUTES)

/mob/living/carbon/human/proc/poultice_unpacify()
	if(QDELETED(src))
		return
	REMOVE_TRAIT(src, TRAIT_PACIFISM, POULTICE_TRAIT)
	to_chat(src, span_warning("我心中的银色迷雾散去了。我的战意又回来了。"))
