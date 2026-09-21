extends Area2D

signal snake_hit

func _ready() -> void:
	$AnimatedSprite2D.play()
	snake_hit.connect($"../NPC"._on_snake_hit)

func _process(delta):
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		snake_hit.emit()
