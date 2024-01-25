extends Sprite2D

var player
var tilemap_object

func _ready():
	player =  $"../Player"# Adjust the path based on your scene structure
	tilemap_object = $"../TileMap" # Adjust the path based on your scene structure
	pass

func _process(delta):

	var player_position = player.global_transform.origin

	# Current tile_size for tile map is 16 x 16
	var tile_size = 16  # Replace with your actual tile size

	# The tile position of the player in proportion to their size
	var player_tile_position = Vector2i(int(player_position.x / tile_size),int(player_position.y / tile_size))

	# The tile position of the current object
	var item_tile_position = Vector2i(int(global_transform.origin.x / tile_size),int(global_transform.origin.y / tile_size))

	# Check if the player is on the same tile as the item
	if player_tile_position == item_tile_position:
		print("Hello, World.")
		queue_free() #Destroy item
		
		#Add any additional functions below when you have picked up said item.

