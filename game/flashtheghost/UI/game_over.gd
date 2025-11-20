extends Control


func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_main_menu_pressed() -> void:
	Globals.change_scene(Globals.scene_main_menu)

func _on_restart_pressed() -> void:
	Globals.change_scene(Globals.game_scene)
