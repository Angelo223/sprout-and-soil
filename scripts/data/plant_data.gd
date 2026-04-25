class_name PlantData
extends RefCounted

const PLANTS := {
	"carrot": {
		"display_name": "Carrot",
		"plant_type": "root",
		"growth_days": 3,
		"description": "A simple root vegetable for the first prototype."
	},
	"onion": {
		"display_name": "Onion",
		"plant_type": "root",
		"growth_days": 3,
		"description": "A strong-smelling bulb plant that will later be useful for companion planting tests."
	},
	"tomato": {
		"display_name": "Tomato",
		"plant_type": "fruit",
		"growth_days": 4,
		"description": "A warm-season crop for future relationship experiments."
	},
	"basil": {
		"display_name": "Basil",
		"plant_type": "herb",
		"growth_days": 2,
		"description": "A cozy herb that will later pair well with some crops."
	},
	"potato": {
		"display_name": "Potato",
		"plant_type": "root",
		"growth_days": 4,
		"description": "A sturdy tuber for testing risky plant relationships."
	},
	"bean": {
		"display_name": "Bean",
		"plant_type": "legume",
		"growth_days": 3,
		"description": "A climbing plant that can support future special combinations."
	},
	"corn": {
		"display_name": "Corn",
		"plant_type": "grain",
		"growth_days": 5,
		"description": "A tall crop that can become part of a companion planting trio."
	},
	"squash": {
		"display_name": "Squash",
		"plant_type": "fruit",
		"growth_days": 4,
		"description": "A broad-leaf plant for testing special garden layouts."
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

static func is_herb(plant_id: String) -> bool:
	return get_plant_type(plant_id) == "herb"
