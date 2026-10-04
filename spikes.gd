extends Area2D

signal spike_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spike_hit.connect($"../NPC"._on_snake_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if !body.in_air or body.jump_target == self.position:
			$Sprite.play()
			spike_hit.emit()
