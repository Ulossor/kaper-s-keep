extends Node2D

signal ePT

@onready var npc =$NPC
@onready var main = $"../../Main"

@export var start_pos=Vector2i(0,6)
@export var end_pos=Vector2i(0, 0)
var lines = ["pockerAt last, I am here...",
			"pockerThe old gold",
			"pockerof the keep...",
			"pockeris mine!",
			"(what a fool...)",
			"pockerNothing...",
			"pockerwill stop me now!"]
			
var lines2 = ["pockerLet's see..."]

var lines3 = ["pockerUhh...",
			"pockerThere's just",
			"pockera few coins...",
			"pockerWhere is",
			"pockerTHE GOLD???",
			"what money you think",
			"I'm not living on?",
			"been long since I last",
			"got my prize money,",
			"and now, i got to place",
			"all these traps,",
			"for buggers like you!",
			"do you think it's cheap??"]
			
var lines4 = ["pocker...",
			"pockerI am really sorry",
			"pockerabout your situation,",
			"pockersir,",
			"pockermaybe i could...",
			"Oh i'm not mad",
			"You can leave now",
			"pocker..."]
			
var lines5 = ["If... you can"]

func _ready() -> void:
	
#	$Player.available_traps = {
#	"pit" : 
#		{"atlas_coords" : Vector2i(0, 0), "amount":  0},
#	"spikes" :
#		{"atlas_coords": Vector2i(0, 1), "amount": 0},
#	"jumper":
#		{"atlas_coords": Vector2i(0,2), "amount": 0, "direction": "down"},
#	"snake":
#		{"atlas_coords": Vector2i(0,3), "amount": 0}}
	$"../HUD/ArsenalBox".hide()
	$NPC.move_to(start_pos)
	await get_tree().create_timer(1).timeout
	$"../../Main".dialog()
	await get_tree().create_timer(0.2).timeout
	await $"../HUD/DialogBox".visibility_changed
	$NPC.move_to(end_pos)
	await ePT
	$"../../Main".dialog(lines2)
	await get_tree().create_timer(0.2).timeout
	await $"../HUD/DialogBox".visibility_changed
	$Chest.play()
	await $Chest.animation_finished
	await get_tree().create_timer(1).timeout
	$"../../Main".dialog(lines3)
	await get_tree().create_timer(0.2).timeout
	await $"../HUD/DialogBox".visibility_changed
	await get_tree().create_timer(1).timeout
	$"../../Main".dialog(lines4)
	await get_tree().create_timer(0.2).timeout
	await $"../HUD/DialogBox".visibility_changed
	$NPC.move_to(Vector2i(0,1))
	$Layer1.set_cell(Vector2i(-1,3),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(0,3),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(1,3),0,Vector2i(0,3))
	await get_tree().create_timer(1).timeout
	$NPC.move_to(Vector2i(0,0))
	$Layer1.set_cell(Vector2i(-1,1),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(-1,0),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(-1,-1),0,Vector2i(0,3))
	
	$Layer1.set_cell(Vector2i(1,1),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(1,0),0,Vector2i(0,3))
	$Layer1.set_cell(Vector2i(1,-1),0,Vector2i(0,3))
	
	await get_tree().create_timer(1).timeout
	$"../../Main".dialog(lines5)
	await get_tree().create_timer(0.2).timeout
	await $"../HUD/DialogBox".visibility_changed
	await get_tree().create_timer(1).timeout
	$"../HUD/TheEnd".show()
	$"../HUD/HUDHiss".play()
	await $"../HUD/HUDHiss".finished
	$"../HUD/TheEnd/TELbl".show()
	
func _process(_delta: float) -> void:
	if npc.position == $Layer0.map_to_local(end_pos):
		ePT.emit()
