extends Node

const SAVE_PATH := "user://sprout_save.json"
const SAVE_VERSION := 1

var data: Dictionary = _default_data()

func _default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"total_harvest": 0,
		"starter_goal_completed": false,
		"herb_bed_unlocked": false,
		"diary_entries": [],
		"discovered_relationships": {},
		"bed_tile_states": {},
		"active_bed_id": "starter_bed"
	}

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func load_game() -> bool:
	if not has_save():
		data = _default_data()
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		data = _default_data()
		return false

	var raw := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		data = _default_data()
		return false

	data = _migrate(parsed)
	return true

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(JSON.stringify(data))
	file.close()

func reset() -> void:
	data = _default_data()
	save_game()

func _migrate(raw: Dictionary) -> Dictionary:
	var merged := _default_data()
	for key in raw.keys():
		merged[key] = raw[key]
	merged["version"] = SAVE_VERSION
	return merged
