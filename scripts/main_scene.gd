extends Node2D

const AVAILABLE_SEEDS := ["carrot", "onion", "tomato", "basil", "potato", "bean", "corn", "squash"]
const TEXT_COLOR := Color(0.16, 0.24, 0.14)
const TARGET_HARVEST := 8
const TARGET_DISCOVERIES := 3
const GRASS_TEXTURE_PATH := "res://assets/tiles/ground/tile_grass_base.svg"
const SEED_SLOT_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot.svg"
const SEED_SLOT_SELECTED_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot_selected.svg"

var garden_grid: GardenGrid
var seed_bar: SeedBar
var status_panel: GardenStatusPanel
var selected_seed_id := "carrot"
var harvest_label: Label
var goal_label: Label
var bed_label: Label
var starter_bed_button: Button
var herb_bed_button: Button
var water_button: Button
var total_harvest := 0
var starter_goal_completed := false
var herb_bed_unlocked := false

func _ready() -> void:
	_create_background()
	_create_garden_backdrop()
	_create_title()
	_create_harvest_counter()
	_create_goal_label()
	_create_bed_label()
	_create_bed_selector()
	_create_garden_grid()
	_create_seed_bar()
	_create_care_button()
	_create_status_panel()
	_update_goal_label()

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

func _create_garden_backdrop() -> void:
	var garden_backdrop := TextureRect.new()
	garden_backdrop.name = "GardenBackdrop"
	garden_backdrop.texture = load(GRASS_TEXTURE_PATH)
	garden_backdrop.position = Vector2(28, 430)
	garden_backdrop.size = Vector2(1024, 890)
	garden_backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	garden_backdrop.stretch_mode = TextureRect.STRETCH_SCALE
	garden_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(garden_backdrop)

	var controls_backdrop := ColorRect.new()
	controls_backdrop.name = "ControlsBackdrop"
	controls_backdrop.color = Color(0.94, 0.86, 0.68, 0.88)
	controls_backdrop.position = Vector2(28, 1325)
	controls_backdrop.size = Vector2(1024, 555)
	add_child(controls_backdrop)

func _create_title() -> void:
	var title := Label.new()
	title.name = "Title"
	title.text = "Sprout & Soil"
	title.position = Vector2(0, 80)
	title.size = Vector2(1080, 80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 40)
	add_child(title)

	var hint := Label.new()
	hint.name = "Hint"
	hint.text = "Choose a seed, then tap an empty bed."
	hint.position = Vector2(0, 155)
	hint.size = Vector2(1080, 60)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", TEXT_COLOR)
	hint.add_theme_font_size_override("font_size", 28)
	add_child(hint)

func _create_garden_grid() -> void:
	garden_grid = GardenGrid.new()
	garden_grid.name = "GardenGrid"
	garden_grid.set_selected_seed(selected_seed_id)
	garden_grid.relationship_discovered.connect(_on_relationship_discovered)
	garden_grid.garden_message.connect(_on_garden_message)
	garden_grid.harvest_completed.connect(_on_harvest_completed)
	garden_grid.active_bed_changed.connect(_on_active_bed_changed)
	add_child(garden_grid)

func _create_harvest_counter() -> void:
	harvest_label = Label.new()
	harvest_label.name = "HarvestLabel"
	harvest_label.text = "Harvest Basket: 0"
	harvest_label.position = Vector2(0, 220)
	harvest_label.size = Vector2(1080, 50)
	harvest_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	harvest_label.add_theme_color_override("font_color", TEXT_COLOR)
	harvest_label.add_theme_font_size_override("font_size", 28)
	add_child(harvest_label)

func _create_goal_label() -> void:
	goal_label = Label.new()
	goal_label.name = "GoalLabel"
	goal_label.position = Vector2(0, 270)
	goal_label.size = Vector2(1080, 45)
	goal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	goal_label.add_theme_color_override("font_color", TEXT_COLOR)
	goal_label.add_theme_font_size_override("font_size", 24)
	add_child(goal_label)

func _create_bed_label() -> void:
	bed_label = Label.new()
	bed_label.name = "BedLabel"
	bed_label.text = "Starter Bed"
	bed_label.position = Vector2(0, 315)
	bed_label.size = Vector2(1080, 50)
	bed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bed_label.add_theme_color_override("font_color", TEXT_COLOR)
	bed_label.add_theme_font_size_override("font_size", 30)
	add_child(bed_label)

func _create_bed_selector() -> void:
	starter_bed_button = Button.new()
	starter_bed_button.name = "StarterBedButton"
	starter_bed_button.text = "Starter"
	starter_bed_button.position = Vector2(330, 365)
	starter_bed_button.size = Vector2(190, 60)
	_apply_button_theme(starter_bed_button)
	starter_bed_button.pressed.connect(_on_starter_bed_pressed)
	add_child(starter_bed_button)

	herb_bed_button = Button.new()
	herb_bed_button.name = "HerbBedButton"
	herb_bed_button.text = "Herb Locked"
	herb_bed_button.position = Vector2(560, 365)
	herb_bed_button.size = Vector2(190, 60)
	_apply_button_theme(herb_bed_button)
	herb_bed_button.disabled = true
	herb_bed_button.pressed.connect(_on_herb_bed_pressed)
	add_child(herb_bed_button)

func _create_seed_bar() -> void:
	seed_bar = SeedBar.new()
	seed_bar.name = "SeedBar"
	seed_bar.position = Vector2(0, 1300)
	seed_bar.setup(AVAILABLE_SEEDS, selected_seed_id)
	seed_bar.seed_selected.connect(_on_seed_selected)
	add_child(seed_bar)

func _create_care_button() -> void:
	water_button = Button.new()
	water_button.name = "WaterGardenButton"
	water_button.text = "Water Garden"
	water_button.position = Vector2(390, 1500)
	water_button.size = Vector2(300, 80)
	_apply_button_theme(water_button)
	water_button.pressed.connect(_on_water_button_pressed)
	add_child(water_button)

func _create_status_panel() -> void:
	status_panel = GardenStatusPanel.new()
	status_panel.name = "GardenStatusPanel"
	status_panel.position = Vector2(0, 1600)
	status_panel.setup()
	add_child(status_panel)

func _apply_button_theme(button: Button) -> void:
	var normal_style := StyleBoxTexture.new()
	normal_style.texture = load(SEED_SLOT_TEXTURE_PATH)
	normal_style.content_margin_left = 14
	normal_style.content_margin_top = 14
	normal_style.content_margin_right = 14
	normal_style.content_margin_bottom = 14

	var hover_style := StyleBoxTexture.new()
	hover_style.texture = load(SEED_SLOT_SELECTED_TEXTURE_PATH)
	hover_style.content_margin_left = 14
	hover_style.content_margin_top = 14
	hover_style.content_margin_right = 14
	hover_style.content_margin_bottom = 14

	var disabled_style := StyleBoxTexture.new()
	disabled_style.texture = load(SEED_SLOT_SELECTED_TEXTURE_PATH)
	disabled_style.content_margin_left = 14
	disabled_style.content_margin_top = 14
	disabled_style.content_margin_right = 14
	disabled_style.content_margin_bottom = 14

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	button.add_theme_color_override("font_color", TEXT_COLOR)
	button.add_theme_color_override("font_hover_color", TEXT_COLOR)
	button.add_theme_color_override("font_pressed_color", TEXT_COLOR)
	button.add_theme_color_override("font_disabled_color", TEXT_COLOR)
	button.add_theme_font_size_override("font_size", 18)

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
	_update_goal_label()
	_check_starter_goal()

func _on_garden_message(message: String) -> void:
	status_panel.show_message(message)

func _on_harvest_completed(harvest_result: Dictionary) -> void:
	total_harvest += harvest_result.get("yield_amount", 0)
	harvest_label.text = "Harvest Basket: %s" % total_harvest
	_update_goal_label()
	_check_starter_goal()

func _on_active_bed_changed(bed: GardenBed) -> void:
	bed_label.text = bed.display_name
	starter_bed_button.disabled = bed.bed_id == "starter_bed"
	herb_bed_button.disabled = bed.bed_id == "herb_bed" or not herb_bed_unlocked

func _update_goal_label() -> void:
	goal_label.text = "Goal: %s/%s baskets  |  %s/%s discoveries" % [
		min(total_harvest, TARGET_HARVEST),
		TARGET_HARVEST,
		min(status_panel.get_diary_entry_count() if status_panel != null else 0, TARGET_DISCOVERIES),
		TARGET_DISCOVERIES
	]

func _check_starter_goal() -> void:
	if starter_goal_completed:
		return

	if total_harvest < TARGET_HARVEST:
		return

	if status_panel == null or status_panel.get_diary_entry_count() < TARGET_DISCOVERIES:
		return

	starter_goal_completed = true
	herb_bed_unlocked = true
	herb_bed_button.text = "Herb Bed"
	herb_bed_button.disabled = false
	status_panel.show_message("Starter Bed complete!\nHerb Bed unlocked.")
