extends Node2D

@onready var npc =$NPC
@onready var main = $"../../Main"

var start_pos=Vector2i(3,1)
var end_pos=Vector2i(-5,1)

func _ready() -> void:
	
	await get_tree().create_timer(3).timeout
	
	npc.move_to(start_pos)
	
	
	
	npc.move_to(end_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if npc.position == $Layer0.map_to_local(end_pos):
		npc.game_over.emit()
