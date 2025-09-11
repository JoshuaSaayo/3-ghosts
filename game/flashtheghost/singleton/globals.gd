extends Node

signal empty_battery

var flash_ligt_life : int = 100
var flash_ligt_max_life: int = 100


func set_flash_ligt_life(value : int) -> void:
	flash_ligt_life = value
	
	if flash_ligt_life <= 0:
		emit_signal("empty_battery")
