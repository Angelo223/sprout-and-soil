class_name GardenGrid
extends Node2D

const GRID_SIZE := 3
const TILE_SIZE := Vector2(260, 260)
const TILE_GAP := 24
const DEFAULT_SEED := "carrot"
const VIEWPORT_WIDTH := 1080

var tiles: Array[GardenTile] = []

func _ready() -> void:
	_create_tiles()

func _create_tiles() -> void:
	var total_size := Vector2(
		GRID_SIZE * TILE_SIZE.x + (GRID_SIZE - 1) * TILE_GAP,
		GRID_SIZE * TILE_SIZE.y + (GRID_SIZE - 1) * TILE_GAP
	)
	var start_position := Vector2((VIEWPORT_WIDTH - total_size.x) / 2.0, 360)

	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var index := y * GRID_SIZE + x
			var tile := GardenTile.new()
			tile.name = "GardenTile_%s_%s" % [x, y]
			tile.position = start_position + Vector2(x * (TILE_SIZE.x + TILE_GAP), y * (TILE_SIZE.y + TILE_GAP))
			tile.size = TILE_SIZE
			tile.setup(index, Vector2i(x, y))
			tile.tile_selected.connect(_on_tile_selected)
			add_child(tile)
			tiles.append(tile)

func _on_tile_selected(tile: GardenTile) -> void:
	if tile.is_empty():
		tile.plant(DEFAULT_SEED)
