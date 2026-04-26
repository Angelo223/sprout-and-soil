class_name PlantData
extends RefCounted

const PLANTS := {
	"carrot": {
		"display_name": "Carrot",
		"plant_type": "root",
		"growth_days": 3,
		"description": "A simple root vegetable for the first prototype.",
		"stage_sprites": [
			"res://assets/plants/carrot/plant_carrot_stage_01.svg"
		]
	},
	"onion": {
		"display_name": "Onion",
		"plant_type": "root",
		"growth_days": 3,
		"description": "A strong-smelling bulb plant that will later be useful for companion planting tests.",
		"stage_sprites": [
			"res://assets/plants/onion/plant_onion_stage_01.svg"
		]
	},
	"tomato": {
		"display_name": "Tomato",
		"plant_type": "fruit",
		"growth_days": 4,
		"description": "A warm-season crop for future relationship experiments.",
		"stage_sprites": [
			"res://assets/plants/tomato/plant_tomato_stage_01.svg"
		]
	},
	"basil": {
		"display_name": "Basil",
		"plant_type": "herb",
		"growth_days": 2,
		"description": "A cozy herb that will later pair well with some crops.",
		"stage_sprites": [
			"res://assets/plants/basil/plant_basil_stage_01.svg"
		]
	},
	"potato": {
		"display_name": "Potato",
		"plant_type": "root",
		"growth_days": 4,
		"description": "A sturdy tuber for testing risky plant relationships.",
		"stage_sprites": []
	},
	"bean": {
		"display_name": "Bean",
		"plant_type": "legume",
		"growth_days": 3,
		"description": "A climbing plant that can support future special combinations.",
		"stage_sprites": []
	},
	"corn": {
		"display_name": "Corn",
		"plant_type": "grain",
		"growth_days": 5,
		"description": "A tall crop that can become part of a companion planting trio.",
		"stage_sprites": []
	},
	"squash": {
		"display_name": "Squash",
		"plant_type": "fruit",
		"growth_days": 4,
		"description": "A broad-leaf plant for testing special garden layouts.",
		"stage_sprites": []
	}
}

static func get_all_plant_ids() -> Array:
	return PLANTS.keys()

static func get_plant(plant_id: String) -> Dictionary:
	return PLANTS.get(plant_id, {})

static func get_display_name(plant_id: String) -> String:
	var plant := get_plant(plant_id)
	return plant.get("display_name", plant_id.capitalize())

static func get_growth_days(plant_id: String) -> int:
	var plant := get_plant(plant_id)
	return plant.get("growth_days", 1)

static func get_plant_type(plant_id: String) -> String:
	var plant := get_plant(plant_id)
	return plant.get("plant_type", "crop")

static func get_stage_sprite_path(plant_id: String, growth_day: int = 1) -> String:
	var plant := get_plant(plant_id)
	var sprites: Array = plant.get("stage_sprites", [])
	if sprites.is_empty():
		return ""

	var stage_index: int = clamp(growth_day - 1, 0, sprites.size() - 1)
	return sprites[stage_index]

static func is_herb(plant_id: String) -> bool:
	return get_plant_type(plant_id) == "herb"
