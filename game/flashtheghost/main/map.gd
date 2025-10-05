extends Node3D

@onready var door_path: Node3D = $Paths/DoorPath
@onready var table_path: Node3D = $Paths/TablePath
@onready var window_path: Node3D = $Paths/WindowPath
@onready var bed_path: Node3D = $Paths/BedPath

@onready var margarete: Node3D = $Entity/Margarete


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
	
}

func _ready() -> void:
	randomize()
	

func get_rndm_ghost():
	var keys = ghost_map.keys()
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
		print("error1")
		return
		
	var _tscn = load(tscn)
	var instance = _tscn.instantiate()
	
	parent.add_child(instance)
	
	if instance.has_method("_setup_path"):
		instance._setup_path(path,stand)


func _on_spawn_timeout() -> void:
	spawn_ghost()
