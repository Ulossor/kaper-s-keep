extends Node2D

@onready var map = $"../Layer0"
@onready var target_tile = Vector2i(-2, 2)
@onready var target_loc = map.map_to_local(target_tile)

var astar: AStarGrid2D
var cur_path: Array[Vector2i] = []
var speed = 50
var is_moving= false

func _ready() -> void:
	setup_astar()
	$Sprite.play()


func _process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_loc, speed * delta)
		if position == target_loc:
			is_moving = false
	else:
		if cur_path.size() > 0:
			var next_tile = cur_path.pop_front()
			target_loc = map.map_to_local(next_tile)
			is_moving = true
	
	
	#var glob_pos = get_global_position()
	#var loc_pos = to_local(glob_pos)
	#var map_pos = map.local_to_map(loc_pos)
	#position = position.move_toward(target_loc, delta*speed)
	#$Sprite.animation = "walk"
	#if position == target_loc:
	#	$Sprite.animation = "default"

func setup_astar():
	astar = AStarGrid2D.new()
	astar.region = map.get_used_rect()
	astar.cell_size = Vector2(32, 16)
	astar.diagonal_mode =AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	var tile_data
	for cell in map.get_used_cells():
		tile_data = map.get_cell_tile_data(cell)
		if tile_data:
			if tile_data.get_custom_data("is_hazard"):
				astar.set_point_solid(cell, true)
				
func move_to(target):
	var start_tile = map.local_to_map(position)
	var path = astar.get_id_path(start_tile, target)
	if path.size() > 0: path.pop_front()
	cur_path = path
