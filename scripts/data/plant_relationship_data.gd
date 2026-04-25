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
		"explanation": "Basil is commonly planted near tomatoes because it attracts pollinators and beneficial insects. Some gardeners also use aromatic herbs to make pest finding harder, though that effect depends on the garden.",
		"short_reason": "Basil can attract useful insects near tomato plants."
	},
	"carrot|onion": {
		"type": TYPE_GOOD,
		"title": "Root friends",
		"explanation": "Carrot and onion use the soil differently, so they do not compete in exactly the same way. Onion scent is also often used in companion planting to make it harder for carrot pests to find carrots.",
		"short_reason": "Different root shapes reduce competition, and onion scent may confuse carrot pests."
	},
	"potato|tomato": {
		"type": TYPE_RISKY,
		"title": "Shared trouble",
		"explanation": "Tomato and potato are both nightshades. Because they are close relatives, they can share diseases such as blight and attract similar pests, so many gardeners avoid planting them close together.",
		"short_reason": "Both are nightshades, so diseases and pests can spread between them."
	},
	"bean|corn": {
		"type": TYPE_SPECIAL,
		"title": "Climbing support",
		"explanation": "Pole beans can use corn stalks as a living support. Beans also fix nitrogen with soil bacteria, which can improve soil fertility over time.",
		"short_reason": "Corn gives beans a support to climb."
	},
	"bean|squash": {
		"type": TYPE_SPECIAL,
		"title": "Living cover",
		"explanation": "Squash leaves spread across the ground and shade the soil. That living cover helps keep moisture in and can make it harder for weeds to take over around beans.",
		"short_reason": "Squash leaves shade the soil and help protect moisture."
	},
	"corn|squash": {
		"type": TYPE_SPECIAL,
		"title": "Tall and low",
		"explanation": "Corn grows upward while squash spreads low across the ground, so they use different layers of the garden. Together with beans, this becomes the classic Three Sisters planting pattern.",
		"short_reason": "Corn grows tall while squash covers the ground."
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
