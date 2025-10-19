extends Node2D

signal closing_anim

@onready var lewdscenes: AnimationPlayer = $Node2D/lewdscenes
@onready var moan: AudioStreamPlayer

var sounds: Dictionary = {
	"margarete1": [
		preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan1.wav"),
		preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan2.wav"),
		preload("res://lewds/lewd_assets/margarete1_ls/audio/margarete_moan3.wav")
	],
	"nino1": [
		preload("res://lewds/lewd_assets/nino1_ls/audio/nino_moan1.wav"),
		preload("res://lewds/lewd_assets/nino1_ls/audio/nino_moan2.wav"),
		preload("res://lewds/lewd_assets/nino1_ls/audio/nino_moan3.wav")
	],
	"nino2": [
		preload("res://lewds/lewd_assets/nino2_ls/audio/nino_moan1.mp3"),
		preload("res://lewds/lewd_assets/nino2_ls/audio/nino_moan2.mp3")
	],
	"yuna1": [
		preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan1.wav"),
		preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan2.wav"),
		preload("res://lewds/lewd_assets/yuna1_ls/audio/yuna_moan3.wav")
	],
	"yuna2": [
		preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck2.wav"),
		preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck3.wav"),
		preload("res://lewds/lewd_assets/yuna2_ls/audio/yuna_suck.wav")
	]
}

func _ready():
	moan = get_node_or_null("Node2D/Moan")
	
	
	lewdscenes.play("lewdscene")
	start_timer()
	lewdscenes.animation_finished.connect(_on_animation_finished)

func _process(delta):
	# Detect when animation loops back to start
	if !is_instance_valid(moan):
		return
	
	if lewdscenes.current_animation_position < 0.05 and not moan.playing:
		play_random_sound()

func play_random_sound():
	var sound_key = Globals.days_data[Globals.day]["sound_key"]
	var random_sound = sounds[sound_key].pick_random()
	moan.stream = random_sound
	moan.play()

func start_timer(duration = 5):
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_on_animation_finished.bind("lewdscene"))

func _on_animation_finished (anim_name):
	if anim_name == "lewdscene":
		lewdscenes.play("climax")
	
	if anim_name == "climax":
		emit_signal("closing_anim")
