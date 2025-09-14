extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $SubViewport

var material
var flash : bool = false
var tween : Tween


func _ready():
	material = mesh_instance_3d.get_surface_override_material(0)
	
	await get_tree().process_frame
	
	set_shader_texture()
	_transition_vanished()
	pause_tween()



func set_shader_texture() -> void:
	if material and sub_viewport:
		var viewport_texture = sub_viewport.get_texture()
		if viewport_texture:
			print("SubViewport texture: ", viewport_texture)
			# Make sure this parameter name matches your shader!
			material.set_shader_parameter("base_color_texture", viewport_texture)
		else:
			push_error("SubViewport texture is null!")

func _transition_vanished() -> void:
	if material:
		tween = create_tween()
		tween.tween_method(_update_shader_parameter, -0.1, 1.5, 5.0)\
			.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.finished.connect(remove_entity)

func remove_entity() -> void:
	pass

func pause_tween():
	if tween and tween.is_valid():
		tween.pause()
		print("Tween paused")

func resume_tween():
	if tween and tween.is_valid():
		tween.play()
		print("Tween resumed")

func _update_shader_parameter(value: float):
	if value >= 0.5:
		material.set_shader_parameter("edgeColor", Color(1.0, 1.0, 1.0))
	
	material.set_shader_parameter("dissolveSlider", value)


func _on_area_3d_area_entered(area: Area3D) -> void:
	resume_tween()

func _on_area_3d_area_exited(area: Area3D) -> void:
	pause_tween()
