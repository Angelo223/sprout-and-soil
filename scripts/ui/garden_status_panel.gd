class_name GardenStatusPanel
extends Control

const TEXT_COLOR := Color(0.16, 0.24, 0.14)

var status_label: Label
var diary_label: Label
var diary_entries: Array[String] = []

func _ready() -> void:
	_build_ui()

func setup() -> void:
	_build_ui()
	show_message("Plant neighbors, water the garden, then tap mature plants to harvest.")
	_update_diary_label()

func show_message(message: String) -> void:
	_build_ui()
	status_label.text = message

func show_discovery(discovery: Dictionary) -> void:
	var first_name := PlantData.get_display_name(discovery.get("first_plant_id", ""))
	var second_name := PlantData.get_display_name(discovery.get("second_plant_id", ""))
	var type_label := PlantRelationshipData.get_type_label(discovery.get("type", PlantRelationshipData.TYPE_NEUTRAL))
	var title: String = discovery.get("title", "New discovery")
	var short_reason: String = discovery.get("short_reason", discovery.get("explanation", ""))

	show_message("New discovery: %s + %s\n%s: %s" % [first_name, second_name, title, short_reason])
	add_diary_entry("%s: %s + %s" % [type_label, first_name, second_name])

func add_diary_entry(entry: String) -> void:
	if diary_entries.has(entry):
		return

	diary_entries.append(entry)
	_update_diary_label()

func get_diary_entry_count() -> int:
	return diary_entries.size()

func _build_ui() -> void:
	if status_label != null:
		return

	size = Vector2(1080, 285)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(110, 0)
	status_label.size = Vector2(860, 110)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", TEXT_COLOR)
	status_label.add_theme_font_size_override("font_size", 24)
	add_child(status_label)

	diary_label = Label.new()
	diary_label.name = "DiaryLabel"
	diary_label.position = Vector2(110, 120)
	diary_label.size = Vector2(860, 165)
	diary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	diary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	diary_label.add_theme_color_override("font_color", TEXT_COLOR)
	diary_label.add_theme_font_size_override("font_size", 21)
	add_child(diary_label)

func _update_diary_label() -> void:
	_build_ui()

	if diary_entries.is_empty():
		diary_label.text = "Garden Diary\nNo plant relationships discovered yet."
		return

	var diary_text := "Garden Diary (%s)" % diary_entries.size()
	var start_index: int = max(diary_entries.size() - 4, 0)

	for index in range(start_index, diary_entries.size()):
		diary_text += "\n- %s" % diary_entries[index]

	diary_label.text = diary_text
