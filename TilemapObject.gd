extends Node
@export var map : TileMap
@export var cell_position : Vector2i
@export var goal_cell : Vector2i
@export var move_time : float = 0.2
var parent : Node2D
var is_tweening : bool = false

func _ready():
	parent = get_parent()
	cell_position = map.local_to_map(parent.position)
	goal_cell = cell_position
	_sync_parent()
	map.objects.append(parent)

func MoveToCell(new_cell : Vector2i, ignore_objects : bool = false, override_movement : bool = false):
	var tile_open : bool = CheckCell(new_cell)
	if !tile_open:
		return
	if !is_tweening || override_movement:
		is_tweening = true
		var tween = create_tween()
		tween.tween_property(parent, "position", map.map_to_local(new_cell), move_time)
		goal_cell = new_cell
		await tween.finished
		cell_position = goal_cell
		is_tweening = false

func CheckCell(check_cell) -> bool:
	if !map.get_cell_tile_data(0, check_cell):
		return false
	for ob in map.objects:
		if ob != parent:
			var mapob = ob.find_child("TilemapObject")
			if mapob && (mapob.cell_position == check_cell || mapob.goal_cell == check_cell):
				print("Movement of " + parent.name + " blocked by " + ob.name)
				return false
	return true

func MoveDirection(direction : Vector2i):
	MoveToCell(cell_position + direction)

func _sync_parent():
	parent.position = map.map_to_local(cell_position)
