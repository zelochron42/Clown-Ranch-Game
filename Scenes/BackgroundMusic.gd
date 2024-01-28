extends AudioStreamPlayer2D

@export var intros : Array[AudioStreamMP3]
@export var loops : Array[AudioStreamMP3]

var song_num : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = intros[0]
	play()
	finished.connect(_play_loop)

func _play_loop():
	if stream != loops[song_num] && stream != intros[song_num]:
		stream = intros[song_num]
	else:
		stream = loops[song_num]
	play()

func SetTrack(track : int):
	song_num = track
	
func IRS():
	stop()
	stream = intros[2]
	song_num = 2
	play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
