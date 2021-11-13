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
	var left_mat = material.duplicate()
	left_mat.TEXTURE_ALBEDO = left_wall_texture
	var right_mat = material.duplicate()
	right_mat.TEXTURE_ALBEDO = right_wall_texture
	var top_mat = material.duplicate()
	top_mat.TEXTURE_ALBEDO = top_wall_texture
