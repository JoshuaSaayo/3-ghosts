extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
var material

func _ready():
	material = mesh_instance_3d.get_surface_override_material(0)
	
	await get_tree().create_timer(1.0).timeout

	_transition_vanished()

func _transition_vanished() -> void:
	if material:
		var tween = create_tween()
		tween.tween_method(_update_shader_parameter, -0.1, 1.0, 5.0)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _update_shader_parameter(value: float):
	print(value)
	material.set_shader_parameter("transition_out", value)
