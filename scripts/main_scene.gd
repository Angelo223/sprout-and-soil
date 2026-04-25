extends Node2D

const AVAILABLE_SEEDS := ["carrot", "onion", "tomato", "basil", "potato", "bean", "corn", "squash"]
const TEXT_COLOR := Color(0.16, 0.24, 0.14)
const BUTTON_COLOR := Color(0.33, 0.42, 0.31)
const BUTTON_SELECTED_COLOR := Color(0.73, 0.82, 0.66)
const TARGET_HARVEST := 8
const TARGET_DISCOVERIES := 3

var garden_grid: GardenGrid
var selected_seed_id := "carrot"
var seed_buttons: Dictionary = {}
var selected_seed_label: Label
var harvest_label: Label
var goal_label: Label
var bed_label: Label
var discovery_label: Label
var diary_label: Label
var water_button: Button
var diary_entries: Array[String] = []
var total_harvest := 0
var starter_goal_completed := false

func _ready() -> void:
	_create_background()
	_create_title()
	_create_harvest_counter()
	_create_goal_label()
	_create_bed_label()
	_create_garden_grid()
	_create_seed_bar()
	_create_care_button()
	_create_status_panel()
	_create_diary_panel()
	_update_seed_selection_ui()
	_update_goal_label()

func _create_background() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.78, 0.91, 0.72)
	background.size = Vector2(1080, 1920)
	add_child(background)
	move_child(background, 0)

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
	bed_label.position = Vector2(0, 320)
	bed_label.size = Vector2(1080, 50)
	bed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bed_label.add_theme_color_override("font_color", TEXT_COLOR)
	bed_label.add_theme_font_size_override("font_size", 30)
	add_child(bed_label)

func _create_seed_bar() -> void:
	selected_seed_label = Label.new()
	selected_seed_label.name = "SelectedSeedLabel"
	selected_seed_label.position = Vector2(0, 1230)
	selected_seed_label.size = Vector2(1080, 50)
	selected_seed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selected_seed_label.add_theme_color_override("font_color", TEXT_COLOR)
	selected_seed_label.add_theme_font_size_override("font_size", 28)
	add_child(selected_seed_label)

	var seed_bar := HBoxContainer.new()
	seed_bar.name = "SeedBar"
	seed_bar.position = Vector2(70, 1300)
	seed_bar.size = Vector2(940, 120)
	seed_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	seed_bar.add_theme_constant_override("separation", 16)
	add_child(seed_bar)

	for seed_id in AVAILABLE_SEEDS:
		var button := Button.new()
		button.name = "%sSeedButton" % seed_id.capitalize()
		button.text = PlantData.get_display_name(seed_id)
		button.custom_minimum_size = Vector2(100, 100)
		_apply_seed_button_theme(button)
		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		seed_bar.add_child(button)
		seed_buttons[seed_id] = button

func _create_care_button() -> void:
	water_button = Button.new()
	water_button.name = "WaterGardenButton"
	water_button.text = "Water Garden"
	water_button.position = Vector2(390, 1430)
	water_button.size = Vector2(300, 80)
	_apply_seed_button_theme(water_button)
	water_button.pressed.connect(_on_water_button_pressed)
	add_child(water_button)

func _create_status_panel() -> void:
	discovery_label = Label.new()
	discovery_label.name = "StatusLabel"
	discovery_label.text = "Plant neighbors, water the garden, then tap mature plants to harvest."
	discovery_label.position = Vector2(110, 1540)
	discovery_label.size = Vector2(860, 110)
	discovery_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	discovery_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	discovery_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	discovery_label.add_theme_color_override("font_color", TEXT_COLOR)
	discovery_label.add_theme_font_size_override("font_size", 24)
	add_child(discovery_label)

func _create_diary_panel() -> void:
	diary_label = Label.new()
	diary_label.name = "DiaryLabel"
	diary_label.text = "Garden Diary\nNo plant relationships discovered yet."
	diary_label.position = Vector2(110, 1685)
	diary_label.size = Vector2(860, 190)
	diary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	diary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	diary_label.add_theme_color_override("font_color", TEXT_COLOR)
	diary_label.add_theme_font_size_override("font_size", 21)
	add_child(diary_label)

func _apply_seed_button_theme(button: Button) -> void:
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = BUTTON_COLOR
	normal_style.corner_radius_top_left = 6
	normal_style.corner_radius_top_right = 6
	normal_style.corner_radius_bottom_left = 6
	normal_style.corner_radius_bottom_right = 6

	var hover_style := normal_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = Color(0.39, 0.49, 0.36)

	var disabled_style := normal_style.duplicate() as StyleBoxFlat
	disabled_style.bg_color = BUTTON_SELECTED_COLOR

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	button.add_theme_color_override("font_color", Color(0.98, 1.0, 0.94))
	button.add_theme_color_override("font_hover_color", Color(0.98, 1.0, 0.94))
	button.add_theme_color_override("font_pressed_color", Color(0.98, 1.0, 0.94))
	button.add_theme_color_override("font_disabled_color", TEXT_COLOR)
	button.add_theme_font_size_override("font_size", 21)

func _on_seed_button_pressed(seed_id: String) -> void:
	selected_seed_id = seed_id
	garden_grid.set_selected_seed(selected_seed_id)
	_update_seed_selection_ui()

func _update_seed_selection_ui() -> void:
	selected_seed_label.text = "Selected seed: %s" % PlantData.get_display_name(selected_seed_id)

	for seed_id in seed_buttons.keys():
		var button: Button = seed_buttons[seed_id]
		button.disabled = seed_id == selected_seed_id

func _on_water_button_pressed() -> void:
	garden_grid.water_all()

func _on_relationship_discovered(discovery: Dictionary) -> void:
	var first_name := PlantData.get_display_name(discovery.get("first_plant_id", ""))
	var second_name := PlantData.get_display_name(discovery.get("second_plant_id", ""))
	var type_label := PlantRelationshipData.get_type_label(discovery.get("type", PlantRelationshipData.TYPE_NEUTRAL))
	var title: String = discovery.get("title", "New discovery")
	discovery_label.text = "New discovery: %s + %s\n%s" % [first_name, second_name, title]
	_add_diary_entry("%s: %s + %s - %s" % [type_label, first_name, second_name, title])
	_update_goal_label()
	_check_starter_goal()

func _on_garden_message(message: String) -> void:
	discovery_label.text = message

func _on_harvest_completed(harvest_result: Dictionary) -> void:
	total_harvest += harvest_result.get("yield_amount", 0)
	harvest_label.text = "Harvest Basket: %s" % total_harvest
	_update_goal_label()
	_check_starter_goal()

func _add_diary_entry(entry: String) -> void:
	if diary_entries.has(entry):
		return

	diary_entries.append(entry)
	_update_diary_label()

func _update_diary_label() -> void:
	var diary_text := "Garden Diary (%s)" % diary_entries.size()
	var start_index: int = max(diary_entries.size() - 4, 0)

	for index in range(start_index, diary_entries.size()):
		diary_text += "\n- %s" % diary_entries[index]

	diary_label.text = diary_text

func _update_goal_label() -> void:
	goal_label.text = "Goal: %s/%s baskets  |  %s/%s discoveries" % [
		min(total_harvest, TARGET_HARVEST),
		TARGET_HARVEST,
		min(diary_entries.size(), TARGET_DISCOVERIES),
		TARGET_DISCOVERIES
	]

func _check_starter_goal() -> void:
	if starter_goal_completed:
		return

	if total_harvest < TARGET_HARVEST:
		return

	if diary_entries.size() < TARGET_DISCOVERIES:
		return

	starter_goal_completed = true
	discovery_label.text = "Starter Bed complete!\nA new garden bed can be unlocked next."
