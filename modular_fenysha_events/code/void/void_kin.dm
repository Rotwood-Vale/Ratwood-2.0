/*
 * Who counts as one of the void's own.
 *
 * Mutants carry both factions, void humans get "void" from inherent_factions,
 * and alien.dm already tests for the strings directly in a dozen places - this
 * is the same test with a name on it, for the abilities that have to spare
 * their own side.
 */

/proc/is_void_kin(mob/living/kin)
	if(!istype(kin))
		return FALSE
	return ("void" in kin.faction) || ("fractal" in kin.faction)
