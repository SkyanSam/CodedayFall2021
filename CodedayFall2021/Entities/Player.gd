extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3()
var degree_margin = 70
var last_velocity = Vector3.ONE
export var speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():#setup
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): #void/loop
	velocity.x = 0
	velocity.z = 0
	#velocity.y -= 10*delta
	
	
	if Input.get_action_strength("s"):
		velocity.z = speed*delta
	if Input.get_action_strength("a"):
		velocity.x = -speed*delta
	if Input.get_action_strength("w"):
		velocity.z = -speed*delta
	if Input.get_action_strength("d"):
		velocity.x = speed*delta
	#if Input.get_action_strength("ui_select") and $RayCast.is_colliding():
			#velocity.y = 250*delta
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	if (velocity != Vector3.ZERO):
		last_velocity = velocity
	
	if (velocity == Vector3.ZERO):
		pass
	else:
		var x_m = 1
		if (velocity.x < 0 || velocity.y > 0):
			x_m = -1
		var basis = Basis()
		basis.x = Vector3(1 * x_m,0,0)
		basis.y = Vector3(0,1,0)
		basis.z = Vector3(0,0,1)
		$MeshInstance.set_transform(basis)
	
	if (Input.is_action_just_pressed("hair_blow")):
		var vect = Vector2()
		vect.angle()
		for e in get_tree().get_nodes_in_group("Enemies"):
			var diff = (e.translation - translation).normalized()
			var diff2d = Vector2(diff.x, diff.z)
			var enemy_dir_angle = rad2deg(diff2d.angle())
			var last_velocity2d = Vector2(last_velocity.x, last_velocity.z)
			var player_dir_angle = rad2deg(last_velocity2d.normalized().angle())
			print("Hair dry with e" + str(enemy_dir_angle) + " and p" + str(player_dir_angle))
			if abs(enemy_dir_angle - player_dir_angle) < degree_margin || abs(enemy_dir_angle - player_dir_angle + 360) < degree_margin || abs(enemy_dir_angle - player_dir_angle - 360) < degree_margin:
				e.player_push(last_velocity)
	# UH yeah hairblower doesnt WORK?!?!?
		
	
