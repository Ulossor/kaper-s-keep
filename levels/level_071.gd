extends Node2D

@onready var npc =$NPC
@onready var main = $"../../Main"

@export var start_pos=Vector2i(-1,4)
@export var end_pos=Vector2i(3,0)
var lines = ["You have a pit.",
			"The adventurer will try",
			"to jump over it",
			"if it is in his path." ]

func _ready() -> void:
	$Player.available_traps = {
	"pit" : 
		{"atlas_coords" : Vector2i(0, 0), "amount":  2},
	"spikes" :
		{"atlas_coords": Vector2i(0, 1), "amount": 0},
	"jumper":
		{"atlas_coords": Vector2i(0,2), "amount": 0, "direction": "down"},
	"snake":
		{"atlas_coords": Vector2i(0,3), "amount": 0}}
	$"../HUD".refresh_arsenal()
	
	$"../../Main".prep_phase()
	
	$"../../Main".dialog()

func _process(delta: float) -> void:
	if npc.position == $Layer0.map_to_local(end_pos):
		npc.game_over.emit()
