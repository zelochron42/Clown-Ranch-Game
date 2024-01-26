extends Node

@export var sheep_count : int
var sheep = preload("res://sheep.tscn")
var clown = preload("res://angry_clown.tscn")
var timer : Timer
@export var sheep_zone : Rect2i

func _ready():
	timer = $ClownReset
	await get_tree().create_timer(0.1).timeout
	for i in range(sheep_count):
		SpawnSheep()

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		SpawnSheep()
		
func ClownReturn():
	timer.start()
	await timer.timeout
	_spawn_clown()
	
func _spawn_clown():
	var start_pos = Vector2i(-1, 0)
	var new_clown = clown.instantiate()
	new_clown.entry_position = start_pos
	var tmo = new_clown.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_clown)
	tmo.SetCell(start_pos)
	

func SpawnSheep():
	var random_x : int = randi_range(sheep_zone.position.x, sheep_zone.end.x)
	var random_y : int = randi_range(sheep_zone.position.y, sheep_zone.end.y)
	var new_tile : Vector2i = Vector2i(random_x, random_y)
	print(new_tile)
	var new_sheep = sheep.instantiate()
	var tmo = new_sheep.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_sheep)
	tmo.SetCell(new_tile)
	
