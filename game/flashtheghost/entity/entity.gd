extends Node3D

@export var ghost_node : Node2D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $SubViewport

var material
var flash : bool = false
var tween : Tween

var speed_default : int = 10
var movement_speed : int = speed_default
var ghost_target_position 

func _ready():
	material = mesh_instance_3d.get_surface_override_material(0)
	
	await get_tree().process_frame
	
	set_shader_texture()
	_transition_vanished()
	pause_tween()


func _process(delta: float) -> void:
	move_ghost(delta)

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

func _setup_path(paths) -> void:
	if !is_instance_valid(paths):
		print("error")
		
	var children = paths.get_children()
	global_position = children[0].global_position
	ghost_target_position = children[1].global_position

#below method is for ghost movements
func move_ghost(delta) -> void:
	if ghost_target_position:
		global_position = global_position.move_toward(ghost_target_position, movement_speed * delta)

#below method is not use
func select_ghost_position(ghost_position : String) -> void:
	if !is_instance_valid(ghost_node):
		print("error")
		return
	if ghost_node.has_node(ghost_position):
		var children = ghost_node.get_children()
		
		for child in children:
			child.visible = false
		
		ghost_node.get_node(ghost_position).visible = true
		

func _on_area_3d_area_entered(area: Area3D) -> void:
	resume_tween()

func _on_area_3d_area_exited(area: Area3D) -> void:
	pause_tween()
