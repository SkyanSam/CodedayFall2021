extends Node

export var tilemap_csv_filename = "res://Tilemap/tilemap.csv" #= preload("res://Tilemap/tilemap.csv")
export var blocks = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var result = []
	var file = File.new()
	if file.open(tilemap_csv_filename, file.READ) != 0:
		print("opened file")
		file.get_line()
		#get_csv_line ( String delim=”,” ) 
		while not file.eof_reached():
			var line = file.get_line()
			result.append(line)
		file.close()
	var array_3d = []
	for r in result:
		array_3d.append(r.split(','))
	
	for y in result:
		for x in y:
			if (array_3d[y][x] >= 0):
				var block = blocks[array_3d[y][x]].instance()
				block.global_position = Vector3(x, 0, y)
					


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
