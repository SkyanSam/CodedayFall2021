extends Node

export var tilemap_csv_filename = "res://Tilemap/tilemap.txt" #= preload("res://Tilemap/tilemap.csv")
export var blocks = []
export var preloaded_blocks = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for b in blocks:
		preloaded_blocks.append(load(b))
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

	for y in height:
		for x in width:
			if (int(matrix[y][x]) >= 0):
				var block : Spatial = preloaded_blocks[matrix[y][x]].instance()
				block.translation = Vector3(x, 0, y)
				add_child(block)
	print(str(result.size()) + "," + str(result[0].split(',').size()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_map(w, h):
	var map = []

	for x in range(w):
		var col = []
		col.resize(h)
		map.append(col)

	return map
