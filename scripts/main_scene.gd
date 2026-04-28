extends Node2D

const AVAILABLE_SEEDS := ["carrot", "onion", "tomato", "basil", "potato", "bean", "corn", "squash"]
const TARGET_HARVEST := 8
const TARGET_DISCOVERIES := 3
const GRASS_TEXTURE_PATH := "res://assets/tiles/ground/tile_grass_base.svg"
const BACKGROUND_TEXTURE_PATH := "res://assets/art/generated/garden_background.png"
const GARDEN_BOARD_TEXTURE_PATH := "res://assets/art/generated/garden_play_board_cropped.png"
const WATER_BUTTON_TEXTURE_PATH := "res://assets/ui/generated/water_button_cropped.png"

const COLOR_TEXT_DEEP := Color("#263D25")
const COLOR_CREAM := Color("#F1E7C8")
const COLOR_CREAM_SOFT := Color("#FBF4DD")
const COLOR_BUTTER := Color("#E7C767")
const COLOR_MOSS := Color("#496B43")
const COLOR_SOIL := Color("#765035")
const COLOR_CLAY := Color("#B86F4B")
const COLOR_MINT := Color("#DDEEC2")
const COLOR_CANVAS := Color("#EAF1D7")

const TOP_BAR_TOP := 54
const TOP_BAR_HEIGHT := 76
const TABS_TOP := TOP_BAR_TOP + TOP_BAR_HEIGHT + 34
const TABS_HEIGHT := 64
const GRID_TOP := TABS_TOP + TABS_HEIGHT + 30
const GRID_HEIGHT := 920
const SEED_BAR_TOP := GRID_TOP + GRID_HEIGHT + 36
const SEED_BAR_HEIGHT := 94
const WATER_BUTTON_TOP := SEED_BAR_TOP + SEED_BAR_HEIGHT + 16
const WATER_BUTTON_HEIGHT := 80
const STATUS_TOP := WATER_BUTTON_TOP + WATER_BUTTON_HEIGHT + 18

var garden_grid: GardenGrid
var seed_bar: SeedBar
var status_panel: GardenStatusPanel
var selected_seed_id := "carrot"
var harvest_value_label: Label
var diary_button_label: Label
var starter_bed_button: Button
var herb_bed_button: Button
var water_button: Button
var total_harvest := 0
var starter_goal_completed := false
var herb_bed_unlocked := false

func _ready() -> void:
	_create_background()
	_create_header_panel()
	_create_top_bar()
	_create_bed_tabs()
	_create_garden_frame()
	_create_garden_grid()
	_create_seed_bar()
	_create_water_button()
	_create_status_panel()

func _create_background() -> void:
	var background := TextureRect.new()
	background.name = "Background"
	background.texture = load(BACKGROUND_TEXTURE_PATH)
	background.position = Vector2.ZERO
	background.size = Vector2(1080, 1920)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	move_child(background, 0)

	var readability_wash := ColorRect.new()
	readability_wash.name = "ReadabilityWash"
	readability_wash.color = Color(0.95, 0.98, 0.82, 0.10)
	readability_wash.position = Vector2.ZERO
	readability_wash.size = Vector2(1080, 1920)
	readability_wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(readability_wash)

func _create_header_panel() -> void:
	var header_panel := _make_panel(Color(1.0, 0.97, 0.86, 0.76), Color(0.50, 0.36, 0.24, 0.42), 34, 2)
	header_panel.name = "HeaderPanel"
	header_panel.position = Vector2(30, 28)
	header_panel.size = Vector2(1020, 218)
	header_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(header_panel)

func _create_top_bar() -> void:
	var diary_button := Button.new()
	diary_button.name = "DiaryButton"
	diary_button.position = Vector2(44, TOP_BAR_TOP)
	diary_button.size = Vector2(220, TOP_BAR_HEIGHT)
	diary_button.focus_mode = Control.FOCUS_NONE
	_apply_pill_theme(diary_button, Color("#FFF7DF"), Color("#8A6647"))
	diary_button.pressed.connect(_on_diary_button_pressed)
	add_child(diary_button)

	diary_button_label = Label.new()
	diary_button_label.name = "DiaryButtonLabel"
	diary_button_label.text = "Diary"
	diary_button_label.position = Vector2(0, 0)
	diary_button_label.size = diary_button.size
	diary_button_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diary_button_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	diary_button_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	diary_button_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	diary_button_label.add_theme_font_size_override("font_size", 25)
	diary_button.add_child(diary_button_label)

	var basket_pill := _make_panel(Color("#F0CC61"), Color("#7A6032"), 30, 3)
	basket_pill.name = "BasketPill"
	basket_pill.position = Vector2(816, TOP_BAR_TOP)
	basket_pill.size = Vector2(220, TOP_BAR_HEIGHT)
	add_child(basket_pill)

	var basket_label := Label.new()
	basket_label.name = "BasketLabel"
	basket_label.text = "Baskets"
	basket_label.position = Vector2(20, 0)
	basket_label.size = Vector2(120, TOP_BAR_HEIGHT)
	basket_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	basket_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	basket_label.add_theme_font_size_override("font_size", 21)
	basket_pill.add_child(basket_label)

	harvest_value_label = Label.new()
	harvest_value_label.name = "HarvestValueLabel"
	harvest_value_label.text = "0"
	harvest_value_label.position = Vector2(140, 0)
	harvest_value_label.size = Vector2(60, TOP_BAR_HEIGHT)
	harvest_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	harvest_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	harvest_value_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	harvest_value_label.add_theme_font_size_override("font_size", 30)
	basket_pill.add_child(harvest_value_label)

func _create_bed_tabs() -> void:
	var tab_row := Control.new()
	tab_row.name = "BedTabs"
	tab_row.position = Vector2(0, TABS_TOP)
	tab_row.size = Vector2(1080, TABS_HEIGHT)
	add_child(tab_row)

	var tab_width := 200
	var tab_gap := 16
	var total := tab_width * 2 + tab_gap
	var start_x: float = (1080 - total) / 2.0

	starter_bed_button = Button.new()
	starter_bed_button.name = "StarterBedButton"
	starter_bed_button.text = "Starter"
	starter_bed_button.position = Vector2(start_x, 0)
	starter_bed_button.size = Vector2(tab_width, TABS_HEIGHT)
	_apply_tab_theme(starter_bed_button, true, false)
	starter_bed_button.pressed.connect(_on_starter_bed_pressed)
	tab_row.add_child(starter_bed_button)

	herb_bed_button = Button.new()
	herb_bed_button.name = "HerbBedButton"
	herb_bed_button.text = "Herb"
	herb_bed_button.position = Vector2(start_x + tab_width + tab_gap, 0)
	herb_bed_button.size = Vector2(tab_width, TABS_HEIGHT)
	_apply_tab_theme(herb_bed_button, false, true)
	herb_bed_button.disabled = true
	herb_bed_button.pressed.connect(_on_herb_bed_pressed)
	tab_row.add_child(herb_bed_button)

func _create_garden_frame() -> void:
	var board := TextureRect.new()
	board.name = "GardenBoard"
	board.texture = load(GARDEN_BOARD_TEXTURE_PATH)
	board.position = Vector2(18, GRID_TOP - 12)
	board.size = Vector2(1044, GRID_HEIGHT + 24)
	board.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	board.stretch_mode = TextureRect.STRETCH_SCALE
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(board)

func _create_garden_grid() -> void:
	garden_grid = GardenGrid.new()
	garden_grid.name = "GardenGrid"
	garden_grid.grid_top_offset = GRID_TOP + 90
	garden_grid.set_selected_seed(selected_seed_id)
	garden_grid.relationship_discovered.connect(_on_relationship_discovered)
	garden_grid.garden_message.connect(_on_garden_message)
	garden_grid.harvest_completed.connect(_on_harvest_completed)
	garden_grid.active_bed_changed.connect(_on_active_bed_changed)
	add_child(garden_grid)

func _create_seed_bar() -> void:
	var controls_panel := _make_panel(Color(1.0, 0.97, 0.86, 0.78), Color(0.50, 0.36, 0.24, 0.42), 34, 2)
	controls_panel.name = "ControlsPanel"
	controls_panel.position = Vector2(36, SEED_BAR_TOP - 34)
	controls_panel.size = Vector2(1008, 254)
	controls_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(controls_panel)

	seed_bar = SeedBar.new()
	seed_bar.name = "SeedBar"
	seed_bar.position = Vector2(56, SEED_BAR_TOP)
	seed_bar.setup(AVAILABLE_SEEDS, selected_seed_id)
	seed_bar.seed_selected.connect(_on_seed_selected)
	add_child(seed_bar)

func _create_water_button() -> void:
	water_button = Button.new()
	water_button.name = "WaterGardenButton"
	water_button.text = "Water Garden"
	water_button.position = Vector2(340, WATER_BUTTON_TOP)
	water_button.size = Vector2(400, WATER_BUTTON_HEIGHT)
	_apply_primary_button_theme(water_button)
	water_button.pressed.connect(_on_water_button_pressed)
	add_child(water_button)

func _create_status_panel() -> void:
	status_panel = GardenStatusPanel.new()
	status_panel.name = "GardenStatusPanel"
	status_panel.position = Vector2(0, 0)
	status_panel.setup()
	add_child(status_panel)

	status_panel.status_label.position = Vector2(60, STATUS_TOP)
	status_panel.status_label.size = Vector2(960, 60)

func _make_panel(bg: Color, border: Color, radius: int, border_width: int) -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(0.12, 0.10, 0.06, 0.24)
	style.shadow_size = 10
	style.shadow_offset = Vector2(0, 5)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _apply_pill_theme(button: Button, bg: Color, border: Color) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = bg
	normal.border_color = border
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(28)
	normal.shadow_color = Color(0.12, 0.10, 0.06, 0.25)
	normal.shadow_size = 5
	normal.shadow_offset = Vector2(0, 3)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(bg.r * 0.96, bg.g * 0.96, bg.b * 0.96)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(bg.r * 0.90, bg.g * 0.90, bg.b * 0.90)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

func _apply_tab_theme(button: Button, is_active: bool = false, is_locked: bool = false) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#FFF7DF") if is_active else Color("#E7EFD4")
	normal.border_color = Color("#7D5B3E") if is_active else Color("#809B70")
	normal.set_border_width_all(4 if is_active else 2)
	normal.set_corner_radius_all(22)
	normal.shadow_color = Color(0.09, 0.13, 0.07, 0.16)
	normal.shadow_size = 4
	normal.shadow_offset = Vector2(0, 2)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#FFFBEA") if is_active else Color("#F4F7E3")
	hover.border_color = Color("#8A6647")

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#FFF7DF")
	pressed.border_color = Color("#7D5B3E")
	pressed.set_border_width_all(4)

	var disabled := StyleBoxFlat.new()
	disabled.bg_color = Color(0.91, 0.91, 0.80, 0.70) if is_locked else normal.bg_color
	disabled.border_color = Color(0.45, 0.45, 0.35, 0.45) if is_locked else normal.border_color
	disabled.set_border_width_all(2)
	disabled.set_corner_radius_all(22)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_hover_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_pressed_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_disabled_color", Color(0.31, 0.36, 0.28, 0.72) if is_locked else COLOR_TEXT_DEEP)
	button.add_theme_font_size_override("font_size", 24)
	button.focus_mode = Control.FOCUS_NONE

func _apply_primary_button_theme(button: Button) -> void:
	var normal := StyleBoxTexture.new()
	normal.texture = load(WATER_BUTTON_TEXTURE_PATH)
	normal.content_margin_left = 24
	normal.content_margin_top = 12
	normal.content_margin_right = 24
	normal.content_margin_bottom = 12

	var hover := normal.duplicate() as StyleBoxTexture
	hover.modulate_color = Color(1.08, 1.08, 1.02)

	var pressed := normal.duplicate() as StyleBoxTexture
	pressed.modulate_color = Color(0.90, 0.95, 0.88)

	var disabled := normal.duplicate() as StyleBoxTexture
	disabled.modulate_color = Color(0.72, 0.78, 0.70)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_color", COLOR_CREAM)
	button.add_theme_color_override("font_hover_color", COLOR_CREAM_SOFT)
	button.add_theme_color_override("font_pressed_color", COLOR_CREAM)
	button.add_theme_color_override("font_disabled_color", COLOR_CREAM)
	button.add_theme_font_size_override("font_size", 27)
	button.focus_mode = Control.FOCUS_NONE

func _on_seed_selected(seed_id: String) -> void:
	selected_seed_id = seed_id
	garden_grid.set_selected_seed(selected_seed_id)

func _on_water_button_pressed() -> void:
	garden_grid.water_all()

func _on_starter_bed_pressed() -> void:
	if garden_grid.get_active_bed().bed_id == "starter_bed":
		return

	garden_grid.switch_bed("starter_bed")

func _on_herb_bed_pressed() -> void:
	if not herb_bed_unlocked:
		status_panel.show_message("Finish the Starter Bed to unlock the Herb Bed.")
		return

	garden_grid.switch_bed("herb_bed")

func _on_diary_button_pressed() -> void:
	status_panel.toggle_diary()

func _on_relationship_discovered(discovery: Dictionary) -> void:
	status_panel.show_discovery(discovery)
	_update_diary_label()
	_check_starter_goal()

func _on_garden_message(message: String) -> void:
	status_panel.show_message(message)

func _on_harvest_completed(harvest_result: Dictionary) -> void:
	total_harvest += harvest_result.get("yield_amount", 0)
	harvest_value_label.text = "%s" % total_harvest
	_check_starter_goal()

func _on_active_bed_changed(bed: GardenBed) -> void:
	_update_bed_tab_states(bed.bed_id)

func _update_bed_tab_states(active_bed_id: String) -> void:
	starter_bed_button.disabled = false
	herb_bed_button.disabled = not herb_bed_unlocked
	starter_bed_button.text = "Starter"
	herb_bed_button.text = "Herb" if herb_bed_unlocked else "Herb Locked"
	_apply_tab_theme(starter_bed_button, active_bed_id == "starter_bed", false)
	_apply_tab_theme(herb_bed_button, active_bed_id == "herb_bed", not herb_bed_unlocked)

func _update_diary_label() -> void:
	if diary_button_label == null or status_panel == null:
		return

	var count := status_panel.get_diary_entry_count()
	if count <= 0:
		diary_button_label.text = "Diary"
	else:
		diary_button_label.text = "Diary  %s" % count

func _check_starter_goal() -> void:
	if starter_goal_completed:
		return

	if total_harvest < TARGET_HARVEST:
		return

	if status_panel == null or status_panel.get_diary_entry_count() < TARGET_DISCOVERIES:
		return

	starter_goal_completed = true
	herb_bed_unlocked = true
	herb_bed_button.disabled = false
	status_panel.show_message("Herb Bed unlocked.")
