extends Node
@export var map : TileMap
@export var cell_position : Vector2i
@export var move_time : float
var parent : Node2D

func _ready():
	parent = get_parent()
	cell_position = map.local_to_map(parent.position)
	_sync_parent()

func MoveToCell(new_cell : Vector2i):
	cell_position = new_cell
	_sync_parent()
	pass
	
func MoveDirection(direction : Vector2i):
	MoveToCell(cell_position + direction)

func _sync_parent():
	parent.position = map.map_to_local(cell_position)
