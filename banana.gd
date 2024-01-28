extends Sprite2D

@export var trip_time : float = 2
@export var remove_delay : float = 1.5
@export var horizontal_force : float = 50
@export var vertical_force : float = 50
var tilemap_object : Node
var rb2d : RigidBody2D

func _ready():
	tilemap_object = $TilemapObject
	rb2d = $RigidBody2D

func _process(delta):
	pass
	
func EntryTrigger(entrant) -> bool: #triggers when something tries to step on this object
	if entrant.has_method("Trip"):
		entrant.Trip(trip_time)
		_self_remove()
	return true
	
func _self_remove():
	z_index = 500
	rb2d.freeze = false
	rb2d.apply_impulse(Vector2(randf_range(-horizontal_force, horizontal_force), -vertical_force))
	rotation_degrees = randf_range(0, 360)
	rb2d.reparent(get_tree().current_scene)
	reparent(rb2d)
	tilemap_object.Remove(false)
	await get_tree().create_timer(remove_delay).timeout
	queue_free()
