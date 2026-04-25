class_name GardenGrid
extends Node2D

signal relationship_discovered(discovery: Dictionary)
signal garden_message(message: String)
signal harvest_completed(harvest_result: Dictionary)

const GRID_SIZE := 3
const TILE_SIZE := Vector2(260, 260)
const TILE_GAP := 24
const VIEWPORT_WIDTH := 1080

var starter_bed: GardenBed
var selected_seed_id: String = "carrot"
var tiles: Array[GardenTile] = []
var discovered_relationships: Dictionary = {}

func _ready() -> void:
	starter_bed = GardenBed.new("starter_bed", "Starter Bed", GRID_SIZE, _get_starter_bed_indices())
	_create_tiles()

func set_selected_seed(seed_id: String) -> void:
	selected_seed_id = seed_id

func _get_starter_bed_indices() -> Array[int]:
	var indices: Array[int] = []

	for index in range(GRID_SIZE * GRID_SIZE):
		indices.append(index)

	return indices

func _create_tiles() -> void:
	var total_size := Vector2(
		GRID_SIZE * TILE_SIZE.x + (GRID_SIZE - 1) * TILE_GAP,
		GRID_SIZE * TILE_SIZE.y + (GRID_SIZE - 1) * TILE_GAP
	)
	var start_position := Vector2((VIEWPORT_WIDTH - total_size.x) / 2.0, 380)

	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var index := y * GRID_SIZE + x
			var tile := GardenTile.new()
			tile.name = "GardenTile_%s_%s" % [x, y]
			tile.position = start_position + Vector2(x * (TILE_SIZE.x + TILE_GAP), y * (TILE_SIZE.y + TILE_GAP))
			tile.size = TILE_SIZE
			tile.setup(index, Vector2i(x, y), starter_bed.bed_id)
			tile.tile_selected.connect(_on_tile_selected)
			add_child(tile)
			tiles.append(tile)

func _on_tile_selected(tile: GardenTile) -> void:
	if tile.is_empty():
		tile.plant(selected_seed_id)
		var new_discoveries := _evaluate_all_relationships()
		if new_discoveries == 0:
			garden_message.emit("Planted %s." % PlantData.get_display_name(selected_seed_id))
		return

	if tile.is_mature():
		_harvest_tile(tile)
		return

	garden_message.emit("%s needs %s more day(s)." % [
		PlantData.get_display_name(tile.plant_id),
		tile.get_days_until_mature()
	])

func water_all() -> void:
	var watered_count := 0

	for tile in tiles:
		if tile.is_empty() or tile.is_mature():
			continue

		tile.grow_one_day()
		watered_count += 1

	var new_discoveries := _evaluate_all_relationships()

	if watered_count == 0:
		garden_message.emit("Nothing needs water right now.")
		return

	if new_discoveries == 0:
		garden_message.emit("Watered the garden. %s plant(s) grew." % watered_count)

func _harvest_tile(tile: GardenTile) -> void:
	var harvest_result := tile.harvest()
	_evaluate_all_relationships()

	var plant_name := PlantData.get_display_name(harvest_result.get("plant_id", ""))
	var health: String = harvest_result.get("health", "healthy")
	var yield_amount: int = _get_harvest_yield(health)
	harvest_result["yield_amount"] = yield_amount
	harvest_completed.emit(harvest_result)

	match health:
		"thriving":
			garden_message.emit("Great harvest: %s gave %s baskets." % [plant_name, yield_amount])
		"stressed":
			garden_message.emit("Damaged harvest: %s gave no baskets." % plant_name)
		"curious":
			garden_message.emit("Interesting harvest: %s gave %s basket and hinted at a pattern." % [plant_name, yield_amount])
		_:
			garden_message.emit("Harvested %s for %s basket." % [plant_name, yield_amount])

func _get_harvest_yield(health: String) -> int:
	match health:
		"thriving":
			return 2
		"stressed":
			return 0
		_:
			return 1

func _evaluate_all_relationships() -> int:
	var new_discoveries := 0

	for tile in tiles:
		if not tile.is_empty():
			tile.set_health_state("healthy")

	for tile in tiles:
		if not tile.is_empty():
			new_discoveries += _evaluate_new_neighbors(tile)

	_apply_three_sisters_bonus()
	return new_discoveries

func _evaluate_new_neighbors(tile: GardenTile) -> int:
	var new_discoveries := 0

	for neighbor in _get_neighbor_tiles(tile):
		if neighbor.is_empty():
			continue

		var relationship := PlantRelationshipData.get_relationship(tile.plant_id, neighbor.plant_id)
		if relationship.is_empty():
			continue

		var relationship_type: String = relationship.get("type", PlantRelationshipData.TYPE_NEUTRAL)
		_apply_relationship_health(tile, neighbor, relationship_type)
		if _record_relationship_discovery(tile.plant_id, neighbor.plant_id, relationship):
			new_discoveries += 1

	return new_discoveries

func _apply_three_sisters_bonus() -> void:
	var special_plants: Array[String] = ["corn", "bean", "squash"]
	var found_tiles: Dictionary = {}

	for tile in tiles:
		if special_plants.has(tile.plant_id):
			found_tiles[tile.plant_id] = tile

	if found_tiles.size() != special_plants.size():
		return

	for plant_id in special_plants:
		var tile: GardenTile = found_tiles[plant_id] as GardenTile
		if tile.health != "stressed":
			tile.set_health_state("thriving")

func _get_neighbor_tiles(tile: GardenTile) -> Array[GardenTile]:
	var neighbors: Array[GardenTile] = []

	for candidate in tiles:
		if candidate == tile:
			continue

		var distance: Vector2i = candidate.grid_position - tile.grid_position
		var is_cardinal_neighbor: bool = abs(distance.x) + abs(distance.y) == 1
		if is_cardinal_neighbor:
			neighbors.append(candidate)

	return neighbors

func _apply_relationship_health(tile: GardenTile, neighbor: GardenTile, relationship_type: String) -> void:
	match relationship_type:
		PlantRelationshipData.TYPE_GOOD:
			if tile.health != "stressed":
				tile.set_health_state("thriving")
			if neighbor.health != "stressed":
				neighbor.set_health_state("thriving")
		PlantRelationshipData.TYPE_RISKY:
			tile.set_health_state("stressed")
			neighbor.set_health_state("stressed")
		PlantRelationshipData.TYPE_SPECIAL:
			if tile.health != "stressed":
				tile.set_health_state("curious")
			if neighbor.health != "stressed":
				neighbor.set_health_state("curious")

func _record_relationship_discovery(first_plant_id: String, second_plant_id: String, relationship: Dictionary) -> bool:
	var relationship_key := PlantRelationshipData.get_relationship_key(first_plant_id, second_plant_id)
	if discovered_relationships.has(relationship_key):
		return false

	var discovery: Dictionary = relationship.duplicate()
	discovery["key"] = relationship_key
	discovery["first_plant_id"] = first_plant_id
	discovery["second_plant_id"] = second_plant_id
	discovered_relationships[relationship_key] = discovery
	relationship_discovered.emit(discovery)
	return true
