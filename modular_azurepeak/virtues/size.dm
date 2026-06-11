/datum/virtue/size/giant
	name = "巨人"
	desc = "我从小就比常人更高大、更强壮，也更能扛。我走起路来总是沉重笨拙，而我那惊人的体型甚至能撞开脆弱的木门。"
	added_traits = list(TRAIT_BIGGUY, TRAIT_DEATHBYSNUSNU)
	custom_text = "增大你的角色体型。"

/datum/virtue/size/giant/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()
	recipient.change_stat("constitution", 1)
