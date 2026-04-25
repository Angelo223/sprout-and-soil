class_name CodexPanel
extends CanvasLayer

signal closed()

const TEXT_COLOR := Color(0.16, 0.24, 0.14)
const PAPER_COLOR := Color(0.95, 0.91, 0.78)
const PAPER_EDGE := Color(0.48, 0.36, 0.22)
const ENTRY_COLOR := Color(0.99, 0.96, 0.86)
const TYPE_COLORS := {
	PlantRelationshipData.TYPE_GOOD: Color(0.30, 0.50, 0.26),
	PlantRelationshipData.TYPE_RISKY: Color(0.66, 0.30, 0.22),
	PlantRelationshipData.TYPE_SPECIAL: Color(0.34, 0.44, 0.66),
	PlantRelationshipData.TYPE_NEUTRAL: Color(0.50, 0.50, 0.50)
}

var discoveries: Array[Dictionary] = []
var list_view: VBoxContainer
var detail_view: Control
var detail_title_label: Label
var detail_pair_label: Label
var detail_type_badge: ColorRect
var detail_type_label: Label
var detail_explanation_label: Label
var empty_label: Label
var page_title: Label
var scroll_container: ScrollContainer

func _ready() -> void:
	layer = 10
	_build_overlay()
	visible = false

func open_with(entries: Array) -> void:
	discoveries.clear()
	for entry in entries:
		if typeof(entry) == TYPE_DICTIONARY:
			discoveries.append(entry)

	_show_list()
	visible = true

func close() -> void:
	visible = false
	closed.emit()

func _build_overlay() -> void:
	var dim := ColorRect.new()
	dim.name = "Dim"
	dim.color = Color(0.10, 0.16, 0.10, 0.55)
	dim.position = Vector2.ZERO
	dim.size = Vector2(1080, 1920)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var paper := PanelContainer.new()
	paper.name = "Paper"
	paper.position = Vector2(60, 220)
	paper.size = Vector2(960, 1480)
	paper.custom_minimum_size = Vector2(960, 1480)
	var paper_style := StyleBoxFlat.new()
	paper_style.bg_color = PAPER_COLOR
	paper_style.corner_radius_top_left = 24
	paper_style.corner_radius_top_right = 24
	paper_style.corner_radius_bottom_left = 24
	paper_style.corner_radius_bottom_right = 24
	paper_style.border_width_left = 6
	paper_style.border_width_top = 6
	paper_style.border_width_right = 6
	paper_style.border_width_bottom = 6
	paper_style.border_color = PAPER_EDGE
	paper_style.content_margin_left = 36
	paper_style.content_margin_right = 36
	paper_style.content_margin_top = 28
	paper_style.content_margin_bottom = 28
	paper.add_theme_stylebox_override("panel", paper_style)
	add_child(paper)

	var root := VBoxContainer.new()
	root.name = "Root"
	root.add_theme_constant_override("separation", 18)
	paper.add_child(root)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	root.add_child(header)

	page_title = Label.new()
	page_title.text = "Garden Codex"
	page_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page_title.add_theme_color_override("font_color", TEXT_COLOR)
	page_title.add_theme_font_size_override("font_size", 44)
	header.add_child(page_title)

	var close_button := Button.new()
	close_button.text = "Close"
	close_button.custom_minimum_size = Vector2(170, 70)
	_apply_button_theme(close_button)
	close_button.pressed.connect(close)
	header.add_child(close_button)

	var divider := ColorRect.new()
	divider.color = PAPER_EDGE
	divider.custom_minimum_size = Vector2(0, 4)
	root.add_child(divider)

	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll_container)

	list_view = VBoxContainer.new()
	list_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_view.add_theme_constant_override("separation", 14)
	scroll_container.add_child(list_view)

	empty_label = Label.new()
	empty_label.text = "No relationships discovered yet.\nPlant neighbors and observe."
	empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	empty_label.add_theme_color_override("font_color", TEXT_COLOR)
	empty_label.add_theme_font_size_override("font_size", 26)
	list_view.add_child(empty_label)

	detail_view = _build_detail_view()
	root.add_child(detail_view)
	detail_view.visible = false

func _build_detail_view() -> Control:
	var container := VBoxContainer.new()
	container.name = "Detail"
	container.add_theme_constant_override("separation", 14)
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var back_button := Button.new()
	back_button.text = "<- Back to list"
	back_button.custom_minimum_size = Vector2(0, 70)
	_apply_button_theme(back_button)
	back_button.pressed.connect(_show_list)
	container.add_child(back_button)

	detail_pair_label = Label.new()
	detail_pair_label.add_theme_color_override("font_color", TEXT_COLOR)
	detail_pair_label.add_theme_font_size_override("font_size", 32)
	container.add_child(detail_pair_label)

	var badge_row := HBoxContainer.new()
	badge_row.add_theme_constant_override("separation", 12)
	container.add_child(badge_row)

	detail_type_badge = ColorRect.new()
	detail_type_badge.custom_minimum_size = Vector2(28, 28)
	badge_row.add_child(detail_type_badge)

	detail_type_label = Label.new()
	detail_type_label.add_theme_color_override("font_color", TEXT_COLOR)
	detail_type_label.add_theme_font_size_override("font_size", 26)
	badge_row.add_child(detail_type_label)

	detail_title_label = Label.new()
	detail_title_label.add_theme_color_override("font_color", TEXT_COLOR)
	detail_title_label.add_theme_font_size_override("font_size", 28)
	container.add_child(detail_title_label)

	detail_explanation_label = Label.new()
	detail_explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_explanation_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_explanation_label.add_theme_color_override("font_color", TEXT_COLOR)
	detail_explanation_label.add_theme_font_size_override("font_size", 24)
	container.add_child(detail_explanation_label)

	return container

func _show_list() -> void:
	for child in list_view.get_children():
		if child == empty_label:
			continue
		child.queue_free()

	page_title.text = "Garden Codex (%s)" % discoveries.size()

	if discoveries.is_empty():
		empty_label.visible = true
	else:
		empty_label.visible = false
		for discovery in discoveries:
			list_view.add_child(_build_entry(discovery))

	if detail_view != null:
		detail_view.visible = false
	scroll_container.visible = true

func _build_entry(discovery: Dictionary) -> Control:
	var first_id: String = discovery.get("first_plant_id", "")
	var second_id: String = discovery.get("second_plant_id", "")
	var pair_text := "%s + %s" % [
		PlantData.get_display_name(first_id),
		PlantData.get_display_name(second_id)
	]
	var relationship_type: String = discovery.get("type", PlantRelationshipData.TYPE_NEUTRAL)
	var type_label := PlantRelationshipData.get_type_label(relationship_type)

	var entry := Button.new()
	entry.custom_minimum_size = Vector2(0, 130)
	entry.focus_mode = Control.FOCUS_NONE

	var entry_style := StyleBoxFlat.new()
	entry_style.bg_color = ENTRY_COLOR
	entry_style.corner_radius_top_left = 14
	entry_style.corner_radius_top_right = 14
	entry_style.corner_radius_bottom_left = 14
	entry_style.corner_radius_bottom_right = 14
	entry_style.border_width_left = 12
	entry_style.border_color = TYPE_COLORS.get(relationship_type, TYPE_COLORS[PlantRelationshipData.TYPE_NEUTRAL])
	entry_style.content_margin_left = 22
	entry_style.content_margin_right = 22
	entry_style.content_margin_top = 14
	entry_style.content_margin_bottom = 14
	var hover_style: StyleBoxFlat = entry_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = ENTRY_COLOR.lightened(0.04)
	entry.add_theme_stylebox_override("normal", entry_style)
	entry.add_theme_stylebox_override("hover", hover_style)
	entry.add_theme_stylebox_override("pressed", hover_style)
	entry.add_theme_stylebox_override("focus", entry_style)
	entry.text = ""

	var stack := VBoxContainer.new()
	stack.set_anchors_preset(Control.PRESET_FULL_RECT)
	stack.add_theme_constant_override("separation", 6)
	stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	entry.add_child(stack)

	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 10)
	top_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(top_row)

	var pair_label := Label.new()
	pair_label.text = pair_text
	pair_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pair_label.add_theme_color_override("font_color", TEXT_COLOR)
	pair_label.add_theme_font_size_override("font_size", 28)
	pair_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_row.add_child(pair_label)

	var type_text := Label.new()
	type_text.text = type_label
	type_text.add_theme_color_override("font_color", TYPE_COLORS.get(relationship_type, TEXT_COLOR))
	type_text.add_theme_font_size_override("font_size", 24)
	type_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_row.add_child(type_text)

	var subtitle := Label.new()
	subtitle.text = String(discovery.get("title", ""))
	subtitle.add_theme_color_override("font_color", TEXT_COLOR)
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(subtitle)

	var reason := Label.new()
	reason.text = String(discovery.get("short_reason", ""))
	reason.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reason.add_theme_color_override("font_color", TEXT_COLOR.lightened(0.05))
	reason.add_theme_font_size_override("font_size", 20)
	reason.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack.add_child(reason)

	entry.pressed.connect(_show_detail.bind(discovery))
	return entry

func _show_detail(discovery: Dictionary) -> void:
	var first_id: String = discovery.get("first_plant_id", "")
	var second_id: String = discovery.get("second_plant_id", "")
	var pair_text := "%s + %s" % [
		PlantData.get_display_name(first_id),
		PlantData.get_display_name(second_id)
	]
	var relationship_type: String = discovery.get("type", PlantRelationshipData.TYPE_NEUTRAL)

	page_title.text = "Diary Entry"
	detail_pair_label.text = pair_text
	detail_type_badge.color = TYPE_COLORS.get(relationship_type, TYPE_COLORS[PlantRelationshipData.TYPE_NEUTRAL])
	detail_type_label.text = PlantRelationshipData.get_type_label(relationship_type)
	detail_title_label.text = String(discovery.get("title", ""))
	detail_explanation_label.text = String(discovery.get("explanation", discovery.get("short_reason", "")))

	scroll_container.visible = false
	detail_view.visible = true

func _apply_button_theme(button: Button) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.26, 0.39, 0.29)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.border_width_bottom = 4
	style.border_color = Color(0.18, 0.28, 0.20)
	var hover: StyleBoxFlat = style.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.32, 0.46, 0.34)
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	button.add_theme_color_override("font_color", Color(0.98, 1.0, 0.94))
	button.add_theme_color_override("font_hover_color", Color(0.98, 1.0, 0.94))
	button.add_theme_color_override("font_pressed_color", Color(0.98, 1.0, 0.94))
	button.add_theme_font_size_override("font_size", 24)
