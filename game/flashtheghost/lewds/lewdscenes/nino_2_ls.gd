extends Node2D

@onready var lewdscenes: AnimationPlayer = $Node2D/lewdscenes
@onready var nino_moans: AudioStreamPlayer = $Node2D/NinoMoans



var sounds: Array[AudioStream] = [
	preload("res://lewds/lewd_assets/nino2_ls/audio/nino_moan1.mp3"),
	preload("res://lewds/lewd_assets/nino2_ls/audio/nino_moan2.mp3")
]

func _ready():
	lewdscenes.play("lewdscene")

func _process(delta):
	# Detect when animation loops back to start
	if lewdscenes.current_animation_position < 0.05 and not nino_moans.playing:
		play_random_sound()

func play_random_sound():
	var random_sound = sounds.pick_random()
	nino_moans.stream = random_sound
	nino_moans.play()
