extends Node2D

const GRID_SIZE := 3
const TILE_SIZE := Vector2(260, 260)
const TILE_GAP := 24

var planted_tiles: Dictionary = {}

func _ready() -> void:
	_create_background()
	_create_title()
	_create_garden_grid()

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
	hint.text = "Tap a bed to plant a test carrot."
	hint.position = Vector2(0, 155)
	hint.size = Vector2(1080, 60)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hint)

func _create_garden_grid() -> void:
	var total_size := Vector2(
		GRID_SIZE * TILE_SIZE.x + (GRID_SIZE - 1) * TILE_GAP,
		GRID_SIZE * TILE_SIZE.y + (GRID_SIZE - 1) * TILE_GAP
	)
	var start_position := Vector2((1080 - total_size.x) / 2.0, 360)

	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var index := y * GRID_SIZE + x
			var button := Button.new()
			button.name = "GardenTile_%s_%s" % [x, y]
			button.text = "Empty Bed"
			button.position = start_position + Vector2(x * (TILE_SIZE.x + TILE_GAP), y * (TILE_SIZE.y + TILE_GAP))
			button.size = TILE_SIZE
			button.pressed.connect(_on_garden_tile_pressed.bind(button, index))
			add_child(button)

func _on_garden_tile_pressed(button: Button, tile_index: int) -> void:
	if planted_tiles.has(tile_index):
		return

	planted_tiles[tile_index] = {
		"plant_id": "carrot",
		"growth_day": 1,
		"health": "healthy"
	}

	button.text = "Carrot\nDay 1"
