extends Node2D

signal gotcha
signal game_over

@onready var map0 = $"../Layer0"
@onready var map1 = $"../Layer1"
var target_tile # Vector2i(-2, 2)
var target_loc # map0.map_to_local(target_tile)

var astar: AStarGrid2D
var cur_path: Array[Vector2i] = []
var speed = 50
var is_moving = false
var in_air = false

func _ready() -> void:
	setup_astar()
	$Sprite.play()


func _process(delta: float) -> void:
	check_damage(position)
	if in_air:
		$Sprite.animation = "in air"	
	if is_moving:
		$Sprite.animation = "walk"
		position = position.move_toward(target_loc, speed * delta)
		if position == target_loc:
			is_moving = false
	
		
	else:
		$Sprite.animation ="default"
		if cur_path.size() > 0:
			var next_tile = cur_path.pop_front()
			
			target_loc = map0.map_to_local(next_tile)
			is_moving = true

func setup_astar():
	astar = AStarGrid2D.new()
	astar.region = map0.get_used_rect()
	astar.cell_size = Vector2(32, 16)
	astar.diagonal_mode =AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	var tile_data
	for cell in map0.get_used_cells():
		tile_data = map0.get_cell_tile_data(cell)
		if tile_data:
			if tile_data.get_custom_data("is_hazard"):
				astar.set_point_solid(cell, true)
		if map1.get_cell_source_id(cell ) != -1:
			astar.set_point_solid(cell, true)
				
func move_to(target):
	var start_tile = map0.local_to_map(position)
	var path = astar.get_id_path(start_tile, target)
	if path.size() > 0: path.pop_front()
	cur_path = path

func check_damage(pos):
	if map1.get_cell_source_id(map1.local_to_map(pos) ) != -1:
		var tile = map1.local_to_map(pos)
		var tile_data = map1.get_cell_tile_data(tile)
		if tile_data:
			if tile_data.get_custom_data("type") == "pit":
				set_process(false)
				
				gotcha.emit()
