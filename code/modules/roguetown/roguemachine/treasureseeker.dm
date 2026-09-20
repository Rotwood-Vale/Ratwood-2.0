// A bathhouse cousin of the HEADEATER: swallows treasures instead of skulls and
// spirits them away to the Nightmistress's vault. Every consignment is entered
// into the BRASSFACE's Hoard ledger, and the hoard pays interest on the vault's
// contents via the BMtreasury subsystem.
/obj/structure/roguemachine/headeater/treasureseeker
	name = "TREASURE SEEKER"
	desc = "A kin of the HEADEATER, its brass gullet re-tuned by the Bathhouse for gentler appetites. Feed it any trinket and the prize is whisked away to the Nightmistress's vault - where the hoard remembers its worth."

/obj/structure/roguemachine/headeater/treasureseeker/examine_extra(mob/user)
	. = list()
	. += span_info("Left-click with an item to consign it to the Nightmistress's vault. Right-click to consign every item on the tile before it.")
	. += span_smallnotice("Each consignment is entered into the BRASSFACE's Hoard ledger, and the hoard pays interest on the vault's treasures.")
	. += span_smallnotice("Dross is refused - it swallows only what the hoard can turn a profit on, leaving worthless trinkets, loose coin and containers behind.")

/// Collects the open floor turfs of the Nightmistress's vault area.
/obj/structure/roguemachine/headeater/treasureseeker/proc/get_vault_turfs()
	var/area/vault_area = GLOB.areas_by_type[/area/rogue/outdoors/exposed/bath/vault]
	if(!vault_area)
		return list()
	var/list/turfs = list()
	for(var/turf/open/floor/vault_floor in vault_area)
		turfs += vault_floor
	return turfs

/// Records one consigned item in the hoard ledger. Returns the item's appraised value.
/obj/structure/roguemachine/headeater/treasureseeker/proc/log_consignment(obj/item/I, mob/user)
	var/value = I.get_real_price() || 0
	SSBMtreasury.add_hoard_log("deposit", I.name, value, user.real_name)
	return value

/obj/structure/roguemachine/headeater/treasureseeker/attackby(obj/item/I, mob/user, params)
	var/mob/living/L = user
	if(istype(L) && L.used_intent && L.used_intent.type == INTENT_HARM)
		return // Harm intent bashes the machine; heads and dross alike are refused.
	if(!SSBMtreasury.generates_profit(I))
		to_chat(user, span_warning("[src] sniffs at [I] and turns its brass nose up - the hoard has no taste for such dross."))
		return TRUE
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src] rattles hollowly - the Nightmistress's vault cannot be reached."))
		return TRUE
	if(!user.transferItemToLoc(I, pick(turfs)))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return TRUE
	log_consignment(I, user)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	to_chat(user, span_danger("[src] gulps down [I], whisking it away to the Nightmistress's vault."))
	return TRUE

/obj/structure/roguemachine/headeater/treasureseeker/attack_right(mob/user)
	var/turf/front = get_step(src, dir)
	if(!front)
		return
	var/list/to_ship = list()
	var/rejected = 0
	for(var/obj/item/I in front.contents)
		if(I.anchored)
			continue
		if(!SSBMtreasury.generates_profit(I)) // Dross is left behind.
			rejected++
			continue
		to_ship += I
	if(!length(to_ship))
		if(rejected)
			to_chat(user, span_warning("[src] turns its brass nose up at the dross before it - nothing there would fatten the hoard."))
		else
			to_chat(user, span_info("Nothing glitters upon the tile before [src]."))
		return
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src] rattles hollowly - the Nightmistress's vault cannot be reached."))
		return
	var/shipped = 0
	for(var/obj/item/I in to_ship)
		if(I.loc != front) // Something else grabbed it mid-gulp.
			continue
		I.forceMove(pick(turfs))
		log_consignment(I, user)
		shipped++
	if(shipped)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		to_chat(user, span_danger("[src] gulps down [shipped] treasure[shipped > 1 ? "s" : ""], whisking them away to the Nightmistress's vault."))
		if(rejected)
			to_chat(user, span_warning("[src] leaves [rejected] trifle[rejected > 1 ? "s" : ""] untouched - the hoard has no taste for such dross."))
