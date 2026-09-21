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
var jump_target
var path_p

func _ready() -> void:
	$Sprite.animation = "default"
	set_process(false)
	await get_tree().create_timer(2).timeout
	set_process(true)
	setup_astar()
	$Sprite.play()


func _process(delta: float) -> void:
	if cur_path:
		if !in_air:
			if map0.local_to_map(position) != path_p:
				#await get_tree().physics_frame
				#await get_tree().physics_frame
				manage_pit()
			path_p = map0.local_to_map(position)
	check_damage(position, delta)
	if in_air:
		$Sprite.animation = "in_air"
		position = position.move_toward(jump_target, delta * speed)
		if position == jump_target:
			in_air = false
			$Sprite.animation = "default"
			set_process(false)
			await get_tree().create_timer(0.3).timeout
			set_process(true)
			move_to($"../../Level".end_pos)
			is_moving = false
	elif is_moving:
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
	astar.fill_solid_region(astar.region)
	var tile_data
	for cell in map0.get_used_cells():
		astar.set_point_solid(cell,false)
		tile_data = map0.get_cell_tile_data(cell)
		if tile_data:
			if tile_data.get_custom_data("is_hazard"):
				astar.set_point_solid(cell, true)
				
			if map1.get_cell_tile_data(cell):
				if map1.get_cell_tile_data(cell).get_custom_data("type") == "snake":
					var snake = load("res://snake.tscn")
					snake = snake.instantiate()
					$"../../Level".add_child(snake)
					snake.position = map1.map_to_local(cell)
					map1.erase_cell(cell)
					astar.set_point_solid(cell)
				elif map1.get_cell_tile_data(cell).get_custom_data("type") == "jumper":
					var jumper = load("res://jumper.tscn")
					jumper = jumper.instantiate()
					jumper.position = map1.map_to_local(cell)
					$"../../Level".add_child(jumper)
					
					#map1.erase_cell(cell)
					#astar.set_point_solid(cell)
					
					
		if map1.get_cell_source_id(cell ) == 2:
			astar.set_point_solid(cell, true)
		
				
func move_to(target):
	var start_tile = map0.local_to_map(position)
	var path = astar.get_id_path(start_tile, target)
	if path.size() > 0: path.pop_front()
	cur_path = path
	

func check_damage(pos, delta):
	if !in_air:
		if map1.get_cell_source_id(map1.local_to_map(pos) ) != -1:
			var tile = map1.local_to_map(pos)
			var tile_data = map1.get_cell_tile_data(tile)
			if tile_data:
				if tile_data.get_custom_data("type") == "spikes":
					gotcha.emit()
				if tile_data.get_custom_data("type") == "pit":
					gotcha.emit()
				if tile_data.get_custom_data("type") == "snake":
					gotcha.emit()

func _on_snake_hit():
	gotcha.emit()
	
func manage_pit():
	var next_tile
	if cur_path.size() >= 1:
		var cur_dir = cur_path[0] - map0.local_to_map(position)
		if abs(cur_dir.x) > abs(cur_dir.y):
			cur_dir.y = 0
		else: cur_dir.x = 0
		cur_dir = cur_dir.sign()
		var tile_data = map1.get_cell_tile_data(map0.local_to_map(position) + cur_dir)
		if tile_data:
			
			
			if tile_data.get_custom_data("type") == "pit":
				#await get_tree().create_timer(0.2).timeout
				jump_target = map0.map_to_local(cur_path[0] + cur_dir)
				target_loc = jump_target
				in_air = true
				next_tile = (map0.local_to_map(jump_target))
				
				if map1.get_cell_tile_data(next_tile):
					if map1.get_cell_tile_data(next_tile).get_custom_data("type") == "pit":
						
						in_air = false
				
#				if cur_path[0] == (map0.local_to_map(position) + cur_dir):
#					cur_path.pop_front()
#					cur_path.pop_front()
		#print(cur_path)
