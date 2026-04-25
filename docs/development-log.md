# Development Log

## 2026-04-25 - Initial playable garden prototype

### What changed

- Confirmed the first Godot project setup and test scene.
- Added an interactive 3x3 garden grid prototype.
- Clicking/tapping an empty bed plants a test carrot and displays `Carrot Day 1`.

### Current architecture

The first prototype has been split into separate responsibilities:

- `scripts/main_scene.gd`
  - Creates the background, title, hint text, and attaches the garden grid.
- `scripts/garden/garden_grid.gd`
  - Creates and owns the 3x3 grid.
  - Handles tile selection.
  - Plants the current selected seed.
- `scripts/garden/garden_tile.gd`
  - Represents one garden bed.
  - Stores tile index, grid position, planted seed, growth day, and health state.
  - Emits a signal when selected.
- `scripts/data/plant_data.gd`
  - Stores the first plant definitions.
  - Provides helper methods for display names and growth days.

### First plant data

The initial data model contains placeholder entries for:

- Carrot
- Onion
- Tomato
- Basil

These are not final balancing values. They exist so the game can start moving toward a real plant system.

## 2026-04-25 - Seed selection prototype

### What changed

- Added a simple seed selection bar to the main scene.
- The player can now choose between:
  - Carrot
  - Onion
  - Tomato
  - Basil
- The selected seed is shown above the seed bar.
- The selected seed button is disabled so the current choice is visible.
- `GardenGrid` now exposes `set_selected_seed(seed_id)` and plants the currently selected seed instead of always planting carrots.

### Design note

The seed bar is intentionally plain. The goal of this step is to prove the interaction flow, not final UI quality.

The current loop is now:

1. Pick a seed.
2. Tap an empty bed.
3. The selected plant appears in the bed as `Plant Name / Day 1`.

## 2026-04-25 - Move Godot project to repository root

### What changed

- Moved the Godot project out of the former `sprout-&-soil/` subfolder.
- `project.godot` now lives directly in the repository root.
- `MainScene.tscn` now lives directly in the repository root.
- `scripts/` now lives directly in the repository root.
- `docs/` remains in the repository root and continues to hold project documentation.
- Root-level `.editorconfig`, `.gitattributes`, `.gitignore`, `icon.svg`, and `icon.svg.import` are used for the Godot project.

### Current expected repository shape

```text
sprout-and-soil/
├─ project.godot
├─ MainScene.tscn
├─ icon.svg
├─ icon.svg.import
├─ README.md
├─ docs/
│  ├─ development-log.md
│  ├─ game-concept.md
│  └─ project-structure.md
└─ scripts/
   ├─ main_scene.gd
   ├─ data/
   │  └─ plant_data.gd
   └─ garden/
      ├─ garden_grid.gd
      └─ garden_tile.gd
```

### Next recommended step

After pulling the repo, open `project.godot` from the repository root and verify that the seed selection prototype still starts correctly.

Then add the first hidden plant relationship system.
