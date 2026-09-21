extends Area2D

@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"

var direction

func _ready() -> void:
	var tile_data = map1.get_cell_tile_data(map1.local_to_map(position))
	direction = tile_data.get_custom_data("direction")
	$Sprite.animation = direction
	print(direction)


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if !body.in_air:
			var jump_target 
			match direction:
				"up": jump_target = map0.local_to_map(body.position) + Vector2i(-2,0)
				"right": jump_target = map0.local_to_map(body.position) + Vector2i(0,-2)
				"down": jump_target = map0.local_to_map(body.position) + Vector2i(2,0)
				"left": jump_target = map0.local_to_map(body.position) + Vector2i(0,2)
			body.jump_target = map0.map_to_local(jump_target)
			await get_tree().physics_frame
			body.in_air = true
