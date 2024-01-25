extends Node

var sheep = preload("res://sheep.tscn")
@export var sheep_zone : Rect2i

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		SpawnSheep()

func SpawnSheep():
	var random_x : int = randi_range(sheep_zone.position.x, sheep_zone.end.x)
	var random_y : int = randi_range(sheep_zone.position.y, sheep_zone.end.y)
	var new_tile : Vector2i = Vector2i(random_x, random_y)
	print(new_tile)
	var new_sheep = sheep.instantiate()
	var tmo = new_sheep.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_sheep)
	tmo.MoveToCell(new_tile)
	
