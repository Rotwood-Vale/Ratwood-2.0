GLOBAL_LIST_INIT(economic_regions, init_economic_regions())

/proc/init_economic_regions()
	var/list/result = list()
	for(var/datum/economic_region/er as anything in subtypesof(/datum/economic_region))
		var/datum/economic_region/instance = new er()
		if(!instance.region_id)
			continue
		if(instance.map_swap_only)
			continue
		result[instance.region_id] = instance
	return result

/datum/economic_region
	var/region_id
	var/name
	/// Italicized one-liner shown beneath the region name in the Lore Primer's
	/// realm regions section. The steward UI ignores it; only `description` shows there.
	var/subtitle = ""
	var/description = ""
	var/list/produces = list()
	var/list/demands = list()
	var/list/possible_standing_order_types = list()
	var/associated_marker_id
	var/is_region_blockaded = FALSE
	/// Null = this region cannot be blockaded.
	var/threat_region_id
	/// Name-day celebrants for the birthday-tribute standing order. Lives on the region so
	/// per-map identity swaps carry their own names; empty list falls back to generic text.
	var/list/order_celebrants = list()
	/// Alternate that exists only to take another region's slot on a specific map, via
	/// map_adjustment.trade_region_swaps. Skipped by init_economic_regions() so it never
	/// appears alongside the region it replaces.
	var/map_swap_only = FALSE
	// Ensure this region won't replenish blockade. Used only for Kingsfield because Kingsfield blockade is devastating and shouldn't repeat mid round.
	var/blockade_replenish_eligible = TRUE

	var/list/produces_today = list()
	var/list/demands_today = list()

	var/list/produces_day_start = list()
	var/list/demands_day_start = list()

	/// -1 = never cleared. Otherwise the cooldown window runs from this day.
	var/day_last_cleared = -1

/datum/economic_region/New()
	. = ..()
	produces_today = produces.Copy()
	demands_today = demands.Copy()
	produces_day_start = produces.Copy()
	demands_day_start = demands.Copy()
	if(!associated_marker_id)
		associated_marker_id = "[region_id]_blockade"

/datum/economic_region/proc/get_day_capacity(good_id, importing)
	var/list/today = importing ? produces_today : demands_today
	return max(0, today[good_id] || 0)

/datum/economic_region/proc/get_day_capacity_total(good_id, importing)
	var/list/day_start = importing ? produces_day_start : demands_day_start
	return max(0, day_start[good_id] || 0)

/datum/economic_region/proc/get_batch_capacity(good_id, importing)
	var/pace = (importing ? produces[good_id] : demands[good_id]) || 0
	if(pace <= 0)
		return 0
	return clamp((importing ? produces_today[good_id] : demands_today[good_id]) || 0, 0, pace)

/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "Kingsfield"
	subtitle = "The Royal Demesne, Heartland of the Vale"
	blockade_replenish_eligible = FALSE
	order_celebrants = list("Lady Marisol of Cherrybrook", "Lord Berenger the Younger", "Dame Vesalia Sundermark", "Sir Aldwin of Aubergrove")
	description = "The royal demesne of the Duke of the Vale, and their most valuable possession besides Rotwood Vale itself. A stretch of land some ten miles across the south bank of the great river, home to dozens of agricultural settlements, hamlets, and smaller market towns. Its lands are rich, and its people aplenty. The agricultural heartland of the Vale, producing most of its grain, meat, and dairy, imported into Rotwood Vale daily and re-exported for profit. Many of Rotwood Vale's residents keep estates here. The Duke, owning most of the land directly, claims a tithe of ten percent of all produce from the region, and at least a quarter on any land directly owned by the Crown, as is their perogative, making this region vital to the Crown's coffers."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_GRAIN = TG_SUPPLY_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_RICE = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_MEAT = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_PORK = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_BUTTER = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CABBAGE = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_POTATO = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_ONION = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_PUMPKIN = 2, // literal: trickle supply, not a staple
	)
	demands = list(
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_STONE = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CINNABAR = TG_DEMAND_IRON,
		TRADE_GOOD_SILVER_INGOT = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 3, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_VISCERA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_SINEW = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_SALMON = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_DEMAND_FISH_SPECIALTY,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "Rosawood"
	subtitle = "The Elven Enclave, Lumber of the Cold Coast"
	order_celebrants = list("Lady Sylvarine Briarmoss")
	description = "The last vassal of the Vale still ruled by an elven lord with a majority elven population. An elven enclave on a peninsula jutting north of Mount Decapitation, alongside a narrow strip of infertile coastal woodland known as the Southern Rosawood. Access is largely by sea. Lumber is exported from the southern edge. The county is unusually, almost magically cold, its growing season barely three months a yil. Its inhabitants feed themselves on those three months of harvest, supplemented by fish from the northern sea, though it never produces or exports enough to supply the Vale. The overland route through the passes below Decapitation is passable, but slow, and fraught with rogue Black Oaks. And the elves prefer it that way. Some say, the beautiful white cloaks of the Rosawood Count, are woven in the same manner as those of the Black Oaks, notorious mercenaries that are barely tolerated the Crown. As for any allegations of collusion, the Count of Rosawood has always been quick to deny them, and the Crown has never found any evidence to the contrary."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_WOOD = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_FIBERS = TG_SUPPLY_FIBERS,
		TRADE_GOOD_HIDE = TG_SUPPLY_LEATHER,
		TRADE_GOOD_FUR = TG_SUPPLY_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_SUPPLY_LEATHER,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "Rockhill"
	subtitle = "The Orchards, Vintners and Herbalists of the Ridge"
	order_celebrants = list("Lord Hadrius Vespermill", "Lady Aurinde Greengable")
	description = "A cluster of orchards and herb gardens to the north of the Vale, sheltered by a ridge that makes the climate there milder than it has any right to be. The many rolling hills of the county make for poor grain land but excellent orchard land. Rockhill wine and liquor are renowned throughout the Vale, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates. Rockhill apple brandy is the realm's most counterfeited drink. Every other inn from Bleakcoast to Heartfelt claims to serve it, but perhaps only a third of them actually do. The county is also known for its many country manor, with perhaps three quarter of the noble houses of the realm owning at least one in Rockhill."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_APPLE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

// Swapped in for Rockhill on the Rockhill map, where the realm is itself called Rockhill and
// a trade road to a county of the same name reads as nonsense. Vespermill was already the
// region's noble seat in standing_order.dm ("Lord Hadrius Vespermill", the midsummer tourney,
// the master-of-hounds), so promoting it to the county name costs no new lore. Keeps
// TRADE_REGION_ROCKHILL and the orchard profile so trade goods, crown imports and every
// standing order keyed to the region continue to resolve.
/datum/economic_region/vespermill
	map_swap_only = TRUE
	region_id = TRADE_REGION_ROCKHILL
	name = "Vespermill"
	subtitle = "The Orchards, Vintners and Herbalists of the Wold"
	description = "A cluster of orchards and herb gardens across the rolling wold, sheltered by a long ridge that makes the climate there milder than it has any right to be. The hills make for poor grain land but excellent orchard land, and the county has leaned into it for six generations. Vespermill wine and liquor are renowned throughout the Vale, and some are exported beyond. It is a quiet, quaint, agricultural county, dotted with noble estates and named for the mill above the vesper-brook that the first Lord Vespermill built his hall around. Vespermill apple brandy is the realm's most counterfeited drink. Every other inn from Bleakcoast to Heartfelt claims to serve it, but perhaps only a third of them actually do. The county is also known for its many country manors, with perhaps three quarters of the noble houses of the realm owning at least one among the orchards."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_APPLE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "Daftsmarch"
	subtitle = "The Mining March, Ores of the Mount"
	order_celebrants = list("Lord Korgrad of Pickleridge")
	description = "The County of Daftsmarch is the heart of the Vale's mining industry, a long strip of land hugging the southern end of Mount Decapitation. It produces most of the raw ore and salt that the Vale depends on. The work pays well, and the veins are plentiful. But Daftsmarch sits uncomfortably close to the ruins of Tarichea, and the various denizens of the Underdark. The dangers posed by the drows and their ilk are a constant threat - many of them seeing Daftsmarch as a convenient source of slaves. But the ore vein are even richer - and the Crown is loathe to keep them unused - sending adventurers, mercenaries and garrison alike to do battle with the Underdark's denizens and keep them at bay."
	threat_region_id = THREAT_REGION_UNDERDARK
	produces = list(
		TRADE_GOOD_IRON_ORE = TG_SUPPLY_IRON,
		TRADE_GOOD_COPPER_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_STONE = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
		TRADE_GOOD_CINNABAR = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_SALT = TG_SUPPLY_SALT,
		TRADE_GOOD_GLASS_BATCH = TG_SUPPLY_GLASS,
	)
	demands = list(
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "Blackholt"
	subtitle = "The Bog's Edge, Huntsmarshal's Demesne"
	order_celebrants = list("Huntsmarshal Ostran")
	description = "A settlement at the southern edge of the Terrorbog, part of the Royal Demesne, and the only part the Duke never tours or manages directly. Instead, management is assigned to a special courtier, the Huntsmarshal of Blackholt. It straddles the bog proper and the undrained marshland at its edge. The locals have learned to make a living off the bog's unusual, some say Psydon-blessed yields: silk from its moths, viscera from its inhabitants, and the rare Essence of Dendor that herbalists and mages pay handsomely for. Blackholt itself is a grim, functional place. Nobody moves there. People end up there."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_SILK = TG_SUPPLY_SILK,
		TRADE_GOOD_VISCERA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_SINEW = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 1, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_CLAY = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_HIDE = 2, // literal: bog-game byproduct, backup supply if Rosawood is blockaded
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "Saltwick"
	subtitle = "The Coastal Town, Fisheries of the Realm"
	description = "A settlement southeast of Rotwood Vale, around a day's ride away, located on the coast of Kingsfield. It was settled first by immigrants from Hammerhold and later by settlers from southern Gronn. The town is divided starkly into two parts: The curing houses and salt farms owned mostly by the town's dwarven and Hammerholdian settlers, while those of Gronnic descent makes up most of the fishermen and sailors. The two groups marry eachother rarely and argue often - but coexists somewhat harmoniously in the same town either way. Of course, Hammerholdian and Gronnmen are not the only inhabitants - many people down on their luck or seeking work also reside. Salt is imported from Daftsmarch, used to preserve the fish caught by local fishermen, and then exported throughout the Vale and Psydonia."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_FISH_FILET = TG_SUPPLY_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_SUPPLY_FISH_MINCE,
		TRADE_GOOD_SALMON = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_SUPPLY_FISH_SPECIALTY,
	)
	demands = list(
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2, // wood draws 2x raw-mat baseline: building, firewood, charring
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "Bleakcoast"
	subtitle = "The Bleakisles Seamarch, Pirate Archipelago"
	order_celebrants = list("Lord Captain Vesarion of Saltreef")
	description = "Also known as the Bleakisles Seamarch. A series of rocky outcrops said to have been created when Comet Syon impacted near the Terrorbog, radiating outward and hurling the islands from the sea itself. The archipelago numbers in the hundreds and makes navigation along all but a narrow stretch of the Vale's coast treacherous. What it lacks in fertile land it makes up for in the bounty of its seas. Schools of fish swarm in the shallow, rocky bottoms and swim as far as the Vale's coast, feeding thousands. But that bounty is not for Bleakisles inhabitants to enjoy. The isles are infested with pirates, the notorious Bleakisles Reavers, who prey on any merchant or fisherman that strays too far from shore. The Duchy maintains several garrisons to keep them in check, and has, once every two generations, undertaken a harrying of the isles, burning every non-military settlement and salting it. To no avail. Within a generation, the pirates always return, for trade is lucrative, and piracy even more so."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
	)

/datum/economic_region/northfort
	region_id = TRADE_REGION_NORTHFORT
	name = "Northfort"
	subtitle = "The Border Fort, Watch on the Northern Approach"
	description = "A fortified castle at the northern approach into the Vale, the only direct overland route from the north. As economically unproductive as a fort can be, which is very. The crown feeds it because without it, the border between Grenzelhoft and the Vale becomes negotiable."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list()
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "Heartfelt"
	subtitle = "The Borderland, Greatest Vassal of the Vale"
	order_celebrants = list("Count Eduard Harlause", "Sir Ardent of the March")
	description = "The County of Heartfelt is the Vale's most powerful vassal, comprising nearly the entirety of the western borderland, bordering Otava, Grenzelhoft, Naledi, and Aavnr. The Count of Heartfelt has always been afforded considerable liberty in how they raise revenues and how many men they keep under arms, for if Heartfelt falls, the Vale's heartland would be exposed. Its defense is funded by a network of estates, holdings, and acres scattered across hundreds of pockets in the Vale outside Heartfelt proper, which the Count uses to purchase armaments and pay retinue alike. But any ruler of the Vale knows there is no greater threat to themselves than the self-professed greatest defender of the Vale."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_SILVER_INGOT = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/hagenwald
	region_id = TRADE_REGION_HAGENWALD
	name = "Hagenwald"
	subtitle = "The Industrial Heart, Forges of the Coppiced Wood"
	description = "The industrial heart of the Vale, sitting on the northern face of Mount Decapitation, where Daftsmarch's ore is taken by mules to be smelted, refined, and forged. Hagenwald produces nearly every ingot of iron, steel, copper, and tin the kingdom uses - without its furnaces, the Vale's smiths would be reduced to working scrap. The town's wealth is built on coppiced woodland that flanks it on three sides, cut and re-cut on a generational rotation so the fire never go out. Its workforce is half Grenzelhoftian by descent, drawn over the centuries by wages, and the streets are perpetually grey with soot. The Crown garrisons it quietly."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list(
		TRADE_GOOD_IRON_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
	)
	demands = list(
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_SILVER_ORE = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_CINNABAR = TG_DEMAND_IRON,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2, // wood draws 2x raw-mat baseline: building, firewood, charring
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
	)

/// Builds the realm regions section of the Lore Primer from the economic_region datums,
/// so steward UI prose and primer prose stay in sync from a single source.
/proc/build_regions_primer_html()
	var/list/parts = list()
	parts += "<details>"
	parts += "<summary><strong><span style='font-size:130%'> REGIONS OF [uppertext(SSmapping.map_adjustment.realm_name)] </span></strong></summary>"
	parts += "<strong><span style='font-size:115%'> THE INTERNAL VASSALS AND DEMESNES </span></strong>"
	parts += "<br><br>"
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		parts += "<details>"
		parts += "<summary><strong> [uppertext(region.name)] </strong></summary>"
		parts += "<br>"
		if(region.subtitle)
			parts += "<em>[region.subtitle]</em>"
			parts += "<br><br>"
		parts += region.description
		parts += "<br>"
		parts += "</details>"
	parts += "<br><br>"
	parts += "</details>"
	return jointext(parts, "\n")



// Al-Ashur trade region identities, swapped in on the Desert Town map via
// map_adjustment.trade_region_swaps. Each name derives visibly from the Vale original
// (Kingsfield becomes Shahfield, Daftsmarch becomes Daftsmarz) and each is a child of the
// region it replaces, inheriting region_id, produces/demands and the blockade wiring. The
// economy is identical; only the identity changes.

/datum/economic_region/kingsfield/alashar
	map_swap_only = TRUE
	name = "Shahfield"
	subtitle = "The Shah's Demesne, Breadbasket of Al-Ashur"
	order_celebrants = list("Lady Roshanak of the River Gate", "Lord Kavus the Younger", "Dame Yasmin Zarafshan", "Sir Bahman of the Qanats")
	description = "The royal province, watered by qanat lines older than any dynasty that has claimed them. A hundred villages along the green ribbon of the river grow the grain, drive the herds, and press the cheese that feed Al-Ashur, and the Crown claims its tithe of every harvest as it has since the first Shah raised the first sluice gate. Many of the city's great families keep summer estates here, and the road between is never empty of grain carts."

/datum/economic_region/rosawood/alashar
	map_swap_only = TRUE
	name = "Rosabagh"
	subtitle = "The Elven Enclave, Cypress Timber of the Cold Shore"
	order_celebrants = list("Lady Sylvarine of the Cypresses")
	description = "The last vassal still ruled by an elven lord: a grove country of black cypress on the cold northern shore, reached more easily by sea than by the pass road. Its timber is prized for beams and ship keels, and its taciturn woodwrights fell exactly as many trees as they plant. The Count of Rosabagh weaves white cloaks in the manner of the Black Oaks, and answers questions about that fraternity the way cypress answers wind."

/datum/economic_region/rockhill/alashar
	map_swap_only = TRUE
	name = "Rocktepe"
	subtitle = "The Golden Gardens, Vintners and Herbalists of the Oasis Terraces"
	order_celebrants = list("Lord Bahram of the Terraces", "Lady Anahita Greengable")
	description = "A stair of walled garden terraces climbing out of the dust, kept impossibly green by channels cut in the time of the old empire. Rocktepe's orchards and poppy beds supply the realm's tables and its apothecaries alike, and its date brandy is the most counterfeited drink between the two seas. Every caravanserai from Saltabad to Heartkand claims to pour it, and perhaps a third truly do. The nobility keep pleasure gardens here, and guard their water rights more jealously than their daughters."

/datum/economic_region/daftsmarch/alashar
	map_swap_only = TRUE
	name = "Daftsmarz"
	subtitle = "The Mining Satrapy, Ores of the Red Mountains"
	order_celebrants = list("Mine Lord Korgrad of the Red Galleries")
	description = "A satrapy of tunnels and tailings in the red mountains, where the ore veins run deep enough to make men rich and deeper still to make them mad. Its mine lords pay the Crown in ingots and ask in return only that nobody inquire how far down the newest galleries go, nor what the deep dwellers take in trade at the bottom of them."

/datum/economic_region/blackholt/alashar
	map_swap_only = TRUE
	name = "Karaholt"
	subtitle = "The Hunting Grounds, the Marshal's Preserve"
	order_celebrants = list("Huntsmarshal Arash")
	description = "The Crown's hunting preserve on the wet margin where the dunes give way to reed marsh: lion and boar for the court's sport, hide and fur and salt game for its coffers. The Master of the Hunt rules it as a private kingdom of hides and hounds, and poachers who reach the city ahead of his riders are, by tradition, allowed to keep whatever they can swallow."

/datum/economic_region/saltwick/alashar
	map_swap_only = TRUE
	name = "Saltabad"
	subtitle = "The Salt Flats, Fisheries of the Gulf"
	description = "A white country: salt pans glittering to the horizon, and past them the gulf with its fishing fleets. Saltabad's brine masters and net captains feed the realm and cure what they feed it with, and its harbor bazaar changes silver in six languages. The town is said to be the only place in Al-Ashur where the tax farmer arrives by boat."

/datum/economic_region/bleakcoast/alashar
	map_swap_only = TRUE
	name = "Bleakthalassa"
	subtitle = "The Corsair Isles, Scourge of the Eastern Sea"
	order_celebrants = list("Lord Captain Nikephoros of the Skerries")
	description = "An archipelago of corsair harbors that the Crown claims as a province and the corsairs regard as a joke with a tax stamp. Thalassan captains raid past the edge of every map, and the furs, amber, and stranger things they bring home reach the mainland bazaars with the salt still on them. The Crown's protection extends exactly as far as its last galley patrol, a fact the islanders commemorate fondly and often."

/datum/economic_region/northfort/alashar
	map_swap_only = TRUE
	name = "Northdez"
	subtitle = "The Border Pass, Watch on the Mountain Road"
	description = "The fortified pass on the northern road, held by a garrison whose muster rolls are older than some of the realms they watch against. Northdez produces little and demands much: iron, grain, and men. The Crown pays gladly, on the arithmetic that a satrapy which eats ten wagons of supply annually is cheaper than a war."

/datum/economic_region/heartfelt/alashar
	map_swap_only = TRUE
	name = "Heartkand"
	subtitle = "The Great Theme, Mightiest Vassal of Al-Ashur"
	order_celebrants = list("Strategos Alexios Harlause", "Sir Ardavan of the March")
	description = "The great eastern theme, largest and proudest of the realm's vassals, ruled by a strategos whose obeisance to the Crown is impeccably formal and precisely as deep as parchment. Its estates and horse pastures could feed a second capital, and its levies march under their own banners first. Every generation, some minister proposes reminding Heartkand who rules whom; every generation, wiser ministers propose lunch instead."

/datum/economic_region/hagenwald/alashar
	map_swap_only = TRUE
	name = "Hagenkar"
	subtitle = "The Forge Quarter, Smiths of the Coppiced Hills"
	description = "A country of charcoal smoke and hammer song in the coppiced hills, where the smith clans of Hagenkar burn their woodlots on a cycle their grandmothers set and their granddaughters will keep. Its forges eat the realm's ore and give back tools, blades, and the best mail south of the mountains. The Crown taxes the quarter lightly, on the theory that one does not annoy the people who make one's weapons."
