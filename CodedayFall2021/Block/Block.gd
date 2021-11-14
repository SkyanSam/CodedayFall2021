tool

extends StaticBody


export (Texture) var left_wall_texture
export (Texture) var right_wall_texture
export (Texture) var top_wall_texture
var material = preload("res://Block/spatialmaterial.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left_mat = SpatialMaterial.new()
	left_mat.albedo_texture = left_wall_texture
	$LeftFace.material_override = left_mat
	var right_mat = SpatialMaterial.new() 
	right_mat.albedo_texture = right_wall_texture
	$RightFace.material_override = right_mat
	var top_mat = SpatialMaterial.new()
	top_mat.albedo_texture = top_wall_texture
	$TopFace.material_override = top_mat
