class_name SeedBar
extends Control

signal seed_selected(seed_id: String)

const TEXT_COLOR := Color(0.16, 0.24, 0.14)
const SEED_SLOT_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot.svg"
const SEED_SLOT_SELECTED_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot_selected.svg"

var available_seeds: Array = []
var selected_seed_id := "carrot"
var seed_buttons: Dictionary = {}
var selected_seed_label: Label
var seed_container: HBoxContainer

func setup(seed_ids: Array, initial_seed_id: String) -> void:
	available_seeds = seed_ids.duplicate()
	selected_seed_id = initial_seed_id
	_build_ui()
	_update_selection_ui()

func set_selected_seed(seed_id: String) -> void:
	if selected_seed_id == seed_id:
		return

	selected_seed_id = seed_id
	_update_selection_ui()

func _build_ui() -> void:
	if selected_seed_label != null:
		return

	size = Vector2(1080, 200)

	selected_seed_label = Label.new()
	selected_seed_label.name = "SelectedSeedLabel"
	selected_seed_label.position = Vector2(0, 0)
	selected_seed_label.size = Vector2(1080, 50)
	selected_seed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selected_seed_label.add_theme_color_override("font_color", TEXT_COLOR)
	selected_seed_label.add_theme_font_size_override("font_size", 28)
	add_child(selected_seed_label)

	seed_container = HBoxContainer.new()
	seed_container.name = "SeedContainer"
	seed_container.position = Vector2(44, 70)
	seed_container.size = Vector2(992, 128)
	seed_container.alignment = BoxContainer.ALIGNMENT_CENTER
	seed_container.add_theme_constant_override("separation", 10)
	add_child(seed_container)

	for seed_id_value in available_seeds:
		var seed_id := str(seed_id_value)
		var button := Button.new()
		button.name = "%sSeedButton" % seed_id.capitalize()
		button.text = PlantData.get_display_name(seed_id)
		button.custom_minimum_size = Vector2(116, 118)
		_apply_seed_button_theme(button)
		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		seed_container.add_child(button)
		seed_buttons[seed_id] = button

func _apply_seed_button_theme(button: Button) -> void:
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

func _on_seed_button_pressed(seed_id: String) -> void:
	selected_seed_id = seed_id
	_update_selection_ui()
	seed_selected.emit(seed_id)

func _update_selection_ui() -> void:
	if selected_seed_label == null:
		return

	selected_seed_label.text = "Selected seed: %s" % PlantData.get_display_name(selected_seed_id)

	for seed_id in seed_buttons.keys():
		var button: Button = seed_buttons[seed_id]
		button.disabled = seed_id == selected_seed_id
