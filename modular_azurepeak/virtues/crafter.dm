// Virtues that let you unlock crafter role
/datum/virtue/utility/blacksmith
	name = "Blacksmith's Apprentice (5 TRI)"
	triumph_cost = 5 //Gives access to level 2 in smithing crafting weapon and armorsmithing. Makes it so you can start smithing night 1 and be at legendary by night 3. Bad.
	desc = "In my youth, I worked under a skilled blacksmith, honing my skills with an anvil."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/weaponsmithing, 2, 2),
						list(/datum/skill/craft/armorsmithing, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2)
	)

/datum/virtue/utility/tailor
	name = "Tailor's Apprentice (2 TRI)"
	triumph_cost = 2 //Gives a bunch of useful shit including crafting skill, but isn't too powerful.
	desc = "In my youth, I worked under a skilled tailor, studying fabric and design."
	added_traits = list(TRAIT_SEWING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
	)
	added_stashed_items = list(
		"Needle" = /obj/item/needle,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors
	)

/datum/virtue/utility/physician
	name = "Physician's Apprentice (4 TRI)"
	triumph_cost = 4 //Medicine and Alchemy together are a huge nono, atop of medicine and alchemy expert perks... Who the fuck thought this was a good idea?
	desc = "In my youth, I worked under a skilled physician, studying medicine and alchemy."
	added_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	added_stashed_items = list("Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/misc/medicine, 2, 2)
	)

/datum/virtue/utility/physician/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


/datum/virtue/utility/hunter
	name = "Hunter's Apprentice (5 TRI)"
	triumph_cost = 5 //Survival Expert is worth more than sewing expert, and this gets essentially the same skillblock as Tailor's Apprentice with bonus tracking. Lol.
	desc = "In my youth, I trained under a skilled hunter, learning how to butcher animals and work with leather/hide."
	added_traits = list(TRAIT_SURVIVAL_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
						list(/datum/skill/misc/tracking, 2, 2)
	)

/datum/virtue/utility/artificer
	name = "Artificer's Apprentice (5 TRI)"
	triumph_cost = 5 //I shouldn't need to explain why getting level 2 in almost everything related to masonwork is absolutely unfortunate because of how people use it on vanguard/etc to build megaforts.
	desc = "In my youth, I worked under a skilled artificer, studying construction and engineering."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/craft/masonry, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/craft/ceramics, 2, 2)
	)
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/wood,
		"Chisel" = /obj/item/rogueweapon/chisel,
		"Hand Saw" = /obj/item/rogueweapon/handsaw,
		"Blowing Pipe" = /obj/item/rogueweapon/blowrod
	)

/datum/virtue/utility/mining
	name = "Miner's Apprentice (4 TRI)"
	added_traits = list(TRAIT_SMITHING_EXPERT) // Not sure whether smithing or homestead but given mining goods goes into smithing this fits better?
	triumph_cost = 4 //This doesn't give much... IN THEORY. In practice, this makes towner roles able to just pick up a pickaxe and kill any bandit they see.
	desc = "The dark shafts, the damp smells of ichor and the laboring hours are no stranger to me. I keep my pickaxe and lamptern close, and have been taught how to mine well."
	added_stashed_items = list(
		"Steel Pickaxe" = /obj/item/rogueweapon/pick/steel,
		"Lamptern" = /obj/item/flashlight/flare/torch/lantern,
		"Ore Bag" = /obj/item/storage/hip/orestore/bronze,
	)
	added_skills = list(list(/datum/skill/labor/mining, 3, 5)) //Lets not give people legendary mining roundstart so they can go frag out with blacksteel picks.
