extends KinematicBody

var path = []
var path_node = 0
var speed = 10
onready var nav = get_parent()
onready var player = $"../../Player"

func _ready():
	pass 
func pass_physics_process(delta):
		if path_node < path.size():
			var direction =(path[path_node] - global_transform.origin)
			if direction.length() < 1:
				path_node == 1
			else:
				move_and_slide(direction.normalized * speed, Vector3.UP)
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0
