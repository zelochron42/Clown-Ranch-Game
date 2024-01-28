extends Node

@onready var label = $Label #Reference to the lable node
@onready var timer = $Timer #Reference to timer node

@export var spawner : Node


var time_left
var minute 
var second

func _ready():
	timer.start()
	
func time_left_counter():
	time_left = timer.time_left
	minute = floor(time_left / 60)
	second = int(time_left) % 60
	return[minute,second]
	
func ResetTimer():
	timer.stop()
	timer.start()

func _process(delta):
	label.text="%02d:%02d" % time_left_counter()
	#Anycode below this is what triggers when time hits 0:00
	#Id imagine a switch statement or even a random number gen for spawning enamies during the wave
	if second==0 and minute ==0:
		spawner.GameOver()
	
#Only thing Now is resetting the timer when loading a new scene

func _on_timer_timeout():
	pass # Replace with function body.
