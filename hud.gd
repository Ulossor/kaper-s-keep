extends Node2D

signal next
signal retry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOver.hide()
	$WellDone.hide()
	$TheEnd.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
