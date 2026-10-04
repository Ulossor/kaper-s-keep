extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	$Label.hide()
	await get_tree().create_timer(1.0).timeout
	set_process(true)
	$Timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
	if Input.is_action_just_pressed("Start"):
		
		await get_tree().physics_frame
		get_tree().change_scene_to_file("res://main.tscn")


func _on_timer_timeout() -> void:
	$Label.visible = not $Label.visible


func _on_timer_2_timeout() -> void:
	$Cloud.position.x += -1


func _on_timer_3_timeout() -> void:
	$Cloud1.position.x += +1
