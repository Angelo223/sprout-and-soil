class_name GardenBed
extends RefCounted

var bed_id: String
var display_name: String
var grid_size: int
var tile_indices: Array[int]

func _init(
	new_bed_id: String,
	new_display_name: String,
	new_grid_size: int,
	new_tile_indices: Array[int]
) -> void:
	bed_id = new_bed_id
	display_name = new_display_name
	grid_size = new_grid_size
	tile_indices = new_tile_indices

func contains_tile(tile_index: int) -> bool:
	return tile_indices.has(tile_index)
