extends Node3D

@export var ghost_node : Node2D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var ghost_quit_timer: Timer = $GhostQuit
@onready var ghost_jumpscare_timer: Timer = $GhostJumpscare

@onready var crawl_sound: AudioStreamPlayer3D = $Sound/CrawlSound

var material
var flash : bool = false
var tween : Tween

var speed_default : Array = [6,6]
var movement_speed : Array = speed_default
var ghost_original_position 
var ghost_target_position 

var player

var force_vanish : bool = false
var ghost_quit_tag : String = "DEFAULT"

var ghost_anim : AnimatedSprite2D
var force_death : bool = false

func _ready():
	material = mesh_instance_3d.get_surface_override_material(0)
	player = get_tree().get_first_node_in_group("player")
	await get_tree().process_frame
	_setup_speed()
	set_shader_texture()
	_transition_vanished()
	pause_tween()

func _setup_speed():
	if Globals.days_data.has(Globals.day):
		movement_speed = Globals.days_data[Globals.day].ghost_movement
	pass


func _process(delta: float) -> void:
	if ghost_quit_tag == "DEFAULT":
		move_ghost(delta)
	elif ghost_quit_tag == "QUIT":
		move_ghost_to_original_position(delta)
	else:
		move_to_player(delta)
		
	if global_position.distance_to(player.global_position) > 0.3 or ghost_quit_tag != "JUMPSCARE":
		look_at(player.global_position)

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
	queue_free()

func pause_tween():
	if tween and tween.is_valid() and !force_vanish:
		tween.pause()
		ghost_flash(true)

func resume_tween():
	if tween and tween.is_valid() and !force_vanish:
		tween.play()
		ghost_flash(false)

func ghost_flash(value : bool) -> void:
	if is_instance_valid(ghost_anim):
		ghost_anim.play("default")

func _update_shader_parameter(value: float):
	if value >= 0.5:
		material.set_shader_parameter("edgeColor", Color(1.0, 1.0, 1.0))
	
	material.set_shader_parameter("dissolveSlider", value)
	force_death = true
	# force death XD
	if value >= 0.8:
		remove_entity()

func _setup_path(paths,stand) -> void:
	if !is_instance_valid(paths):
		print("error")
		
	var children = paths.get_children()
	global_position = children[0].global_position
	ghost_target_position = children[1].global_position
	ghost_original_position = global_position
	select_ghost_position(stand)

func _get_speed():
	var speed = randi_range(movement_speed[0],movement_speed[1])
	return speed

#below method is for ghost movements
func move_ghost(delta) -> void:
	if ghost_target_position:
		global_position = global_position.move_toward(ghost_target_position, _get_speed() * delta)

func move_ghost_to_original_position(delta) -> void:
	global_position = global_position.move_toward(ghost_original_position, _get_speed() * delta)
	
	if global_position.distance_to(ghost_original_position) < 0.1:
		force_vanish = true
		tween.play()
	
func move_to_player(delta) -> void:
	var target_position
	if is_instance_valid(player):
		var direction = player.global_position - global_position
		direction.y = 0  
		target_position = global_position + direction.normalized() * (_get_speed() * 10) * delta
		global_position = global_position.move_toward(target_position, (_get_speed() * 13) * delta)
	
	if target_position:
		if global_position.distance_to(target_position) < 0.1:
			player._jump_scare("Margarete")
			remove_entity()
	
func select_ghost_position(ghost_position : String) -> void:
	if !is_instance_valid(ghost_node):
		print("error")
		return
		
	if ghost_node.has_node(ghost_position):
		var children = ghost_node.get_children()
		
		for child in children:
			child.visible = false
		ghost_anim = ghost_node.get_node(ghost_position)
		ghost_node.get_node(ghost_position).visible = true
	
	if "Crawl" in ghost_position:
		crawl_sound.play()
		ghost_jumpscare_timer.start()
		ghost_quit_timer.stop()
		

func _on_area_3d_area_entered(area: Area3D) -> void:
	resume_tween()

func _on_area_3d_area_exited(area: Area3D) -> void:
	if ! force_death:
		pause_tween()

func _on_ghost_quit_timeout() -> void:
	ghost_quit_tag = "QUIT"
	mesh_instance_3d.scale.x = -1

func _on_ghost_jumpscare_timeout() -> void:
	ghost_quit_tag = "JUMPSCARE"
