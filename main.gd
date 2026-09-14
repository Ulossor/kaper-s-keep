extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Level/NPC.move_to(Vector2i(-2,2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
