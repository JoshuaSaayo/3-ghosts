extends Node

signal empty_battery

var scene_main_menu = load("res://UI/menu.tscn")
var game_scene = load("res://main/map.tscn")
var game_over_scene = load("res://UI/game_over.tscn")


@onready var anim: AnimationPlayer = $Anim

var selected_scene

var flash_ligt_life : int = 100
var flash_ligt_max_life: int = 100

var day : int = 1
var max_day : int = 5

var game_finished : bool = false

var unlock_gallery : Array = [1,2,3,4,5]

var days_data = {
	1: {
		"available_ghosts": ["Yuna"],  # Array of ghosts
		"day_end_anim":"res://lewds/lewdscenes/yuna_1_ls.tscn" ,  # Filesystem path
		"sound_key" : "yuna1",
		"day_time_limit": 240,  # int - seconds
		"batt_life": 100,
		"ghost_movement": [6,8],
		
	},
	2: {
		"available_ghosts": ["Yuna"],
		"day_end_anim": "res://lewds/lewdscenes/yuna_2_ls.tscn",
		"sound_key" : "yuna2",
		"day_time_limit": 240,
		"batt_life": 90,
		"ghost_movement": [6,10],
		
	},
	3: {
		"available_ghosts": ["Yuna","Nino"],
		"day_end_anim": "res://lewds/lewdscenes/nino_1_ls.tscn",
		"sound_key" : "nino1",
		"day_time_limit": 240,
		"batt_life": 80,
		"ghost_movement": [6,12],
		
	},
	4: {
		"available_ghosts": ["Yuna","Nino"],
		"day_end_anim": "res://lewds/lewdscenes/nino_2_ls.tscn",
		"sound_key" : "nino2",
		"day_time_limit": 240,
		"batt_life": 70,
		"ghost_movement": [6,14],
		
	},
	5: {
		"available_ghosts": ["Yuna","Nino","Margarete"],
		"day_end_anim": "res://lewds/lewdscenes/margarete_1_ls.tscn",
		"sound_key" : "margarete1",
		"day_time_limit": 240,
		"batt_life": 60,
		"ghost_movement": [6,15],
		
	}
}

func _save_data():
	var data : Dictionary = {
		"day":day
	}
	Save.save_game(data,"game_data")

func get_loaded_data():
	var data : Dictionary = Save.load_game("game_data")
	if data.is_empty():
		push_error("missing save")
	day = data["day"]
	
func set_flash_ligt_life(value : int) -> void:
	flash_ligt_life = value
	
	if flash_ligt_life <= 0:
		emit_signal("empty_battery")

func change_scene_anim():
	var _scene = selected_scene
	get_tree().change_scene_to_packed(_scene)

func change_scene(scene):
	selected_scene = scene
	anim.play("show")

func game_end():
	change_scene(game_over_scene)

func game_pause(value : bool) -> void:
	get_tree().paused = value

func _reset_game():
	day = 1
	flash_ligt_life =  flash_ligt_max_life
