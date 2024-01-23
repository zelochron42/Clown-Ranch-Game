extends Sprite2D
var tilemap_object

func _ready():
	tilemap_object = $TilemapObject
	pass

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		tilemap_object.MoveDirection(Vector2i.DOWN)
	if Input.is_action_pressed("ui_up"):
		tilemap_object.MoveDirection(Vector2i.UP)
	if Input.is_action_pressed("ui_left"):
		tilemap_object.MoveDirection(Vector2i.LEFT)
	if Input.is_action_pressed("ui_right"):
		tilemap_object.MoveDirection(Vector2i.RIGHT)	
