extends Control

@onready var thumbnail_a: Button = $GalleryContainer/ThumbnailA
@onready var thumbnail_b: Button = $GalleryContainer/ThumbnailB
@onready var thumbnail_c: Button = $GalleryContainer/ThumbnailC
@onready var thumbnail_d: Button = $GalleryContainer/ThumbnailD
@onready var thumbnail_e: Button = $GalleryContainer/ThumbnailE

@onready var thumbnail_a_locked: TextureRect = $GalleryContainer/ThumbnailALocked
@onready var thumbnail_a_locked_2: TextureRect = $GalleryContainer/ThumbnailALocked2
@onready var thumbnail_a_locked_3: TextureRect = $GalleryContainer/ThumbnailALocked3
@onready var thumbnail_a_locked_4: TextureRect = $GalleryContainer/ThumbnailALocked4
@onready var thumbnail_a_locked_5: TextureRect = $GalleryContainer/ThumbnailALocked5

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var lewd_scene: Control = $CanvasLayer/LewdScene

@onready var cover: ColorRect = $Cover

var ls 

func _ready() -> void:
	thumbnail_a.pressed.connect(_on_gallery_pressed.bind(1))
	thumbnail_b.pressed.connect(_on_gallery_pressed.bind(2))
	thumbnail_c.pressed.connect(_on_gallery_pressed.bind(3))
	thumbnail_d.pressed.connect(_on_gallery_pressed.bind(4))
	thumbnail_e.pressed.connect(_on_gallery_pressed.bind(5))
	
func _show(_value):
	if !_value:
		visible = false
		
	else:
		var data = Save.load_game("gallery")
		if data:
			Globals.unlock_gallery = data["unlock_gallery"]
		check_lock()
		visible = true
		

func check_lock():
	var arr = [thumbnail_a_locked,thumbnail_a_locked_2,thumbnail_a_locked_3,thumbnail_a_locked_4,thumbnail_a_locked_5]
	for value in Globals.unlock_gallery:
		arr[value-1].visible = false
	
func _on_gallery_pressed(idx:int):
	if !Globals.unlock_gallery.has(float(idx)):
		return
		
	if Globals.days_data.has(idx):
		var data = Globals.days_data[idx]
		var anim = load(Globals.days_data[idx]["day_end_anim"])
		var a = anim.instantiate()
		a.closing_anim.connect(_on_anim_finished)
		lewd_scene.add_child(a)
		ls = a
		canvas_layer.visible = true
		cover.visible = true

func _on_anim_finished() -> void:
	cover.visible = false
	

func _on_close_ls_pressed() -> void:
	if is_instance_valid(ls):
		canvas_layer.visible = false
		ls.queue_free()
	_on_anim_finished()

func _on_close_pressed() -> void:
	_show(false)
