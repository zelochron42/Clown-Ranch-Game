extends Sprite2D

var jokes : Array[String] = [
	"Why did the chicken cross the road?\nBecause the road crossed him first.",
	"What do you call a polar bear in a desert?\nLost.",
	"How did the clown measure the percentage of his life he'd wasted?\nA PIE-chart.",
	"What's black and white and red all over?\nMy unpaid mortgage papers...",
	"What's black and white and red all over?\nThe divorce papers my wife sent me...",
	"Did you hear about the kidnapping at school?\nHe woke up.",
	"What did the sheep do when it got upset?\nIt went baa-listic.",
	"How many days does it take to grow an acorn?\nAt least tree.",
	"What do vehicles do before a race?\nCarb Loading...",
	"What did the apple say to the banana?\nI don't know...",
	"What do you call a jelly break dancer?\nI don't know, it jammed...",
	"What do you call a desktop that spins?\nA computer...",
	"Did you see the boat on the highway?\nIt's down the rowed...",
	"How do carpets go fast?\nThey floor it...",
	"Why do thunderstorms take good pictures?\nIt's all about the lightning...",
	"I used to hate body hair,\nBut then it grew on me...",
	"I applied for a job at a bakery,\nBut they told me I kneaded more experience...",
	"Why can't you trick an unemployed jester?\nBecause he's nobody's fool...",
	"Do you remember where to wait for fruit juice?\nI forgot the punch line...",
]
var introductions : Array[String] = [
	"My last set bombed... \nI'll practice some new material here...",
	"Here are some more jokes... \nNone of them are very good though...",
	"Can you tell me if any of these are funny? \nI can't feel joy so I wouldn't know...",
	"Hey, I thought up some new jokes...\nWanna hear them?"
]
enum states {walkdown, talking, walkup}
var state : states = states.walkdown

@export var talk_position : Vector2i
@export var spawn_position : Vector2i
var text : RichTextLabel
var pathfinding : Node
var tilemap_object : Node
var joke_timer : Timer
@export var text_speed : float = 0.02
@export var linebreak_pause : float = 0.5

func _ready():
	pathfinding = $Pathfinder
	text = $RichTextLabel
	text.text = ""
	tilemap_object = $TilemapObject
	joke_timer = $JokeCooldown

func _process(delta):
	match state:
		states.walkdown:
			_walkdown()
		states.talking:
			_joking()
		states.walkup:
			walkup()
func _walkdown():
	if tilemap_object.is_tweening:
		return
	elif tilemap_object.cell_position == talk_position:
		state = states.talking
		joke_timer.timeout.connect(_joke_routine)
		_joke_routine(introductions[randi() % introductions.size()])
		return
	else:
		var next_tile : Array[Vector2i] = pathfinding.FindPath(tilemap_object.cell_position, talk_position)
		tilemap_object.MoveToCell(next_tile[1], true) #the sad clown can move through objects
	
func _joking():
	pass
	
func _joke_routine(this_joke = ""):
	if this_joke == "":
		this_joke = jokes[randi() % jokes.size()]
	text.text = this_joke
	text.visible_characters = 0
	for i in range(0, this_joke.length()):
		await get_tree().create_timer(text_speed).timeout
		if this_joke[i] == '\n':
				await get_tree().create_timer(linebreak_pause).timeout
		text.visible_characters = i + 1
	joke_timer.start()
	
func walkup():
	pass
