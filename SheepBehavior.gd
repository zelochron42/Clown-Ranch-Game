extends Sprite2D

@export var trailer_position : Vector2i
var laughter : TextureProgressBar
var tilemap_object
var spawner
var pathfinding
var directions = [Vector2i.DOWN, Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT]

func _ready():
	tilemap_object = $TilemapObject
	laughter = $LaughMeter
	pathfinding = $Pathfinder
	spawner = $"../EntitySpawner"

func _process(delta):
	if laughter.laugh_value > 0:
		_laughing_behavior()
	else:
		_bored_behavior()
		
		
func _bored_behavior():
	if randf() >= 0.95:
		tilemap_object.MoveDirection(directions[randi() % directions.size()])
	
func _laughing_behavior():
	var my_pos = tilemap_object.cell_position
	var end_pos = trailer_position
	var p : Array[Vector2i] = pathfinding.FindPath(my_pos, end_pos, false)
	if p.size() > 1:
		tilemap_object.MoveToCell(p[1])
	elif my_pos == end_pos:
		spawner.SheepReturn()
		tilemap_object.Remove()
