extends Control

@onready var lewd_scene_anim: Control = $LewdSceneAnim
@onready var anim: AnimationPlayer = $Anim
@onready var label: Label = $Label

@onready var dialog_box: Control = $DialogBox
@onready var pause: Control = $"../Pause"

var selected_tscn
var one_time = false

func _ready() -> void:
	label.text = "NIGHT "+ str(Globals.day) +" COMPLETED"
	selected_tscn = Globals.days_data[Globals.day]["day_end_anim"]
	
func _show(value):
	pause.disabled = true
	_show_pov(false)
	get_tree().paused = true
	anim.play("open")

func _show_pov(_value):
	var pov = get_tree().get_first_node_in_group("POV")
	if is_instance_valid(pov):
		pov.visible = _value

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
	var data 
	
	if one_time:
		return
	one_time = true
	
	if !Globals.unlock_gallery.has(Globals.day):
		Globals.unlock_gallery.append(Globals.day)
		data = {"unlock_gallery": Globals.unlock_gallery}
		Save.save_game(data,"gallery")
	
	print("Globals.day: ", Globals.day)
	if Globals.day >= 5:
		Globals.game_finished = true
		Globals.change_scene(Globals.scene_main_menu)
		return
	
	Globals.day = clamp(Globals.day + 1, 1 , Globals.max_day)
	Globals.change_scene(Globals.game_scene)

func _start_dialog(time : String):
	dialog_box._start_dialog(time)

func _on_dialog_box_all_dialog_finished(time : String = "post") -> void:
	instantiate_anim()
