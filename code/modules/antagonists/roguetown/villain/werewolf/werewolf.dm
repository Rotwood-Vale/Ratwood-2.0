/datum/antagonist/werewolf
	name = "Verevolf"
	roundend_category = "Werewolves"
	antagpanel_category = "Werewolf"
	job_rank = ROLE_WEREWOLF
	confess_lines = list(
		"THE BEAST INSIDE ME!",
		"BEWARE THE BEAST!", // beware my /obj/item/organ/penis/knotted/big
		"MY LUPINE MARK!",
	)
	rogue_enabled = TRUE
	var/special_role = ROLE_WEREWOLF
	var/transformed
	var/transforming
	var/untransforming
	var/tf_stage = null
	var/wolfname = "Verevolf"
	var/automatically_untransforms_in_daytime = FALSE
	var/ready_to_untransform = FALSE

/datum/antagonist/werewolf/lesser
	name = "Lesser Verevolf"
	increase_votepwr = FALSE

/datum/antagonist/werewolf/lesser/roundend_report()
	return

/datum/antagonist/werewolf/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/werewolf/lesser))
		return span_boldnotice("A young lupine kin.")
	if(istype(examined_datum, /datum/antagonist/werewolf))
		return span_boldnotice("An elder lupine kin.")
	if(examiner.Adjacent(examined))
		if(istype(examined_datum, /datum/antagonist/vampire))
			if(transformed)
				return span_boldwarning("An Ancient Vampire. I must be careful!")

/datum/antagonist/werewolf/on_gain()
	greet()
	owner.special_role = name
	if(increase_votepwr)
		forge_werewolf_objectives()

	wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
	return ..()

/datum/antagonist/werewolf/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_danger("I am no longer a [special_role]!"))
	owner.special_role = null
	return ..()

/datum/antagonist/werewolf/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/werewolf/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/werewolf/proc/forge_werewolf_objectives()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/werewolf/escape_objective = new
		escape_objective.owner = owner
		add_objective(escape_objective)
		return

/datum/antagonist/werewolf/greet()
	to_chat(owner.current, span_userdanger("Since a bite long, long ago, Dendor's Madness has swelled within me. Before the Moonlight, I will sate my hallowed Lust." + "<br><br>(This guidance is to help guide the mindset of playing werewolf, rather than hard rules limiting your roleplay:" + "<br><br>The curse running through your veins has turned you into an intelligent beast of lust and desire." + "<br><br>While werewolves are quite powerful, the goal is for them to be lustful beasts. Your intent should be to fuck, although violence is a valid path to accomplish this: avoid finishing off opponents, give them room to retreat and repair, check their ERP notes and capture the wounded. Give them a tactful fight, and wrap it up with a scene when possible." + "<br><br>Ideally, keep more to the Terrorbog and the outskirts or flanks of Lowtown. Be subtle in highly populated areas, especially Hightown. When pursued by a large group, fight with the intent to scare them off, to retreat to a secluded area and to stay alive. But avoid always running away without a fight: combat is fun, after all." + "<br><br>The only method of infection is your \"<b>Voluntary Bite</b>\" ability. After you transform you'll remain a werewolf until using the \"<b>Give In To Daylight</b>\" ability, to detransform during daytime.)"))
	return ..()

/datum/antagonist/werewolf/lesser/greet()
	// leave this empty so that lesser verevolf's dont get the greeting on bite.
	// there is probably a better way to do this but this works until sm1 smarter inevitably rewrites WW.

/mob/living/carbon/human/proc/can_werewolf()
	if(!mind)
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	//No cross species pollination!!!
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/dragon))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/werewolf_check(werewolf_type = /datum/antagonist/werewolf/lesser)
	if(!mind)
		return
	var/already_wolfy = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(already_wolfy)
		return already_wolfy
	if(!can_werewolf())
		return
	return mind.add_antag_datum(werewolf_type)

/mob/living/carbon/human/proc/werewolf_infect_attempt()
	var/datum/antagonist/werewolf/wolfy = werewolf_check()
	if(!wolfy)
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return
	to_chat(src, span_danger("I feel horrible... REALLY horrible..."))
	mob_timers["puke"] = world.time
	vomit(1, blood = TRUE, stun = FALSE)
	return wolfy

/mob/living/carbon/human
	var/tmp/werewolf_bite_pending = FALSE

// Adapted from Rivermist Hollow's Voluntary Bite (AGPL-3.0), revision 8dba961e768e:
// https://github.com/sheetofseaweed/Rivermist-Hollow-Vanderlin/blob/8dba961e768ecf8b9cbbc7b8199372f6a9fead96/modular_rmh/code/modules/antagonists/werewolf/werewolf_objectives.dm
/mob/living/carbon/human/proc/can_receive_werewolf_bite(mob/living/carbon/human/source)
	if(QDELETED(source) || source == src || source.stat != CONSCIOUS || stat != CONSCIOUS)
		return FALSE
	if(!source.Adjacent(src) || !client || !mind || mind.current != src || !can_werewolf())
		return FALSE
	if(is_banned_from(ckey, list(ROLE_SYNDICATE, ROLE_WEREWOLF)))
		return FALSE
	var/datum/antagonist/werewolf/source_werewolf = source.mind?.has_antag_datum(/datum/antagonist/werewolf)
	return source_werewolf?.transformed && source.mind.current == source

/mob/living/carbon/human/proc/offer_werewolf_bite(mob/living/carbon/human/source)
	set waitfor = FALSE

	if(werewolf_bite_pending || !can_receive_werewolf_bite(source))
		return
	werewolf_bite_pending = TRUE
	var/datum/mind/recipient_mind = mind
	var/client/recipient_client = client
	var/datum/antagonist/werewolf/source_werewolf = source.mind.has_antag_datum(/datum/antagonist/werewolf)
	// Use the timed TGUI modal even when native inputs are preferred; native alerts have no timeout.
	var/datum/tgui_alert/offer = new(src, "[source] offers to turn me into a verevolf with a deliberate bite. Do I accept the curse?", "Voluntary Bite", list("Accept", "Reject"), 20 SECONDS, TRUE, GLOB.tgui_always_state)
	offer.ui_interact(src)
	offer.wait()
	var/answer
	if(!QDELETED(offer))
		answer = offer.choice
		qdel(offer)
	if(QDELETED(src))
		return
	werewolf_bite_pending = FALSE
	if(answer != "Accept")
		to_chat(src, span_notice("I refuse the verevolf's curse."))
		if(!QDELETED(source))
			to_chat(source, span_notice("[src] refuses the verevolf's curse."))
		return
	if(!can_receive_werewolf_bite(source) || mind != recipient_mind || client != recipient_client || source.mind.has_antag_datum(/datum/antagonist/werewolf) != source_werewolf)
		to_chat(src, span_warning("The moment to accept the curse has passed."))
		return
	if(!werewolf_check())
		return
	to_chat(src, span_userdanger("The verevolf's curse takes root within me!"))
	to_chat(source, span_notice("[src] accepts the verevolf's curse."))
	log_combat(source, src, "converted into a verevolf through a voluntary bite")

/mob/living/carbon/human/proc/werewolf_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin
	parent_type = /obj/item/clothing/suit/roguetown/armor/regenerating
	slot_flags = null
	name = "verevolf's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_WWOLF
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 550
	item_flags = DROPDEL
	repair_time = 20 SECONDS
	var/is_disrupted = FALSE
	repairmsg_begin = "My skin begins to slowly mend its abuse.."
	repairmsg_continue = "My skin mends some of its abuse.."
	repairmsg_stop = "My skin stops mending from the onslaught!"
	repairmsg_end = "My skin has become taut with newfound vigor!"

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/Initialize(mapload)///makes blessed silver do extra damage
	. = ..()
	// Skin armor is assigned directly rather than equipped into a clothing slot.
	if(isliving(loc))
		RegisterSignal(loc, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND), TYPE_PROC_REF(/obj/item/clothing/suit/roguetown/armor/regenerating, on_attacked_by))
	AddComponent(/datum/component/cursed_item, TRAIT_GRABIMMUNE, "HIDE", "#VOLFED")/// no one should ever see this unless they spawn in werewolf skin via the game panel. TRAIT_GRABIMMUNE is only on werewolves and the matyr during their super saiyan, should be fine.

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/on_attacked_by(datum/source)
	is_disrupted = TRUE
	deltimer(reptimer)
	reptimer = null
	combat_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/clothing/suit/roguetown/armor/regenerating, begin_repair)), 60 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/begin_repair()
	is_disrupted = FALSE
	return ..()

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(QDELETED(src))
		return
	// Match Azure Peak: smaller hits do not reset an existing repair tick.
	if(reptimer)
		if(damage_amount < 35)
			return
		to_chat(loc, span_notice(repairmsg_stop))
		deltimer(reptimer)
		reptimer = null
	if(is_disrupted || obj_integrity >= max_integrity)
		return
	reptimer = addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/clothing/suit/roguetown/armor/regenerating, begin_repair)), repair_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/armour_regen(repair_percent = 0.2 * max_integrity, skip_message = FALSE)
	return ..(obj_integrity == 0 ? 5 : repair_percent, skip_message)

/obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin/Destroy()
	deltimer(combat_timer)
	deltimer(reptimer)
	return ..()

/datum/intent/simple/werewolf
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = "genslash"
	penfactor = 50
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"

/datum/intent/mace/smash/werewolf
	name = "thrash"
	desc = "A powerful, smash of lycan muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	chargetime = 1
	penfactor = 60

/obj/item/rogueweapon/werewolf_claw
	name = "Verevolf Claw"
	desc = ""
	item_state = null
	experimental_inhand = FALSE
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 900
	max_integrity = 900
	force = 25
	block_chance = 0
	wdefense = 2
	armor_penetration = 15
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	special = /datum/special_intent/axe_swing	//Good pairing for area denial for WW's.

/obj/item/rogueweapon/werewolf_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/werewolf_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/werewolf_claw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)
