extends Sprite2D
@export var laugh_square_range : int = 1
@export var laugh_force : float = 16
@export var tickle_force : float = 0.5
var tilemap_object
var facing_direction : Vector2i

enum items {none, banana, rake, balloon, pie}
@export var current_item : items
@export var item_quantity : int
@export var item_textures : Array[Texture2D]
var laugh_anim : AnimationPlayer

var ui_item_label : Label
var ui_item_texture : TextureRect

var bananadrop = preload("res://banana.tscn")
var pie_projectile = preload("res://pie.tscn")

var tripped : bool = false

func _ready():
	tilemap_object = $TilemapObject
	ui_item_label = $"../CanvasLayer/ItemLabel"
	ui_item_texture = $"../CanvasLayer/ItemTexture"
	laugh_anim = $LaughAnimation

func _process(_delta):
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
	elif target.has_method("FakeLaugh") && type == "laugh":
		target.FakeLaugh()
		
func _perform_action(): #function for determining which action happens when the player presses the button
	var success : bool = false
	match current_item:
		items.none:
			_laugh_action()
		items.banana:
			success = _drop_banana()
		items.pie:
			success = _throw_pie()
	if success:
		item_quantity -= 1
		if item_quantity <= 0:
			PickupItem("none", 0)
	
func _laugh_action():
	if !laugh_anim.is_playing():
		for x in range(-laugh_square_range, laugh_square_range+1):
			for y in range(-laugh_square_range, laugh_square_range+1):
				var check_x = tilemap_object.cell_position.x + x
				var check_y = tilemap_object.cell_position.y + y
				var check_obj = tilemap_object.map.ObjectFromCell(Vector2i(check_x, check_y))
				if (check_obj != null):
					MakeLaugh(check_obj, laugh_force, "laugh")
		laugh_anim.play("haha_grow")
	

func PickupItem(id : String, quantity : int = 1):
	match id:
		"none":
			ui_item_texture.texture = item_textures[0]
			ui_item_label.text = "LAUGH"
		"banana":
			ui_item_texture.texture = item_textures[1]
			ui_item_label.text = "BANANA"
		"rake":
			ui_item_texture.texture = item_textures[2]
			ui_item_label.text = "RAKE"
		"balloon":
			ui_item_texture.texture = item_textures[3]
			ui_item_label.text = "BALLOON"
		"pie":
			ui_item_texture.texture = item_textures[4]
			ui_item_label.text = "PIE"
		_:
			printerr("unrecognized item type!")
			return
	current_item = items[id]
	item_quantity = quantity

func _drop_banana() -> bool:
	print("dropping banana")
	var new_tile = tilemap_object.goal_cell + facing_direction
	
	var occupying_object = tilemap_object.map.ObjectFromCell(new_tile)
	if occupying_object:
		return false
		
	var new_banana = bananadrop.instantiate()
	var tmo = new_banana.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_banana)
	tmo.SetCell(new_tile)
	return true

func _throw_pie() -> bool:
	var new_pie = pie_projectile.instantiate()
	get_tree().current_scene.add_child(new_pie)
	new_pie.position = position
	new_pie.ThrowPie(facing_direction)
	return true
	
func Trip(trip_time : float):
	tripped = true
	rotation_degrees = 90 + (randi_range(0, 1) * -180)
	await get_tree().create_timer(trip_time).timeout
	tripped = false
	rotation_degrees = 0
	
