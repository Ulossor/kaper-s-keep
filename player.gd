extends Node2D

@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"

@export var available_traps = {
	"pit" : 
		{"atlas_coords" : Vector2i(0, 0), "amount":  3},
	"spikes" :
		{"atlas_coords": Vector2i(0, 1), "amount": 3},
	"jumper":
		{"atlas_coords": Vector2i(0,2), "amount": 3},
	"snake":
		{"atlas_coords": Vector2i(0,3), "amount": 3}}

var cur_trap: Dictionary = available_traps["pit"]
var trap_coords: Vector2i = cur_trap["atlas_coords"]
var index = 0

func _ready() -> void:
	set_process(false)
	await get_tree().physics_frame
	set_process(true)
	
	
	

func _process(_delta: float) -> void:
	
	position_input()
	
	if Input.is_action_just_pressed("A"):
		if cur_trap["amount"] > 0:
			map1.set_cell(map1.local_to_map(position), 0, trap_coords)
			cur_trap["amount"] += -1
	if Input.is_action_just_pressed("B"):
		change_trap()
		


func position_input():
	if map1.get_cell_source_id(map1.local_to_map(position) + Vector2i(-1,-1)) != -1:
		z_index = 2
	else: z_index = 0
	var glob_pos = get_global_position()
	var loc_pos = to_local(glob_pos)
	var map_pos = map0.local_to_map(glob_pos)
	if Input.is_action_just_pressed("left"):
		map_pos = map_pos + Vector2i(0,1)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("right"):
		map_pos = map_pos + Vector2i(0,-1)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("up"):
		map_pos = map_pos + Vector2i(-1, 0)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("down"):
		map_pos = map_pos + Vector2i(1,0)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos) == -1:
			return
		else:
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
	
