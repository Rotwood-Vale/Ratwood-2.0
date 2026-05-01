// Keys for the Criminal Underbelly. Use underbelly_ as the prefix for all lockids.

/obj/item/roguekey/underbelly/scum
	name = "rusted iron key"
	desc = "Rusted and clearly not meant for just any door."
	icon_state = "rustkey"
	lockid = "underbelly_scum"

/obj/item/roguekey/underbelly/boss
	name = "blackened iron key"
	desc = "Heavy and well-worn."
	icon_state = "rustkey"
	lockid = "underbelly_boss"

// Single-use pass coin for the Doorman. Dark-stained silver, consumed on use.
/obj/item/roguecoin/scum_pass
	name = "marked coin"
	desc = "A ziliqua with a small notch cut into its edge and a dark stain pressed into the face. It means nothing to most."
	icon = 'modular_underbelly/sprites/underbelly_coinage.dmi'
	icon_state = "silver"
	color = null
	sellprice = 0
	base_type = "scum_pass_marked"
	plural_name = "marked coins"
	static_price = TRUE
	simpleton_price = TRUE

/obj/item/roguecoin/scum_pass/update_icon()
	return

/obj/item/roguecoin/scum_pass/Crossed(atom/movable/AM)
	return

/obj/item/roguecoin/scum_pass/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/roguecoin))
		return
	return ..()

// Reusable variant. Persists between uses but enforces a cooldown so it can't be spammed.
/obj/item/roguecoin/scum_pass/etched
	name = "etched coin"
	desc = "An older, heavier ziliqua. Engraved on the face is a sigil too deliberate to be decorative. Worn smooth at the rim. Whoever holds it is known."
	icon_state = "gold"
	color = null
	base_type = "scum_pass_etched"
	plural_name = "etched coins"
	/// world.time we last opened a Doorman with this. Cooldown enforced inside the Doorman attackby.
	var/pass_last_used = 0
	/// Time between uses. The coin stays put, but it won't take you through twice in five minutes.
	var/pass_cooldown = 5 MINUTES
