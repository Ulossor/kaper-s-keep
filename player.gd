extends Node2D



@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"

@export var available_traps = {
	"spikes" : 
		{"atlas_coords" : Vector2i(1, 3), "amount":  3},
	"slopes" :
		{"atlas_coords": Vector2i(2, 3), "amount": 3}}

var start_pos = Vector2i(3, 3)
var cur_trap: Dictionary = available_traps["spikes"]
var trap_coords: Vector2i = cur_trap["atlas_coords"]
var index = 0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position_input()
	
	
	if Input.is_action_just_pressed("A"):
		if cur_trap["amount"] > 0:
			map1.set_cell(map1.local_to_map(position), 2, trap_coords)
			cur_trap["amount"] += -1
	if Input.is_action_just_pressed("B"):
		change_trap()
		


func position_input():
	if map1.get_cell_source_id(map1.local_to_map(position)) != -1:
		z_index = 2
	else: z_index = 1
	var glob_pos = get_global_position()
	var loc_pos = to_local(glob_pos)
	var map_pos = map0.local_to_map(glob_pos)
	if Input.is_action_just_pressed("ui_left"):
		map_pos = map_pos + Vector2i(0,1)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_right"):
		map_pos = map_pos + Vector2i(0,-1)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_up"):
		map_pos = map_pos + Vector2i(-1, 0)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_down"):
		map_pos = map_pos + Vector2i(1,0)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return

func change_trap():
	var keys = available_traps.keys()
	for trap in available_traps:
		if cur_trap["atlas_coords"] == available_traps[trap]["atlas_coords"]:
			self.available_traps[trap] = cur_trap
			
	index = (index+1)%available_traps.size()
	if available_traps[keys[index]]["amount"] > 0:
		cur_trap = available_traps[keys[index]]
		trap_coords = cur_trap["atlas_coords"]
	
