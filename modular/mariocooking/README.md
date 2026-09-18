# Pasta and sauces, first version

## Playing

- Cut dough on a table as usual, then cut a small dough again to produce raw pasta.
- Heat an ordinary pot with at least 10 units of water on a lit hearth. Add raw pasta; one portion cooks at a time. Finished pasta appears on the hearth's turf. Remove the pot and use it in hand to retrieve unfinished pasta. Cold pots and unlit hearths do not advance cooking.
- Forge a saucepan and sauceboat through the existing iron cookware recipes, one iron ingot each.
- Add ingredient items to the saucepan. Use it in hand to start a batch, then place it on a lit hearth. Fanning uses the existing cooking-skill speed adjustment. Use a removed saucepan in hand again to cancel the batch and recover its items.
- Transfer finished sauce between vessels with the existing feed/fill intents. Use the sauceboat's feed intent on food to serve 5 units, limited by the food's remaining reagent capacity. Empty the saucepan before making another batch.

| Sauce | Ingredients for one 60-unit batch |
| --- | --- |
| Tomato Sauce | One whole tomato, one salt item, one sugar item |
| Garlick Butter | One butter slice, one garlick clove, one salt item |
| Gravy | One mince item, one flour item, one salt item, 10 units of water |
| Secret Sauce | Three distinct ingredient items selected once per round; no added liquid |

Ingredient order does not matter. Missing, additional, or incorrect ingredients produce Ruined Sauce. Liquid quantities use the existing recipe matcher's tolerance (less than 0.5 units). Tomato and butter sauces need no added water. Heating an empty reagent holder works in Ratwood, so their pans can heat without added liquid.

Ordinary foods retain their type and name. Sauces transfer as reagents and participate in normal eating and taste handling. Ingredients used to prepare a sauce are converted into its output, as with existing stews; their separate chemicals are not copied into the batch. Later additives in a prepared sauce are transferred with the mixture.

Cooked pasta uses the valid sauce with the largest volume for its name and tinted `pasta_sauce` overlay. Ties favor the first sauce in the reagent holder. Noodles keep their original color; unrelated overlays and rotten-food identification are preserved. Ruined Sauce adds its unpleasant taste but does not define a pasta variety.

Secret Sauce selects from pepper, allspice, sugar, salt, butter slices, garlick cloves, poppies, rotten meat, brains, and eyes. At least one of the last four ingredients is selected. The 100 possible combinations never collide with the basic recipes. The actual selection is not registered in recipe books or exposed through examination. Eating it grants a non-stacking -8 stress event for 15 minutes and the message “This sauce tastes unimaginable!” It provides no healing, combat bonuses, or additional nutrition.

## Existing systems reused

- `snacks.slice()` and small-dough's ordinary knife interaction.
- Hearth pot attachments, reagent temperature, food `cooking()` / `heating_act()`, and `initialize_cooked_food()`; `boiled_type` extends these for solid-food boiling.
- `/datum/recipe` and `select_recipe()` for exact item and reagent matching. Item identity matters because Ratwood's salt and flour items both contain `floure`.
- `SScooking.Initialize()` to construct the sauce recipe list, guarded against rerolling it.
- Glass vessel transfers, the existing item `pre_attack()` hook, reagent-change icon updates, consumable taste descriptions, and `/datum/stressevent`.
- Iron anvil cookware recipes for acquiring both vessels.

To add a sauce, define a `/datum/reagent/consumable/sauce` subtype with its taste, color, and optional `pasta_name`, plus a `/datum/recipe/sauce` subtype with item/liquid requirements and that reagent as `result`. No pasta logic changes are required. Sauce recipes return reagents rather than calling the base recipe's item-producing `make()` proc.

## Changed files

- `code/__DEFINES/cooking.dm`: shared boiling temperature.
- `code/controllers/subsystem/rogue/cooking_subsystem.dm`: sauce recipe initialization.
- `code/game/objects/lighting/rogue_fires.dm`: saucepan input and hot-pot cooking hooks.
- `code/modules/food_and_drinks/food/snacks.dm`: generic solid-food boiling support.
- `modular/Neu_Food/code/cookware/pot.dm`: solid-food loading, cooking, retrieval, and cleanup.
- `modular/Neu_Food/code/raw/raw_dough.dm`: small-dough slicing result.
- `modular/mariocooking/code/{pasta,sauce_recipes,sauces,sauceware}.dm`: new content and vessel behaviors.
- `roguetown.dme`: includes.
- `code/modules/unit_tests/{_unit_tests,pasta_sauces}.dm`: regression tests and registration.

All required basic ingredients and the curated strange ingredients existed. No replacement ingredients, extra dishes, map placements, or new sprites were added. Existing `mfood_default.dmi` supplies all used states; `shellfish_limbs.dmi` is unchanged.

## Validation

The completed changes pass DreamChecker suite-1.11 with zero diagnostics, the existing DME file-directory check, and `git diff --check`. Added DM tests cover exact and invalid recipes, stable Secret Sauce selection, cold/hot boiling, reagent conservation, food identity, nonfood rejection, predominant sauce naming, and the Secret Sauce mood event.

The DM tests have been statically checked, not executed. A full BYOND compile and in-game playtest remain necessary; the authoring environment could not run the pinned 32-bit compiler natively.
