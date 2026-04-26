extends Node2D

const AVAILABLE_SEEDS := ["carrot", "onion", "tomato", "basil", "potato", "bean", "corn", "squash"]
const TARGET_HARVEST := 8
const TARGET_DISCOVERIES := 3
const GRASS_TEXTURE_PATH := "res://assets/tiles/ground/tile_grass_base.svg"

const COLOR_TEXT_DEEP := Color("#263D25")
const COLOR_TEXT_SOFT := Color("#4A5C42")
const COLOR_CREAM := Color("#F1E7C8")
const COLOR_CREAM_SOFT := Color("#FBF4DD")
const COLOR_SAGE := Color("#AFCB9B")
const COLOR_MOSS := Color("#627A4E")
const COLOR_SOIL := Color("#7B5738")
const COLOR_CLAY := Color("#B86F4B")
const COLOR_BUTTER := Color("#E7C767")
const COLOR_PROGRESS_TRACK := Color("#D8C99A")
const COLOR_PROGRESS_FILL := Color("#7B9B5A")

const HEADER_TOP := 36
const HEADER_HEIGHT := 200
const TABS_TOP := HEADER_TOP + HEADER_HEIGHT + 16
const TABS_HEIGHT := 76
const GRID_TOP := TABS_TOP + TABS_HEIGHT + 24
const GRID_HEIGHT := 880
const BOTTOM_PANEL_TOP := GRID_TOP + GRID_HEIGHT + 16
const BOTTOM_PANEL_HEIGHT := 1920 - BOTTOM_PANEL_TOP - 28

var garden_grid: GardenGrid
var seed_bar: SeedBar
var status_panel: GardenStatusPanel
var selected_seed_id := "carrot"
var harvest_value_label: Label
var goal_progress_label: Label
var harvest_progress_bar: ProgressBar
var discovery_progress_bar: ProgressBar
var bed_label: Label
var starter_bed_button: Button
var herb_bed_button: Button
var water_button: Button
var total_harvest := 0
var starter_goal_completed := false
var herb_bed_unlocked := false

func _ready() -> void:
	_create_background()
	_create_header_panel()
	_create_bed_tabs()
	_create_garden_frame()
	_create_garden_grid()
	_create_bottom_panel()
	_create_seed_bar()
	_create_care_button()
	_create_status_panel()
	_update_goal_display()

func _create_background() -> void:
	var background := TextureRect.new()
	background.name = "Background"
	background.texture = load(GRASS_TEXTURE_PATH)
	background.position = Vector2.ZERO
	background.size = Vector2(1080, 1920)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	move_child(background, 0)

	var vignette := ColorRect.new()
	vignette.name = "Vignette"
	vignette.color = Color(0.16, 0.20, 0.12, 0.18)
	vignette.position = Vector2.ZERO
	vignette.size = Vector2(1080, 1920)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette)

func _create_header_panel() -> void:
	var panel := _make_panel(COLOR_CREAM, COLOR_SOIL, 28, 4)
	panel.name = "HeaderPanel"
	panel.position = Vector2(28, HEADER_TOP)
	panel.size = Vector2(1024, HEADER_HEIGHT)
	add_child(panel)

	var title := Label.new()
	title.name = "Title"
	title.text = "Sprout & Soil"
	title.position = Vector2(40, 18)
	title.size = Vector2(620, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	title.add_theme_font_size_override("font_size", 44)
	panel.add_child(title)

	var basket_badge := _make_panel(COLOR_BUTTER, COLOR_SOIL, 22, 3)
	basket_badge.name = "BasketBadge"
	basket_badge.position = Vector2(720, 22)
	basket_badge.size = Vector2(264, 60)
	panel.add_child(basket_badge)

	var basket_label := Label.new()
	basket_label.name = "BasketLabel"
	basket_label.text = "Baskets"
	basket_label.position = Vector2(20, 0)
	basket_label.size = Vector2(140, 60)
	basket_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	basket_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	basket_label.add_theme_font_size_override("font_size", 24)
	basket_badge.add_child(basket_label)

	harvest_value_label = Label.new()
	harvest_value_label.name = "HarvestValueLabel"
	harvest_value_label.text = "0"
	harvest_value_label.position = Vector2(150, 0)
	harvest_value_label.size = Vector2(110, 60)
	harvest_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	harvest_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	harvest_value_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	harvest_value_label.add_theme_font_size_override("font_size", 30)
	basket_badge.add_child(harvest_value_label)

	var hint := Label.new()
	hint.name = "Hint"
	hint.text = "Choose a seed, then tap an empty bed."
	hint.position = Vector2(40, 84)
	hint.size = Vector2(944, 32)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	hint.add_theme_color_override("font_color", COLOR_TEXT_SOFT)
	hint.add_theme_font_size_override("font_size", 22)
	panel.add_child(hint)

	goal_progress_label = Label.new()
	goal_progress_label.name = "GoalProgressLabel"
	goal_progress_label.position = Vector2(40, 122)
	goal_progress_label.size = Vector2(944, 28)
	goal_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	goal_progress_label.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	goal_progress_label.add_theme_font_size_override("font_size", 20)
	panel.add_child(goal_progress_label)

	harvest_progress_bar = _make_progress_bar()
	harvest_progress_bar.name = "HarvestProgressBar"
	harvest_progress_bar.position = Vector2(40, 156)
	harvest_progress_bar.size = Vector2(460, 22)
	harvest_progress_bar.max_value = TARGET_HARVEST
	panel.add_child(harvest_progress_bar)

	discovery_progress_bar = _make_progress_bar()
	discovery_progress_bar.name = "DiscoveryProgressBar"
	discovery_progress_bar.position = Vector2(524, 156)
	discovery_progress_bar.size = Vector2(460, 22)
	discovery_progress_bar.max_value = TARGET_DISCOVERIES
	panel.add_child(discovery_progress_bar)

func _create_bed_tabs() -> void:
	var tab_row := Control.new()
	tab_row.name = "BedTabs"
	tab_row.position = Vector2(28, TABS_TOP)
	tab_row.size = Vector2(1024, TABS_HEIGHT)
	add_child(tab_row)

	bed_label = Label.new()
	bed_label.name = "BedLabel"
	bed_label.text = "Starter Bed"
	bed_label.position = Vector2(0, 0)
	bed_label.size = Vector2(360, TABS_HEIGHT)
	bed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	bed_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	bed_label.add_theme_color_override("font_color", COLOR_CREAM)
	bed_label.add_theme_color_override("font_shadow_color", Color(0.10, 0.16, 0.08, 0.85))
	bed_label.add_theme_constant_override("shadow_offset_x", 0)
	bed_label.add_theme_constant_override("shadow_offset_y", 3)
	bed_label.add_theme_font_size_override("font_size", 30)
	tab_row.add_child(bed_label)

	starter_bed_button = Button.new()
	starter_bed_button.name = "StarterBedButton"
	starter_bed_button.text = "Starter"
	starter_bed_button.position = Vector2(560, 0)
	starter_bed_button.size = Vector2(220, TABS_HEIGHT)
	_apply_tab_theme(starter_bed_button)
	starter_bed_button.pressed.connect(_on_starter_bed_pressed)
	tab_row.add_child(starter_bed_button)

	herb_bed_button = Button.new()
	herb_bed_button.name = "HerbBedButton"
	herb_bed_button.text = "Herb (locked)"
	herb_bed_button.position = Vector2(794, 0)
	herb_bed_button.size = Vector2(230, TABS_HEIGHT)
	_apply_tab_theme(herb_bed_button)
	herb_bed_button.disabled = true
	herb_bed_button.pressed.connect(_on_herb_bed_pressed)
	tab_row.add_child(herb_bed_button)

func _create_garden_frame() -> void:
	var frame := _make_panel(COLOR_SOIL, COLOR_CLAY, 32, 5)
	frame.name = "GardenFrame"
	frame.position = Vector2(28, GRID_TOP)
	frame.size = Vector2(1024, GRID_HEIGHT)
	add_child(frame)

	var inner := TextureRect.new()
	inner.name = "GardenSoil"
	inner.texture = load(GRASS_TEXTURE_PATH)
	inner.position = Vector2(20, 20)
	inner.size = Vector2(984, GRID_HEIGHT - 40)
	inner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	inner.stretch_mode = TextureRect.STRETCH_SCALE
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(inner)

	var inner_shade := ColorRect.new()
	inner_shade.name = "GardenSoilShade"
	inner_shade.color = Color(0.10, 0.18, 0.08, 0.18)
	inner_shade.position = Vector2(20, 20)
	inner_shade.size = inner.size
	inner_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(inner_shade)

func _create_garden_grid() -> void:
	garden_grid = GardenGrid.new()
	garden_grid.name = "GardenGrid"
	garden_grid.grid_top_offset = GRID_TOP + 26
	garden_grid.set_selected_seed(selected_seed_id)
	garden_grid.relationship_discovered.connect(_on_relationship_discovered)
	garden_grid.garden_message.connect(_on_garden_message)
	garden_grid.harvest_completed.connect(_on_harvest_completed)
	garden_grid.active_bed_changed.connect(_on_active_bed_changed)
	add_child(garden_grid)

func _create_bottom_panel() -> void:
	var panel := _make_panel(COLOR_CREAM_SOFT, COLOR_SOIL, 32, 4)
	panel.name = "BottomPanel"
	panel.position = Vector2(28, BOTTOM_PANEL_TOP)
	panel.size = Vector2(1024, BOTTOM_PANEL_HEIGHT)
	add_child(panel)

func _create_seed_bar() -> void:
	seed_bar = SeedBar.new()
	seed_bar.name = "SeedBar"
	seed_bar.position = Vector2(56, BOTTOM_PANEL_TOP + 24)
	seed_bar.setup(AVAILABLE_SEEDS, selected_seed_id)
	seed_bar.seed_selected.connect(_on_seed_selected)
	add_child(seed_bar)

func _create_care_button() -> void:
	water_button = Button.new()
	water_button.name = "WaterGardenButton"
	water_button.text = "Water Garden"
	water_button.position = Vector2(360, BOTTOM_PANEL_TOP + 250)
	water_button.size = Vector2(360, 86)
	_apply_primary_button_theme(water_button)
	water_button.pressed.connect(_on_water_button_pressed)
	add_child(water_button)

func _create_status_panel() -> void:
	status_panel = GardenStatusPanel.new()
	status_panel.name = "GardenStatusPanel"
	status_panel.position = Vector2(56, BOTTOM_PANEL_TOP + 350)
	status_panel.setup()
	add_child(status_panel)

func _make_panel(bg: Color, border: Color, radius: int, border_width: int) -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(0.12, 0.10, 0.06, 0.30)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 4)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _make_progress_bar() -> ProgressBar:
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.min_value = 0

	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = COLOR_PROGRESS_TRACK
	bg_style.border_color = COLOR_SOIL
	bg_style.set_border_width_all(2)
	bg_style.set_corner_radius_all(11)

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = COLOR_PROGRESS_FILL
	fill_style.set_corner_radius_all(11)

	bar.add_theme_stylebox_override("background", bg_style)
	bar.add_theme_stylebox_override("fill", fill_style)
	return bar

func _apply_tab_theme(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = COLOR_SAGE
	normal.border_color = COLOR_MOSS
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(20)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#C0D6AC")

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = COLOR_CREAM
	pressed.border_color = COLOR_SOIL
	pressed.set_border_width_all(4)

	var disabled := StyleBoxFlat.new()
	disabled.bg_color = COLOR_CREAM
	disabled.border_color = COLOR_SOIL
	disabled.set_border_width_all(4)
	disabled.set_corner_radius_all(20)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_hover_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_pressed_color", COLOR_TEXT_DEEP)
	button.add_theme_color_override("font_disabled_color", COLOR_TEXT_DEEP)
	button.add_theme_font_size_override("font_size", 26)
	button.focus_mode = Control.FOCUS_NONE

func _apply_primary_button_theme(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = COLOR_MOSS
	normal.border_color = Color("#3F5532")
	normal.set_border_width_all(4)
	normal.set_corner_radius_all(28)
	normal.shadow_color = Color(0.10, 0.16, 0.08, 0.55)
	normal.shadow_size = 8
	normal.shadow_offset = Vector2(0, 5)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#74905D")

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#506840")
	pressed.shadow_offset = Vector2(0, 2)

	var disabled := normal.duplicate() as StyleBoxFlat
	disabled.bg_color = Color("#9CAB8B")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_color", COLOR_CREAM)
	button.add_theme_color_override("font_hover_color", COLOR_CREAM_SOFT)
	button.add_theme_color_override("font_pressed_color", COLOR_CREAM)
	button.add_theme_color_override("font_disabled_color", COLOR_CREAM)
	button.add_theme_font_size_override("font_size", 30)
	button.focus_mode = Control.FOCUS_NONE

func _on_seed_selected(seed_id: String) -> void:
	selected_seed_id = seed_id
	garden_grid.set_selected_seed(selected_seed_id)

func _on_water_button_pressed() -> void:
	garden_grid.water_all()

func _on_starter_bed_pressed() -> void:
	garden_grid.switch_bed("starter_bed")

func _on_herb_bed_pressed() -> void:
	if not herb_bed_unlocked:
		status_panel.show_message("Complete the Starter Bed goal to unlock the Herb Bed.")
		return

	garden_grid.switch_bed("herb_bed")

func _on_relationship_discovered(discovery: Dictionary) -> void:
	status_panel.show_discovery(discovery)
	_update_goal_display()
	_check_starter_goal()

func _on_garden_message(message: String) -> void:
	status_panel.show_message(message)

func _on_harvest_completed(harvest_result: Dictionary) -> void:
	total_harvest += harvest_result.get("yield_amount", 0)
	harvest_value_label.text = "%s" % total_harvest
	_update_goal_display()
	_check_starter_goal()

func _on_active_bed_changed(bed: GardenBed) -> void:
	bed_label.text = bed.display_name
	starter_bed_button.disabled = bed.bed_id == "starter_bed"
	herb_bed_button.disabled = bed.bed_id == "herb_bed" or not herb_bed_unlocked

func _update_goal_display() -> void:
	var discoveries := status_panel.get_diary_entry_count() if status_panel != null else 0
	var harvest_clamped := min(total_harvest, TARGET_HARVEST)
	var discoveries_clamped := min(discoveries, TARGET_DISCOVERIES)

	goal_progress_label.text = "Goal:  %s/%s baskets    %s/%s discoveries" % [
		harvest_clamped,
		TARGET_HARVEST,
		discoveries_clamped,
		TARGET_DISCOVERIES
	]

	if harvest_progress_bar != null:
		harvest_progress_bar.value = harvest_clamped
	if discovery_progress_bar != null:
		discovery_progress_bar.value = discoveries_clamped

func _check_starter_goal() -> void:
	if starter_goal_completed:
		return

	if total_harvest < TARGET_HARVEST:
		return

	if status_panel == null or status_panel.get_diary_entry_count() < TARGET_DISCOVERIES:
		return

	starter_goal_completed = true
	herb_bed_unlocked = true
	herb_bed_button.text = "Herb"
	herb_bed_button.disabled = false
	status_panel.show_message("Starter Bed complete!\nHerb Bed unlocked.")
