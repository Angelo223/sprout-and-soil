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

## 2026-04-25 - First hidden relationship prototype

### What changed

- Added all 8 MVP test plants to `PlantData`:
  - Carrot
  - Onion
  - Tomato
  - Basil
  - Potato
  - Bean
  - Corn
  - Squash
- Added `scripts/data/plant_relationship_data.gd` for relationship rules outside UI code.
- Added first relationship types:
  - Good
  - Risky
  - Special
- `GardenGrid` now checks newly planted tiles against cardinal neighbors.
- Discovered relationships are stored in the grid and emitted through a signal.
- The main scene now shows a short discovery message when a new relationship is found.
- Tile health labels now react to relationship outcomes:
  - `Thriving` for helpful neighbors
  - `Stressed` for risky neighbors
  - `Curious` for special-pattern hints

### First prototype relationships

- Carrot + Onion: good
- Tomato + Basil: good
- Tomato + Potato: risky
- Corn + Bean: special
- Corn + Squash: special
- Bean + Squash: special

### Next recommended step

Add basic growth progression and harvesting so Issue #2 can be completed before turning discoveries into a full garden diary screen.

## 2026-04-25 - Basic watering and harvest loop

### What changed

- Added a `Water Garden` button to advance planted crops by one growth day.
- Tiles now show `Ready` when a plant reaches its configured growth duration.
- Tapping a mature planted tile harvests it and clears the bed.
- Tapping an immature planted tile explains how many days remain.
- Relationship health now affects harvest feedback:
  - `Thriving` plants produce a better harvest message.
  - `Stressed` plants produce a damaged harvest message.
  - `Curious` plants hint at a special planting pattern.
- Corn, Bean, and Squash now receive a simple trio bonus when all three exist in the garden.

### Next recommended step

Move discovered relationship history out of the temporary message label and into a first garden diary/codex screen.

## 2026-04-25 - Temporary garden diary

### What changed

- Split the bottom feedback area into:
  - A status label for the latest action or discovery explanation.
  - A simple garden diary label for discovered relationships.
- Relationship discoveries now stay visible after later actions update the status text.
- Duplicate discoveries are ignored by the diary.

### Next recommended step

Replace the temporary diary label with a proper codex view once the prototype has more relationships and explanations.

## 2026-04-25 - Harvest basket scoring

### What changed

- Added a harvest basket counter near the top of the screen.
- Harvested plants now produce a small yield:
  - `Thriving`: 2 baskets
  - `Healthy` or `Curious`: 1 basket
  - `Stressed`: 0 baskets
- Harvest feedback now mentions the yield amount, so plant placement has a visible gameplay result.

### Next recommended step

Add a small garden goal, such as reaching 8 baskets or discovering 3 relationships, so a prototype session has a clear endpoint.

## 2026-04-25 - Starter bed foundation

### What changed

- Added `GardenBed` as a lightweight data object for bed metadata.
- The current 3x3 board is now represented as the first `Starter Bed`.
- Garden tiles now store the bed id they belong to.
- The main scene shows the active bed name above the grid.

### Design direction

The current board remains a small prototype bed, but the code now has a place to grow toward multiple garden beds later.

Future bed ideas:

- Starter Bed
- Herb Bed
- Compost Bed
- Sunny Bed
- Greenhouse Bed

### Next recommended step

Keep the current 3x3 bed as the tutorial space, then add a second locked/unlocked bed once the first session goal exists.

## 2026-04-25 - Starter bed goal

### What changed

- Added a visible Starter Bed goal:
  - Collect 8 harvest baskets.
  - Discover 3 plant relationships.
- The goal display updates after harvests and new discoveries.
- Completing both requirements shows a short completion message.
- The garden grid was moved slightly lower to make room for the goal display.

### Next recommended step

Use the completion state to unlock or preview a second bed, such as a Herb Bed or Sunny Bed.

## 2026-04-25 - Unlockable Herb Bed

### What changed

- Added a simple bed selector with:
  - Starter Bed
  - Herb Bed
- Herb Bed starts locked.
- Completing the Starter Bed goal unlocks the Herb Bed.
- `GardenGrid` now stores separate tile state per bed.
- Switching beds saves the current bed and loads the selected bed.

### Current limitation

The Herb Bed currently uses the same 3x3 layout and rules as the Starter Bed. It exists to prove multi-bed garden structure before adding unique bed traits.

### Next recommended step

Give Herb Bed its own identity, such as faster Basil growth, better herb relationships, or a smaller curated seed set.

## 2026-04-25 - Herb Bed identity pass

### What changed

- Added simple plant types to `PlantData`.
- Basil is now marked as an herb.
- Herb Bed now has a prototype trait:
  - Herbs grow 2 days per watering instead of 1.
  - Herbs produce +1 basket when harvested in Herb Bed, unless stressed.
- Harvest feedback mentions the Herb Bed bonus.

### Current limitation

Only Basil currently uses the herb type because the prototype plant set has one herb. This trait will matter more once Garlic, Lavender, Rosemary, Chamomile, or Mint are added.

### Next recommended step

Add one or two new herb plants, such as Garlic and Lavender, then give Herb Bed its own curated seed set.

## 2026-04-25 - Relationship explanation pass

### What changed

- Replaced placeholder relationship text with more factual companion-planting explanations.
- Added short reasons for discovery messages.
- Kept the language cautious where companion-planting effects can vary by real garden conditions.
- Shortened diary entries so the bottom UI stays readable.

### Next recommended step

Add a proper relationship detail view later, so the diary can show the short entry first and open the full explanation on demand.
