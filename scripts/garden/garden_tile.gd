class_name GardenTile
extends Control

signal tile_selected(tile: GardenTile)

const TILE_SIZE := Vector2(210, 210)
const BED_TEXTURE_PATH := "res://assets/tiles/beds/tile_bed_empty.svg"

var tile_index: int = -1
var grid_position: Vector2i = Vector2i.ZERO
var bed_id: String = ""
var plant_id: String = ""
var growth_day: int = 0
var health: String = "empty"

var bed_texture: TextureRect
var plant_texture: TextureRect
var status_label: Label
var click_button: Button

func _ready() -> void:
	custom_minimum_size = TILE_SIZE
	size = TILE_SIZE
	_build_visuals()
	_update_visuals()

func setup(index: int, position_in_grid: Vector2i, owning_bed_id: String = "") -> void:
	tile_index = index
	grid_position = position_in_grid
	bed_id = owning_bed_id
	_update_visuals()

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
	_update_visuals()

func load_state(state: Dictionary) -> void:
	plant_id = state.get("plant_id", "")
	growth_day = state.get("growth_day", 0)
	health = state.get("health", "empty")
	_update_visuals()

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
	_update_visuals()

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
	_update_visuals()
	return result

func set_health_state(new_health: String) -> void:
	if is_empty():
		return

	health = new_health
	_update_visuals()

func _build_visuals() -> void:
	if bed_texture != null:
		return

	bed_texture = TextureRect.new()
	bed_texture.name = "BedTexture"
	bed_texture.position = Vector2.ZERO
	bed_texture.size = TILE_SIZE
	bed_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bed_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bed_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bed_texture)

	plant_texture = TextureRect.new()
	plant_texture.name = "PlantTexture"
	plant_texture.position = Vector2(28, 18)
	plant_texture.size = Vector2(154, 154)
	plant_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plant_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	plant_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(plant_texture)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(14, 162)
	status_label.size = Vector2(182, 34)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.add_theme_color_override("font_color", Color(0.98, 0.94, 0.82))
	status_label.add_theme_color_override("font_shadow_color", Color(0.20, 0.12, 0.08, 0.75))
	status_label.add_theme_constant_override("shadow_offset_x", 1)
	status_label.add_theme_constant_override("shadow_offset_y", 2)
	status_label.add_theme_font_size_override("font_size", 16)
	add_child(status_label)

	click_button = Button.new()
	click_button.name = "ClickButton"
	click_button.position = Vector2.ZERO
	click_button.size = TILE_SIZE
	click_button.text = ""
	click_button.flat = true
	click_button.focus_mode = Control.FOCUS_NONE
	click_button.pressed.connect(_on_pressed)
	add_child(click_button)

func _on_pressed() -> void:
	tile_selected.emit(self)

func _update_visuals() -> void:
	if bed_texture == null:
		return

	bed_texture.texture = load(BED_TEXTURE_PATH)

	if is_empty():
		plant_texture.texture = null
		status_label.text = ""
		return

	var sprite_path := PlantData.get_stage_sprite_path(plant_id, growth_day)
	if sprite_path.is_empty():
		plant_texture.texture = null
	else:
		plant_texture.texture = load(sprite_path)

	status_label.text = _get_status_text()

func _get_status_text() -> String:
	if is_empty():
		return ""

	if is_mature():
		return "Ready"

	match health:
		"thriving":
			return "Thriving"
		"stressed":
			return "Stressed"
		"curious":
			return "Curious"
		_:
			return "Day %s" % growth_day
