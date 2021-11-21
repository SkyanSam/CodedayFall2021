extends Node

export var tilemap_csv_filename = "res://Tilemap/tilemap.txt" #= preload("res://Tilemap/tilemap.csv")
export var rooms_data = ["", ""]
export var blocks = []
export var preloaded_blocks = []
export var min_room_distance = 3
export var min_hallway_turns = 0
export var max_hallway_turns = 3
export var min_hallway_segment_length = 5
export var max_hallway_segment_length = 10
# Called when the node enters the scene tree for the first time.
func return_matrix(csv_location):
	var result = []
	var file = File.new()
	file.open(tilemap_csv_filename, file.READ)
	print("opened file")
	#get_csv_line ( String delim=”,” ) 
	while not file.eof_reached():
		var line = file.get_line()
		result.append(line)
	file.close()
	
	var height = result.size()
	var width = result[0].split(',').size()
	var matrix = create_map(height , width)
	
	for y in range(result.size()):
		var list = result[y].split(',')
		for x in range(list.size()):
			matrix[y][x] = int(list[x])
	
	return result

func _ready():
	randomize()
	
	for b in blocks:
		preloaded_blocks.append(load(b))
	#var result = []
	#var file = File.new()
	#file.open(tilemap_csv_filename, file.READ)
	#print("opened file")
	#get_csv_line ( String delim=”,” ) 
	#while not file.eof_reached():
		#var line = file.get_line()
		#result.append(line)
	#file.close()
	
	#var height = result.size()
	#var width = result[0].split(',').size()
	#var matrix = create_map(height , width)
	
	#for y in range(result.size()):
		#var list = result[y].split(',')
		#for x in range(list.size()):
			#matrix[y][x] = int(list[x])
			
	var height = 100
	var width = 100
	var matrix = procedural(100,500)
	for y in height:
		for x in width:
			if (int(matrix[y][x]) >= 0):
				var block : Spatial = preloaded_blocks[matrix[y][x]].instance()
				block.translation = Vector3(x, 0, y)
				add_child(block)
	#print(str(result.size()) + "," + str(result[0].split(',').size()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_map(w, h):
	var map = []

	for x in range(w):
		var col = []
		#col.resize(h)
		for y in range(h):
			col.append(-1)
		map.append(col)
			

	return map

func procedural(r, rooms):
	var matrix = create_map(r,r)
	var room_matrix = [[0,0,0],[0,0,0],[0,0,0]]
	for i in range(rooms):
		var coords = try_create_room(r, [[0,0,0],[0,0,0],[0,0,0]], matrix, 50)
		if (coords != null):
			matrix = place_room(coords, room_matrix, matrix)
	return matrix
func is_room_overlap(coords : Vector2, room_matrix, level_matrix):
	for y in range(room_matrix.size()):
		for x in range(room_matrix.size()):
			if (room_matrix[y][x] != -1):
				var m_y = y + coords.y
				var m_x = x + coords.x
				for a in range(-min_room_distance, min_room_distance + 1):
					for b in range(-min_room_distance, min_room_distance + 1):
						if (m_y + b < 0 || m_y + b >= level_matrix.size() || m_x + a < 0 || m_x + a >= level_matrix.size()): 
							return true	
						elif level_matrix[m_y + b][m_x + a] == 1:
							return true
	return false

#func match_openings(level_matrix):
	#var coords = []
	#var directions = [] # 0: RIGHT, 1: DOWN, 2: LEFT, 3: UP
	#var matches = create_map()
	#for y in range(level_matrix.size()):
		#for x in range(level_matrix.size()):
			#if (level_matrix[y][x] == 10):
				#openings.append(Vector2(x,y))
				#if (level_matrix[y+1][x] != -1): directions.append(1)
				#elif (level_matrix[y-1][x] != -1): directions.append(3)
				#elif (level_matrix[y][x+1] != -1): directions.append(2)
				#elif (level_matrix[y][x-1] != -1): directions.append(0)
	
	#for i in coords:
		#var last_closest_item = -1
		#for j in coords:
			#if (i != j):
				#if ((coords[i] - coords[last_closest_item]).length() > (coords[i] - coords[j]).length()):
					
				
				
func search_for_closest_opening(coords : Vector2, level_matrix, target_angle : float, max_angle_difference : float):
	var last_coords = Vector2(-1,-1)
	for y in range(level_matrix.size()):
		for x in range(level_matrix.size()):
			if (coords != Vector2(x,y) && level_matrix[y][x] == 10):
				if ((coords - last_coords).length() > (coords - Vector2(x,y)).length()):
					var this_angle = rad2deg((coords - Vector2(x,y)).angle()) 
					if (target_angle - max_angle_difference <= this_angle && this_angle <= target_angle + max_angle_difference):
						last_coords = Vector2(x,y)
	if (last_coords == Vector2(-1,-1)):
		return null
	else:
		return last_coords
		
			
func try_create_room(r, room_matrix, level_matrix, tries): # returns null or vector2
	if tries == 0:
		return null
	var coords = rand_range(0,r) * Vector2(cos(rand_range(0,2*PI)), sin(rand_range(0,2*PI)))
	if is_room_overlap(coords, room_matrix, level_matrix):
		return try_create_room(r, room_matrix, level_matrix, tries - 1)
	else:
		return coords

func is_area_empty(coords, room_matrix, level_matrix):
	for y in range(room_matrix.size()):
		for x in range(room_matrix.size()):
			if (level_matrix[y + coords.y][x + coords.x] != -1):
				return false
	return true
func place_room(coords, room_matrix, level_matrix):
	for y in range(room_matrix.size()):
		for x in range(room_matrix.size()):
			level_matrix[y + coords.y][x + coords.x] = room_matrix[y][x]
	return level_matrix

func try_create_hall(coords : Vector2, direction_angle : float, r, rooms : Array, level_matrix, tries):
	if (tries == 0):
		return null
	var current_coords = coords
	var curr_direction = direction_angle
	for i in range(0, rand_range(min_hallway_turns, max_hallway_turns + 1)):
		for j in range(0, rand_range(min_hallway_segment_length, max_hallway_segment_length + 1)):
			current_coords += Vector2(cos(deg2rad(direction_angle)), sin(deg2rad(direction_angle)))
			if (does_matrix_include_coords(level_matrix, current_coords)):
				var tile = level_matrix[current_coords.y][current_coords.x]
				if (tile == -1 || tile == -2):
					level_matrix[current_coords.y][current_coords.x] = -2
				else:
					return try_create_hall(coords, direction_angle, r, rooms, level_matrix, tries - 1)
			else:
				return try_create_hall(coords, direction_angle, r, rooms, level_matrix, tries - 1)
		var rand = rand_range(0, 2)
		if (rand_range(0, 2) == 0):
			curr_direction += 90
		else:
			curr_direction -= 90
	
	var curr_direction_vect = Vector2(cos(deg2rad(curr_direction)), sin(deg2rad(curr_direction)))
	var room_data = find_opening_in_rooms(rooms, -curr_direction_vect)
	if (room_data != null):
		var room_number = room_data[0]
		var room_coords = room_data[1]
	else:
		return try_create_hall(coords, direction_angle, r, rooms, level_matrix, tries - 1)
	return level_matrix

func does_matrix_include_coords(array, coords : Vector2):
	if range(array.size()).has(coords.y):
		if range(array[coords.y].size()).has(coords.x):
			return true
	return false

func find_opening_in_room(room_matrix : Array, direction : Vector2):
	for y in range(0, room_matrix.size()):
		for x in range(0, room_matrix[y].size()):
			if (room_matrix[y][x] == 10):
				if (does_matrix_include_coords(room_matrix, Vector2(x,y) + direction)):
					if (room_matrix[y + direction.y][x + direction.x] <= 0):
						return Vector2(x,y)
					else:
						return null
				else:
					return Vector2(x,y)
func find_opening_in_rooms(rooms : Array, direction : Vector2):
	for i in range(0, rooms.size()):
		var coords = find_opening_in_room(rooms[i], direction)
		if (coords != null):
			return [i, coords]
	return null
