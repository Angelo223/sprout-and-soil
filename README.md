# Sprout & Soil

A cozy mobile gardening game built with Godot.

In **Sprout & Soil**, players grow colorful garden beds, discover plant relationships through experimentation, and learn why certain plants work well together while others struggle.

## Core idea

- Cozy mobile-first garden gameplay
- Tap-based planting, watering, caring, and harvesting
- Hidden plant compatibility system
- Player discovers good and bad plant combinations over time
- Failed or damaged harvests explain what went wrong
- No pay-to-win monetization; optional purchases should focus on cosmetics, decoration, and personal expression

## Design documents

- [Game concept](docs/game-concept.md)
- [Progression and art direction](docs/progression-and-art-direction.md)
- [Project structure](docs/project-structure.md)
- [Development log](docs/development-log.md)

## Current project status

This repository contains the first playable Godot prototype.

Next steps:

1. Expand relationship outcomes beyond tile health labels and harvest messages.
2. Add first prototype art and mobile UI polish.
3. Add basic save/load for discovered relationships.
4. Turn the temporary diary label into a full codex screen.

Implemented so far:

- Godot 4 mobile project setup
- Main garden scene
- Interactive 3x3 garden grid
- First garden bed metadata layer for future multi-bed gardens
- Unlockable Herb Bed with separate planted tile state
- Herb Bed trait: herbs grow faster and produce a bonus basket
- Seed picker with the first 8 test plants
- Basic hidden plant relationship data
- First discovery message when neighboring plants reveal a relationship
- Watering, growth progression, maturity, and simple harvesting
- Relationship-influenced harvest feedback
- Temporary garden diary listing discovered relationships
- Harvest basket counter with better yields from healthy companion planting
- Starter Bed goal that unlocks the Herb Bed

## Working title

**Sprout & Soil**

Repository name:

```text
sprout-and-soil
```

Suggested Android package name:

```text
com.andreescholl.sproutandsoil
```
