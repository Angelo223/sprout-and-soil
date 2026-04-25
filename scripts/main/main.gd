extends Control

const TILE_COUNT := 9

@onready var garden_grid: GridContainer = %GardenGrid

func _ready() -> void:
	_create_test_grid()

func _create_test_grid() -> void:
	for index in TILE_COUNT:
		var button := Button.new()
		button.text = "Empty Bed"
		button.custom_minimum_size = Vector2(260, 260)
		button.pressed.connect(_on_tile_pressed.bind(button, index))
		garden_grid.add_child(button)

func _on_tile_pressed(button: Button, index: int) -> void:
	button.text = "Carrot\nDay 1"
	button.disabled = true
	print("Planted test carrot on tile %s" % index)
