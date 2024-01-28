extends Sprite2D

@export var trip_time : float = 2
@export var remove_delay : float = 0.25
var tilemap_object : Node

func _ready():
	tilemap_object = $TilemapObject

func _process(delta):
	pass
	
func EntryTrigger(entrant) -> bool: #triggers when something tries to step on this object
	if entrant.has_method("Trip"):
		entrant.Trip(trip_time)
		_self_remove()
	return true
	
func _self_remove():
	await get_tree().create_timer(remove_delay).timeout
	tilemap_object.Remove()
