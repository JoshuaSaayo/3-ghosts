extends Control

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $Anim
@onready var dialog_box: Control = $"../DialogBox"


func _ready() -> void:
	anim.animation_finished.connect(_animation_finished)
	get_tree().paused = true
	
func _start():
	label.text = "NIGHT "+ str(Globals.day) +"!"
	anim.play("play")

func _animation_finished(anim_name):
	get_tree().paused = false

func _on_dialog_box__dialog_ready() -> void:
	dialog_box._start_dialog("pre")

func _on_dialog_box_all_dialog_finished(_time) -> void:
	var t = _time
	_start()
