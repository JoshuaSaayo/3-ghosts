extends Control

@onready var end_credit: Control = $end_credit

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _start_credits() -> void:
	end_credit.visible = false
	await get_tree().create_timer(3.0).timeout
	end_credit.visible = true
