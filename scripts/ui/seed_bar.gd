class_name SeedBar
extends Control

signal seed_selected(seed_id: String)

const TEXT_DEEP := Color("#263D25")
const SEED_SLOT_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot.svg"
const SEED_SLOT_SELECTED_TEXTURE_PATH := "res://assets/ui/seed_bar/ui_seed_slot_selected.svg"

const BAR_WIDTH := 968
const BAR_HEIGHT := 170
const SLOT_HEIGHT := 158
const SLOT_GAP := 12
const SLOT_MIN_WIDTH := 96
const SLOT_MAX_WIDTH := 150

var available_seeds: Array = []
var selected_seed_id := "carrot"
var seed_buttons: Dictionary = {}
var scroll_container: ScrollContainer
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
	if scroll_container != null:
		return

	size = Vector2(BAR_WIDTH, BAR_HEIGHT)

	scroll_container = ScrollContainer.new()
	scroll_container.name = "SeedScrollContainer"
	scroll_container.position = Vector2(0, 0)
	scroll_container.size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.follow_focus = true
	scroll_container.scroll_deadzone = 12
	add_child(scroll_container)

	seed_container = HBoxContainer.new()
	seed_container.name = "SeedContainer"
	seed_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	seed_container.alignment = BoxContainer.ALIGNMENT_CENTER
	seed_container.add_theme_constant_override("separation", SLOT_GAP)
	scroll_container.add_child(seed_container)

	var slot_width: int = _compute_slot_width(available_seeds.size())

	for seed_id_value in available_seeds:
		var seed_id := str(seed_id_value)
		var button := Button.new()
		button.name = "%sSeedButton" % seed_id.capitalize()
		button.text = PlantData.get_display_name(seed_id)
		button.custom_minimum_size = Vector2(slot_width, SLOT_HEIGHT)
		button.focus_mode = Control.FOCUS_NONE
		_apply_seed_button_theme(button)
		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		seed_container.add_child(button)
		seed_buttons[seed_id] = button

func _compute_slot_width(seed_count: int) -> int:
	if seed_count <= 0:
		return SLOT_MAX_WIDTH

	var available_width: int = BAR_WIDTH - (seed_count - 1) * SLOT_GAP
	var ideal_width: int = int(float(available_width) / float(seed_count))
	return clampi(ideal_width, SLOT_MIN_WIDTH, SLOT_MAX_WIDTH)

func _apply_seed_button_theme(button: Button) -> void:
	var normal_style := StyleBoxTexture.new()
	normal_style.texture = load(SEED_SLOT_TEXTURE_PATH)
	normal_style.content_margin_left = 12
	normal_style.content_margin_top = 12
	normal_style.content_margin_right = 12
	normal_style.content_margin_bottom = 12

	var hover_style := StyleBoxTexture.new()
	hover_style.texture = load(SEED_SLOT_SELECTED_TEXTURE_PATH)
	hover_style.content_margin_left = 12
	hover_style.content_margin_top = 12
	hover_style.content_margin_right = 12
	hover_style.content_margin_bottom = 12

	var disabled_style := StyleBoxTexture.new()
	disabled_style.texture = load(SEED_SLOT_SELECTED_TEXTURE_PATH)
	disabled_style.content_margin_left = 12
	disabled_style.content_margin_top = 12
	disabled_style.content_margin_right = 12
	disabled_style.content_margin_bottom = 12

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	button.add_theme_color_override("font_color", TEXT_DEEP)
	button.add_theme_color_override("font_hover_color", TEXT_DEEP)
	button.add_theme_color_override("font_pressed_color", TEXT_DEEP)
	button.add_theme_color_override("font_disabled_color", TEXT_DEEP)
	button.add_theme_font_size_override("font_size", 18)

func _on_seed_button_pressed(seed_id: String) -> void:
	selected_seed_id = seed_id
	_update_selection_ui()
	seed_selected.emit(seed_id)

func _update_selection_ui() -> void:
	for seed_id in seed_buttons.keys():
		var button: Button = seed_buttons[seed_id]
		button.disabled = seed_id == selected_seed_id
