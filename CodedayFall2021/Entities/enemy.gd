extends KinematicBody

#var path = []
#var path_node = 0
export var speed = 10
export var max_distance = 5
#onready var nav = get_parent()
#onready var player = $"../../Player"
var player_push_is = false
var player_push_vel = Vector2()

func _ready():
	pass 
func pass_physics_process(delta):
		#if path_node < path.size():
			#var direction =(path[path_node] - global_transform.origin)
			#if direction.length() < 1:
				#path_node == 1
			#else:
				#move_and_slide(direction.normalized * speed, Vector3.UP)
#func move_to(target_pos):
	#path = nav.get_simple_path(global_transform.origin, target_pos)
	#path_node = 0
	pass

func _process(delta):
	var distance = Global.player.translation - translation
	if (distance.length() < max_distance):
		if (player_push_is == false):
			move_and_slide( (Global.player.translation - translation).normalized() * speed * delta )
	
	if (player_push_is):
		move_and_slide(player_push_vel * speed * delta)
		
func player_push(vel):
	player_push_vel = vel
	player_push_is = true
	yield(get_tree().create_timer(1),"timeout")
	player_push_is = false
