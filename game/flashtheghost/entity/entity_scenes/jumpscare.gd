extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	animated_sprite_2d.animation_finished.connect(_animation_finished)

func _animation_finished():
	Globals.change_scene(Globals.game_scene)
