extends Node
@export var tilemap : TileMap
@export var maximum_checks : int = 1000
@export var tilemap_object : Node
@export var player_object : Node
var astar : AStarGrid2D
func _ready():
	
	astar = AStarGrid2D.new()
	var rect : Rect2i = tilemap.get_used_rect()
	astar.region = rect
	astar.cell_size = Vector2i(16, 16)
	astar.default_compute_heuristic = astar.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = astar.HEURISTIC_MANHATTAN
	astar.diagonal_mode = astar.DIAGONAL_MODE_NEVER
	astar.update()
	
func FindPath(start : Vector2i, end : Vector2i) -> Array[Vector2i]:
	var endpath : Array[Vector2i] = astar.get_id_path(start, end)
	return endpath
	
func _process(delta):
	pass
		
