# Development Log

## 2026-04-25 - Initial playable garden prototype

### What changed

- Confirmed that the Godot project lives in `sprout-&-soil/`.
- Kept the repository root available for documentation and planning files.
- Configured `sprout-&-soil/project.godot` to start `res://MainScene.tscn`.
- Added an interactive 3x3 garden grid prototype.
- Clicking/tapping an empty bed plants a test carrot and displays `Carrot Day 1`.

### Current architecture

The first prototype has been split into separate responsibilities:

- `sprout-&-soil/scripts/main_scene.gd`
  - Creates the background, title, hint text, and attaches the garden grid.
- `sprout-&-soil/scripts/garden/garden_grid.gd`
  - Creates and owns the 3x3 grid.
  - Handles tile selection.
  - Plants the current selected seed.
- `sprout-&-soil/scripts/garden/garden_tile.gd`
  - Represents one garden bed.
  - Stores tile index, grid position, planted seed, growth day, and health state.
  - Emits a signal when selected.
- `sprout-&-soil/scripts/data/plant_data.gd`
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

### Next recommended step

Add the first hidden plant relationship system.

A good first version would check neighboring tiles after planting and store simple relationship discoveries, for example:

- Carrot + Onion = positive discovery
- Tomato + Basil = positive discovery
- Tomato + Potato = risky discovery later, once potato exists

The result should not be shown before planting. It should only appear after the player experiences the outcome.
