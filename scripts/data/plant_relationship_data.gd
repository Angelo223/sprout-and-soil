class_name PlantRelationshipData
extends RefCounted

const TYPE_GOOD := "good"
const TYPE_NEUTRAL := "neutral"
const TYPE_RISKY := "risky"
const TYPE_SPECIAL := "special"

const RELATIONSHIPS := {
	"basil|tomato": {
		"type": TYPE_GOOD,
		"title": "Helpful neighbors",
		"explanation": "Tomato and Basil grow happily together. The basil keeps the bed feeling balanced."
	},
	"carrot|onion": {
		"type": TYPE_GOOD,
		"title": "Root friends",
		"explanation": "Carrot and Onion make calm neighbors. Their different scents help the bed stay healthy."
	},
	"potato|tomato": {
		"type": TYPE_RISKY,
		"title": "Shared trouble",
		"explanation": "Tomato and Potato are too closely related here. Pests and plant sickness can spread between them."
	},
	"bean|corn": {
		"type": TYPE_SPECIAL,
		"title": "Climbing support",
		"explanation": "Bean can climb beside Corn. This looks like the start of a special garden pattern."
	},
	"bean|squash": {
		"type": TYPE_SPECIAL,
		"title": "Living cover",
		"explanation": "Bean and Squash can share space well. Squash leaves help cover the soil."
	},
	"corn|squash": {
		"type": TYPE_SPECIAL,
		"title": "Tall and low",
		"explanation": "Corn and Squash use different garden space. This may become stronger with another crop nearby."
	}
}

static func get_relationship(first_plant_id: String, second_plant_id: String) -> Dictionary:
	return RELATIONSHIPS.get(_make_key(first_plant_id, second_plant_id), {})

static func has_relationship(first_plant_id: String, second_plant_id: String) -> bool:
	return not get_relationship(first_plant_id, second_plant_id).is_empty()

static func get_relationship_key(first_plant_id: String, second_plant_id: String) -> String:
	return _make_key(first_plant_id, second_plant_id)

static func get_type_label(relationship_type: String) -> String:
	match relationship_type:
		TYPE_GOOD:
			return "Good"
		TYPE_RISKY:
			return "Risky"
		TYPE_SPECIAL:
			return "Special"
		_:
			return "Neutral"

static func _make_key(first_plant_id: String, second_plant_id: String) -> String:
	var ids := [first_plant_id, second_plant_id]
	ids.sort()
	return "%s|%s" % [ids[0], ids[1]]
