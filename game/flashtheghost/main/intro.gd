extends Control

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $Anim


func _ready() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout

	anim.animation_finished.connect(_animation_finished)
	
	label.text = "NIGHT "+ str(Globals.day) +"!"
	anim.play("play")

func _animation_finished(anim_name):
	get_tree().paused = false
