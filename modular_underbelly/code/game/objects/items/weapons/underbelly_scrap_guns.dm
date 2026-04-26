/*
	UNDERBELLY SCRAP GUNS
	Poorly-maintained, cobbled-together firearms found among the Scum.
	High misfire rate (25%). Don't point them at yourself.
*/

// =====================================================
// SCRAP PISTOL — based on the arquebus pistol
// =====================================================
/obj/item/gun/ballistic/firearm/arquebus_pistol/scrap_pistol
	name = "scrap pistol"
	desc = "A salvaged arquebus pistol. The barrel is tied on with rope and the firing mechanism is temperamental. \
	It might fire. It might not. It definitely hurts if it does."
	icon_state = "pistol"
	item_state = "pistol"
	force = 8
	spread = 8
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP

/obj/item/gun/ballistic/firearm/arquebus_pistol/scrap_pistol/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	if(prob(25))
		playsound(src, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 60, TRUE)
		visible_message(span_warning("[src] sputters and fails to fire."))
		return
	. = ..()

// =====================================================
// SCRAP BLUNDERBUSS — based on the blunderbuss
// =====================================================
/obj/item/gun/ballistic/firearm/blunderbuss/scrap_blunderbuss
	name = "scrap blunderbuss"
	desc = "A blunderbuss assembled from scavenged parts. The stock is cracked and the barrel doesn't quite sit straight. \
	At close range it's terrifying. More than a quarter of the time it just clicks."
	icon_state = "blunderbuss"
	item_state = "blunderbuss"
	force = 18
	spread = 20
	mag_type = /obj/item/ammo_box/magazine/internal/firearm/blunderbuss

/obj/item/gun/ballistic/firearm/blunderbuss/scrap_blunderbuss/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	if(prob(35))
		playsound(src, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 60, TRUE)
		visible_message(span_warning("[src] misfires with a miserable click."))
		return
	. = ..()

// =====================================================
// SCRAP MUSKET — based on the arquebus (rifle)
// =====================================================
/obj/item/gun/ballistic/firearm/arquebus/scrap_musket
	name = "scrap musket"
	desc = "A long arquebus with a barrel that's been repaired more times than it's worth. \
	Slow to load, inaccurate, and prone to misfiring spectacularly. The up side is that it still fires a lead ball."
	force = 12
	spread = 12

/obj/item/gun/ballistic/firearm/arquebus/scrap_musket/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	if(prob(25))
		playsound(src, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 60, TRUE)
		visible_message(span_warning("[src] sparks and misfires, wasting the charge."))
		return
	. = ..()
