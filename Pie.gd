extends RigidBody2D

@export var lifetime : float = 2
@export var speed : float = 10
@export var trip_time : float = 1
var player : Node2D
var map : Node

func _ready():
	player = $"../Player"
	map = $"../TileMap"
	
func _process(delta):
	var objs = map.objects
	var cell : Vector2i = map.local_to_map(position)
	for o in objs:
		var tmo = o.find_child("TilemapObject")
		if tmo != null:
			if o != player && (tmo.cell_position == cell || tmo.goal_cell == cell) && o.has_method("Trip"):
				o.Trip(trip_time)
				_self_remove()

func ThrowPie(direction : Vector2i):
	apply_impulse(Vector2(direction) * speed)
	rotation_degrees = rad_to_deg(atan2(direction.y, direction.x)) + 90
	await get_tree().create_timer(lifetime).timeout
	_self_remove()
	
func _self_remove():
	queue_free()
