class_name GardenStatusPanel
extends Control

const TEXT_DEEP := Color("#263D25")
const TEXT_SOFT := Color("#4A5C42")
const ACCENT_SOIL := Color("#7B5738")
const PAPER_CREAM := Color("#FFF8E6")
const PAPER_WARM := Color("#FFF1C6")
const SHADOW_INK := Color(0.10, 0.16, 0.08, 0.35)
const DIARY_PANEL_TEXTURE_PATH := "res://assets/ui/generated/diary_panel_cropped.png"

const COLOR_TYPE_GOOD := Color("#7B9B5A")
const COLOR_TYPE_RISKY := Color("#B86F4B")
const COLOR_TYPE_SPECIAL := Color("#C9A445")
const COLOR_TYPE_NEUTRAL := Color("#8C9BC8")

const STATUS_FADE_DELAY := 4.5
const STATUS_FADE_DURATION := 0.6

const DIARY_CARD_SIZE := Vector2(920, 1100)
const PLANT_TILE_BG := Color("#FFF6DA")
const PLANT_TILE_BORDER := Color("#D7BF82")

var status_label: Label

var diary_entries: Array[Dictionary] = []
var diary_overlay: Control
var diary_card: Panel
var diary_heading: Label

var list_view: Control
var list_scroll: ScrollContainer
var list_box: VBoxContainer
var list_empty_label: Label
var list_close_button: Button

var detail_view: Control
var detail_back_button: Button
var detail_plant_a_panel: Panel
var detail_plant_a_image: TextureRect
var detail_plant_a_name: Label
var detail_plant_b_panel: Panel
var detail_plant_b_image: TextureRect
var detail_plant_b_name: Label
var detail_type_panel: Panel
var detail_type_label: Label
var detail_title_label: Label
var detail_explanation_label: Label

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

	show_message("%s + %s — %s" % [first_name, second_name, short_reason])
	add_diary_entry(discovery)

func add_diary_entry(discovery: Dictionary) -> void:
	var key: String = discovery.get("key", PlantRelationshipData.get_relationship_key(
		discovery.get("first_plant_id", ""),
		discovery.get("second_plant_id", "")
	))

	for existing in diary_entries:
		if existing.get("key", "") == key:
			return

	var stored := discovery.duplicate()
	stored["key"] = key
	diary_entries.append(stored)
	_refresh_diary_list()

func get_diary_entry_count() -> int:
	return diary_entries.size()

func toggle_diary() -> void:
	_build_ui()
	if diary_overlay.visible:
		close_diary()
	else:
		open_diary()

func open_diary() -> void:
	_build_ui()
	_show_list_view()
	diary_overlay.visible = true

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
	dim.color = Color(0.10, 0.14, 0.08, 0.62)
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

	diary_card = _make_card(Color(1, 1, 1, 0), Color(1, 1, 1, 0), 28, 0)
	diary_card.name = "DiaryCard"
	diary_card.position = Vector2(80, 330)
	diary_card.size = DIARY_CARD_SIZE
	diary_overlay.add_child(diary_card)

	var diary_card_texture := TextureRect.new()
	diary_card_texture.name = "DiaryCardTexture"
	diary_card_texture.texture = load(DIARY_PANEL_TEXTURE_PATH)
	diary_card_texture.position = Vector2.ZERO
	diary_card_texture.size = DIARY_CARD_SIZE
	diary_card_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	diary_card_texture.stretch_mode = TextureRect.STRETCH_SCALE
	diary_card_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	diary_card.add_child(diary_card_texture)

	diary_heading = Label.new()
	diary_heading.name = "DiaryHeading"
	diary_heading.text = "Garden Diary"
	diary_heading.position = Vector2(70, 78)
	diary_heading.size = Vector2(780, 48)
	diary_heading.add_theme_color_override("font_color", TEXT_DEEP)
	diary_heading.add_theme_font_size_override("font_size", 32)
	diary_card.add_child(diary_heading)

	var separator := ColorRect.new()
	separator.name = "DiarySeparator"
	separator.color = Color(ACCENT_SOIL.r, ACCENT_SOIL.g, ACCENT_SOIL.b, 0.25)
	separator.position = Vector2(70, 136)
	separator.size = Vector2(780, 2)
	separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	diary_card.add_child(separator)

	_build_list_view()
	_build_detail_view()
	_show_list_view()

func _build_list_view() -> void:
	list_view = Control.new()
	list_view.name = "DiaryListView"
	list_view.position = Vector2(0, 150)
	list_view.size = Vector2(DIARY_CARD_SIZE.x, DIARY_CARD_SIZE.y - 150)
	diary_card.add_child(list_view)

	list_scroll = ScrollContainer.new()
	list_scroll.name = "DiaryListScroll"
	list_scroll.position = Vector2(74, 12)
	list_scroll.size = Vector2(DIARY_CARD_SIZE.x - 148, list_view.size.y - 158)
	list_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	list_scroll.scroll_deadzone = 12
	list_view.add_child(list_scroll)

	list_box = VBoxContainer.new()
	list_box.name = "DiaryListBox"
	list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_box.add_theme_constant_override("separation", 14)
	list_scroll.add_child(list_box)

	list_empty_label = Label.new()
	list_empty_label.name = "DiaryEmptyLabel"
	list_empty_label.text = "Plant neighbors and discover how they get along.\nYour first findings will appear here."
	list_empty_label.position = Vector2(110, 110)
	list_empty_label.size = Vector2(DIARY_CARD_SIZE.x - 220, 200)
	list_empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	list_empty_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	list_empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	list_empty_label.add_theme_color_override("font_color", TEXT_SOFT)
	list_empty_label.add_theme_font_size_override("font_size", 24)
	list_view.add_child(list_empty_label)

	list_close_button = Button.new()
	list_close_button.name = "DiaryCloseButton"
	list_close_button.text = "Close"
	list_close_button.position = Vector2((DIARY_CARD_SIZE.x - 200) / 2.0, list_view.size.y - 188)
	list_close_button.size = Vector2(200, 70)
	list_close_button.focus_mode = Control.FOCUS_NONE
	_apply_pill_button_theme(list_close_button, Color("#496B43"), Color("#2F4C32"), PAPER_CREAM)
	list_close_button.pressed.connect(close_diary)
	list_view.add_child(list_close_button)

func _build_detail_view() -> void:
	detail_view = Control.new()
	detail_view.name = "DiaryDetailView"
	detail_view.position = Vector2(0, 0)
	detail_view.size = DIARY_CARD_SIZE
	detail_view.visible = false
	diary_card.add_child(detail_view)

	detail_back_button = Button.new()
	detail_back_button.name = "DiaryBackButton"
	detail_back_button.text = "< Back"
	detail_back_button.position = Vector2(70, 76)
	detail_back_button.size = Vector2(150, 60)
	detail_back_button.focus_mode = Control.FOCUS_NONE
	_apply_pill_button_theme(detail_back_button, Color("#FFF8DF"), Color("#8A6647"), TEXT_DEEP)
	detail_back_button.pressed.connect(_show_list_view)
	detail_view.add_child(detail_back_button)

	var plant_tile_size := Vector2(340, 340)
	var plant_a_origin := Vector2(80, 190)
	var plant_b_origin := Vector2(500, 190)

	detail_plant_a_panel = _make_plant_tile()
	detail_plant_a_panel.position = plant_a_origin
	detail_plant_a_panel.size = plant_tile_size
	detail_view.add_child(detail_plant_a_panel)

	detail_plant_a_image = TextureRect.new()
	detail_plant_a_image.name = "PlantAImage"
	detail_plant_a_image.position = Vector2(30, 30)
	detail_plant_a_image.size = Vector2(280, 230)
	detail_plant_a_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	detail_plant_a_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	detail_plant_a_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_plant_a_panel.add_child(detail_plant_a_image)

	detail_plant_a_name = Label.new()
	detail_plant_a_name.name = "PlantAName"
	detail_plant_a_name.position = Vector2(0, 270)
	detail_plant_a_name.size = Vector2(plant_tile_size.x, 50)
	detail_plant_a_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_plant_a_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_plant_a_name.add_theme_color_override("font_color", TEXT_DEEP)
	detail_plant_a_name.add_theme_font_size_override("font_size", 26)
	detail_plant_a_panel.add_child(detail_plant_a_name)

	var plus_label := Label.new()
	plus_label.name = "PlusLabel"
	plus_label.text = "+"
	plus_label.position = Vector2(plant_a_origin.x + plant_tile_size.x, plant_a_origin.y)
	plus_label.size = Vector2(plant_b_origin.x - plant_a_origin.x - plant_tile_size.x, plant_tile_size.y)
	plus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	plus_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	plus_label.add_theme_color_override("font_color", ACCENT_SOIL)
	plus_label.add_theme_font_size_override("font_size", 64)
	detail_view.add_child(plus_label)

	detail_plant_b_panel = _make_plant_tile()
	detail_plant_b_panel.position = plant_b_origin
	detail_plant_b_panel.size = plant_tile_size
	detail_view.add_child(detail_plant_b_panel)

	detail_plant_b_image = TextureRect.new()
	detail_plant_b_image.name = "PlantBImage"
	detail_plant_b_image.position = Vector2(30, 30)
	detail_plant_b_image.size = Vector2(280, 230)
	detail_plant_b_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	detail_plant_b_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	detail_plant_b_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_plant_b_panel.add_child(detail_plant_b_image)

	detail_plant_b_name = Label.new()
	detail_plant_b_name.name = "PlantBName"
	detail_plant_b_name.position = Vector2(0, 270)
	detail_plant_b_name.size = Vector2(plant_tile_size.x, 50)
	detail_plant_b_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_plant_b_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_plant_b_name.add_theme_color_override("font_color", TEXT_DEEP)
	detail_plant_b_name.add_theme_font_size_override("font_size", 26)
	detail_plant_b_panel.add_child(detail_plant_b_name)

	detail_type_panel = Panel.new()
	detail_type_panel.position = Vector2((DIARY_CARD_SIZE.x - 250) / 2.0, 570)
	detail_type_panel.size = Vector2(250, 56)
	detail_view.add_child(detail_type_panel)

	detail_type_label = Label.new()
	detail_type_label.name = "DetailTypeLabel"
	detail_type_label.position = Vector2(0, 0)
	detail_type_label.size = detail_type_panel.size
	detail_type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_type_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_type_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	detail_type_label.add_theme_color_override("font_color", PAPER_CREAM)
	detail_type_label.add_theme_font_size_override("font_size", 22)
	detail_type_panel.add_child(detail_type_label)

	detail_title_label = Label.new()
	detail_title_label.name = "DetailTitle"
	detail_title_label.position = Vector2(60, 660)
	detail_title_label.size = Vector2(DIARY_CARD_SIZE.x - 120, 60)
	detail_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	detail_title_label.add_theme_color_override("font_color", TEXT_DEEP)
	detail_title_label.add_theme_font_size_override("font_size", 30)
	detail_view.add_child(detail_title_label)

	detail_explanation_label = Label.new()
	detail_explanation_label.name = "DetailExplanation"
	detail_explanation_label.position = Vector2(110, 730)
	detail_explanation_label.size = Vector2(DIARY_CARD_SIZE.x - 220, DIARY_CARD_SIZE.y - 790)
	detail_explanation_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_explanation_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	detail_explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_explanation_label.add_theme_color_override("font_color", TEXT_SOFT)
	detail_explanation_label.add_theme_font_size_override("font_size", 22)
	detail_view.add_child(detail_explanation_label)

func _show_list_view() -> void:
	if list_view == null:
		return

	diary_heading.visible = true
	list_view.visible = true
	if detail_view != null:
		detail_view.visible = false
	_refresh_diary_list()

func _show_detail_view(entry: Dictionary) -> void:
	if detail_view == null:
		return

	diary_heading.visible = false
	list_view.visible = false
	detail_view.visible = true

	var first_id: String = entry.get("first_plant_id", "")
	var second_id: String = entry.get("second_plant_id", "")
	var type_id: String = entry.get("type", PlantRelationshipData.TYPE_NEUTRAL)

	detail_plant_a_name.text = PlantData.get_display_name(first_id)
	detail_plant_b_name.text = PlantData.get_display_name(second_id)
	_set_plant_tile_image(detail_plant_a_image, first_id)
	_set_plant_tile_image(detail_plant_b_image, second_id)

	detail_type_label.text = PlantRelationshipData.get_type_label(type_id)
	_apply_type_panel_color(detail_type_panel, type_id)

	detail_title_label.text = entry.get("title", "")
	detail_explanation_label.text = entry.get("explanation", entry.get("short_reason", ""))

func _refresh_diary_list() -> void:
	if list_box == null:
		return

	for child in list_box.get_children():
		child.queue_free()

	if diary_entries.is_empty():
		diary_heading.text = "Garden Diary"
		list_empty_label.visible = true
		return

	diary_heading.text = "Garden Diary  (%s)" % diary_entries.size()
	list_empty_label.visible = false

	for entry in diary_entries:
		list_box.add_child(_make_entry_button(entry))

func _make_entry_button(entry: Dictionary) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 96)
	button.focus_mode = Control.FOCUS_NONE
	button.flat = true
	button.pressed.connect(_show_detail_view.bind(entry))

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("#FFF8DF")
	card_style.border_color = Color(ACCENT_SOIL.r, ACCENT_SOIL.g, ACCENT_SOIL.b, 0.22)
	card_style.set_border_width_all(2)
	card_style.set_corner_radius_all(18)
	card_style.shadow_color = Color(0.12, 0.10, 0.06, 0.10)
	card_style.shadow_size = 3
	card_style.shadow_offset = Vector2(0, 2)

	var hover_style := card_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = Color("#FFF1C6")

	var pressed_style := card_style.duplicate() as StyleBoxFlat
	pressed_style.bg_color = Color("#EFD99D")

	button.add_theme_stylebox_override("normal", card_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_color_override("font_color", Color(0, 0, 0, 0))
	button.add_theme_color_override("font_hover_color", Color(0, 0, 0, 0))
	button.add_theme_color_override("font_pressed_color", Color(0, 0, 0, 0))

	var type_id: String = entry.get("type", PlantRelationshipData.TYPE_NEUTRAL)

	var type_panel := Panel.new()
	type_panel.name = "TypeBadge"
	type_panel.position = Vector2(20, 20)
	type_panel.size = Vector2(150, 56)
	type_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_apply_type_panel_color(type_panel, type_id)
	button.add_child(type_panel)

	var type_label := Label.new()
	type_label.name = "TypeLabel"
	type_label.text = PlantRelationshipData.get_type_label(type_id)
	type_label.position = Vector2(0, 0)
	type_label.size = type_panel.size
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	type_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	type_label.add_theme_color_override("font_color", PAPER_CREAM)
	type_label.add_theme_font_size_override("font_size", 20)
	type_panel.add_child(type_label)

	var first_name := PlantData.get_display_name(entry.get("first_plant_id", ""))
	var second_name := PlantData.get_display_name(entry.get("second_plant_id", ""))

	var pair_label := Label.new()
	pair_label.name = "PairLabel"
	pair_label.text = "%s  +  %s" % [first_name, second_name]
	pair_label.position = Vector2(190, 18)
	pair_label.size = Vector2(540, 36)
	pair_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pair_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pair_label.add_theme_color_override("font_color", TEXT_DEEP)
	pair_label.add_theme_font_size_override("font_size", 26)
	button.add_child(pair_label)

	var subtitle: String = entry.get("title", "")
	var subtitle_label := Label.new()
	subtitle_label.name = "SubtitleLabel"
	subtitle_label.text = subtitle
	subtitle_label.position = Vector2(190, 54)
	subtitle_label.size = Vector2(540, 32)
	subtitle_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle_label.add_theme_color_override("font_color", TEXT_SOFT)
	subtitle_label.add_theme_font_size_override("font_size", 20)
	button.add_child(subtitle_label)

	var arrow_label := Label.new()
	arrow_label.name = "ArrowLabel"
	arrow_label.text = ">"
	arrow_label.position = Vector2(740, 0)
	arrow_label.size = Vector2(60, 96)
	arrow_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	arrow_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	arrow_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	arrow_label.add_theme_color_override("font_color", ACCENT_SOIL)
	arrow_label.add_theme_font_size_override("font_size", 32)
	button.add_child(arrow_label)

	return button

func _make_plant_tile() -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = PLANT_TILE_BG
	style.border_color = PLANT_TILE_BORDER
	style.set_border_width_all(3)
	style.set_corner_radius_all(20)
	style.shadow_color = SHADOW_INK
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 4)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _set_plant_tile_image(image: TextureRect, plant_id: String) -> void:
	if image == null:
		return

	var sprite_path := PlantData.get_stage_sprite_path(plant_id, 1)
	if sprite_path.is_empty() or not ResourceLoader.exists(sprite_path):
		image.texture = null
		return

	image.texture = load(sprite_path)

func _apply_type_panel_color(panel: Panel, type_id: String) -> void:
	var color := _color_for_type(type_id)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(color.r * 0.7, color.g * 0.7, color.b * 0.7)
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	panel.add_theme_stylebox_override("panel", style)

func _color_for_type(type_id: String) -> Color:
	match type_id:
		PlantRelationshipData.TYPE_GOOD:
			return COLOR_TYPE_GOOD
		PlantRelationshipData.TYPE_RISKY:
			return COLOR_TYPE_RISKY
		PlantRelationshipData.TYPE_SPECIAL:
			return COLOR_TYPE_SPECIAL
		_:
			return COLOR_TYPE_NEUTRAL

func _make_card(bg: Color, border: Color, radius: int, border_width: int) -> Panel:
	var panel := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.shadow_color = SHADOW_INK
	style.shadow_size = 18
	style.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _apply_pill_button_theme(button: Button, bg: Color, border: Color, font_color: Color) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = bg
	normal.border_color = border
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(18)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(bg.r * 0.95, bg.g * 0.95, bg.b * 0.95)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(bg.r * 0.88, bg.g * 0.88, bg.b * 0.88)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color)
	button.add_theme_font_size_override("font_size", 24)
