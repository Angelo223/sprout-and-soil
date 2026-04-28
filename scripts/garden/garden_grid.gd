class_name GardenGrid
extends Node2D

signal relationship_discovered(discovery: Dictionary)
signal garden_message(message: String)
signal harvest_completed(harvest_result: Dictionary)
signal active_bed_changed(bed: GardenBed)

const GRID_SIZE := 3
const TILE_SIZE := Vector2(210, 210)
const TILE_GAP := 52
const VIEWPORT_WIDTH := 1080
const DEFAULT_GRID_TOP := 450

var active_bed_id := "starter_bed"
var beds: Dictionary = {}
var bed_tile_states: Dictionary = {}
var selected_seed_id: String = "carrot"
var tiles: Array[GardenTile] = []
var discovered_relationships: Dictionary = {}
var grid_top_offset: int = DEFAULT_GRID_TOP

func _ready() -> void:
	_create_beds()
	_create_tiles()
	_load_active_bed_tiles()
	active_bed_changed.emit(get_active_bed())

func set_selected_seed(seed_id: String) -> void:
	selected_seed_id = seed_id

func switch_bed(bed_id: String) -> bool:
	if not beds.has(bed_id):
		return false

	_save_active_bed_tiles()
	active_bed_id = bed_id
	_load_active_bed_tiles()
	_evaluate_all_relationships()
	active_bed_changed.emit(get_active_bed())
	garden_message.emit("Opened %s." % get_active_bed().display_name)
	return true

func get_active_bed() -> GardenBed:
	return beds[active_bed_id] as GardenBed

func _create_beds() -> void:
	var starter_bed: GardenBed = GardenBed.new("starter_bed", "Starter Bed", GRID_SIZE, _get_starter_bed_indices())
	var herb_bed: GardenBed = GardenBed.new("herb_bed", "Herb Bed", GRID_SIZE, _get_starter_bed_indices())
	beds[starter_bed.bed_id] = starter_bed
	beds[herb_bed.bed_id] = herb_bed
	bed_tile_states[starter_bed.bed_id] = _create_empty_bed_state()
	bed_tile_states[herb_bed.bed_id] = _create_empty_bed_state()

func _create_empty_bed_state() -> Array[Dictionary]:
	var states: Array[Dictionary] = []

	for index in range(GRID_SIZE * GRID_SIZE):
		states.append({
			"plant_id": "",
			"growth_day": 0,
			"health": "empty"
		})

	return states

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
	var start_position := Vector2((VIEWPORT_WIDTH - total_size.x) / 2.0, grid_top_offset)

	for y in GRID_SIZE:
		for x in GRID_SIZE:
			var index := y * GRID_SIZE + x
			var tile := GardenTile.new()
			tile.name = "GardenTile_%s_%s" % [x, y]
			tile.position = start_position + Vector2(x * (TILE_SIZE.x + TILE_GAP), y * (TILE_SIZE.y + TILE_GAP))
			tile.size = TILE_SIZE
			tile.setup(index, Vector2i(x, y), active_bed_id)
			tile.tile_selected.connect(_on_tile_selected)
			add_child(tile)
			tiles.append(tile)

func _save_active_bed_tiles() -> void:
	var states: Array[Dictionary] = []

	for tile in tiles:
		states.append(tile.get_state())

	bed_tile_states[active_bed_id] = states

func _load_active_bed_tiles() -> void:
	var states: Array[Dictionary] = bed_tile_states[active_bed_id] as Array[Dictionary]

	for index in range(tiles.size()):
		var tile: GardenTile = tiles[index]
		tile.bed_id = active_bed_id
		tile.load_state(states[index])

func _on_tile_selected(tile: GardenTile) -> void:
	if tile.is_empty():
		tile.plant(selected_seed_id)
		var new_discoveries := _evaluate_all_relationships()
		_save_active_bed_tiles()
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

		tile.grow_days(_get_growth_days_for_tile(tile))
		watered_count += 1

	var new_discoveries := _evaluate_all_relationships()
	_save_active_bed_tiles()

	if watered_count == 0:
		garden_message.emit("Nothing needs water right now.")
		return

	if new_discoveries == 0:
		garden_message.emit("Watered the garden. %s plant(s) grew." % watered_count)

func _harvest_tile(tile: GardenTile) -> void:
	var harvest_result := tile.harvest()
	_evaluate_all_relationships()
	_save_active_bed_tiles()

	var plant_name := PlantData.get_display_name(harvest_result.get("plant_id", ""))
	var health: String = harvest_result.get("health", "healthy")
	var plant_id: String = harvest_result.get("plant_id", "")
	var yield_amount: int = _get_harvest_yield(health, plant_id)
	harvest_result["yield_amount"] = yield_amount
	harvest_completed.emit(harvest_result)

	match health:
		"thriving":
			garden_message.emit("%s gave %s baskets.%s" % [plant_name, yield_amount, _get_harvest_bonus_text(plant_id)])
		"stressed":
			garden_message.emit("Damaged harvest: %s gave no baskets." % plant_name)
		"curious":
			garden_message.emit("%s gave %s basket and hinted at a pattern.%s" % [plant_name, yield_amount, _get_harvest_bonus_text(plant_id)])
		_:
			garden_message.emit("%s gave %s basket.%s" % [plant_name, yield_amount, _get_harvest_bonus_text(plant_id)])

func _get_growth_days_for_tile(tile: GardenTile) -> int:
	if active_bed_id == "herb_bed" and PlantData.is_herb(tile.plant_id):
		return 2

	return 1

func _get_harvest_bonus_text(plant_id: String) -> String:
	if active_bed_id == "herb_bed" and PlantData.is_herb(plant_id):
		return "\nHerb Bed bonus!"

	return ""

func _get_harvest_yield(health: String, plant_id: String) -> int:
	var base_yield := 1

	match health:
		"thriving":
			base_yield = 2
		"stressed":
			base_yield = 0

	if base_yield > 0 and active_bed_id == "herb_bed" and PlantData.is_herb(plant_id):
		base_yield += 1

	return base_yield

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
	var special_tiles: Dictionary = {}

	for tile in tiles:
		if special_plants.has(tile.plant_id):
			if not special_tiles.has(tile.plant_id):
				special_tiles[tile.plant_id] = []
			special_tiles[tile.plant_id].append(tile)

	if special_tiles.size() != special_plants.size():
		return

	for corn_tile in special_tiles["corn"]:
		for bean_tile in special_tiles["bean"]:
			for squash_tile in special_tiles["squash"]:
				if _is_connected_special_trio(corn_tile, bean_tile, squash_tile):
					_apply_trio_bonus([corn_tile, bean_tile, squash_tile])
					return

func _is_connected_special_trio(corn_tile: GardenTile, bean_tile: GardenTile, squash_tile: GardenTile) -> bool:
	var corn_touches_bean: bool = _are_tiles_neighbors(corn_tile, bean_tile)
	var corn_touches_squash: bool = _are_tiles_neighbors(corn_tile, squash_tile)
	var bean_touches_squash: bool = _are_tiles_neighbors(bean_tile, squash_tile)
	return corn_touches_bean and (corn_touches_squash or bean_touches_squash)

func _apply_trio_bonus(trio_tiles: Array[GardenTile]) -> void:
	for tile in trio_tiles:
		if tile.health != "stressed":
			tile.set_health_state("thriving")

func _get_neighbor_tiles(tile: GardenTile) -> Array[GardenTile]:
	var neighbors: Array[GardenTile] = []

	for candidate in tiles:
		if candidate == tile:
			continue

		if _are_tiles_neighbors(tile, candidate):
			neighbors.append(candidate)

	return neighbors

func _are_tiles_neighbors(first_tile: GardenTile, second_tile: GardenTile) -> bool:
	var distance: Vector2i = first_tile.grid_position - second_tile.grid_position
	return abs(distance.x) + abs(distance.y) == 1

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
