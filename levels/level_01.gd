extends Node2D

@onready var npc =$NPC
@onready var main = $"../../Main"

var start_pos=Vector2i(3,1)
var end_pos=Vector2i(-4,1)

func _ready() -> void:
	main.cur_level = main.lvls[1]
	await get_tree().create_timer(2).timeout
	
	npc.move_to(start_pos)
	
	
	
	npc.move_to(end_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
