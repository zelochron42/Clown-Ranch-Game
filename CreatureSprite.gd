extends Node

var parent : Sprite2D
@export var animate_speed : float = 1
@export var direction : int = 0
var tilemap_object
var time_offset : float
@export var sprite_size : Vector2i
@export var sprite_cells : Vector2i = Vector2i(1, 1)

func _ready():
	parent = get_parent()
	tilemap_object = $"../TilemapObject"
	time_offset = randf()
	tilemap_object.movedirection.connect(_change_direction)

func _process(delta):
	var rx : int = 0
	var ry : int = 0
	match direction:
		0: #down
			ry = 0
		1: #left
			ry = sprite_size.y*2
			parent.flip_h = true
		2: #up
			ry = sprite_size.y
		3: # right
			ry = sprite_size.y*2
			parent.flip_h = false
		_:
			printerr("Direction outside of bounds")
	if tilemap_object.is_tweening:
		var time : int = int((Time.get_unix_time_from_system() + time_offset) * animate_speed)
		rx = (time % sprite_cells.x) * sprite_size.x #this is some funky voodoo code right here
	parent.region_rect.position = Vector2(rx, ry)
	
func _change_direction(new_dir : int):
	direction = new_dir
