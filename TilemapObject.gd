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

func MoveToCell(new_cell : Vector2i, ignore_objects : bool = false, override_movement : bool = false) -> Node:
	var valid_tile : bool = _check_cell_for_tile(new_cell)
	if !valid_tile:
		return null

	var obstruction : Node = _check_cell_for_object(new_cell)
	if obstruction:
		return obstruction

	if !is_tweening || override_movement:
		is_tweening = true
		var tween = create_tween()
		tween.tween_property(parent, "position", map.map_to_local(new_cell), move_time)
		goal_cell = new_cell
		await tween.finished
		cell_position = goal_cell
		is_tweening = false
	return null
func _check_cell_for_tile(check_cell) -> bool:
	return map.get_cell_tile_data(0, check_cell) != null

func _check_cell_for_object(check_cell) -> Node:
	for ob in map.objects:
		if ob != parent:
			var mapob = ob.find_child("TilemapObject")
			if mapob && (mapob.cell_position == check_cell || mapob.goal_cell == check_cell):
				return ob
	return null

func MoveDirection(direction : Vector2i) -> Node:
	var target = await MoveToCell(cell_position + direction)
	return target

func _sync_parent():
	parent.position = map.map_to_local(cell_position)
