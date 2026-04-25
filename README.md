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

1. Replace debug visuals with first prototype art (tiles, plants, seed packets).
2. Add more plants and bed traits (Cool Bed, Sunny Bed).
3. Add per-plant detail screens linked from the codex.
4. Add gentle audio (planting, watering, harvest).

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
- Thriving plants grow 1 extra day per watering
- Three Sisters completion message when corn, bean, and squash all touch
- Harvest basket counter with better yields from healthy companion planting
- Buddy harvest and lesson stats under the harvest counter
- Starter Bed goal that unlocks the Herb Bed
- Full Garden Codex screen with relationship list and detail view
- Persistent save/load for the whole garden, diary, and progression

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
