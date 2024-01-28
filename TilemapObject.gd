extends Node
@export var map : TileMap
@export var cell_position : Vector2i #the cell that this tile is currently on
@export var goal_cell : Vector2i #the cell that this object is moving towards
#while holding still, cell_position and goal_cell will be the same
@export var move_time : float = 0.2 #time in seconds it takes to move from one tile to another
var parent : Node2D
var is_tweening : bool = false
signal movedirection(direction : int)

func _ready(): #equivalent to Unity's Start() method, runs once at the start
	map = get_tree().current_scene.find_child("TileMap")
	parent = get_parent()
	cell_position = map.local_to_map(parent.position)
	goal_cell = cell_position
	_sync_parent()
	map.objects.append(parent) #adds parent to the list of moving objects tracked by GameMap.gd

func SetCell(new_cell):
	cell_position = new_cell
	goal_cell = cell_position
	_sync_parent()

func MoveToCell(new_cell : Vector2i, ignore_objects : bool = false, override_movement : bool = false) -> Node:
	#This function will attempt to tween this object to a specified cell
	#If it fails due to being blocked by an object, it will return the node of the object that blocked it
	
	var valid_tile : bool = _check_cell_for_tile(new_cell) #Check to make sure the tilemap has a tile here
	if !valid_tile:
		return null #Fails to move if there is no tile to move to

	var obstruction : Node = _check_cell_for_object(new_cell) #Check for other objects blocking the tile
	if obstruction && !ignore_objects:
		return obstruction #Fails to move and returns the object that blocked it

	if !is_tweening || override_movement: #The object cannot start a new tween if it is already tweening
		_check_direction(new_cell - cell_position) #extra function for sprite management
		is_tweening = true
		var tween = create_tween() #create the tween animation that will move this object
		tween.tween_property(parent, "position", map.map_to_local(new_cell), move_time)
		goal_cell = new_cell
		_end_tween(tween)
	return null #Returns null after moving successfully, since nothing blocked it
func _end_tween(tween):
	await tween.finished #Wait in real-time for the tween to end
	cell_position = goal_cell
	is_tweening = false

func _check_cell_for_tile(check_cell) -> bool: #simple function that checks the tilemap to see if a tile is empty
	return map.get_cell_tile_data(0, check_cell) != null

func _check_cell_for_object(check_cell) -> Node: #function that checks for any moving objects on a specific tile
	var ob = map.ObjectFromCell(check_cell)
	if ob != parent && ob != null: #ignore self
		if ob.has_method("EntryTrigger"):
			var entered : bool = ob.EntryTrigger(parent)
			if entered:
				return null
		return ob
	return null

func MoveDirection(direction : Vector2i) -> Node: #Simple function that just runs MoveToCell to an adjacent cell
	var target = await MoveToCell(cell_position + direction)
	return target

func _sync_parent(): #Snap the physical position of this object to its exact cell position
	parent.position = map.map_to_local(cell_position)
	
func _check_direction(direction : Vector2i):
	match direction:
		Vector2i.DOWN:
			movedirection.emit(0)
		Vector2i.LEFT:
			movedirection.emit(1)
		Vector2i.UP:
			movedirection.emit(2)
		Vector2i.RIGHT:
			movedirection.emit(3)
	
func Remove(delete : bool = true):
	map.objects.erase(parent)
	if delete:
		parent.queue_free()
