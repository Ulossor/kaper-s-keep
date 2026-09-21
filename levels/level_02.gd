extends Node2D

@onready var npc =$NPC
@onready var main = $"../../Main"

var start_pos=Vector2i(3,1)
var end_pos=Vector2i(-5,1)

func _ready() -> void:
	var arsenal = $"../HUD/ArsenalBox"
	$Player.available_traps = {
	"pit" : 
		{"atlas_coords" : Vector2i(0, 0), "amount":  0},
	"spikes" :
		{"atlas_coords": Vector2i(0, 1), "amount": 1},
	"jumper":
		{"atlas_coords": Vector2i(0,2), "amount": 0, "direction": "down"},
	"snake":
		{"atlas_coords": Vector2i(0,3), "amount": 0}}
	for child in arsenal.get_children():
		child.queue_free()
	
	var tileset_texture = $Layer1.tile_set.get_source(0).texture 
	var tile_size = Vector2i(32, 32) 

	
	for trap in $Player.available_traps:
		var data = $Player.available_traps[trap]
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
			label.text = "x" + str(data["amount"])
			row.add_child(label)
			arsenal.add_child(row)
	
	
	await get_tree().create_timer(3).timeout
	
	npc.move_to(start_pos)
	
	
	
	npc.move_to(end_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if npc.position == $Layer0.map_to_local(end_pos):
		npc.game_over.emit()
