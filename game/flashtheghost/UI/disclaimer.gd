extends Control

func _ready() -> void:
	$Prompt.setup("",
	"It features intense psychological horror, sudden jump scares, flashing lights, graphic depictions, strong language, and sexual themes.",
	" I ACCEPT",
	" I MUST LEAVE"
	)


func _on_prompt_prompt_response(code: String, result: bool) -> void:
	if code == "":
		if result:
			Globals.change_scene(Globals.scene_main_menu)
		else:
			get_tree().quit()
