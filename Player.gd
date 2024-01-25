extends Sprite2D
@export var laugh_square_range : int = 1
@export var laugh_force : float = 16
@export var tickle_force : float = 0.5
var tilemap_object

func _ready():
	tilemap_object = $TilemapObject
	pass

func _process(delta):
	if Input.is_action_pressed("move_down"):
		TryMove(Vector2i.DOWN)
	if Input.is_action_pressed("move_up"):
		TryMove(Vector2i.UP)
	if Input.is_action_pressed("move_left"):
		TryMove(Vector2i.LEFT)
	if Input.is_action_pressed("move_right"):
		TryMove(Vector2i.RIGHT)	
	if Input.is_action_just_pressed("player_action"):
		_perform_action()
		
func TryMove(direction):
	var target = await tilemap_object.MoveDirection(direction)
	if target != null:
		MakeLaugh(target, tickle_force)

func MakeLaugh(target, value : float = laugh_force):
	print("attempting to make target laugh")
	var meter = target.find_child("LaughMeter")
	if meter:
		meter.AddLaugh(value)
		
func _perform_action(): #function for determining which action happens when the player presses the button
	_laugh_action() #currently only has one action, will add more later
	
func _laugh_action():
	print("laughing")
	for x in range(-laugh_square_range, laugh_square_range+1):
		for y in range(-laugh_square_range, laugh_square_range+1):
			var check_x = tilemap_object.cell_position.x + x
			var check_y = tilemap_object.cell_position.y + y
			var check_obj = tilemap_object.map.ObjectFromCell(Vector2i(check_x, check_y))
			if (check_obj != null):
				MakeLaugh(check_obj, laugh_force)
