class_name GardenTile
extends Button

signal tile_selected(tile: GardenTile)

var tile_index: int = -1
var grid_position: Vector2i = Vector2i.ZERO
var plant_id: String = ""
var growth_day: int = 0
var health: String = "empty"

func setup(index: int, position_in_grid: Vector2i) -> void:
	tile_index = index
	grid_position = position_in_grid
	_update_label()

func is_empty() -> bool:
	return plant_id.is_empty()

func plant(seed_id: String) -> void:
	if not is_empty():
		return

	plant_id = seed_id
	growth_day = 1
	health = "healthy"
	_update_label()

func _ready() -> void:
	pressed.connect(_on_pressed)
	_update_label()

func _on_pressed() -> void:
	tile_selected.emit(self)

func _update_label() -> void:
	if is_empty():
		text = "Empty Bed"
		return

	text = "%s\nDay %s" % [PlantData.get_display_name(plant_id), growth_day]
