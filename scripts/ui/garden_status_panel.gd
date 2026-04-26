class_name GardenStatusPanel
extends Control

const TEXT_DEEP := Color("#263D25")
const TEXT_SOFT := Color("#4A5C42")
const ACCENT_SOIL := Color("#7B5738")
const PAPER_CREAM := Color("#FBF4DD")
const SHADOW_INK := Color(0.10, 0.16, 0.08, 0.35)

const PANEL_WIDTH := 968
const PANEL_HEIGHT := 280
const STATUS_HEIGHT := 110
const SEPARATOR_THICKNESS := 2

var status_card: Panel
var status_label: Label
var diary_card: Panel
var diary_heading: Label
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

	size = Vector2(PANEL_WIDTH, PANEL_HEIGHT)

	status_card = _make_card(Color("#FFFAE3"), ACCENT_SOIL, 22, 3)
	status_card.name = "StatusCard"
	status_card.position = Vector2(0, 0)
	status_card.size = Vector2(PANEL_WIDTH, STATUS_HEIGHT)
	add_child(status_card)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(28, 12)
	status_label.size = Vector2(PANEL_WIDTH - 56, STATUS_HEIGHT - 24)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", TEXT_DEEP)
	status_label.add_theme_font_size_override("font_size", 22)
	status_card.add_child(status_label)

	diary_card = _make_card(PAPER_CREAM, ACCENT_SOIL, 22, 3)
	diary_card.name = "DiaryCard"
	diary_card.position = Vector2(0, STATUS_HEIGHT + 14)
	diary_card.size = Vector2(PANEL_WIDTH, PANEL_HEIGHT - STATUS_HEIGHT - 14)
	add_child(diary_card)

	diary_heading = Label.new()
	diary_heading.name = "DiaryHeading"
	diary_heading.text = "Garden Diary"
	diary_heading.position = Vector2(28, 10)
	diary_heading.size = Vector2(PANEL_WIDTH - 56, 30)
	diary_heading.add_theme_color_override("font_color", TEXT_DEEP)
	diary_heading.add_theme_font_size_override("font_size", 22)
	diary_card.add_child(diary_heading)

	var separator := ColorRect.new()
	separator.name = "DiarySeparator"
	separator.color = Color(ACCENT_SOIL.r, ACCENT_SOIL.g, ACCENT_SOIL.b, 0.45)
	separator.position = Vector2(28, 44)
	separator.size = Vector2(PANEL_WIDTH - 56, SEPARATOR_THICKNESS)
	separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	diary_card.add_child(separator)

	diary_label = Label.new()
	diary_label.name = "DiaryLabel"
	diary_label.position = Vector2(28, 54)
	diary_label.size = Vector2(PANEL_WIDTH - 56, diary_card.size.y - 64)
	diary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	diary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	diary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	diary_label.add_theme_color_override("font_color", TEXT_SOFT)
	diary_label.add_theme_font_size_override("font_size", 20)
	diary_card.add_child(diary_label)

func _make_card(bg: Color, border: Color, radius: int, border_width: int) -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = SHADOW_INK
	style.shadow_size = 4
	style.shadow_offset = Vector2(0, 3)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _update_diary_label() -> void:
	_build_ui()

	if diary_entries.is_empty():
		diary_heading.text = "Garden Diary"
		diary_label.text = "No plant relationships discovered yet."
		return

	diary_heading.text = "Garden Diary  (%s)" % diary_entries.size()
	var diary_text := ""
	var start_index: int = max(diary_entries.size() - 4, 0)

	for index in range(start_index, diary_entries.size()):
		if not diary_text.is_empty():
			diary_text += "\n"
		diary_text += "•  %s" % diary_entries[index]

	diary_label.text = diary_text
