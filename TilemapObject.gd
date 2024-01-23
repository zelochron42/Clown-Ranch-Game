extends Node
@export var map : TileMap
@export var cell_position : Vector2i
@export var goal_cell : Vector2i
@export var move_time : float
var parent : Node2D
var is_tweening : bool = false

func _ready():
	parent = get_parent()
	cell_position = map.local_to_map(parent.position)
	_sync_parent()

func MoveToCell(new_cell : Vector2i, override_movement : bool = false):
	if !is_tweening || override_movement:
		is_tweening = true
		var tween = create_tween()
		tween.tween_property(parent, "position", map.map_to_local(new_cell), move_time)
		goal_cell = new_cell
		await tween.finished
		cell_position = goal_cell
		is_tweening = false
	
func MoveDirection(direction : Vector2i):
	MoveToCell(cell_position + direction)

func _sync_parent():
	parent.position = map.map_to_local(cell_position)
