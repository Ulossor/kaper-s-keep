extends Node2D

@onready var npc = $Level/NPC

var lvls = ["levels/level00.tscn", "levels/level01.tscn",
			"levels/level02.tscn", "levels/level03.tscn",
			"levels/level04.tscn", "levels/level05.tscn",
			"levels/level06.tscn", "levels/level07.tscn",
			"levels/level071.tscn",
			"levels/level08.tscn", "levels/level09.tscn"]
var cur_level = lvls[0]

func _ready() -> void:
	pass

func _on_gotcha():
	$HUD/WellDone.show()
	$Level/Player.set_process(false)
	$Level/NPC.set_process(false)
	

func _on_game_over():
	$HUD/GameOver.show()

func _on_hud_next() -> void:
	$Level.queue_free()
	await get_tree().physics_frame
	$HUD/WellDone.hide()
	for i in range(lvls.size()):
		if cur_level == lvls[i] and cur_level != lvls[-1]:
			cur_level = lvls[i + 1]
			break
		if cur_level == lvls[-1]:
			$HUD/TheEnd.show()
	var next = load(cur_level)
	await get_tree().physics_frame
	var next_inst = next.instantiate()
	add_child(next_inst)


func _on_hud_retry() -> void:
	$Level.queue_free()
	await get_tree().physics_frame
	if $HUD/GameOver.visible:
		$HUD/GameOver.hide()
	else: $HUD/WellDone.hide()
	var next = load(cur_level)
	await get_tree().physics_frame
	var next_inst = next.instantiate()
	add_child(next_inst)


func _on_child_entered_tree(node: Node) -> void:
	
	if node.name == "Level":
		#print("capy")
		$Level/NPC.gotcha.connect(_on_gotcha)
		$Level/NPC.game_over.connect(_on_game_over)

func prep_phase():
	await get_tree().physics_frame
	$"Level/NPC".set_process(true)
	$"Level/NPC".move_to($Level.start_pos)
	$"Level/Layer2".enabled = true
	$"Level/Player".prep = true
	$"Level/Player".show()
	$"Level/Player".set_process(true)
	$HUD/ArsenalBox.show()

func run_phase():
	await get_tree().physics_frame

	$"Level/Layer2".enabled = false
	$"Level/Player".prep = false
	$"Level/Player".set_process(false)
	$"Level/Player".hide()
	$"Level/NPC".setup_astar()
	$"Level/NPC".set_process(true)
	$HUD/ArsenalBox.hide()
	await get_tree().create_timer(1).timeout
	$"Level/NPC".move_to($"Level".end_pos)

func dialog(text = $Level.lines):
	await get_tree().physics_frame
	$"Level/Player".set_process(false)
	#$"Level/NPC".set_process(false)
	$"HUD/DialogBox".show()
	for line in text:
		if line.contains("pocker"):
			line = line.replace("pocker","")
			if !$"HUD/DialogBox/HB".has_node(^"TextureRect"):
				
				var png = load("res://art/npcs/cowboyface0.png")
				var icon = TextureRect.new()
				icon.texture = png
				icon.custom_minimum_size = Vector2i(24,24)
				icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
				icon.stretch_mode =TextureRect.STRETCH_KEEP
				$"HUD/DialogBox/HB".add_child(icon, true)
				$"HUD/DialogBox/HB".move_child(icon, 0)
		else:
			if $"HUD/DialogBox/HB".has_node(^"TextureRect"):
				$"HUD/DialogBox/HB/TextureRect".queue_free()
		$"HUD/DialogBox/HB/Label".text = line
		await get_tree().create_timer(0.2).timeout
		while true:
			var event = await get_tree().root.window_input
			if event.is_action_pressed("A"):
				break

	if $"HUD/DialogBox".visible:
		await get_tree().create_timer(0.2).timeout
		$"HUD/DialogBox".hide()
		$"Level/Player".set_process(true)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start"):
		if $"HUD/DialogBox".visible:
			get_viewport().set_input_as_handled()
			$"HUD/DialogBox".hide()
			$"Level/Player".set_process(true)
			
			
	
