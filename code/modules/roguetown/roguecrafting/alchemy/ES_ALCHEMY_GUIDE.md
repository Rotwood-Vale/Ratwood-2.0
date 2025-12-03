# Hybrid Alchemy System (Kingdom Come Deliverance meets Elder Scrolls)

## Overview
This alchemy system combines the best of Kingdom Come: Deliverance's multi-stage extraction process with Elder Scrolls' effect-based discovery and mixing mechanics, creating a unique and deep crafting experience.

**Inspired by:**
- **Kingdom Come: Deliverance** - Progressive refinement through multiple boiling stages
- **Elder Scrolls (Skyrim/Oblivion)** - Effect-based discovery and ingredient combination
- **Our own spin** - Creative paired-word naming and smell-based effect revelation

## How It Works

### 1. Boiling Herbs in Cauldron (Part 1)
Add exactly ONE herb to a cauldron with a base reagent:

**NOVICE LEVEL (Skill 1) - Primary Extraction (90u minimum):**
- Water (90u+) + Herb → "Herb Tonic" (60u) (herb consumed)
- Cooking Oil (90u+) + Herb → "Oil of Herb" (60u) (herb consumed)

**AMATEUR LEVEL (Skill 2):**
- Wine (90u+) + Herb → "Herb Bitters" (60u) (herb consumed)
- Acid (90u+) + Herb → "Vitriol of Herb" (60u) (herb consumed)

**JOURNEYMAN LEVEL (Skill 3) - Secondary Processing (60u minimum):**
- Herb Tonic (60u+) → "Herb Concentrate" (30u) (boil again, NO herb needed)
- Oil of Herb (60u+) → "Herb Paste" (30u) (boil again, NO herb needed)

**EXPERT LEVEL (Skill 4) - Tertiary Processing (60u minimum):**
- Herb Bitters (60u+) → "Herb Powder" (30u) (boil again, NO herb needed)
- Vitriol of Herb (60u+) → "Herb Salt" (30u) (boil again, NO herb needed)

**Example:**
- Water (90u) + Rosa → Creates "rosa tonic" (60u) with Rosa's effects [rosa consumed]
- Rosa tonic (60u) alone → Creates "rosa concentrate" (30u) with Rosa's effects [NO herb needed]

### 2. Grinding in Mortar (Part 2)
Grind ingredients in a mortar & pestle to extract reagents with effects.

**Herbs**: Create herb powders for traditional potions
**Produce**: Create powdered produce (4u) with alchemy effects!
- Grinding apples → "powdered apple" (4u, effects: restore_stamina, heal_brute, fortify_constitution)
- Grinding potatoes → "powdered potato" (4u, effects: fortify_constitution, restore_stamina, fortify_endurance)
- Grinding cabbage → "powdered cabbage" (4u, effects: fortify_endurance, heal_brute, restore_energy)
- All produce can now participate in the alchemy system!

### 3. Mixing Reagents (Part 3)
When two reagents with **common effects** from **DIFFERENT herb sources** are mixed in a container, they automatically combine to create a creatively named potion!

**Creative Naming System:**
- Each effect has two words: [adjective, noun] (e.g., heal_burn = "soothing", "balm")
- **1 common effect**: Uses adjective only → "soothing"
- **2 common effects**: Adjective from first + Noun from second → "soothing heal"
- **3+ common effects**: Mysterious name → "strange brew"

**Example:**
- Rosa tonic (effects: heal burn, restore blood, fortify constitution) - source_herb_name = "rosa"
- Symphitum oil (effects: heal brute, heal burn, restore blood) - source_herb_name = "symphitum"
- **Common effects:** heal burn, restore blood (2 effects)
- **Different herbs:** "rosa" ≠ "symphitum" ✅ mixing allowed
- **Result:** Creates "soothing fluid" (heal_burn adjective + restore_blood noun) with blended color, combined smell, and mixed taste!

**Same-Herb Prevention:**
- Rosa tonic + Rosa concentrate → ❌ NO REACTION (both contain "rosa")
- This prevents trivial crafting and encourages diverse herb gathering

## Alchemy Effects and Paired-Word Naming

Each effect has a distinct smell AND two words [adjective, noun] for creative potion naming:

### Positive Effects
- `EFFECT_HEAL_BRUTE` - "mending", "heal" | Smell: wet moss
- `EFFECT_HEAL_BURN` - "soothing", "balm" | Smell: soothing balm
- `EFFECT_HEAL_TOX` - "curing", "antidote" | Smell: purity
- `EFFECT_RESTORE_STAMINA` - "energizing", "vigor" | Smell: fresh air
- `EFFECT_RESTORE_ENERGY` - "invigorating", "essence" | Smell: clean air
- `EFFECT_RESTORE_BLOOD` - "vital", "fluid" | Smell: iron and life
- `EFFECT_FORTIFY_STRENGTH` - "mighty", "power" | Smell: power
- `EFFECT_FORTIFY_PERCEPTION` - "keen", "sight" | Smell: sharp clarity
- `EFFECT_FORTIFY_INTELLIGENCE` - "brilliant", "mind" | Smell: arcane essence
- `EFFECT_FORTIFY_CONSTITUTION` - "hardy", "body" | Smell: mountain air
- `EFFECT_FORTIFY_ENDURANCE` - "enduring", "fortitude" | Smell: earth
- `EFFECT_FORTIFY_SPEED` - "swift", "motion" | Smell: a swift breeze
- `EFFECT_FORTIFY_LUCK` - "fortunate", "blessing" | Smell: fortune

### Negative Effects
- `EFFECT_PARALYZE` - "binding", "lock" | Smell: stagnant air
- `EFFECT_POISON` - "toxic", "venom" | Smell: death
- `EFFECT_DAMAGE_STAMINA` - "draining", "fatigue" | Smell: exhaustion
- `EFFECT_DAMAGE_ENERGY` - "exhausting", "drain" | Smell: draining cold
- `EFFECT_BLINDNESS` - "darkening", "shadow" | Smell: darkness
- `EFFECT_SILENCE` - "muting", "silence" | Smell: muffled void
- `EFFECT_SLOW` - "sluggish", "draught" | Smell: thick molasses
- `EFFECT_WEAKNESS` - "enfeebling", "curse" | Smell: decay

## Current Herb Effects

### Symphitum
- EFFECT_HEAL_BRUTE
- EFFECT_HEAL_BURN
- EFFECT_RESTORE_BLOOD

### Calendula
- EFFECT_HEAL_BRUTE
- EFFECT_FORTIFY_ENDURANCE
- EFFECT_RESTORE_BLOOD

### Mentha
- EFFECT_FORTIFY_PERCEPTION
- EFFECT_FORTIFY_INTELLIGENCE
- EFFECT_RESTORE_STAMINA

### Rosa
- EFFECT_HEAL_BURN
- EFFECT_RESTORE_BLOOD
- EFFECT_FORTIFY_CONSTITUTION

## Herb Alchemy Effects Reference

### Healing Herbs
- **Symphitum**: heal brute, heal burn, restore blood
- **Calendula**: heal brute, fortify endurance, restore blood
- **Taraxacum**: heal brute, damage stamina, heal toxin
- **Urtica**: heal brute, fortify speed, restore energy
- **Valeriana**: heal brute, fortify speed, damage stamina

### Enhancement Herbs
- **Mentha**: fortify perception, fortify intelligence, restore stamina
- **Salvia**: fortify constitution, fortify strength, fortify endurance
- **Euphrasia**: fortify speed, fortify intelligence, restore energy
- **Benedictus**: restore stamina, fortify intelligence, fortify endurance
- **Artemisia**: fortify luck, fortify speed, restore energy

### Restorative Herbs
- **Hypericum**: restore stamina, restore energy, heal toxin
- **Rosa**: heal burn, restore blood, fortify constitution

### Poisonous Herbs
- **Atropa**: poison, damage stamina, weakness
- **Matricaria**: fortify perception, poison, slow
- **Paris**: damage stamina, poison, paralyze

## Skill-Based Effect Discovery

Examining herbs reveals their effects as smells based on your alchemy skill:

- **NOVICE (Skill 1)**: Can smell the **first** effect
- **APPRENTICE/AMATEUR (Skill 2)**: Can smell **first and second** effects
- **JOURNEYMAN/EXPERT (Skill 3+)**: Can smell **all three** effects

**Example:**
```
> You examine rosa...
> You smell: soothing balm (heal burn revealed)
```

As your skill increases, you'll detect more effects, allowing you to discover which herbs share common effects for potion mixing!

## Complete Workflow Example

1. **Gather ingredients**
   - Collect rosa herb
   - Collect symphitum herb
   - Get water and cooking oil

2. **Create first extract (PRIMARY)**
   - Add 90u water to cauldron
   - Add rosa herb
   - Light cauldron
   - Result: 60u "rosa tonic" (effects: heal burn, restore blood, fortify constitution)
   - Rosa herb is consumed

3. **Concentrate the extract (SECONDARY) - NO HERB NEEDED**
   - Pour 60u rosa tonic into cauldron
   - Light cauldron (NO herb needed!)
   - Result: 30u "rosa concentrate" (same effects as rosa tonic, more concentrated)

4. **Create second extract (PRIMARY)**
   - Add 90u cooking oil to cauldron
   - Add symphitum herb
   - Light cauldron
   - Result: 60u "symphitum oil" (effects: heal brute, heal burn, restore blood)
   - Symphitum herb is consumed

5. **Mix to create creatively named potion**
   - Pour rosa tonic into vial
   - Pour symphitum oil into same vial
   - **Automatic reaction:** Common effects detected (heal burn, restore blood)
   - **Different herbs:** "rosa" ≠ "symphitum" ✅
   - **2 common effects:** Uses paired-word naming
   - Result: Creates "soothing fluid" with:
     - Blended color (RGB average of both sources)
     - Combined smell ("soothing balm, iron and life")
     - Mixed taste ("rosa and symphitum and watery herbs and oily herbs")
     - BOTH effects applied when consumed!

## Technical Details

### Mixing Mechanics
- Mixing occurs automatically when reagents with common effects are combined in containers
- Maximum 30 units converted per mixing event
- 2 reagents → 1 potion (50% conversion rate)
- **Same-herb prevention**: Reagents from the same source herb cannot mix (prevents trivial crafting)
- Mixed potions track all source herbs (e.g., "rosa-symphitum") and cannot be re-mixed with those herbs

### Extraction Ratios (KCD-Style Progressive Refinement)
- **Primary extraction**: 90u base reagent → 60u extract (2/3 conversion, herb consumed)
- **Secondary extraction**: 60u extract → 30u concentrate (1/2 conversion, NO herb needed)
- Cauldron accepts only ONE item at a time for focused alchemy

### Creative Naming (Our Unique Spin)
- Each effect has [adjective, noun] word pair
- 1 common effect: Uses adjective only (e.g., "soothing")
- 2 common effects: Adjective₁ + Noun₂ (e.g., "soothing heal")
- 3+ common effects: "strange brew" (mysterious!)

### Property Blending
- **Colors**: RGB values averaged (50/50 blend)
- **Smells**: All effect smells combined (comma-separated)
- **Tastes**: Source reagent tastes combined
- **Effects**: ALL common effects apply dynamically via on_mob_life()

### Skill-Based Discovery (Elder Scrolls-Style)
- Higher alchemy skill reveals more effects when examining herbs
- Creates discovery-based gameplay - experiment to find combinations!

## Adding New Herbs

To add effects to a herb, add the `alchemy_effects` list:

```dm
/obj/item/alch/my_herb
    name = "my herb"
    icon_state = "my_herb"
    alchemy_effects = list(EFFECT_HEAL_BRUTE, EFFECT_FORTIFY_STRENGTH)
    major_pot = /datum/alch_cauldron_recipe/health_potion
    med_pot = /datum/alch_cauldron_recipe/str_potion
    minor_pot = null
```

The herb will pass its effects to any extract created from it!
