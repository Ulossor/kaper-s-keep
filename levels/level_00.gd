extends Node2D

@onready var npc =$NPC
@onready var pl = $Player
@onready var main = $"../../Main"



@export var start_pos=Vector2i(4,1)
@export var end_pos=Vector2i(-5,1)
var lines = ["Welcome.",
			"You will help me today.",
			"Use arrows to choose position",
			"then press 'A' to set trap.",
			"Place the Spikes",
			"right on the path",
			"to kill the adventurer.",
			"He will not notice them.",
			"pockerDid I hear someone?",
			"No, there's no one here",
			"but you.",
			"pockerAlright then..."]

func _ready() -> void:
	$Player.available_traps = {
	"pit" : 
		{"atlas_coords" : Vector2i(0, 0), "amount":  0},
	"spikes" :
		{"atlas_coords": Vector2i(0,1), "amount": 1},
	"jumper":
		{"atlas_coords": Vector2i(0,2), "amount": 0, "direction": "down"},
	"snake":
		{"atlas_coords": Vector2i(0,3), "amount": 0}}

	$"../HUD".refresh_arsenal()
	
	$"../../Main".prep_phase()
	
	$"../../Main".dialog()


func _process(_delta: float) -> void:
	if npc.position == $Layer0.map_to_local(end_pos):
		npc.game_over.emit()
