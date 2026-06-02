/datum/anvil_recipe/tools
	abstract_type = /datum/anvil_recipe/tools
	i_type = "Utilities"

// Material parent classes - one skill level lower than weapons
/datum/anvil_recipe/tools/decrepit
	abstract_type = /datum/anvil_recipe/tools/decrepit
	req_bar = /obj/item/ingot/decrepit
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/copper
	abstract_type = /datum/anvil_recipe/tools/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/iron
	abstract_type = /datum/anvil_recipe/tools/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/steel
	abstract_type = /datum/anvil_recipe/tools/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/tools/gold
	abstract_type = /datum/anvil_recipe/tools/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/tools/silver
	abstract_type = /datum/anvil_recipe/tools/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/tools/tin
	abstract_type = /datum/anvil_recipe/tools/tin
	req_bar = /obj/item/ingot/tin
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/blacksteel
	abstract_type = /datum/anvil_recipe/tools/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

// --------- Copper -----------
/datum/anvil_recipe/tools/copper/sickle
	name = "Sickle, Copper (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pick
	name = "Pick, Copper (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/pitchfork
	name = "Pitchfork, Copper (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/copper
	i_type = "Tools"

/datum/anvil_recipe/tools/copper/lamptern
	name = "Lamptern, Copper"
	created_item = /obj/item/flashlight/flare/torch/lantern/copper

/datum/anvil_recipe/tools/copper/hammer
	name = "Hammer, Copper (+Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/copper
	i_type = "Tools"


// --------- ANCIENT ALLOY -----------

/datum/anvil_recipe/tools/decrepit/thresher
	name = "Thresher, Decrepit (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/hoe
	name = "Hoe, Decrepit (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/pitchfork
	name = "Pitchfork, Decrepit (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/hammer
	name = "Hammer, Decrepit (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/sickle
	name = "Sickle, Decrepit (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/decrepit
	i_type = "Tools"


/datum/anvil_recipe/tools/decrepit/tongs
	name = "Tongs, Decrepit"
	created_item = /obj/item/rogueweapon/tongs/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/pick
	name = "Pickaxe, Decrepit (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/shovel
	name = "Shovel, Decrepit (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel/decrepit
	i_type = "Tools"

/datum/anvil_recipe/tools/decrepit/sewingneedle
	name = "Needles, Decrepit (x3)"
	created_item = /obj/item/needle/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/pan
	name = "Frypan, Decrepit"
	created_item = /obj/item/cooking/pan/decrepit

/datum/anvil_recipe/tools/decrepit/agobs
	name = "Goblets x2"
	created_item = /obj/item/reagent_containers/glass/cup/decrepitgob
	createditem_num = 2

/datum/anvil_recipe/tools/decrepit/amugs
	name = "Mug, Decrepit (x3)"
	created_item = /obj/item/reagent_containers/glass/cup/decrepitmug
	createditem_num = 3


/datum/anvil_recipe/tools/decrepit/pot
	name = "Cooking Pot, Decrepit"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/decrepit


/datum/anvil_recipe/tools/decrepit/platter
	name = "Platter, Decrepit (x3)"
	created_item = /obj/item/cooking/platter/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/bowl
	name = "Bowl, Decrepit (x2)"
	created_item = /obj/item/reagent_containers/glass/bowl/decrepit

/datum/anvil_recipe/tools/decrepit/fork
	name = "Fork, Decrepit (x3)"
	created_item = /obj/item/kitchen/fork/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/spoon
	name = "Spoon, Decrepit (x3)"
	created_item = /obj/item/kitchen/spoon/decrepit
	createditem_num = 3


// --------- IRON -----------

/datum/anvil_recipe/tools/iron/blowrod
	name = "Glass Blowing Rod"
	created_item = /obj/item/rogueweapon/blowrod

/datum/anvil_recipe/tools/iron/surgerytools
	name = "Surgeon's Bag (+1 Iron, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/storage/belt/rogue/surgery_bag/full

/datum/anvil_recipe/tools/iron/torch
	name = "Fieftorches (x5) (+1 Coal)"
	additional_items = list(/obj/item/rogueore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	createditem_num = 5
	
/datum/anvil_recipe/tools/iron/pan
	name = "Frypan, Iron"
	created_item = /obj/item/cooking/pan

/datum/anvil_recipe/tools/iron/tallowpot
	name = "Tallowpot, Iron (x2) (+1 Iron)"
	created_item = /obj/item/inqarticles/tallowpot
	createditem_num = 2

/datum/anvil_recipe/tools/iron/keyring
	name = "Keyrings (x3)"
	created_item = /obj/item/storage/keyring
	createditem_num = 3

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "Needles, Iron (x3)"
	created_item = /obj/item/needle
	createditem_num = 3 // They can be refilled with fiber now

/* Movning under Engineering
/datum/anvil_recipe/tools/iron/lockpicks
	name = "Lockpicks x3"
	created_item = /obj/item/lockpick
	createditem_num = 3

/datum/anvil_recipe/tools/iron/lockpickring
	name = "Lockpickrings x3"
	created_item = /obj/item/lockpickring
	createditem_num = 3
*/

/datum/anvil_recipe/tools/iron/branding
	name = "Branding iron"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/surgery/cautery/branding

/datum/anvil_recipe/tools/iron/shovel
	name = "Shovel, Iron (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hammer
	name = "Hammer, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/iron
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/handsaw
	name = "Handsaw, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/handsaw

/datum/anvil_recipe/tools/iron/chisel
	name = "Chisel, Iron"
	created_item = /obj/item/rogueweapon/chisel

/datum/anvil_recipe/tools/iron/tongs
	name = "Tongs, Iron"
	created_item = /obj/item/rogueweapon/tongs
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/sickle
	name = "Sickle, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pick
	name = "Pickaxe, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/hoe
	name = "Hoe, Iron (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/pitchfork
	name = "Pitchfork, Iron (+2 Sticks)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/lamptern
	name = "Lampterns, Iron (x3)"
	created_item = /obj/item/flashlight/flare/torch/lantern
	createditem_num = 3

/datum/anvil_recipe/tools/iron/cups
	name = "Cups, Iron (x3)"
	created_item = /obj/item/reagent_containers/glass/cup
	createditem_num = 3

/datum/anvil_recipe/tools/iron/thresher
	name = "Thresher, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/headhook
	name = "Headhook, Iron (+2 Fibers)"
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	created_item = /obj/item/storage/hip/headhook
	i_type = "Tools"

/datum/anvil_recipe/tools/iron/scissors
	name = "Scissors"
	created_item = /obj/item/rogueweapon/huntingknife/scissors
	i_type = "Tools"

// --------- Steel -----------

/datum/anvil_recipe/tools/steel/hammer
	name = "Claw Hammer (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/steel

/datum/anvil_recipe/tools/steel/pick
	name = "Pickaxe, Steel (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/steel
	i_type = "Tools"

/datum/anvil_recipe/tools/steel/cups
	name = "Goblets x2"
	created_item = /obj/item/reagent_containers/glass/cup/steel
	createditem_num = 2

/datum/anvil_recipe/tools/steel/chefknife
	name = "Chef's Knife"
	created_item = /obj/item/rogueweapon/huntingknife/chefknife

/datum/anvil_recipe/tools/steel/cleaver
	name = "Cleaver"
	created_item = /obj/item/rogueweapon/huntingknife/cleaver

/datum/anvil_recipe/tools/steel/scissors
	name = "Scissors"
	created_item = /obj/item/rogueweapon/huntingknife/scissors/steel
	i_type = "Tools"

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver/cups
	name = "Goblets x2"
	created_item = /obj/item/reagent_containers/glass/cup/silver
	createditem_num = 2

/datum/anvil_recipe/tools/silver/cups/small
	name = "Cups x3"
	created_item = /obj/item/reagent_containers/glass/cup/silver/small
	createditem_num = 3

/datum/anvil_recipe/tools/silver/shovel
	name = "Shovel, Silver (+1 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shovel/silver

// --------- GOLD RECIPES-----------

/datum/anvil_recipe/tools/gold/cups
	name = "Goblets x2"
	created_item = /obj/item/reagent_containers/glass/cup/golden
	createditem_num = 2

/datum/anvil_recipe/tools/gold/cups/small
	name = "Cups x3"
	created_item = /obj/item/reagent_containers/glass/cup/golden/small
	createditem_num = 3

// --------- TIN -----------

/datum/anvil_recipe/tools/tin/cups
	name = "Goblets x2"
	created_item = /obj/item/reagent_containers/glass/cup/tin
	createditem_num = 2

/datum/anvil_recipe/tools/tin/cups/small
	name = "Cups x3"
	created_item = /obj/item/reagent_containers/glass/cup/tin/small
	createditem_num = 3


// --------- COOKING RECIPES -----------
/datum/anvil_recipe/tools/iron/pot
	name = "Cooking Pot, Iron"
	created_item = /obj/item/reagent_containers/glass/bucket/pot

/datum/anvil_recipe/tools/iron/kettle
	name = "Cooking Kettle, Iron"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/kettle

/datum/anvil_recipe/tools/copper/pot
	name = "Cooking Pot, Copper"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper

/datum/anvil_recipe/tools/copper/platter
	name = "Platter, Copper (x2)"
	created_item = /obj/item/cooking/platter/copper
	createditem_num = 2

/datum/anvil_recipe/tools/tin/platter
	name = "Platter, Tin (x2)"
	created_item = /obj/item/cooking/platter/pewter
	createditem_num = 2

/datum/anvil_recipe/tools/gold/platter
	name = "Platter, Gold (x2)"
	created_item = /obj/item/cooking/platter/gold
	createditem_num = 2

/datum/anvil_recipe/tools/silver/platter
	name = "Platter, Silver (x2)"
	created_item = /obj/item/cooking/platter/silver
	createditem_num = 2

/datum/anvil_recipe/tools/iron/spoon
	name = "Spoon, Iron (x3)"
	created_item = /obj/item/kitchen/spoon/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/spoon
	name = "Spoon, Tin (x3)"
	created_item = /obj/item/kitchen/spoon/tin
	createditem_num = 3

/datum/anvil_recipe/tools/iron/fork
	name = "Fork, Iron (x3)"
	created_item = /obj/item/kitchen/fork/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/fork
	name = "Fork, Tin (x3)"
	created_item = /obj/item/kitchen/fork/tin
	createditem_num = 3

/datum/anvil_recipe/tools/silver/fork
	name = "Fork, Silver (x3)"
	created_item = /obj/item/kitchen/fork/silver
	createditem_num = 3

/datum/anvil_recipe/tools/gold/fork
	name = "Fork, gold (x3)"
	created_item = /obj/item/kitchen/fork/gold
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/fork
	name = "Fork, decrepit (x3)"
	created_item = /obj/item/kitchen/fork/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/iron/bowl
	name = "bowl, iron (x2)"
	created_item = /obj/item/reagent_containers/glass/bowl/iron
	createditem_num = 2
	craftdiff = 1

// --------- CASTING TOOLS -----------

/datum/anvil_recipe/tools/crucible
	name = "Crucible"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/reagent_containers/glass/crucible
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/sprue_funnel
	name = "Sprue and Funnel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/sprue_funnel
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_axe
	name = "Axe Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/axe
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_sword
	name = "Sword Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/sword
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_knife
	name = "Knife Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/knife
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_mace
	name = "Mace Head Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/mace
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_polearm
	name = "Polearm Blade Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/polearm
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

/datum/anvil_recipe/tools/mold_plate
	name = "Plate Mold"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/plate
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "Casting"

//black steel tools

/datum/anvil_recipe/tools/blacksteel/hammer
	name = "Blacksteel hammer (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/blacksteel

/datum/anvil_recipe/tools/blacksteel/pick
	name = "Blacksteel Pickaxe (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/blacksteel

/datum/anvil_recipe/tools/blacksteel/tongs
	name = "Blacksteel Tongs"
	created_item = /obj/item/rogueweapon/tongs/blacksteel
	
// --------- HEARTBEAST TOOLS -----------
/datum/anvil_recipe/tools/heartbeast_vials
	name = "Blood vials"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_vial
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 5

/datum/anvil_recipe/tools/heartbeast_canisters
	name = "Blood canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 2

/datum/anvil_recipe/tools/aspect_canisters
	name = "Aspect canisters"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 3
