extends Node2D

@onready var lewdscenes: AnimationPlayer = $Node2D/lewdscenes
@onready var yuna_suck: AudioStreamPlayer = $Node2D/YunaSuck

var sounds: Array[AudioStream] = [
	preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck2.wav"),
	preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck3.wav"),
	preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck.wav")
]

func _ready():
	lewdscenes.play("lewdscene")

func _process(delta):
	# Detect when animation loops back to start
	if lewdscenes.current_animation_position < 0.05 and not yuna_suck.playing:
		play_random_sound()

func play_random_sound():
	var random_sound = sounds.pick_random()
	yuna_suck.stream = random_sound
	yuna_suck.play()
