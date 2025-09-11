extends CharacterBody3D

@export var move_speed = 1000
@export var sprint_speed = 1250
@export var jump_force = 2.0
@export var mouse_sensitivity = 0.2
@export var deceleration = 15.0
@export var max_pitch = 20.0 # degrees

@onready var walk_sound: AudioStreamPlayer3D = $Walk
@onready var flashlight_hit_box: Area3D = $CameraPivot/Camera3D/Flaslight/FlashlightHitBox
@onready var flaslight: SpotLight3D = $CameraPivot/Camera3D/Flaslight
@onready var battery_life_timer: Timer = %BatteryLifeTimer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_speed = 0.0
var target_speed = 0.0
var direction = Vector3.ZERO
var force_step : bool = false

#detection
var detected_object : Array = []
var current_object  : Array = []


# Camera nodes
@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

func _ready():
	flash_light_toggle(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	connect_globals_signal()

func connect_globals_signal() -> void:
	Globals.empty_battery.connect(flash_light_toggle.bind(false))

func _input(event):
	flash_light_control()
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal rotation (left/right)
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotation.y = clamp(rotation.y, deg_to_rad(0), deg_to_rad(90))
		
		# Vertical rotation (up/down) - on camera pivot
		camera_pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		
	if Input.is_action_just_pressed("alt"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func flash_light_life() -> void:
	if flaslight.visible and Globals.flash_ligt_life > 0:
		Globals.set_flash_ligt_life(Globals.flash_ligt_life - 1)

func flash_light_control() -> void:
	if Input.is_action_just_pressed("flash_light"):
		flash_light_toggle()

func flash_light_toggle(force = null) -> void:
	var visibility : bool = !flaslight.visible
	
	if force != null:
		visibility = force
	
	flaslight.visible = visibility
	
	if visibility:
		battery_life_timer.start()
	else:
		battery_life_timer.stop()

func play_walk(play) -> void:
	if play and !walk_sound.playing:
		walk_sound.play()
		return
	elif !play:
		walk_sound.stop()
		return

func _on_battery_life_timer_timeout() -> void:
	flash_light_life()
