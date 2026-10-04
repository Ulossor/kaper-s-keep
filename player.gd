extends Node2D

@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"


@export var prep = true
@export var available_traps = {
	"pit" : 
		{"atlas_coords" : Vector2i(0, 0), "amount":  0},
	"spikes" :
		{"atlas_coords": Vector2i(0, 1), "amount": 0},
	"jumper":
		{"atlas_coords": Vector2i(0,2), "amount": 0, "direction": "down"},
	"snake":
		{"atlas_coords": Vector2i(0,3), "amount": 0}}

var cur_trap: Dictionary = available_traps["pit"]
var trap_coords: Vector2i = cur_trap["atlas_coords"]
var index = 0
var alt_id = 1
var counterEmpty = 0

func _ready() -> void:
	set_process(false)
	await get_tree().physics_frame
	for trap in available_traps:
		if available_traps[trap]["amount"] > 0:
			cur_trap = available_traps[trap]
			trap_coords = cur_trap["atlas_coords"]
			if cur_trap.has("direction"):
				$Sprite.animation = cur_trap["direction"]
			else: $Sprite.animation = trap
			break
	$Sprite.play()
	set_process(true)
	
	
func _process(_delta: float) -> void:
	position_input()
	if cur_trap["amount"] == 0:
		if counterEmpty > available_traps.size():
			pass
		else: change_trap()

	if Input.is_action_just_pressed("A"):
		if cur_trap["amount"] > 0:
			if cur_trap.has("direction"):
				for i in range(0,4):
					var atlas_src = map1.tile_set.get_source(0)
					var base_data = atlas_src.get_tile_data(Vector2i(i,2),0)
					if base_data.get_custom_data("direction") == cur_trap["direction"]:
						map1.set_cell(map1.local_to_map(position), 0, Vector2i(i,2))
			else:
				map1.set_cell(map1.local_to_map(position), 0, trap_coords)
			cur_trap["amount"] += -1
			$"../../HUD".refresh_arsenal()
		
	if Input.is_action_just_pressed("B"):
		change_trap()

	if Input.is_action_just_pressed("Select"):
		if cur_trap.has("direction"):
			var directs = ["up", "right", "down", "left"]
			for i in range(directs.size()):
				if cur_trap["direction"] == directs[i]:
					cur_trap["direction"] = directs[(i+1) % directs.size()]
					break
			$Sprite.animation = cur_trap["direction"]
	if Input.is_action_just_pressed("Start"):
		if prep:
			$"../../../Main".run_phase()

func position_input():
	if map1.get_cell_source_id(map1.local_to_map(position) + Vector2i(-1,-1)) != -1:
		z_index = 2
	else: z_index = 0
	var glob_pos = get_global_position()
	var loc_pos = to_local(glob_pos)
	var map_pos = map0.local_to_map(glob_pos)
	if Input.is_action_just_pressed("left"):
		map_pos = map_pos + Vector2i(0,1)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1 or $"../Layer2".get_cell_source_id(map_pos) != -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("right"):
		map_pos = map_pos + Vector2i(0,-1)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1 or $"../Layer2".get_cell_source_id(map_pos) != -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("up"):
		map_pos = map_pos + Vector2i(-1, 0)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos ) == -1 or $"../Layer2".get_cell_source_id(map_pos) != -1:
			return
		else:
			loc_pos = map0.map_to_local(map_pos)
			set_position(loc_pos)
		return
	if Input.is_action_just_pressed("down"):
		map_pos = map_pos + Vector2i(1,0)
		if map1.get_cell_source_id(map_pos) == 2 or map0.get_cell_source_id(map_pos) == -1 or $"../Layer2".get_cell_source_id(map_pos) != -1:
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
			
	index = (index+1) % available_traps.size()
	if available_traps[keys[index]]["amount"] > 0:
		cur_trap = available_traps[keys[index]]
		trap_coords = cur_trap["atlas_coords"]
		if cur_trap.has("direction"):
			$Sprite.animation = cur_trap["direction"]
		else: $Sprite.animation = keys[index]
		
	for trap in available_traps.values():
		if trap["amount"] == 0:
			counterEmpty += 1
		else: counterEmpty = 0
		
func _unhandled_input(event: InputEvent) -> void:
	if !prep:
		if Input.is_action_just_pressed("Start"):
			$"../../../Main"._on_hud_retry()
