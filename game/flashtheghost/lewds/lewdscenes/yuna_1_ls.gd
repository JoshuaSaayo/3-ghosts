extends Node2D

@onready var lewdscenes: AnimationPlayer = $Node2D/lewdscenes
@onready var yuna_moans: AudioStreamPlayer = $Node2D/YunaMoans


var sounds: Array[AudioStream] = [
	preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan1.wav"),
	preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan2.wav"),
	preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan3.wav")
]

func _ready():
	lewdscenes.play("lewdscene")

func _process(delta):
	# Detect when animation loops back to start
	if lewdscenes.current_animation_position < 0.05 and not yuna_moans.playing:
		play_random_sound()

func play_random_sound():
	var random_sound = sounds.pick_random()
	yuna_moans.stream = random_sound
	yuna_moans.play()
