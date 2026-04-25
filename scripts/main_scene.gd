extends Node2D

const AVAILABLE_SEEDS := ["carrot", "onion", "tomato", "basil"]

var garden_grid: GardenGrid
var selected_seed_id := "carrot"
var seed_buttons: Dictionary = {}
var selected_seed_label: Label

func _ready() -> void:
	_create_background()
	_create_title()
	_create_garden_grid()
	_create_seed_bar()
	_update_seed_selection_ui()

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
	add_child(title)

	var hint := Label.new()
	hint.name = "Hint"
	hint.text = "Choose a seed, then tap an empty bed."
	hint.position = Vector2(0, 155)
	hint.size = Vector2(1080, 60)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hint)

func _create_garden_grid() -> void:
	garden_grid = GardenGrid.new()
	garden_grid.name = "GardenGrid"
	garden_grid.set_selected_seed(selected_seed_id)
	add_child(garden_grid)

func _create_seed_bar() -> void:
	selected_seed_label = Label.new()
	selected_seed_label.name = "SelectedSeedLabel"
	selected_seed_label.position = Vector2(0, 1230)
	selected_seed_label.size = Vector2(1080, 50)
	selected_seed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
		button.custom_minimum_size = Vector2(210, 100)
		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		seed_bar.add_child(button)
		seed_buttons[seed_id] = button

func _on_seed_button_pressed(seed_id: String) -> void:
	selected_seed_id = seed_id
	garden_grid.set_selected_seed(selected_seed_id)
	_update_seed_selection_ui()

func _update_seed_selection_ui() -> void:
	selected_seed_label.text = "Selected seed: %s" % PlantData.get_display_name(selected_seed_id)

	for seed_id in seed_buttons.keys():
		var button: Button = seed_buttons[seed_id]
		button.disabled = seed_id == selected_seed_id
