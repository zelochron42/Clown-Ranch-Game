extends Node
@export var tilemap : TileMap
@export var maximum_checks : int = 1000
@export var tilemap_object : Node
@export var player_object : Node
@export var draw_path : bool = false
var astar : AStarGrid2D
var parent : Sprite2D
var cube = preload("res://sprites/redcube.png")
var grid_offset : Vector2i = Vector2i(-16, 0)

func _ready():
	tilemap = $"../../TileMap"
	parent = get_parent()
	astar = AStarGrid2D.new()
	astar.cell_size = Vector2i(16, 16)
	astar.default_compute_heuristic = astar.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = astar.HEURISTIC_MANHATTAN
	astar.diagonal_mode = astar.DIAGONAL_MODE_NEVER
	#astar.offset = -grid_offset
	_calculate_grid(true)
	
func _calculate_grid(ignore_objects : bool, target : Node = null):
	var rect : Rect2i = tilemap.get_used_rect()
	astar.region = rect
	astar.update()
	if !ignore_objects:
		var objs = tilemap.objects
		for o in objs:
			var parent_check = false
			if target != null:
				parent_check = (o != target.parent)
			if o != parent && parent_check && !o.has_method("EntryTrigger"):
				var tmo = o.find_child("TilemapObject")
				if tmo:
					astar.set_point_solid(tmo.cell_position, true)
					astar.set_point_solid(tmo.goal_cell, true)
	

func FindPath(start : Vector2i, end : Vector2i, ignore_objects : bool = true, target : Node = null) -> Array[Vector2i]:
	_calculate_grid(ignore_objects, target)
	var endpath : Array[Vector2i] = astar.get_id_path(start, end)
	if draw_path:
		for v in endpath:
			_temporary_sprite(v)
	return endpath
	
func _process(delta):
	pass
	
func _temporary_sprite(pos : Vector2i):
	var new_sprite = Sprite2D.new()
	new_sprite.texture = cube
	add_child(new_sprite)
	new_sprite.position = tilemap.map_to_local(pos)
	new_sprite.scale = Vector2(0.2, 0.2)
	await get_tree().create_timer(0.1).timeout
	new_sprite.queue_free()
		
