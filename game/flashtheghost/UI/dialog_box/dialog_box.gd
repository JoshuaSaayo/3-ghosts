extends Control

# Signal to notify when ALL dialog is finished
signal all_dialog_finished
signal _dialog_ready

@onready var character_name: Label = $CharacterName
@onready var label: Label = $Label
@onready var next: Button = $Next
@onready var skip: Button = $Skip

# Current dialog tracking
var current_dialog_key: String = ""
var current_dialog_index: int = 0
var current_dialog_array: Array = []
var dialog_data: Dictionary = {}
var dialog_keys: Array = []
var current_key_index: int = 0

var d_manager
var time 

func _ready():
	d_manager = dialog_manager.new()
	# Connect button signals
	next.pressed.connect(_on_next_pressed)
	skip.pressed.connect(_on_skip_pressed)
	
	# Hide the dialog box initially
	hide_dialog()
	emit_signal("_dialog_ready")

func _start_dialog(_time : String):
	time = _time
	set_dialog_data(d_manager._get_dialog(_time))

# Method to receive dialog data from external source
func set_dialog_data(new_dialog_data: Dictionary):
	dialog_data = new_dialog_data
	dialog_keys = dialog_data.keys()
	
	if not dialog_data.is_empty():
		start_next_dialog_sequence()

func start_next_dialog_sequence():
	if current_key_index < dialog_keys.size():
		current_dialog_key = dialog_keys[current_key_index]
		current_dialog_array = dialog_data[current_dialog_key]
		current_dialog_index = 0
		
		# Show the dialog box and display first line
		show()
		display_current_text()
		update_button_states()
	else:
		# All dialog sequences are complete
		_on_all_dialog_finished()

func display_current_text():
	if current_dialog_index < current_dialog_array.size():
		label.text = current_dialog_array[current_dialog_index]
		
		# Extract character name from dialog key if format is "key||name"
		if "||" in current_dialog_key:
			var parts = current_dialog_key.split("||")
			if parts.size() >= 2:
				character_name.text = parts[1]
		else:
			character_name.text = ""  # Clear if no character name
	else:
		# End of current dialog sequence, move to next one
		current_key_index += 1
		start_next_dialog_sequence()

func _on_next_pressed():
	current_dialog_index += 1
	display_current_text()
	update_button_states()

func _on_skip_pressed():
	_on_all_dialog_finished()

func update_button_states():
	# Disable Next button if we're at the last line of the last sequence
	if current_dialog_index >= current_dialog_array.size() and current_key_index >= dialog_keys.size():
		next.disabled = true
		_on_all_dialog_finished()
	else:
		next.disabled = false

func hide_dialog():
	hide()
	current_dialog_key = ""
	current_dialog_index = 0
	current_dialog_array = []
	current_key_index = 0
	dialog_keys = []
	character_name.text = ""

# Public method to check if dialog is currently active
func is_dialog_active() -> bool:
	return visible



func _on_all_dialog_finished():
	emit_signal("all_dialog_finished",time)
	hide_dialog()
