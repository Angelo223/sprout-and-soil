class_name GardenStatusPanel
extends Control

const TEXT_DEEP := Color("#263D25")
const TEXT_SOFT := Color("#4A5C42")
const ACCENT_SOIL := Color("#7B5738")
const PAPER_CREAM := Color("#FBF4DD")
const SHADOW_INK := Color(0.10, 0.16, 0.08, 0.35)

const STATUS_FADE_DELAY := 4.5
const STATUS_FADE_DURATION := 0.6

var status_label: Label
var diary_overlay: Control
var diary_card: Panel
var diary_label: Label
var diary_heading: Label
var diary_entries: Array[String] = []
var status_tween: Tween
var status_timer: float = 0.0
var status_visible: bool = false

func _ready() -> void:
	_build_ui()
	set_process(true)

func setup() -> void:
	_build_ui()
	show_message("Tap a bed to plant. Water to grow.")

func show_message(message: String) -> void:
	_build_ui()
	if message.is_empty():
		return

	status_label.text = message
	status_label.modulate.a = 1.0
	status_visible = true
	status_timer = 0.0

	if status_tween != null and status_tween.is_valid():
		status_tween.kill()

func show_discovery(discovery: Dictionary) -> void:
	var first_name := PlantData.get_display_name(discovery.get("first_plant_id", ""))
	var second_name := PlantData.get_display_name(discovery.get("second_plant_id", ""))
	var short_reason: String = discovery.get("short_reason", discovery.get("explanation", ""))
	var type_label := PlantRelationshipData.get_type_label(discovery.get("type", PlantRelationshipData.TYPE_NEUTRAL))

	show_message("%s + %s — %s" % [first_name, second_name, short_reason])
	add_diary_entry("%s: %s + %s" % [type_label, first_name, second_name])

func add_diary_entry(entry: String) -> void:
	if diary_entries.has(entry):
		return

	diary_entries.append(entry)
	_refresh_diary()

func get_diary_entry_count() -> int:
	return diary_entries.size()

func toggle_diary() -> void:
	_build_ui()
	diary_overlay.visible = not diary_overlay.visible
	if diary_overlay.visible:
		_refresh_diary()

func close_diary() -> void:
	_build_ui()
	diary_overlay.visible = false

func is_diary_open() -> bool:
	return diary_overlay != null and diary_overlay.visible

func _process(delta: float) -> void:
	if not status_visible or status_label == null:
		return

	status_timer += delta
	if status_timer < STATUS_FADE_DELAY:
		return

	status_visible = false
	status_tween = create_tween()
	status_tween.tween_property(status_label, "modulate:a", 0.0, STATUS_FADE_DURATION)

func _build_ui() -> void:
	if status_label != null:
		return

	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(1080, 1920)

	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(60, 0)
	status_label.size = Vector2(960, 60)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	status_label.add_theme_color_override("font_color", TEXT_SOFT)
	status_label.add_theme_color_override("font_shadow_color", Color(1.0, 1.0, 0.92, 0.85))
	status_label.add_theme_constant_override("shadow_offset_x", 0)
	status_label.add_theme_constant_override("shadow_offset_y", 1)
	status_label.add_theme_font_size_override("font_size", 22)
	status_label.modulate.a = 0.0
	add_child(status_label)

	_build_diary_overlay()

func _build_diary_overlay() -> void:
	diary_overlay = Control.new()
	diary_overlay.name = "DiaryOverlay"
	diary_overlay.position = Vector2.ZERO
	diary_overlay.size = Vector2(1080, 1920)
	diary_overlay.visible = false
	diary_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(diary_overlay)

	var dim := ColorRect.new()
	dim.name = "DiaryDim"
	dim.color = Color(0.10, 0.14, 0.08, 0.55)
	dim.position = Vector2.ZERO
	dim.size = Vector2(1080, 1920)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	diary_overlay.add_child(dim)

	var dim_button := Button.new()
	dim_button.name = "DiaryDimButton"
	dim_button.flat = true
	dim_button.position = Vector2.ZERO
	dim_button.size = Vector2(1080, 1920)
	dim_button.focus_mode = Control.FOCUS_NONE
	dim_button.pressed.connect(close_diary)
	diary_overlay.add_child(dim_button)

	diary_card = _make_card(PAPER_CREAM, ACCENT_SOIL, 32, 4)
	diary_card.name = "DiaryCard"
	diary_card.position = Vector2(80, 380)
	diary_card.size = Vector2(920, 1100)
	diary_overlay.add_child(diary_card)

	diary_heading = Label.new()
	diary_heading.name = "DiaryHeading"
	diary_heading.text = "Garden Diary"
	diary_heading.position = Vector2(40, 32)
	diary_heading.size = Vector2(840, 48)
	diary_heading.add_theme_color_override("font_color", TEXT_DEEP)
	diary_heading.add_theme_font_size_override("font_size", 32)
	diary_card.add_child(diary_heading)

	var separator := ColorRect.new()
	separator.name = "DiarySeparator"
	separator.color = Color(ACCENT_SOIL.r, ACCENT_SOIL.g, ACCENT_SOIL.b, 0.4)
	separator.position = Vector2(40, 90)
	separator.size = Vector2(840, 2)
	separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	diary_card.add_child(separator)

	diary_label = Label.new()
	diary_label.name = "DiaryLabel"
	diary_label.position = Vector2(40, 110)
	diary_label.size = Vector2(840, 880)
	diary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	diary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	diary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	diary_label.add_theme_color_override("font_color", TEXT_SOFT)
	diary_label.add_theme_font_size_override("font_size", 24)
	diary_card.add_child(diary_label)

	var close_button := Button.new()
	close_button.name = "DiaryCloseButton"
	close_button.text = "Close"
	close_button.position = Vector2(360, 1010)
	close_button.size = Vector2(200, 70)
	close_button.focus_mode = Control.FOCUS_NONE
	_apply_close_theme(close_button)
	close_button.pressed.connect(close_diary)
	diary_card.add_child(close_button)

func _refresh_diary() -> void:
	if diary_label == null:
		return

	if diary_entries.is_empty():
		diary_heading.text = "Garden Diary"
		diary_label.text = "Plant neighbors and discover how they get along.\nYour first findings will appear here."
		return

	diary_heading.text = "Garden Diary  (%s)" % diary_entries.size()
	var diary_text := ""
	for entry in diary_entries:
		if not diary_text.is_empty():
			diary_text += "\n"
		diary_text += "•  %s" % entry
	diary_label.text = diary_text

func _make_card(bg: Color, border: Color, radius: int, border_width: int) -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = SHADOW_INK
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 5)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _apply_close_theme(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#627A4E")
	normal.border_color = Color("#3F5532")
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(20)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#74905D")

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#506840")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_color_override("font_color", PAPER_CREAM)
	button.add_theme_color_override("font_hover_color", PAPER_CREAM)
	button.add_theme_color_override("font_pressed_color", PAPER_CREAM)
	button.add_theme_font_size_override("font_size", 24)
