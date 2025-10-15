extends Node2D

@onready var lewdscenes: AnimationPlayer = $Node2D/lewdscenes
@onready var margarete_moans: AudioStreamPlayer = $Node2D/MargareteMoans




var sounds: Array[AudioStream] = [
	preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan1.wav"),
	preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan2.wav"),
	preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan3.wav")
]

func _ready():
	lewdscenes.play("lewdscene")

func _process(delta):
	# Detect when animation loops back to start
	if lewdscenes.current_animation_position < 0.05 and not margarete_moans.playing:
		play_random_sound()

func play_random_sound():
	var random_sound = sounds.pick_random()
	margarete_moans.stream = random_sound
	margarete_moans.play()
