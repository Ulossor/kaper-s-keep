extends Node2D

@onready var npc = $Level/NPC

var lvls = ["levels/level00.tscn", "levels/level01.tscn",
			"levels/level02.tscn", "levels/level03.tscn",
			"levels/level04.tscn", "levels/level05.tscn"]
var cur_level = lvls[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#npc.gotcha.connect(_on_gotcha)
	#npc.game_over.connect(_on_game_over)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	print(cur_level)
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
