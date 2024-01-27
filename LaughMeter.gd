extends TextureProgressBar

@export var laugh_sources : Array[String] = ["unspecified"]
@export var drain_rate : float = 1
var timer : Timer
var laugh_value : float

# Called when the node enters the scene tree for the first time.
func _ready():
	laugh_value = value
	timer = $Timer
	timer.connect("timeout", _laugh_drain)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = int(laugh_value)
	pass
func _laugh_drain():
	AddLaugh(-drain_rate)

func AddLaugh(laughs, laugh_source : String = "unspecified"):
	if laugh_sources.has(laugh_source):
		laugh_value = clamp(laugh_value + laughs, min_value, max_value)
