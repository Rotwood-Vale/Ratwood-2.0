/obj/effect/proc_holder/spell/targeted/touch/lesserknock
	name = "次级开锁术"
	desc = "一道简单法术，将奥术聚为开锁工具。若将其用在门之外的东西上，法术就会消散。"
	clothes_req = FALSE
	drawmessage = "我准备施展一道微弱的奥术咒法。"
	dropmessage = "我释放了这股微弱的奥术焦点。"
	school = "transmutation"
	overlay_state = "rune4"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/lesserknock
	spell_tier = 1
	invocations = list("微启其锁。")
	invocation_type = "whisper" // It is a fake stealth spell (lockpicking is very loud)
	hide_charge_effect = TRUE
	cost = 2 // Utility and needs lockpicking skills

/obj/effect/proc_holder/spell/targeted/touch/lesserknock/miracle
	name = "马西奥斯开锁祷言"
	desc = "向自由之神献上的一段简短祷词，会凝成一件开锁工具。若将其用在门之外的东西上，法术就会消散。" //Slightly more appropriate
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "lockpick"
	miracle = TRUE
	devotion_cost = 30
	invocations = list("由一化众")
	invocation_type = "whisper" // It is a fake stealth spell (lockpicking is very loud)
	associated_skill = /datum/skill/magic/holy

/obj/item/melee/touch_attack/lesserknock
	name = "幽光撬锁针"
	desc = "一根微微发光的撬锁针，仿佛由奥术的奥秘勉强维系成形。想令其消散，只要把它用在门之外的东西上即可。"
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#3FBAFD" // spooky magic blue color that's also used by presti
	picklvl = 0.99
	max_integrity = 30
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
