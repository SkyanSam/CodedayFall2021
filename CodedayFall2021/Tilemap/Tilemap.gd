extends Node

export var tilemap_csv_filename = "res://Tilemap/tilemap.txt" #= preload("res://Tilemap/tilemap.csv")
export var rooms_data = ["", ""]
export var blocks = []
export var preloaded_blocks = []
export var min_room_distance = 3
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
						if not (m_y + b < 0 || m_y + b >= level_matrix.size() || m_x + a < 0 || m_x + a >= level_matrix.size()): 
							if level_matrix[m_y + b][m_x + a] == 1:
								return true
	return false

func try_create_room(r, room_matrix, level_matrix, tries): # returns null or vector2
	if tries == 0:
		return null
	var coords = rand_range(0,r) * Vector2(cos(rand_range(0,2*PI)), sin(rand_range(0,2*PI)))
	if is_room_overlap(coords, room_matrix, level_matrix):
		return try_create_room(r, room_matrix, level_matrix, tries - 1)
	else:
		return coords
		
func place_room(coords, room_matrix, level_matrix):
	for y in range(room_matrix.size()):
		for x in range(room_matrix.size()):
			level_matrix[y + coords.y][x + coords.x] = room_matrix[y][x]
	return level_matrix
