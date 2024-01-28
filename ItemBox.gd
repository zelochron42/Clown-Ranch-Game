extends Sprite2D

@export var item : String
@export var quantity : int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func EntryTrigger(entrant) -> bool: #triggers when something tries to step on this object
	if entrant.has_method("PickupItem"):
		entrant.PickupItem(item, quantity)
	return false
