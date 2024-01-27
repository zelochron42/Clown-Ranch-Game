extends Sprite2D

@export var map : TileMap
var spawner : Node
var laughter : TextureProgressBar
var tilemap_object
var pathfinding
@export var entry_position : Vector2i
@export var happiness_threshold : float = 50 #measured in percentage

func _ready():
	tilemap_object = $TilemapObject
	laughter = $LaughMeter
	pathfinding = $Pathfinder
	map = get_tree().current_scene.find_child("TileMap")
	spawner = $"../EntitySpawner"

func _process(delta):
	if !tilemap_object.is_tweening:
		if laughter.laugh_value > laughter.max_value * happiness_threshold / 100:
			_laugh_behavior()
		else:
			_mad_behavior()
		
		
func _mad_behavior():
	var my_pos = tilemap_object.cell_position
	var end_pos = _nearest_animal()
	var p : Array[Vector2i] = pathfinding.FindPath(my_pos, end_pos)
	if p.size() > 1:
		var target : Node = tilemap_object.MoveToCell(p[1])
		if target:
			var laugh_meter = target.find_child("LaughMeter")
			if laugh_meter:
				laugh_meter.AddLaugh(-4)
	else:
		var directions = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]
		var direction = directions[randi() % 4]
		tilemap_object.MoveDirection(direction)


func _nearest_animal() -> Vector2i:
	var target_pos = tilemap_object.cell_position
	var min_dist : float = 20
	for ob in map.objects:
		var laugh = ob.find_child("LaughMeter")
		if ob != self && laugh && laugh.value > 0 && laugh.laugh_sources.has("unspecified"):
			var ob_pos = ob.find_child("TilemapObject").cell_position
			var dist : float = (ob_pos - tilemap_object.cell_position).length()
			if dist < min_dist:
				min_dist = dist
				target_pos = ob_pos
	return target_pos
	
func _laugh_behavior():
	if tilemap_object.cell_position != entry_position:
		var path = pathfinding.FindPath(tilemap_object.cell_position, entry_position)
		tilemap_object.MoveToCell(path[1], true)
	else:
		spawner.ThreatReturn(name)
		tilemap_object.Remove()
		

