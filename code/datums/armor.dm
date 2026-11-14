#define ARMORID "armor-[blunt]-[slash]-[stab]-[piercing]-[fire]-[acid]-[magic]-[bullet]"

/proc/getArmor(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0, bullet = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, slash, stab, piercing, fire, acid, magic, bullet)

/datum/armor
	datum_flags = DF_USE_TAG
	/// better defined as area pressure melee
	var/blunt
	/// better defined as line pressure melee
	var/slash
	/// better defined as point pressure melee
	var/stab
	/// basically projectiles
	var/piercing
	/// protection against burning
	var/fire
	/// protection against pools of acid
	var/acid
	/// protection against magical attacks (make this adjustable via rune enchantments or something)
	var/magic
	/// protection against the cannon (this can be reused for guns when we redo them)
	var/bullet

/datum/armor/New(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0, bullet = 0)
	src.blunt = blunt
	src.slash = slash
	src.stab = stab
	src.piercing = piercing
	src.fire = fire
	src.acid = acid
	src.magic = magic
	src.bullet = bullet
	
	tag = ARMORID

/datum/armor/proc/modifyRating(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, acid = 0, magic = 0, bullet = 0)
	return getArmor(src.blunt+blunt, src.slash+slash, src.stab+stab, src.piercing+piercing,src.fire+fire, src.acid+acid, src.magic+magic, src.bullet+bullet)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, stab+modifier, piercing+modifier,fire+modifier, acid+modifier, magic+modifier, bullet+modifier)

//TODO! PORT BLACKSTONE BLUNT/SLASH/STAB ARMOR DEFINES!!!!!!
/datum/armor/proc/multiplymodifyAllRatings(modifier = 0)
	return getArmor(blunt*modifier, slash*modifier, stab*modifier, piercing*modifier, fire*modifier, acid*modifier, magic*modifier, bullet*modifier)

/datum/armor/proc/setRating(blunt, slash, stab, piercing, fire, acid, magic, bullet)
	return getArmor((isnull(blunt) ? src.blunt : blunt),\
					(isnull(slash) ? src.slash : slash),\
					(isnull(stab) ? src.stab : stab),\
					(isnull(piercing) ? src.piercing : piercing),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(magic) ? src.magic : magic),\
					(isnull(bullet) ? src.bullet : bullet))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list("blunt" = blunt, "slash" = slash, "stab" = stab, "piercing" = piercing, "fire" = fire, "acid" = acid, "magic" = magic, "bullet" = bullet)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, stab+AA.stab, piercing+AA.piercing, fire+AA.fire, acid+AA.acid, magic+AA.magic, bullet+AA.bullet)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt, slash-AA.slash, stab-AA.stab, piercing-AA.piercing, fire-AA.fire, acid-AA.acid, magic-AA.magic, bullet-AA.bullet)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
