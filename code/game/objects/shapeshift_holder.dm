/obj/shapeshift_holder
	name = "变形载体"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ON_FIRE | UNACIDABLE | ACID_PROOF
	var/mob/living/stored
	var/mob/living/shape
	var/restoring = FALSE
	var/datum/soullink/shapeshift/slink
	var/obj/effect/proc_holder/spell/targeted/shapeshift/source

/obj/shapeshift_holder/Initialize(mapload,obj/effect/proc_holder/spell/targeted/shapeshift/source,mob/living/caster)
	. = ..()
	src.source = source
	shape = loc
	if(!istype(shape))
		CRASH("shapeshift holder created outside mob/living")
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)
	stored.forceMove(src)
	stored.notransform = TRUE
	if(source.convert_damage)
		var/damage_percent = (stored.maxHealth - stored.health)/stored.maxHealth;
		var/damapply = damage_percent * shape.maxHealth;

		shape.apply_damage(damapply, source.convert_damage_type, forced = TRUE);

	slink = soullink(/datum/soullink/shapeshift, stored , shape)
	slink.source = src

/obj/shapeshift_holder/Destroy()
	if(!restoring)
		restore()
	stored = null
	shape = null
	. = ..()

/obj/shapeshift_holder/Moved()
	. = ..()
	if(!restoring || QDELETED(src))
		restore()

/obj/shapeshift_holder/handle_atom_del(atom/A)
	if(A == stored && !restoring)
		restore()

/obj/shapeshift_holder/Exited(atom/movable/AM)
	if(AM == stored && !restoring)
		restore()

/obj/shapeshift_holder/proc/casterDeath()
	//Something kills the stored caster through direct damage.
	if(source.revert_on_death)
		restore(death=TRUE)
	else
		shape.death()

/obj/shapeshift_holder/proc/shapeDeath()
	//Shape dies.
	if(source.die_with_shapeshifted_form)
		if(source.revert_on_death)
			restore(death=TRUE)
	else
		restore(knockout=source.knockout_on_death)

/obj/shapeshift_holder/proc/restore(death=FALSE, knockout=0)
	restoring = TRUE
	qdel(slink)
	if (stored)
		stored.forceMove(get_turf(src))
		stored.notransform = FALSE

		// leave a track to indicate something has shifted out here
		var/obj/effect/track/the_evidence = new(stored.loc)
		the_evidence.handle_creation(stored)
		the_evidence.track_type = "逐渐化作人形足迹的兽类脚印"
		the_evidence.ambiguous_track_type = "可疑的脚印"
		the_evidence.base_diff = 6
		if (knockout)
			stored.Unconscious(knockout, TRUE, TRUE)
			stored.visible_message(span_boldwarning("[stored]在一阵令人作呕的血肉扭动中变回了人形，随即昏倒在地！"), span_userdanger("我急忙挣脱先前形体那正在衰败的生命力，可这份负担还是太沉重了"))
			to_chat(stored, span_crit("……一片黑暗……"))

	if(shape && shape.mind)
		shape.mind?.transfer_to(stored)
	if(death)
		stored.death()
	else if(stored && source.convert_damage)
		stored.revive(full_heal = TRUE, admin_revive = FALSE)

		var/damage_percent = (shape.maxHealth - shape.health)/shape.maxHealth;
		var/damapply = stored.maxHealth * damage_percent

		stored.apply_damage(damapply, source.convert_damage_type, forced = TRUE)
	to_chat(stored, span_notice("Bug notice: If you can no longer see emotes, move to a different z level and back (up/down a level). This is a known bug."))
	qdel(shape)
	if (!QDELETED(src))
		qdel(src)

/datum/soullink/shapeshift
	var/obj/shapeshift_holder/source

/datum/soullink/shapeshift/ownerDies(gibbed, mob/living/owner)
	if(source)
		source.casterDeath(gibbed)

/datum/soullink/shapeshift/sharerDies(gibbed, mob/living/sharer)
	if(source)
		source.shapeDeath(gibbed)
