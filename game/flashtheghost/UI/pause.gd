extends Control

@onready var prompt: Control = $Prompt
@onready var black_background: ColorRect = $BlackBackground
@onready var resume: Button = $PauseMenu/Panel/Resume
@onready var restart: Button = $PauseMenu/Panel/Restart
@onready var main_menu: Button = $"PauseMenu/Panel/Main menu"

var disabled :bool = true

var game_paused: bool = false

func _ready():
	# Connect pause menu buttons
	resume.pressed.connect(_on_resume_pressed)
	restart.pressed.connect(_on_restart_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	
	# Connect prompt signal
	prompt.prompt_response.connect(_on_prompt_response)
	
	# Hide UI elements initially
	visible = false
	prompt.visible = false
	black_background.visible = false

func _input(event):
	if disabled:
		return
	if event.is_action_pressed("pause"):  # ESC key
		toggle_pause()

func toggle_pause():
	game_paused = !game_paused
	visible = game_paused
	black_background.visible = game_paused
	get_tree().paused = game_paused
	
	# Show/hide mouse cursor
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if game_paused else Input.MOUSE_MODE_CAPTURED

func show_pause():
	game_paused = true
	visible = true
	black_background.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_pause():
	game_paused = false
	visible = false
	black_background.visible = false
	prompt.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed():
	toggle_pause()

func _on_restart_pressed():
	# Hide pause menu and show prompt
	$PauseMenu.visible = false
	prompt.setup("restart", "Are you sure you want to restart?", "Yes", "No")

func _on_main_menu_pressed():
	# Hide pause menu and show prompt
	$PauseMenu.visible = false
	prompt.setup("main_menu", "Return to main menu? Unsaved progress will be lost.", "Yes", "No")

func _on_prompt_response(code: String, result: bool):
	# Hide everything first
	prompt.visible = false
	black_background.visible = false
	$PauseMenu.visible = false
	
	if result:  # User clicked Yes
		match code:
			"restart":
				get_tree().paused = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().reload_current_scene()
			"main_menu":
				get_tree().paused = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				Globals.change_scene(Globals.scene_main_menu)
	else:  # User clicked No
		# Just keep everything hidden, don't show pause menu again
		# The pause menu will show again when user presses pause button
		pass
