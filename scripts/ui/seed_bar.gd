class_name SeedBar
extends Control

signal seed_selected(seed_id: String)

const TEXT_DEEP := Color("#263D25")

const BAR_WIDTH := 968
const BAR_HEIGHT := 94
const PICKER_WIDTH := 900
const PICKER_HEIGHT := 210
const CHIP_HEIGHT := 58
const CHIP_GAP := 12
const CHIP_WIDTH := 132

var available_seeds: Array = []
var selected_seed_id := "carrot"
var selected_seed_button: Button
var picker_panel: Panel
var picker_grid: GridContainer
var seed_buttons: Dictionary = {}

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
	if selected_seed_button != null:
		return

	size = Vector2(BAR_WIDTH, BAR_HEIGHT)

	_build_picker()

	selected_seed_button = Button.new()
	selected_seed_button.name = "SelectedSeedButton"
	selected_seed_button.position = Vector2((BAR_WIDTH - 430) / 2.0, 14)
	selected_seed_button.size = Vector2(430, 66)
	selected_seed_button.focus_mode = Control.FOCUS_NONE
	selected_seed_button.pressed.connect(_toggle_picker)
	_apply_seed_button_theme(selected_seed_button, true)
	add_child(selected_seed_button)

func _build_picker() -> void:
	picker_panel = Panel.new()
	picker_panel.name = "SeedPickerPanel"
	picker_panel.position = Vector2((BAR_WIDTH - PICKER_WIDTH) / 2.0, -230)
	picker_panel.size = Vector2(PICKER_WIDTH, PICKER_HEIGHT)
	picker_panel.visible = false
	picker_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(1.0, 0.97, 0.86, 0.96), Color(0.50, 0.36, 0.24, 0.45), 28, 2))
	add_child(picker_panel)

	var title := Label.new()
	title.name = "SeedPickerTitle"
	title.text = "Choose seed"
	title.position = Vector2(30, 18)
	title.size = Vector2(300, 36)
	title.add_theme_color_override("font_color", TEXT_DEEP)
	title.add_theme_font_size_override("font_size", 22)
	picker_panel.add_child(title)

	picker_grid = GridContainer.new()
	picker_grid.name = "SeedPickerGrid"
	picker_grid.columns = 4
	picker_grid.position = Vector2(28, 64)
	picker_grid.size = Vector2(PICKER_WIDTH - 56, 128)
	picker_grid.add_theme_constant_override("h_separation", CHIP_GAP)
	picker_grid.add_theme_constant_override("v_separation", CHIP_GAP)
	picker_panel.add_child(picker_grid)

	for seed_id_value in available_seeds:
		var seed_id := str(seed_id_value)
		var button := Button.new()
		button.name = "%sSeedPickerButton" % seed_id.capitalize()
		button.text = PlantData.get_display_name(seed_id)
		button.custom_minimum_size = Vector2(CHIP_WIDTH, CHIP_HEIGHT)
		button.focus_mode = Control.FOCUS_NONE
		_apply_seed_button_theme(button, false)
		button.pressed.connect(_on_seed_button_pressed.bind(seed_id))
		picker_grid.add_child(button)
		seed_buttons[seed_id] = button

func _toggle_picker() -> void:
	picker_panel.visible = not picker_panel.visible

func _apply_seed_button_theme(button: Button, is_primary: bool = false) -> void:
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(1.0, 0.97, 0.86, 0.90)
	normal_style.border_color = Color(0.50, 0.36, 0.24, 0.38)
	normal_style.set_border_width_all(2)
	normal_style.set_corner_radius_all(28)
	normal_style.shadow_color = Color(0.12, 0.10, 0.06, 0.18)
	normal_style.shadow_size = 4
	normal_style.shadow_offset = Vector2(0, 2)

	var hover_style := normal_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = Color("#FFFBEA")
	hover_style.border_color = Color("#8A6647")

	var disabled_style := normal_style.duplicate() as StyleBoxFlat
	disabled_style.bg_color = Color("#F0CC61")
	disabled_style.border_color = Color("#FFF8DF")
	disabled_style.set_border_width_all(3)
	disabled_style.shadow_color = Color(0.52, 0.38, 0.10, 0.30)
	disabled_style.shadow_size = 7

	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	button.add_theme_color_override("font_color", TEXT_DEEP)
	button.add_theme_color_override("font_hover_color", TEXT_DEEP)
	button.add_theme_color_override("font_pressed_color", TEXT_DEEP)
	button.add_theme_color_override("font_disabled_color", TEXT_DEEP)
	button.add_theme_font_size_override("font_size", 20 if is_primary else 18)

func _make_panel_style(bg: Color, border: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(0.12, 0.10, 0.06, 0.20)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0, 3)
	return style

func _on_seed_button_pressed(seed_id: String) -> void:
	selected_seed_id = seed_id
	_update_selection_ui()
	picker_panel.visible = false
	seed_selected.emit(seed_id)

func _update_selection_ui() -> void:
	if selected_seed_button != null:
		selected_seed_button.text = "Seed: %s" % PlantData.get_display_name(selected_seed_id)

	for seed_id in seed_buttons.keys():
		var button: Button = seed_buttons[seed_id]
		button.disabled = seed_id == selected_seed_id
