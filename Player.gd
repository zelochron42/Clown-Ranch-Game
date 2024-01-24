extends Sprite2D
var tilemap_object

func _ready():
	tilemap_object = $TilemapObject
	pass

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		TryMove(Vector2i.DOWN)
	if Input.is_action_pressed("ui_up"):
		TryMove(Vector2i.UP)
	if Input.is_action_pressed("ui_left"):
		TryMove(Vector2i.LEFT)
	if Input.is_action_pressed("ui_right"):
		TryMove(Vector2i.RIGHT)	
		
func TryMove(direction):
	var target = await tilemap_object.MoveDirection(direction)
	if target != null:
		MakeLaugh(target)

func MakeLaugh(target):
	print("attempting to make target laugh")
	var meter = target.find_child("LaughMeter")
	if meter:
		meter.AddLaugh(1)
	
