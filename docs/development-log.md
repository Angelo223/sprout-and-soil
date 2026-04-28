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

## 2026-04-26 - First visual asset integration

### What changed

- Added the first versioned SVG placeholder assets under `assets/`:
  - `assets/tiles/ground/tile_grass_base.svg`
  - `assets/tiles/beds/tile_bed_empty.svg`
  - `assets/ui/seed_bar/ui_seed_slot.svg`
  - `assets/ui/seed_bar/ui_seed_slot_selected.svg`
  - `assets/plants/carrot/plant_carrot_stage_01.svg`
  - `assets/plants/onion/plant_onion_stage_01.svg`
  - `assets/plants/tomato/plant_tomato_stage_01.svg`
  - `assets/plants/basil/plant_basil_stage_01.svg`
- Extended `PlantData` with `stage_sprites` paths and `get_stage_sprite_path(...)`.
- Reworked `GardenTile` from a text-only `Button` into a `Control` that renders:
  - a bed texture
  - a plant sprite
  - a small status label
  - a transparent click button layer
- Updated `MainScene` to use:
  - grass texture background
  - grass texture garden backdrop
  - SVG seed-slot textures for seed buttons

### Design note

These SVG assets are implementation placeholders, not final production art. They are intentionally committed as text-based assets so the visual integration can be tested immediately and later replaced by polished PNGs or refined SVGs without changing the gameplay logic again.

### Next recommended step

Pull and test in Godot. If the scene loads correctly, continue by replacing the temporary SVG art with final PNG exports and moving the Seed Bar into its own reusable UI component.

## 2026-04-26 - SeedBar UI component extraction

### What changed

- Added `scripts/ui/seed_bar.gd` as a reusable UI component.
- Moved seed button creation, styling, selected-state handling, and selected seed label into `SeedBar`.
- `SeedBar` now emits `seed_selected(seed_id)` when the player selects a seed.
- `MainScene` now creates `SeedBar`, connects its signal, and forwards the selected seed to `GardenGrid`.
- Removed seed-button dictionaries and seed-selection UI update logic from `MainScene`.

### Why

The Seed Bar has its own UI state and visual rules. Keeping it inside `main_scene.gd` would make the main scene increasingly hard to maintain.

### Next recommended step

Test that seed selection still works. After that, extract the Garden Diary/status area into its own UI component as the next cleanup step.

## 2026-04-26 - GardenStatusPanel UI component extraction

### What changed

- Added `scripts/ui/garden_status_panel.gd` as a reusable status and diary component.
- Moved status message rendering and garden diary rendering out of `MainScene`.
- `GardenStatusPanel` now exposes:
  - `show_message(message)`
  - `show_discovery(discovery)`
  - `add_diary_entry(entry)`
  - `get_diary_entry_count()`
- `MainScene` now forwards garden messages and discoveries into `GardenStatusPanel` instead of directly editing labels.
- Starter goal progress now reads the discovery count from `GardenStatusPanel`.

### Why

The status and diary area has its own presentation state. Moving it into a dedicated component keeps `MainScene` focused on connecting systems instead of owning every UI label.

### Next recommended step

Test that discovery messages, diary entries, goal progress, and Herb Bed unlocking still work after the refactor.

## 2026-04-26 - Scrollable SeedBar

### What changed

- Wrapped the Seed Bar button row in a horizontal `ScrollContainer`.
- Increased individual seed button width slightly for better readability.
- Disabled vertical scrolling for the Seed Bar.
- Kept `SeedBar` as the owner of seed selection state and visual selected-state updates.

### Why

Eight seeds were already crowded on a portrait mobile screen. A horizontal scroll area keeps the UI readable and allows the seed list to grow later without redesigning the entire bottom bar.

### Next recommended step

Test touch/mouse scrolling in Godot and on an Android device. If it feels good, the next UI pass should add clearer visual affordance that the Seed Bar can be swiped horizontally.

## 2026-04-26 - UI cleanup pass

### What changed

- Replaced the stack of five top-level labels with a single cream header panel that holds the title, a butter-yellow harvest basket badge, the hint text, the goal line, and two slim progress bars for baskets and discoveries.
- Replaced the duplicated grass backdrop behind the grid with a soil-colored frame panel that wraps the grass texture, so the play area has a clear journal-like edge.
- Replaced the flat `ColorRect` controls backdrop with a rounded cream `StyleBoxFlat` panel that visually anchors the seeds, the water button, and the diary together.
- Reworked the bed selector into proper tabs with an active-state highlight using `StyleBoxFlat` instead of seed-slot textures, and moved the active bed name onto the tab row.
- Restyled `Water Garden` as a moss-green primary action button with shadow and rounded corners, and centered it under the seed row.
- Repositioned and resized `GardenStatusPanel` to fit inside the new bottom panel as two stacked cards (status card + diary card with a heading and separator), and switched the diary entries to bullet lines.
- Added a `grid_top_offset` field to `GardenGrid` so the main scene can vertically center the 3x3 grid inside its new frame instead of hard-coding the y position.
- Centralized the new color palette (cream, sage, moss, soil, clay, butter, deep text green) inside `main_scene.gd`, drawn from `progression-and-art-direction.md`.

### Why

The previous layout grew label by label at the top of the screen until five centered labels and two buttons were stacked between y=80 and y=425 with no visual grouping. The grid backdrop was a second copy of the grass texture, which read as flat noise rather than a defined play area. The controls area was a single translucent rectangle that did not separate the seed bar, the water button, and the diary. The bed selector reused seed-slot art that visually competed with the actual seeds.

### Next recommended step

Test the layout in Godot on the 540x960 window override and on a real Android viewport. Then start replacing the placeholder SVGs with the journal-style assets described in the art direction doc.

## 2026-04-28 - Remaining prototype plant textures

### What changed

- Added Stage-01 SVG placeholder assets for the remaining four MVP test plants:
  - `assets/plants/potato/plant_potato_stage_01.svg`
  - `assets/plants/bean/plant_bean_stage_01.svg`
  - `assets/plants/corn/plant_corn_stage_01.svg`
  - `assets/plants/squash/plant_squash_stage_01.svg`
- Updated `PlantData` so Potato, Bean, Corn, and Squash now resolve sprite paths instead of rendering as empty planted beds.

### Design note

These assets keep the same 256x256 SVG placeholder approach as the first four plants. They are distinct enough for prototype readability while still being lightweight and replaceable later.

## 2026-04-28 - Visual design refresh

### What changed

- Replaced the repeated full-screen grass background with a calmer layered garden backdrop drawn in `MainScene`.
- Updated the garden frame to read more like a focused play surface instead of a flat green box.
- Restyled seed buttons with cleaner modern cards and a brighter selected state.
- Refined the water button, bed tabs, basket/diary pills, and diary modal styling.
- Reworked the grass and empty-bed SVG placeholders so the board feels softer and less debug-like.

### Design note

The refresh keeps the cozy garden-journal direction, but reduces the old flat green repetition and heavy placeholder edges.

## 2026-04-28 - Generated art asset integration

### What changed

- Added generated PNG art assets under `assets/art/generated/` and `assets/ui/generated/`.
- Cropped transparent padding from the generated board, diary, seed-card, selected seed-card, and water-button images for cleaner Godot scaling.
- Replaced the procedural background with `garden_background.png`.
- Replaced the drawn garden frame with `garden_play_board_cropped.png`.
- Updated Seed Bar buttons to use the generated seed-card textures.
- Updated the primary water button to use the generated moss-green button texture.
- Added the generated diary paper texture behind the diary modal content.

### Design note

The generated images are now used as visual foundations, while all text and interaction remains native Godot UI for readability and localization.

## 2026-04-28 - Panel separation pass

### What changed

- Added a dedicated header panel behind the diary button, basket counter, and bed tabs.
- Strengthened the controls area with an outer paper panel and a muted inner panel so seed cards and the water button no longer float directly on the background illustration.
- Adjusted the diary modal to use the generated notepad texture without an extra rectangular backing panel.
- Moved diary content, list scroll area, close button, back button, and relationship detail content inward so they sit inside the illustrated paper safe area.

### Design note

The generated background remains decorative, while interactive UI now lives on readable panels with clearer ownership and less visual overlap.

## 2026-04-28 - Mobile seed selector cleanup

### What changed

- Replaced the tall seed-card selector with compact rounded seed chips.
- Reduced the height of the bottom controls area so it feels more like a mobile toolbar.
- Added more vertical breathing room to the top header and bed tabs.
- Moved the diary close button upward so it sits inside the paper safe area instead of near the illustrated edge.

### Design note

Seed selection should be fast and thumb-friendly. The detailed seed-packet art can return later in a dedicated seed detail view, but the main planting screen works better with compact controls.

## 2026-04-28 - Bed and seed interaction cleanup

### What changed

- Reduced garden tile size from 260x260 to 210x210 and increased spacing so the tiles sit inside the illustrated board instead of overpowering it.
- Moved the 3x3 grid lower within the generated board art to better match the visual safe area.
- Changed the bed selector so the active Starter Bed remains an active button style instead of becoming disabled.
- Renamed the locked Herb Bed tab to `Herb Locked` and gave it a muted locked style.
- Replaced the always-visible seed chip strip with a compact current-seed control that opens the seed picker.
- Added a small seed picker panel that opens above the controls only when the player wants to switch seeds.

### Design note

The main garden screen should keep the player focused on the bed. Secondary choices like seed selection should stay available, but not constantly occupy the visual foreground.

## 2026-04-28 - Seed selector redundancy cleanup

### What changed

- Removed the separate `Change Seed` button.
- Made the current seed control the single tap target for opening the seed picker.

### Design note

One control should do one job. If the current seed label opens the picker, a second change button only adds noise.
