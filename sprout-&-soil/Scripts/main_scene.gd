extends Node2D

func _ready() -> void:
	_create_background()
	_create_title()
	_create_garden_grid()

func _create_background() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.78, 0.91, 0.72)
	background.size = Vector2(1080, 1920)
	add_child(background)
	move_child(background, 0)

func _create_title() -> void:
	var title := Label.new()
	title.name = "Title"
	title.text = "Sprout & Soil"
	title.position = Vector2(0, 80)
	title.size = Vector2(1080, 80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var hint := Label.new()
	hint.name = "Hint"
	hint.text = "Tap a bed to plant a test carrot."
	hint.position = Vector2(0, 155)
	hint.size = Vector2(1080, 60)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hint)

func _create_garden_grid() -> void:
	var garden_grid := GardenGrid.new()
	garden_grid.name = "GardenGrid"
	add_child(garden_grid)
