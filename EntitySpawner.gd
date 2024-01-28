extends Node

@export var sheep_count : int
var sheep = preload("res://sheep.tscn")
var threats = [
	preload("res://angry_clown.tscn"),
	preload("res://sad_clown.tscn")
]
var respawn_timers : Array[Timer]
@export var sheep_zone : Rect2i
@export var threat : int = 0

func _ready():
	respawn_timers = [$MadReset, $SadReset]
	await get_tree().create_timer(0.1).timeout
	for i in range(sheep_count):
		SpawnSheep()

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		SpawnSheep()
		
func ThreatReturn(threat_name : String):
	match threat_name:
		"AngryClown":
			_timed_respawn(0)
		"SadClown":
			_timed_respawn(1)

func _timed_respawn(id : int):
	respawn_timers[id].start()
	await respawn_timers[id].timeout
	var start_pos = Vector2i(15, 0)
	var new_threat = threats[id].instantiate()
	new_threat.entry_position = start_pos
	var tmo = new_threat.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_threat)
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
	
