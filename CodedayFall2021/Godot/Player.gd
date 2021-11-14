extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():#setup
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): #void/loop
	velocity.x = 0
	velocity.z = 0
	velocity.y -= 10*delta
	
	
	if Input.get_action_strength("s"):
		velocity.z = 100*delta
	if Input.get_action_strength("a"):
		velocity.x = -100*delta
	if Input.get_action_strength("w"):
		velocity.z = -100*delta
	if Input.get_action_strength("d"):
		velocity.x = 100*delta
	if Input.get_action_strength("ui_select") and $RayCast.is_colliding():
			velocity.y = 250*delta
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	
