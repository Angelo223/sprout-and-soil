# Recommended Godot Project Structure

This structure is intended for a Godot 4 mobile project.

```text
sprout-and-soil/
├─ project.godot
├─ README.md
├─ docs/
│  ├─ game-concept.md
│  └─ project-structure.md
├─ assets/
│  ├─ art/
│  │  ├─ plants/
│  │  ├─ tiles/
│  │  ├─ ui/
│  │  └─ vfx/
│  ├─ audio/
│  │  ├─ music/
│  │  └─ sfx/
│  └─ fonts/
├─ scenes/
│  ├─ main/
│  │  └─ Main.tscn
│  ├─ garden/
│  │  ├─ GardenGrid.tscn
│  │  ├─ GardenTile.tscn
│  │  └─ Plant.tscn
│  └─ ui/
│     ├─ Hud.tscn
│     ├─ SeedPicker.tscn
│     └─ DiscoveryDialog.tscn
├─ scripts/
│  ├─ core/
│  │  ├─ GameState.gd
│  │  └─ SaveManager.gd
│  ├─ garden/
│  │  ├─ GardenGrid.gd
│  │  ├─ GardenTile.gd
│  │  └─ Plant.gd
│  ├─ data/
│  │  ├─ PlantData.gd
│  │  └─ PlantRelationshipData.gd
│  └─ ui/
│     ├─ Hud.gd
│     ├─ SeedPicker.gd
│     └─ DiscoveryDialog.gd
└─ data/
   ├─ plants.json
   └─ plant_relationships.json
```

## Notes

- Keep plant definitions in data files where possible.
- Keep scenes small and focused.
- Avoid hardcoding plant relationships directly inside UI scripts.
- The garden simulation should be testable separately from the visual presentation.

## First prototype target

The first prototype should prove only one thing:

> Can planting neighboring crops create understandable positive and negative outcomes?

Everything else should stay secondary until that loop feels fun.
