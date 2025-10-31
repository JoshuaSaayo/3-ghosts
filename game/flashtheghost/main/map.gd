extends Node3D
@onready var day_end: Control = $DayEnd

@onready var door_path: Node3D = $Paths/DoorPath
@onready var table_path: Node3D = $Paths/TablePath
@onready var window_path: Node3D = $Paths/WindowPath
@onready var bed_path: Node3D = $Paths/BedPath
@onready var margarete: Node3D = $Entity/Margarete
@onready var yuna: Node3D = $Entity/Yuna
@onready var nino: Node3D = $Entity/Nino
@onready var player: CharacterBody3D = %Player
@onready var player_anim: AnimationPlayer = %PlayerAnim
@onready var spawn: Timer = $Timer/Spawn

@onready var end_day: Timer = $Timer/EndDay


@onready var ghost_map : Dictionary = {
	"margarete_stand" : {
		"path": door_path, 
		"spawn_node": margarete , 
		"char_position": "Stand" , 
		"instance" : "res://entity/margarete.tscn"},
		
		
	"margarete_crawl" : {
		"path": table_path, 
		"spawn_node": margarete , 
		"char_position": "Crawl" , 
		"instance" : "res://entity/margarete.tscn"},
		
	"margarete_crawl_bed" : {
		"path": bed_path, 
		"spawn_node": margarete , 
		"char_position": "CrawlBed" , 
		"instance" : "res://entity/margarete.tscn"},
	
	"margarete_window" : {
		"path": window_path, 
		"spawn_node": margarete , 
		"char_position": "Window" , 
		"instance" : "res://entity/margarete.tscn"},
	
	"yuna_stand" : {
		"path": door_path, 
		"spawn_node": yuna , 
		"char_position": "Stand" , 
		"instance" : "res://entity/yuna.tscn"},
		
	"yuna_crawl" : {
		"path": table_path, 
		"spawn_node": yuna , 
		"char_position": "Crawl" , 
		"instance" : "res://entity/yuna.tscn"},
		
	"nino_crawl_bed" : {
		"path": bed_path, 
		"spawn_node": nino , 
		"char_position": "CrawlBed" , 
		"instance" : "res://entity/nino.tscn"},
	
	"nino_window" : {
		"path": window_path, 
		"spawn_node": nino , 
		"char_position": "Window" , 
		"instance" : "res://entity/nino.tscn"},
	
}

var char_pos : Dictionary = {
	"stand" : Vector3(41.0, 20.0,11.0),
	"crouch" : Vector3(41.0,10.0,11.0),
}

var previous_path 

func _ready() -> void:
	randomize()
	setup_end_timer()

func setup_end_timer():
	if Globals.days_data.has(Globals.day):
		end_day.wait_time = Globals.days_data[Globals.day].day_time_limit
		end_day.start()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("crouch"):
			for key in char_pos.keys():
				if char_pos[key] != player.global_position:
					player.global_position = char_pos[key]
					if !player_anim.is_playing():
						player_anim.play(key)
					return

func get_available_ghost(day): 
	var keys = ghost_map.keys()
	var selected_ghost = Globals.days_data[day].available_ghosts
	var selected_keys : Array
	for key in keys:
		if ghost_map[key].spawn_node.name in selected_ghost:
			selected_keys.append(key)
	return selected_keys

func get_rndm_ghost():
	var crnt_day = Globals.day
	var keys = get_available_ghost(crnt_day)
	print(keys)
	if keys.is_empty():
		print("error")
		
	keys.shuffle()
	var rndm_idx = keys.pick_random()
	
	return ghost_map[rndm_idx]

func spawn_ghost() -> void:
	var dict = get_rndm_ghost()
	var parent = dict.spawn_node
	var tscn = dict.instance
	var path = dict.path
	var stand = dict.char_position
	
	if parent.get_children().size() >= 1:
		return
	
	if previous_path == path:
		print("error3")
		return
	
	previous_path = path
	
	var _tscn = load(tscn)
	var instance = _tscn.instantiate()
	
	parent.add_child(instance)
	
	if instance.has_method("_setup_path"):
		instance._setup_path(path,stand)

func stand_crawl() -> void:
	pass

func _on_spawn_timeout() -> void:
	spawn_ghost()
	spawn.wait_time = randi_range(5,10)

func _on_end_day_timeout() -> void:
	day_end._show(true)

func _on_next_night_pressed() -> void:
	day_end._show(true)
