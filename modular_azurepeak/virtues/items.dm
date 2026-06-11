/datum/virtue/items/rich
	name = "富有而精明"
	desc = "凭借好运或精明筹划，我积攒下了一笔相当可观的财富。我能看出交谈对象及其随身之物的价值，也暗中藏了一些钱币以备不时之需。"
	added_traits = list(TRAIT_SEEPRICES)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))	//So the spell would work
	custom_text = "获得“世俗鉴价”法术，可让你判断某人随身携带以及存放在神经锁中的财富有多少。"
	added_stashed_items = list("沉甸甸的钱袋" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)	
/datum/virtue/items/rich/apply_to_human(mob/living/carbon/human/recipient)
	recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/virtue/items/arsonist
	name = "纵火狂"
	desc = "我喜欢看着世界燃烧，因此我私藏了两枚威力强大的燃烧弹，好让这一切成真。"
	added_skills = list(list(/datum/skill/craft/alchemy, 1, 6))
	added_traits = list(TRAIT_ALCHEMY_EXPERT) // Kaboom
	added_stashed_items = list("燃烧弹#1" = /obj/item/bomb,
								"燃烧弹#2" = /obj/item/bomb
	)
