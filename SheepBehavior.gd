extends Sprite2D
var tilemap_object
var directions = [Vector2i.DOWN, Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT]

func _ready():
	tilemap_object = $TilemapObject
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randf() >= 0.95:
		tilemap_object.MoveDirection(directions[randi() % directions.size()])
	pass
