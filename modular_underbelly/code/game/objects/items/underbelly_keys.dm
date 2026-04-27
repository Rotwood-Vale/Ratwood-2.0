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
	icon_state = "s1"
	color = "#222222"
	sellprice = 0
	base_type = "s"
	plural_name = "marked coins"
	static_price = TRUE
	simpleton_price = TRUE
