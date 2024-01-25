extends Sprite2D

@export var map : TileMap
var laughter : TextureProgressBar
var tilemap_object
var pathfinding
var entry_position : Vector2i
@export var happiness_threshold : float = 50 #measured in percentage

func _ready():
	tilemap_object = $TilemapObject
	laughter = $LaughMeter
	pathfinding = $Pathfinder
	map = get_tree().current_scene.find_child("TileMap")
	entry_position = map.local_to_map(position)

func _process(delta):
	if !tilemap_object.is_tweening:
		if laughter.laugh_value > laughter.max_value * happiness_threshold / 100:
			_laugh_behavior()
		else:
			_mad_behavior()
		
		
func _mad_behavior():
	var directions = [Vector2i.RIGHT, Vector2i.DOWN]
	var direction = directions[randi() % 2]
	tilemap_object.MoveDirection(direction)
	pass

func _nearest_animal():
	
func _laugh_behavior():
	if tilemap_object.cell_position != entry_position:
		var path = pathfinding.FindPath(tilemap_object.cell_position, entry_position)
		tilemap_object.MoveToCell(path[1])
	else:
		tilemap_object.Remove()
		

