// Massive pintle extras: insertion failure and receiver thoughts during penetration.

GLOBAL_LIST_INIT(massive_pintle_lines, list(
	"It's so big... I can feel it in my stomach...",
	"How is this even fitting inside me?",
	"I'm so full... I can't think...",
	"It's stretching me apart...",
	"I'm going to be ruined for anyone else...",
))

GLOBAL_LIST_INIT(massive_pintle_panic_lines, list(
	"FUCK FUCK FUCK-THIS THING IS GONNA KILL ME",
	"IT'S TOO BIG IT'S TOO BIG IT'S TOO BIG",
	"I'M GOING TO SPLIT IN HALF!",
	"GODS, IT'S IN MY GUTS!",
	"I CAN'T TAKE IT, I CAN'T TAKE IT!",
	"IT'S GOING TO COME OUT OF MY MOUTH!",
	"THIS IS HOW I DIE!",
))

GLOBAL_LIST_INIT(massive_pintle_mouth_lines, list(
	"I can't breathe... it's all the way down my throat...",
	"My jaw is going to dislocate...",
	"It's so thick I can't even swallow...",
	"I can feel it in my chest...",
))

GLOBAL_LIST_INIT(massive_pintle_mouth_panic_lines, list(
	"IT'S IN MY LUNGS!",
	"CAN'T BREATHE CAN'T BREATHE CAN'T BREATHE",
	"MY JAW'S GOING TO SNAP!",
	"I'M GOING TO CHOKE ON IT AND DIE!",
))

/// Describes the holes in a sex part bitfield, e.g. "cunt and ass".
/proc/sex_part_orifice_name(part)
	var/list/names = list()
	if(part & SEX_PART_CUNT)
		names += "cunt"
	if(part & SEX_PART_ANUS)
		names += "ass"
	if(part & SEX_PART_SLIT_SHEATH)
		names += "slit"
	if(part & SEX_PART_JAWS)
		names += "mouth"
	return english_list(names, nothing_text = "body")

/// For action between us and our target: whoever a massive pintle is going into, or null.
/// The receiver is the target when our cock goes in, or us when we ride or suck theirs.
/datum/sex_controller/proc/get_massive_pintle_receiver(datum/sex_action/action)
	if(!action || !target || target == user)
		return null
	if(action.is_cock_penetration())
		var/obj/item/organ/penis/pintle = user.getorganslot(ORGAN_SLOT_PENIS)
		return pintle?.massive ? target : null
	if(action.is_cock_penetration(cock_on_target = TRUE))
		var/obj/item/organ/penis/pintle = target.getorganslot(ORGAN_SLOT_PENIS)
		return pintle?.massive ? user : null
	return null

/// The receiver's sex part used by action, given who the receiver is.
/datum/sex_controller/proc/get_receiver_part(datum/sex_action/action, mob/living/carbon/human/receiver)
	return receiver == target ? action.target_sex_part : action.user_sex_part

/// Rolls whether a massive pintle fails to fit when action starts. Returns TRUE and shows the messages on a fail.
/datum/sex_controller/proc/try_massive_insertion_fail(datum/sex_action/action)
	var/mob/living/carbon/human/receiver = get_massive_pintle_receiver(action)
	if(!receiver || !prob(MASSIVE_PENIS_INSERT_FAIL_CHANCE))
		return FALSE
	var/orifice = sex_part_orifice_name(get_receiver_part(action, receiver))
	var/vision = do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE
	if(receiver == target)
		user.visible_message(span_warning("[user] tries to force [user.p_their()] massive cock into [target]'s [orifice], but it's simply too big!"), vision_distance = vision)
	else
		user.visible_message(span_warning("[user] tries to take [target]'s massive cock into [user.p_their()] [orifice], but it's simply too big!"), vision_distance = vision)
	to_chat(receiver, span_warning("It won't fit...!"))
	log_combat(user, target, "Failed to start sex action (massive pintle too big): [action.name]")
	return TRUE

/// Each thrust, maybe gives the receiver of a massive pintle a private thought. The pool depends on our force and on whether it's their mouth.
/datum/sex_controller/proc/massive_pintle_receiver_line(datum/sex_action/action)
	var/mob/living/carbon/human/receiver = get_massive_pintle_receiver(action)
	if(!receiver)
		return
	var/panic = force >= SEX_FORCE_HIGH
	if(!prob(panic ? MASSIVE_PENIS_PANIC_LINE_CHANCE : MASSIVE_PENIS_LINE_CHANCE))
		return
	var/mouth = get_receiver_part(action, receiver) & SEX_PART_JAWS
	if(panic)
		to_chat(receiver, span_boldwarning(pick(mouth ? GLOB.massive_pintle_mouth_panic_lines : GLOB.massive_pintle_panic_lines)))
	else
		to_chat(receiver, span_love(pick(mouth ? GLOB.massive_pintle_mouth_lines : GLOB.massive_pintle_lines)))
