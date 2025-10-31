extends Control

@onready var new_game: Button = $NewGame
@onready var load_game: Button = $LoadGame
@onready var setting: Button = $Setting
@onready var quit: Button = $Quit
@onready var gallery: Button = $Gallery

@onready var setting_tab: Control = $SettingTab
@onready var prompt: Control = $Prompt
@onready var gallery_2: Control = $Gallery2


func _ready():
	_check_load()
	
	new_game.pressed.connect(_on_new_game_pressed)
	load_game.pressed.connect(_on_load_game_pressed)
	setting.pressed.connect(_on_setting_pressed)
	quit.pressed.connect(_on_quit_pressed)
	gallery.pressed.connect(_on_gallery_pressed)
	
func _check_load():
	var valid : Dictionary = Save.load_game("1")
	load_game.disabled = valid.is_empty()
	return valid.is_empty()
	
func _on_new_game_pressed():
	if !_check_load():
		prompt.setup("new_game","You have existing code, Overwrite?", "Yes","No")
	else:
		_new_game()

func _on_load_game_pressed():
	_load_game()

func _on_setting_pressed():
	setting_tab._show(true)

func _on_quit_pressed():
	get_tree().quit()

func _new_game():
	Globals._save_data()
	Globals.change_scene(Globals.game_scene)

func _load_game():
	Globals.get_loaded_data()
	Globals.change_scene(Globals.game_scene)

func _on_gallery_pressed():
	gallery_2._show(true)

func _on_prompt_prompt_response(code: String, result) -> void:
	if code == "new_game":
		if result:
			_new_game()


func _on_instruction_pressed() -> void:
	var controls_short = """MOUSE: Move screen | F: Flashlight | CTRL: Crouch/Stand
	ALT: View cursor
	Shine flashlight on ghosts to banish them"""
	prompt.setup("instruction",controls_short, "Yes","No","Close")
