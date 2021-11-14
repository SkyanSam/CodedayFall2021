extends Area

export var min_break_delay = 1
export var max_break_delay = 5
export var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Fold_body_entered(body):
	var body_node : Spatial = body
	if (body_node.is_in_group("Blocks") && enabled):
		body_node.break(rand_range(min_break_delay, max_break_delay))
