extends TileMap
@export var objects : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func ObjectFromCell(check_cell) -> Node: #function that checks for any moving objects on a specific tile
	for ob in objects: #iterate through the list of objects defined in the tilemap script
		var mapob = ob.find_child("TilemapObject")
		if mapob && (mapob.cell_position == check_cell || mapob.goal_cell == check_cell): #check the current and future position of the object
			return ob
	return null
