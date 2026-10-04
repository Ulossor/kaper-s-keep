extends Area2D

signal snake_hit



func _ready() -> void:
	$Sprite.animation = "default"
	$Sprite.play()
	snake_hit.connect($"../NPC"._on_snake_hit)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var bodypos = body.map0.local_to_map(body.position)
		var selfpos = body.map0.local_to_map(self.position)
		var diff = bodypos - selfpos
		var if_neighbor = abs(diff.x + diff.y) == 1
		if !body.in_air:
			$Sprite.animation = "aggro"
			snake_hit.emit()
		elif if_neighbor:
			await get_tree().physics_frame
			await get_tree().physics_frame
			$Sprite.animation = "aggro"
			snake_hit.emit()
		
