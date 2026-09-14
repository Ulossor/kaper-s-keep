extends Node2D

var start_pos=Vector2i(3, 3)
var on_higher_ground = false
@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var glob_pos = get_global_position()
	var loc_pos = to_local(glob_pos)
	var map_pos = map0.local_to_map(glob_pos)
	if Input.is_action_just_pressed("ui_left"):
		map_pos = map_pos + Vector2i(0,1)
		map_pos = check_height_level(map_pos)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_right"):
		map_pos = map_pos + Vector2i(0,-1)
		map_pos = check_height_level(map_pos)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_up"):
		map_pos = map_pos + Vector2i(-1, 0)
		map_pos = check_height_level(map_pos)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return
	if Input.is_action_just_pressed("ui_down"):
		map_pos = map_pos + Vector2i(1,0)
		map_pos = check_height_level(map_pos)
		loc_pos = map0.map_to_local(map_pos)
		set_position(loc_pos)
		return

func check_height_level(pos: Vector2i):
	if map1.get_cell_source_id(pos + Vector2i(-1,-1)) != -1 and !on_higher_ground:
		on_higher_ground = true
		z_index +=1
		pos += Vector2i(-1,-1)
	elif map1.get_cell_source_id(pos) == -1 and on_higher_ground:
		on_higher_ground = false
		z_index += -1
		pos += Vector2i(1,1)
	return pos


	
