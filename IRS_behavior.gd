extends Sprite2D

@export var map : TileMap
var spawner : Node
var laughter : TextureProgressBar
var tilemap_object
var pathfinding
var tripped : bool = false
var muddied : bool = false
var text_anim : AnimationPlayer
var text_label : Label
var text_timer : Timer
@export var entry_position : Vector2i

func _ready():
	tilemap_object = $TilemapObject
	pathfinding = $Pathfinder
	map = get_tree().current_scene.find_child("TileMap")
	spawner = $"../EntitySpawner"
	text_anim = $TextAnim
	text_label = $Label
	text_timer = $TextHide
	
func _process(delta):
	if !tilemap_object.is_tweening && !tripped:
		if !muddied:
			_aggressive_behavior()
		else:
			_retreat()
		
		
func _aggressive_behavior():
	var my_pos = tilemap_object.goal_cell
	var end_target = _nearest_animal()
	var p : Array[Vector2i]
	if end_target != null:
		p = pathfinding.FindPath(my_pos, end_target.cell_position, false, end_target)
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


func _nearest_animal() -> Node:
	var target_pos = tilemap_object.cell_position
	var min_dist : float = 20
	var target : Node = null
	for ob in map.objects:
		var laugh = ob.find_child("LaughMeter")
		if ob != self && laugh && laugh.value > 0 && laugh.laugh_sources.has("unspecified"):
			var tmo = ob.find_child("TilemapObject")
			var ob_pos = tmo.cell_position
			var dist : float = (ob_pos - tilemap_object.cell_position).length()
			if dist < min_dist:
				min_dist = dist
				target_pos = ob_pos
				target = tmo
	return target
	
func _retreat():
	
	if tilemap_object.cell_position != entry_position:
		var path = pathfinding.FindPath(tilemap_object.cell_position, entry_position)
		if path.size() > 1:
			tilemap_object.MoveToCell(path[1], true)
	else:
		spawner.ThreatReturn(name)
		tilemap_object.Remove()
		
func Trip(trip_time : float):
	tripped = true
	rotation_degrees = 90 + (randi_range(0, 1) * -180)
	muddied = true
	await get_tree().create_timer(trip_time).timeout
	tripped = false
	rotation_degrees = 0
	text_anim.stop()
	text_timer.stop()
	text_label.text = "MY SUIT IS DIRTY!\nMUST CHANGE!"
	text_anim.play("text_scrollin")
	
func FakeLaugh():
	if !muddied && !text_anim.is_playing() && text_timer.is_stopped():
		text_label.text = "Laughter is not in\nmy job description."
		text_anim.play("text_scrollin")
		await text_anim.animation_finished
		text_timer.start()
		await text_timer.timeout
		text_label.visible_ratio = 0
