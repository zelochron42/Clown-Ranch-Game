extends Sprite2D

var jokes : Array[String] = [
	" Why did the chicken cross the road?\n I forget... ",
	" What do you call a polar bear in a desert?\n Lost. ",
	" How did the clown measure the percentage of his life he'd wasted?\n A PIE-chart. ",
	" What's black and white and red all over?\n My unpaid mortgage papers... ",
	" What's black and white and red all over?\n The divorce papers my wife sent me... ",
	" Did you hear about the kidnapping at school?\n He woke up. ",
	" What did the sheep do when it got upset?\n It went baa-listic. ",
	" How many days does it take to grow an acorn?\n At least tree. ",
	" What do vehicles do before a race?\n Carb Loading... ",
	" What did the apple say to the banana?\n I don't know... ",
	" What do you call a jelly break dancer?\n I don't know, it jammed... ",
	" What do you call a desktop that spins?\n A computer... ",
	" Did you see the boat on the highway?\n It's down the rowed... ",
	" How do carpets go fast?\n They floor it... ",
	" Why do thunderstorms take good pictures?\n It's all about the lightning... ",
	" I used to hate body hair,\n But then it grew on me... ",
	" I applied for a job at a bakery,\n But they told me I kneaded more experience... ",
	" Why can't you trick an unemployed jester?\n Because he's nobody's fool... ",
	" Do you remember where to wait for fruit juice?\n I forgot the punch line... ",
]
var introductions : Array[String] = [
	" My last set bombed... \n I'll practice some new material here... ",
	" Here are some more jokes... \n None of them are very good though... ",
	" Can you tell me if any of these are funny? \n I can't feel joy so I wouldn't know... ",
	" Hey, I thought up some new jokes...\n Wanna hear them? ",
	" Here come some jokes...\n I'll stop when I hear some laughter... "
]
var exit_lines : Array[String] = [
	" I knew it, that one's good! ",
	" Really? That was the joke you liked?\n ...well, alright. ",
	" Maybe this joke will finally get some laughs ",
	" I know you're fake laughing, but thanks anyway... ",
	" You really think that was funny? Huh. "
]

enum states {walkdown, talking, wrapup, walkup}
var state : states = states.walkdown

@export var talk_position : Vector2i
@export var entry_position : Vector2i
var text : RichTextLabel
var pathfinding : Node
var tilemap_object : Node
var spawner : Node
var joke_timer : Timer
var laughter : TextureProgressBar
@export var text_speed : float = 0.02
@export var linebreak_pause : float = 0.5
@export var joke_square_range : int = 5
@export var laugh_drain_force : int = 8
var tripped : bool = false

func _ready():
	pathfinding = $Pathfinder
	text = $RichTextLabel
	text.text = ""
	tilemap_object = $TilemapObject
	joke_timer = $JokeCooldown
	laughter = $LaughMeter
	spawner = $"../EntitySpawner"
	laughter.enabled = false

func _process(delta):
	if !tripped && !tilemap_object.is_tweening:
		match state:
			states.walkdown:
				_walkdown()
			states.talking:
				_joking()
			states.walkup:
				_walkup()
func _walkdown():
	if tilemap_object.is_tweening:
		return
	elif tilemap_object.cell_position == talk_position:
		state = states.talking
		tilemap_object.movedirection.emit(0)
		joke_timer.timeout.connect(_joke_routine)
		_joke_routine(introductions[randi() % introductions.size()])
		return
	else:
		var next_tile : Array[Vector2i] = pathfinding.FindPath(tilemap_object.cell_position, talk_position)
		if next_tile.size() > 1:
			tilemap_object.MoveToCell(next_tile[1], true) #the sad clown can move through objects
	
func _joking():
	pass
	
func _joke_routine(this_joke = ""):
	if state != states.talking:
		return
	if this_joke == "":
		this_joke = jokes[randi() % jokes.size()]
	await _text_appear(this_joke)
	if laughter.value > 8:
		state = states.wrapup
		await get_tree().create_timer(linebreak_pause).timeout
		var last_line : String = exit_lines[randi() % exit_lines.size()]
		await _text_appear(last_line)
		await get_tree().create_timer(linebreak_pause).timeout
		state = states.walkup
	elif state == states.talking:
		_laughter_drain()
		joke_timer.start()
		laughter.enabled = true

func _text_appear(line : String) -> void:
	text.text = line
	text.visible_characters = 0
	for i in range(0, line.length()):
		await get_tree().create_timer(text_speed).timeout
		if line[i] == '\n':
				await get_tree().create_timer(linebreak_pause).timeout
		text.visible_characters = i + 1
	return

func _walkup():
	if joke_timer.is_stopped():
		if tilemap_object.cell_position == entry_position:
			spawner.ThreatReturn(name)
			tilemap_object.Remove()
		else:
			var next_tile : Array[Vector2i] = pathfinding.FindPath(tilemap_object.cell_position, entry_position)
			tilemap_object.MoveToCell(next_tile[1], true) #the sad clown can move through objects
	
func _laughter_drain():
	print("bad joke complete, draining laughter")
	for x in range(-joke_square_range, joke_square_range+1):
		for y in range(-joke_square_range, joke_square_range+1):
			var check_x = tilemap_object.cell_position.x + x
			var check_y = tilemap_object.cell_position.y + y
			var check_obj = tilemap_object.map.ObjectFromCell(Vector2i(check_x, check_y))
			if (check_obj != null):
				var meter = check_obj.find_child("LaughMeter")
				if meter:
					meter.AddLaugh(-laugh_drain_force, "bad_joke")
					
#func Trip(trip_time : float):
	#tripped = true
	#rotation_degrees = 90 + (randi_range(0, 1) * -180)
	#await get_tree().create_timer(trip_time).timeout
	#tripped = false
	#rotation_degrees = 0
