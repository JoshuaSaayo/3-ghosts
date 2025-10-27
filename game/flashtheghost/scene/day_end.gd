extends Control

@onready var lewd_scene_anim: Control = $LewdSceneAnim
@onready var anim: AnimationPlayer = $Anim
@onready var label: Label = $Label

@onready var dialog_box: Control = $DialogBox

var selected_tscn
var one_time = false

func _ready() -> void:
	label.text = "NIGHT "+ str(Globals.day) +" COMPLETED"
	selected_tscn = Globals.days_data[Globals.day]["day_end_anim"]
	
func _show(value):
	get_tree().paused = true
	anim.play("open")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	pass

func instantiate_anim():
	if not FileAccess.file_exists(selected_tscn):
		print("MISSING: ", selected_tscn)
		return
	else:
		print("OK: ", selected_tscn)

	var _selected_tscn = load(selected_tscn)
	var ls = _selected_tscn.instantiate()
	ls.closing_anim.connect(_closing_anim)
	lewd_scene_anim.add_child(ls)

func _closing_anim():
	Globals.day = clamp(Globals.day + 1, 1 , Globals.max_day)
	Globals.change_scene(Globals.game_scene)

func _start_dialog(time : String):
	dialog_box._start_dialog(time)

func _on_dialog_box_all_dialog_finished(time : String = "post") -> void:
	instantiate_anim()
