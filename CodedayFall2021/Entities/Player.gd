extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3()
var degree_margin = 30
var last_velocity = Vector3.ONE
# Called when the node enters the scene tree for the first time.
func _ready():#setup
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): #void/loop
	velocity.x = 0
	velocity.z = 0
	#velocity.y -= 10*delta
	
	
	if Input.get_action_strength("s"):
		velocity.z = 100*delta
	if Input.get_action_strength("a"):
		velocity.x = -100*delta
	if Input.get_action_strength("w"):
		velocity.z = -100*delta
	if Input.get_action_strength("d"):
		velocity.x = 100*delta
	#if Input.get_action_strength("ui_select") and $RayCast.is_colliding():
			#velocity.y = 250*delta
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	if (velocity != Vector3.ZERO):
		last_velocity = velocity
	
	if (Input.get_action_strength("hair_blow")):
		
		for e in get_tree().get_nodes_in_group("Enemies"):
			var diff = (e.translation - translation).normalized()
			var enemy_dir_angle = rad2deg(atan2(diff.x, diff.y))
			var player_dir_angle = rad2deg(atan2(last_velocity.normalized().x, last_velocity.normalized().y))
			if (abs(enemy_dir_angle - player_dir_angle) < degree_margin):
				e.player_push(-last_velocity)
	# UH yeah hairblower doesnt WORK?!?!?
		
	
