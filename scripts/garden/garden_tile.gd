class_name GardenTile
extends Button

signal tile_selected(tile: GardenTile)

var tile_index: int = -1
var grid_position: Vector2i = Vector2i.ZERO
var bed_id: String = ""
var plant_id: String = ""
var growth_day: int = 0
var health: String = "empty"

func _ready() -> void:
	pressed.connect(_on_pressed)
	_apply_tile_theme()
	_update_label()

func setup(index: int, position_in_grid: Vector2i, owning_bed_id: String = "") -> void:
	tile_index = index
	grid_position = position_in_grid
	bed_id = owning_bed_id
	_update_label()

func is_empty() -> bool:
	return plant_id.is_empty()

func is_mature() -> bool:
	if is_empty():
		return false

	return growth_day >= PlantData.get_growth_days(plant_id)

func plant(seed_id: String) -> void:
	if not is_empty():
		return

	plant_id = seed_id
	growth_day = 1
	health = "healthy"
	_update_label()

func grow_one_day() -> void:
	if is_empty() or is_mature():
		return

	growth_day += 1
	_update_label()

func get_days_until_mature() -> int:
	if is_empty():
		return 0

	return max(PlantData.get_growth_days(plant_id) - growth_day, 0)

func harvest() -> Dictionary:
	if is_empty():
		return {}

	var result := {
		"plant_id": plant_id,
		"growth_day": growth_day,
		"health": health,
		"was_mature": is_mature()
	}
	plant_id = ""
	growth_day = 0
	health = "empty"
	_update_label()
	return result

func set_health_state(new_health: String) -> void:
	if is_empty():
		return

	health = new_health
	_update_label()

func _on_pressed() -> void:
	tile_selected.emit(self)

func _apply_tile_theme() -> void:
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.33, 0.42, 0.31)
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8

	var hover_style := normal_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = Color(0.39, 0.49, 0.36)

	add_theme_stylebox_override("normal", normal_style)
	add_theme_stylebox_override("hover", hover_style)
	add_theme_stylebox_override("pressed", hover_style)
	add_theme_color_override("font_color", Color(0.98, 1.0, 0.94))
	add_theme_color_override("font_hover_color", Color(0.98, 1.0, 0.94))
	add_theme_color_override("font_pressed_color", Color(0.98, 1.0, 0.94))
	add_theme_font_size_override("font_size", 24)

func _update_label() -> void:
	if is_empty():
		text = "Empty Bed"
		return

	var health_text := ""
	if health != "healthy":
		health_text = "\n%s" % health.capitalize()

	var mature_text := ""
	if is_mature():
		mature_text = "\nReady"

	text = "%s\nDay %s%s%s" % [PlantData.get_display_name(plant_id), growth_day, health_text, mature_text]
