extends Sprite2D
@export var laugh_square_range : int = 1
@export var laugh_force : float = 16
@export var tickle_force : float = 0.5
var tilemap_object
var facing_direction : Vector2i

enum items {none, banana, rake, balloon, pie}
@export var current_item : items
@export var item_quantity : int

var bananadrop = preload("res://banana.tscn")

var tripped : bool = false

func _ready():
	tilemap_object = $TilemapObject

func _process(delta):
	if !tripped && !tilemap_object.is_tweening:
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
	facing_direction = direction
	var target = await tilemap_object.MoveDirection(direction)
	if target != null:
		MakeLaugh(target, tickle_force, "tickle")

func MakeLaugh(target, value : float = laugh_force, type : String = "unspecified"):
	print("attempting to make target laugh")
	var meter = target.find_child("LaughMeter")
	if meter:
		meter.AddLaugh(value, type)
		
func _perform_action(): #function for determining which action happens when the player presses the button
	match current_item:
		items.none:
			_laugh_action()
		items.banana:
			_drop_banana()
	item_quantity -= 1
	if item_quantity <= 0:
		current_item = items.none
	
func _laugh_action():
	print("laughing")
	for x in range(-laugh_square_range, laugh_square_range+1):
		for y in range(-laugh_square_range, laugh_square_range+1):
			var check_x = tilemap_object.cell_position.x + x
			var check_y = tilemap_object.cell_position.y + y
			var check_obj = tilemap_object.map.ObjectFromCell(Vector2i(check_x, check_y))
			if (check_obj != null):
				MakeLaugh(check_obj, laugh_force, "laugh")

func PickupItem(id : String, quantity : int):
	current_item = items[id]
	item_quantity = quantity

func _drop_banana():
	print("dropping banana")
	var new_tile = tilemap_object.goal_cell + facing_direction
	var new_banana = bananadrop.instantiate()
	var tmo = new_banana.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_banana)
	tmo.SetCell(new_tile)
	
func Trip(trip_time : float):
	tripped = true
	rotation_degrees = 90 + (randi_range(0, 1) * -180)
	await get_tree().create_timer(trip_time).timeout
	tripped = false
	rotation_degrees = 0
	
