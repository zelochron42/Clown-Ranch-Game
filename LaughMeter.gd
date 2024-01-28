extends TextureProgressBar

@export var laugh_sources : Array[String] = ["unspecified"]
@export var drain_rate : float = 1
var timer : Timer
var laugh_value : float
var enabled : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	laugh_value = value
	timer = $Timer
	timer.connect("timeout", _laugh_drain)
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var waiting_for_hide : bool = false
func _process(delta):
	value = int(laugh_value)
	if value > 0:
		show()
		waiting_for_hide = false
	elif !waiting_for_hide:
		waiting_for_hide = true
		_delayed_hide()

func _delayed_hide():
	await get_tree().create_timer(2).timeout
	if value == 0:
		hide()

func _laugh_drain():
	AddLaugh(-drain_rate)

func AddLaugh(laughs, laugh_source : String = "unspecified"):
	if laugh_sources.has(laugh_source) && enabled:
		laugh_value = clamp(laugh_value + laughs, min_value, max_value)
