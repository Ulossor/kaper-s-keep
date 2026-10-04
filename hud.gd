extends Node2D

signal next
signal retry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOver.hide()
	$WellDone.hide()
	$TheEnd.hide()



func _on_well_done_visibility_changed() -> void:
	await get_tree().create_timer(1).timeout
	if $WellDone.visible:
		$WellDone/Next.grab_focus()

func _on_game_over_visibility_changed() -> void:
	await get_tree().create_timer(1).timeout
	if $GameOver.visible:
		$GameOver/Retry.grab_focus()

func _on_next_pressed() -> void:
	next.emit()


func _on_retry_pressed() -> void:
	retry.emit()

func _on_go_retry_pressed() -> void:
	retry.emit()


func refresh_arsenal():
	var arsenal = $"ArsenalBox/HBox"
	var player = $"../Level/Player"
	for child in arsenal.get_children():
		child.queue_free()
	
	#var tileset_texture = load("res://art/tiles/tilesheetcounter.png")
	var tileset_texture = $"../Level/Layer1".tile_set.get_source(0).texture 
	var tile_size = Vector2i(32, 32) 

	for trap in player.available_traps:
		var data = player.available_traps[trap]
		if data["amount"] > 0:
			var row = HBoxContainer.new()
			var atlas_tex = AtlasTexture.new()
			atlas_tex.atlas = tileset_texture
			atlas_tex.region = Rect2(Vector2(data["atlas_coords"] * tile_size), Vector2(tile_size))
			
			var icon = TextureRect.new()
			icon.texture = atlas_tex
			row.add_child(icon)
			
			var label = Label.new()
			label.add_theme_font_size_override("font_size", 8)
			label.add_theme_color_override("font_color", "#233933")
			label.text = "x" + str(data["amount"])
			row.add_child(label)
			arsenal.add_child(row)
			
	await get_tree().physics_frame
	if arsenal.get_child_count() == 0:
		var label_empty = Label.new()
		label_empty.add_theme_font_size_override("font_size", 8)
		label_empty.add_theme_color_override("font_color", "#233933")
		label_empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_empty.text = "Empty!"
		arsenal.add_child(label_empty)
