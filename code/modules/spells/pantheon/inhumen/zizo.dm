//Reskin + Flavor of diagnose spell w/ some different flavor. Used for Necromancers/Lich. Pickable instead of an offensive cantrip too.
/obj/effect/proc_holder/spell/invoked/diagnose/secular/zizo
	name = "Arcane Diagnosis"
	desc = "A highly-practiced reading of the body's humors and hidden ailments performed afar with left-handed magicks. Reveals a target's condition, with greater skill in medicine granting deeper detail. By embedding a Forceps on your patient, you may even identify substances within the blood; but even the most unskilled physicker can tell from a Cheele or Leech's reactions."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND //Longer than regular diagnosis range. Progress Baby!
	invocations = list("Studium Valetudo.") //Study health.
	invocation_type = INVOCATION_WHISPER
	antimagic_allowed = FALSE //Arcane, duh.

// Enochian Analyze (T?) - Comes w/ diagnosis cantrip for free, tradeoff from an offensive cantrip.
/obj/effect/proc_holder/spell/invoked/engineeranalyze/zizo
	name = "Enochian Analyze"
	desc = "Examine a structure's details through invoking Enochian magicka to see the world through Zizo's design without the need of specialised tools, close or afar."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND
	invocations = list("Studium Constructio.")
	invocation_type = INVOCATION_WHISPER
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = FALSE
