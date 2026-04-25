# Progression and Art Direction

This document describes the intended growth path for **Sprout & Soil**: which plants arrive when, what the player is working toward, and how the game should feel visually.

## Core fantasy

The player is building a small living garden, not optimizing an industrial farm.

The game should feel like:

- arranging a cozy garden bed
- discovering plant relationships through play
- keeping a gentle garden diary
- slowly unlocking new plants, beds, and decoration
- making the garden feel personal and calm

The long-term loop should be:

```text
Plant and observe
-> Discover relationships
-> Harvest better results
-> Unlock new plants, beds, and decoration
-> Arrange a prettier and smarter garden
-> Fill the garden diary
```

## Overall goals

The game should avoid making coins, timers, or efficiency the emotional center.

Primary goals:

- Fill the garden diary with discovered plant relationships.
- Build healthy and beautiful beds.
- Complete gentle seasonal or bed-specific goals.
- Unlock new garden areas and decorative options.
- Learn small real-world gardening ideas through play.

Secondary goals:

- Earn harvest baskets.
- Improve yields through better layouts.
- Complete special planting patterns.
- Collect cosmetic rewards.

## Plant progression

Plant count should grow slowly. Fewer plants with meaningful relationships are better than many plants with shallow rules.

### Prototype plants

These are already in the first prototype:

- Carrot
- Onion
- Tomato
- Basil
- Potato
- Bean
- Corn
- Squash

### Early game expansion

Add these after the core loop feels good:

- Lettuce
- Strawberry
- Marigold
- Garlic
- Cabbage
- Pea

### Later plant pool

Use these once the diary, bed system, and art style are more mature:

- Lavender
- Rosemary
- Sunflower
- Cucumber
- Pepper
- Pumpkin
- Chamomile
- Mint

### Target counts

- First prototype: 8 plants
- Early game: 12 to 16 plants
- Fuller version: 24 to 36 plants

Do not rush beyond 16 plants until the diary and bed identity systems are fun.

## Unlock structure

Plants should unlock through garden achievements, not only abstract player levels.

### Starter Bed

Purpose: teach planting, watering, relationships, harvest, and diary.

Initial plants:

- Carrot
- Onion
- Tomato
- Basil

Unlock from Starter Bed goals:

- Bean
- Corn
- Squash
- Potato

Example goals:

- Collect 8 harvest baskets.
- Discover 3 plant relationships.
- Build the Three Sisters pattern.

### Herb Bed

Purpose: introduce aromatic herbs, pest confusion, pollinators, and gentle garden support.

Candidate plants:

- Basil
- Garlic
- Lavender
- Rosemary
- Chamomile
- Mint

Possible bed traits:

- Herbs grow 1 day faster.
- Herb relationships give +1 harvest basket once per harvest.
- Aromatic plants reduce risky effects from nearby pest-prone crops.

### Sunny Bed

Purpose: introduce warm-season crops and sun-loving relationships.

Candidate plants:

- Tomato
- Pepper
- Cucumber
- Sunflower
- Basil
- Marigold

Possible bed traits:

- Warm crops grow better here.
- Sunflower can support or attract beneficial insects.
- Some thirsty crops need more careful watering later.

### Cool Bed

Purpose: introduce leafy and cool-weather plants.

Candidate plants:

- Lettuce
- Pea
- Cabbage
- Carrot
- Onion

Possible bed traits:

- Leafy crops grow quickly but may be more sensitive to stress.
- Peas can support soil fertility themes.

### Flower Strip

Purpose: make beauty and ecosystem support part of the game.

Candidate plants:

- Marigold
- Chamomile
- Lavender
- Sunflower

Possible bed traits:

- Flowers improve nearby beds.
- Pollinator-friendly layouts unlock decoration rewards.

## Relationship design

Every relationship should have:

- a gameplay effect
- a short discovery message
- a diary entry
- a plain-language reason
- cautious wording when real gardening evidence varies

Example relationship types:

- Good: improves harvest or health.
- Risky: lowers harvest or causes stress.
- Special: hints at a larger pattern.
- Neutral: no special effect.

Avoid magical-feeling effects. If something changes, the player should be able to understand why.

Good example:

```text
Corn + Bean: Bean can climb the corn stalk.
```

Bad example:

```text
All beans are stronger because corn exists somewhere.
```

## Session structure

A single early session should have a clear endpoint.

Starter Bed example:

1. Plant first seeds.
2. Discover at least one good relationship.
3. Water until plants mature.
4. Harvest enough baskets.
5. Discover 3 relationships.
6. Complete the Starter Bed goal.
7. Unlock Herb Bed.

This should take only a few minutes in prototype form.

## Visual direction

The game should feel cozy, calm, and carefully arranged.

Inspirations:

- **Animal Crossing** for friendliness, rounded forms, and readable charm.
- **Unpacking** for quiet object detail and personal space.
- **Dorfromantik** for soft color harmony and relaxing layout play.
- Botanical notebooks for the garden diary and learning moments.

The style should be stylized rather than realistic.

Preferred direction:

- 2D or 2.5D top-down garden view
- soft shapes
- slightly chunky plant silhouettes
- clear readable plant states
- warm natural palette
- subtle texture instead of flat debug color
- diary UI with paper, stickers, tabs, and botanical sketch details

Avoid:

- harsh saturated colors
- noisy realistic textures
- tiny unreadable plant details
- cold sci-fi UI
- dark muddy palettes
- mobile-game clutter

## Color palette

Suggested base palette:

```text
Sage green       #AFCB9B
Moss green       #627A4E
Soft cream       #F1E7C8
Warm soil        #7B5738
Clay accent      #B86F4B
Tomato red       #C95544
Butter yellow    #E7C767
Lavender blue    #8C9BC8
Deep text green  #263D25
```

Use muted colors, but keep text and interactive elements readable.

## UI direction

The UI should feel like a garden journal rather than a spreadsheet.

Good UI motifs:

- tabs for beds
- seed packets for plant buttons
- diary pages for discoveries
- small illustrated badges for relationship types
- gentle progress ribbons for goals
- harvest basket counter as a small basket icon later

Prototype UI can stay simple, but it should move toward these motifs over time.

## Art asset priorities

When replacing debug visuals, prioritize:

1. Garden tiles with soil texture and state variations.
2. Simple plant sprites for the first 8 plants.
3. Seed packet buttons.
4. Garden diary panel.
5. Harvest basket icon.
6. Bed selector tabs.
7. Decorative unlocked rewards.

Do not create too many plants before the first 8 look and read well.
