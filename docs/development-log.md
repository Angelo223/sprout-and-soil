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
  - Plants the current default seed.
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

### Next recommended step

Add a simple seed selection flow so the player can choose between at least two plants instead of always planting carrots.

After that, implement the first hidden relationship check, for example:

- Carrot + Onion = positive discovery
- Tomato + Potato = risky discovery later
