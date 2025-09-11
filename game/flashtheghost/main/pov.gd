extends Control

@onready var battery: ProgressBar = $Battery

func _process(delta: float) -> void:
	display_battery()

func display_battery() -> void:
	if Globals.flash_ligt_life > -1:
		battery.value = Globals.flash_ligt_life
