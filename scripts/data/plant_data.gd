class_name PlantData
extends RefCounted

const PLANTS := {
	"carrot": {
		"display_name": "Carrot",
		"growth_days": 3,
		"description": "A simple root vegetable for the first prototype."
	},
	"onion": {
		"display_name": "Onion",
		"growth_days": 3,
		"description": "A strong-smelling bulb plant that will later be useful for companion planting tests."
	},
	"tomato": {
		"display_name": "Tomato",
		"growth_days": 4,
		"description": "A warm-season crop for future relationship experiments."
	},
	"basil": {
		"display_name": "Basil",
		"growth_days": 2,
		"description": "A cozy herb that will later pair well with some crops."
	}
}

static func get_plant(plant_id: String) -> Dictionary:
	return PLANTS.get(plant_id, {})

static func get_display_name(plant_id: String) -> String:
	var plant := get_plant(plant_id)
	return plant.get("display_name", plant_id.capitalize())

static func get_growth_days(plant_id: String) -> int:
	var plant := get_plant(plant_id)
	return plant.get("growth_days", 1)
