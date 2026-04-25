class_name GardenTile
extends Button

signal tile_selected(tile: GardenTile)

var tile_index: int = -1
var grid_position: Vector2i = Vector2i.ZERO
var bed_id: String = ""
var plant_id: String = ""
var growth_day: int = 0
var health: String = "empty"
var normal_style: StyleBoxFlat
var hover_style: StyleBoxFlat

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

func load_state(state: Dictionary) -> void:
	plant_id = state.get("plant_id", "")
	growth_day = state.get("growth_day", 0)
	health = state.get("health", "empty")
	_update_label()

func get_state() -> Dictionary:
	return {
		"plant_id": plant_id,
		"growth_day": growth_day,
		"health": health
	}

func grow_days(day_count: int = 1) -> void:
	if is_empty() or is_mature():
		return

	growth_day = min(growth_day + day_count, PlantData.get_growth_days(plant_id))
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
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = _get_tile_color()
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.border_width_left = 4
	normal_style.border_width_top = 4
	normal_style.border_width_right = 4
	normal_style.border_width_bottom = 4
	normal_style.border_color = Color(0.26, 0.33, 0.24)

	hover_style = normal_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = _get_tile_hover_color()

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
		_refresh_tile_colors()
		return

	var health_text := ""
	if health != "healthy":
		health_text = "\n%s" % health.capitalize()

	var mature_text := ""
	if is_mature():
		mature_text = "\nReady"

	text = "%s\nDay %s%s%s" % [PlantData.get_display_name(plant_id), growth_day, health_text, mature_text]
	_refresh_tile_colors()

func _refresh_tile_colors() -> void:
	if normal_style == null or hover_style == null:
		return

	normal_style.bg_color = _get_tile_color()
	hover_style.bg_color = _get_tile_hover_color()

func _get_tile_color() -> Color:
	if is_empty():
		return Color(0.45, 0.32, 0.22)

	if is_mature():
		return Color(0.53, 0.43, 0.20)

	match health:
		"thriving":
			return Color(0.30, 0.50, 0.26)
		"stressed":
			return Color(0.52, 0.34, 0.25)
		"curious":
			return Color(0.34, 0.44, 0.56)
		_:
			return Color(0.35, 0.45, 0.31)

func _get_tile_hover_color() -> Color:
	var color: Color = _get_tile_color()
	return color.lightened(0.08)
