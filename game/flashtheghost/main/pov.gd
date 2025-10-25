extends Control

@onready var battery: ProgressBar = $Battery

func _process(delta: float) -> void:
	display_battery()
	setup_flash_light()

func display_battery() -> void:
	if Globals.flash_ligt_life > -1:
		battery.value = Globals.flash_ligt_life

func setup_flash_light():
	if Globals.days_data.has(Globals.day):
		battery.max_value = Globals.days_data[Globals.day].batt_life
		
