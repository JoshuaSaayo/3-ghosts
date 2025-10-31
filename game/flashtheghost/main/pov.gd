extends Control

@onready var battery_bar: TextureProgressBar = $BatteryBar
@onready var battery_percentage: Label = $BatteryPercentage
@onready var night_counts: Label = $NightCounts

func _ready() -> void:
	night_counts.text = "Night Counts: "+ str(Globals.day)
	battery_bar.value = 0
	battery_percentage.text = "O%"
func _process(delta: float) -> void:
	display_battery()
	setup_flash_light()

func display_battery() -> void:
	if Globals.flash_ligt_life > -1:
		battery_bar.value = Globals.flash_ligt_life
		battery_percentage.text = str(Globals.flash_ligt_life)+"%"

func setup_flash_light():
	if Globals.days_data.has(Globals.day):
		battery_bar.max_value = Globals.days_data[Globals.day].batt_life
		
