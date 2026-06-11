/datum/skill/misc
	abstract_type = /datum/skill/misc
	name = "杂项"
	desc = ""

/datum/skill/misc/athletics
	name = "体能"
	desc = "每级提高 5 点最大耐力，并使剧烈活动时消耗营养的概率每级降低 16%。"
	dreams = list(
		"...your lungs burn and you can no longer feel your breath as the pale volf's howling grows distant. You should have collapsed three times over, but the urge to survive pushes you past your bodily limits...",
		"...the incline before you is steep, and the barrel weighs heavy in your hands but you press on. This is no longer a hill. This is your mountain and with every strained breath, you inch closer to its summit, determined to conquer it..."
	)
	expert_name = "运动员"

/datum/skill/misc/climbing
	name = "攀爬"
	desc = "提高攀爬速度。攀爬大多数石墙至少需要 3 级，攀爬覆苔石墙则需要 4 级。"
	dreams = list(
		"...your elbows are scraped and your hands, calloused but you have a firm hold on the rock wall. With a deep breath and a sudden lunge, you reach upward, searching for another handhold. Your foot slips and gravity pulls at you, your heart racing as you plummet into the void...",
		"...the meadows are shining green and the sun is behind a covering of clouds. Your childhood friend taunts you, his white toothed grin matching his pale eyes before dashing up a tree. You clamber after him and make your way upwards..."
	)
	expert_name = "攀登者"

/datum/skill/misc/reading
	name = "识字"
	desc = "每级提高 2% 成功阅读法术书的概率，同时增强书写与理解技能书的能力。至少需要 1 级才能识字并阅读各类文字。"
	dreams = list(
		"...amidst the void, strange symbols and glyphs make their way into your mind. They re-arrange themselves unceasingly, indecipherable truths speaking in silent voices. The clouds part, and they fall still within the moonlight. The meaning of the gift is revealed...",
		"...you cut into your meal, juices leaking from the edges of the book. Your mind expands throughout your meal, and you are about halfway through the meal when an old, bearded chef asks you how you like his specialty..."
	)
	expert_name = "读书人"

/datum/skill/misc/swimming
	name = "游泳"
	desc = "每级略微减少游泳时消耗的耐力。"
	dreams = list(
		"...there is no light in the suffocating dark. You choose a direction and your arms and legs tear at the thick, oily waters in a desperate attempt to reach the surface. Your heart pounds, and your body yearns for another breath...",
		"...a wave rocks to the side of the boat, and you tumble into the yawning abyss. Lightning splits the sky as the old captain hurls a buoy into the churning sea. Salt water burns your lungs as you thrash and claw, struggling towards your lifeline...",
		"...the current  the beach draws you out further into the ocean, relentless and fast. Your muscles burn as you struggle, every stroke a battle. 'Across, not against!' a voice from your past chides, guiding you as you break free of the riptide's grasp..."
		
	)
	expert_name = "泳者"

/datum/skill/misc/stealing
	name = "扒窃"
	desc = "提高我偷窃成功且不被发现的概率。"
	dreams = list(
		"...one moment, you stand in line at the smithy, waiting behind the captain of the guard. The next, you're at the merchant's stall, shadowing a travelling noble. Moments later, cries of 'Thief!' echo throughout town, while you count out hundreds of mammon...",
		"...a piss-stinking, beggar with wooden-arms and a lice-ridden beard calls out to you, a rotten-toothed smile on his face. 'Spare a zenny for the wretched?' he asks. As you step away from the wretch, you feel strangely light at your waist. A glance down reveals your now empty pouch -- and two wooden arms abandoned on the ground where he had been sitting..."
	)
	expert_name = "扒手"

/datum/skill/misc/sneaking
	name = "潜行"
	desc = "提高潜行成功且不被发现的概率，并降低留下踪迹的几率。"
	dreams = list(
		"...the four connected houses, orthogonally aligned, have a small dip at the center of their slanted rooftops. Your crow's nest. Your safe haven. The only light that can reach you here is what Noc takes from Astrata, and this night is particularly veiled. It's concealing and comforting, safe from the town guard, as you curl up to rest...",
		"...the pale volf gets on its hindlegs, and howls unto the moon. It seeks prey, and you happen to be unfortunate enough to be in its forest. This is the third time it has circled you, as you press yourself tighter into the hollow tree, completely still..."
	)
	expert_name = "潜行者"

/datum/skill/misc/lockpicking
	name = "撬锁"
	desc = "加快撬锁速度并提高成功率。"
	dreams = list(
		"...your pick feels like an extension of your fingers as you nudge the final pin into place. The chest creaks open, revealing a glint of gold that was never meant to see the light of day...",
		"...the street and the merchant's shop stands silent in the moonlight as you kneel before the lock. Each quiet click draws you closer to riches--or discovery. With a soft snap, the door opens, allowing you to slip inside...",
		"...the old woman fumbles at her empty pockets, her face etched with worry. With a deft hand and a keen ear the lock yields and you push the door open, returning her to the warmth of her home..."
	)
	expert_name = "锁匠"

/datum/skill/misc/riding
	name = "骑术"
	desc = "提高骑乘坐骑时的移动速度，以及上下坐骑的速度。"
	dreams = list(
		"...the bog becomes more tolerable when it is not your foot that has to tread upon it. It took some coin, but your travels are much smoother atop your trustworthy steed...",
		"...the landsknecht thrusts their pole-arm at your steed and it bucks wildly. Lurching forwards, you interpose your shield to the weapon and feel your balance shift. Flexing every muscle in your core and legs, you barely manage to remain mounted..."
	)
	expert_name = "骑手"

/datum/skill/misc/music
	name = "音乐"
	desc = "每级提高音乐缓解压力的效果。达到 4 级及以上时，可演奏自定义曲目。"
	dreams = list(
		"...offstage, anxiety grips you, sweat beading on your brow. But onstage, you are as still as a winter night, your voice steady and clear. Curiosity pulls your audience in as you begin to sing...",
		"...you raise your hands to the strings and draw the crowds attention unto yourself. The music comes easily out of you, and your lyre is like a second voice...",
		"...your audience moves under the music like grass against the wind. With a voice bold and boisterous, you sing of the comet's first coming, each note soaring proudly into the air...",
		"...the heat of the bonfire causes sweat to drip down your face. The crowd moves with fervor, their chants rising in rhythm with each beat. You can no longer tell if they follow your tempo or whether your hands obey the beating of their hearts. Tonight, the drum and their spirits thunder as one..."
	)
	expert_name = "乐师"

/datum/skill/misc/medicine
	name = "医术"
	desc = "提高外科手术与缝合伤口的速度和成功率。"
	dream_cost_base = 3
	dreams = list(
		"...the beak-masked doctor leans over the elven corpse, tugging and slicing at a mass of strange, dark flesh. 'The appendix,' he mutters as he holds it aloft. 'Longer in this species of kin than others, adapted for their plant-rich diets.' He gestures for you to observe more closely, his tone as clinical as his blade...",
		"...you stand among seven other students the air thick with anticipation. Before you, two doctors clad in obscuring robes loom. Their masks set them apart: one an owl, wise and flat; the other a crow, inquisitive and sharp. The crow's voice cuts through the silence, instructing on the purpose of each tool laid before you...",
		"...a maskless void drags a veiled corpse into the center of the theater. The crow hands them a single coin, a silent exchange, and the faceless one departs. The lesson commences, and the owl pulls apart the layers of the torso like a macabre curtain; skin, fat and muscle giving way to revealing the liver, heart, stomach and other actors...",
		"...a student to your left pales, her queasiness overwhelming before she faints. You steel yourself, and look at the voidlike ribcage in the torso before you. Well-preserved chunks of flesh lie beside it, waiting for you to restore them to their rightful places..."
	)
	expert_name = "医师"
	max_untraited_level = SKILL_LEVEL_EXPERT // We'll let people get to Expert as an exception because reviving someone is very important to keep players in round
	trait_uncap = list(TRAIT_MEDICINE_EXPERT = SKILL_LEVEL_LEGENDARY)

/datum/skill/misc/tracking
	name = "追踪"
	desc = "提高发现踪迹的概率，并增加我能从中获取的信息量，同时受感知属性影响。 \n \
	达到专家级及以上后，我可以标记踪迹的目标以追索其位置。 \n \
	达到大师级及以上后，我可以发现隐形生物。 \n \ 可通过右键点击眼睛图标进行追踪。"
	dreams = list(
		"... your feet sink into the mud, forcing you to stop and re-evaluate. The storm is close, but not close enough, so you retrace your steps. Left, right, left, until you can manage to step on solid ground once more, taking a new route...",
		"... you kneel, taking a deep look at the floor, studying the slightly sunk shapes in the dirt. Paw-tracks, one after the other, heading up a hill. With a smile, you carry on...",
		"... the blood may have gotten lost in the rain, but the wounded man's boots are as fresh as jackberries, perfectly marked in the sand. You raise your bow, nock an arrow, and carefully trace them towards a cave..."
	)
	expert_name = "追迹者"
