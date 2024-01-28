extends Node

@export var center_text : RichTextLabel
@export var round_timer : Node2D
@export var counter_text : Label
@export var center_display_time : float = 5

@export var sheep_counts : Array[int]
var round_texts : Array[String] = [
	"[center]Tickle the sheep to get them to come home![/center]",
	"[center]The sad clown and the mad clown will bring the mood down![/center]",
	" ",
	"[center]You win![/center]"
]

var sheep = preload("res://sheep.tscn")
var threats = [
	preload("res://angry_clown.tscn"),
	preload("res://sad_clown.tscn"),
	preload("res://irs.tscn")
]
var respawn_timers : Array[Timer]
@export var sheep_zone : Rect2i
@export var threat : int = 0

var active_sheep : int = 0
var total_score : int = 0
var round_in_progress : bool = false
@export var round_number = 0

@export var music : AudioStreamPlayer2D
@export var irs_anim : AnimationPlayer
@export var irs_graphic : TextureRect

func _ready():
	respawn_timers = [$MadReset, $SadReset, $IRSReset]
	center_text.visible = false
	await get_tree().create_timer(1).timeout
	_start_round()
	
func _start_round():
	center_text.visible = true
	center_text.text = round_texts[round_number]
	round_timer.ResetTimer()
	if round_number >= 3:
		await get_tree().create_timer(4).timeout
		GameOver()
		return
	
	for t in respawn_timers:
		t.stop()
	
	match round_number:
		1:
			_timed_respawn(0)
			_timed_respawn(1)
			var box = load("res://banana_box.tscn")
			var new_box = box.instantiate()
			get_tree().current_scene.add_child(new_box)
			music.SetTrack(1)
		2:
			respawn_timers[2].start()
			respawn_timers[2].timeout.connect(_spawn_irs)
			var box_set = load("res://pie_set.tscn")
			var new_set = box_set.instantiate()
			get_tree().current_scene.add_child(new_set)
			music.IRS()
			irs_anim.play("IRS")
			await music.finished
			irs_graphic.visible = false
			center_text.text = "[center]The IRS are here to enforce their new laughter tax!\nStop them with pies![/center]"
			
	for i in range(sheep_counts[round_number]):
		SpawnSheep()
	await get_tree().create_timer(center_display_time).timeout
	center_text.visible = false
	round_number += 1
		
func ThreatReturn(threat_name : String):
	match threat_name:
		"AngryClown":
			if round_number == 2:
				_timed_respawn(0)
		"SadClown":
			if round_number == 2:
				_timed_respawn(1)
		"IRS":
			if round_number == 3:
				irs_count -= 1

func _timed_respawn(id : int):
	respawn_timers[id].start()
	await respawn_timers[id].timeout
	var start_pos = Vector2i(15, 0)
	var new_threat = threats[id].instantiate()
	new_threat.entry_position = start_pos
	var tmo = new_threat.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_threat)
	tmo.SetCell(start_pos)

var irs_count : int = 0
func _spawn_irs():
	if irs_count < 3:
		irs_count += 1
		var start_pos = Vector2i(randi_range(12, 18), 0)
		var new_threat = threats[2].instantiate()
		new_threat.entry_position = start_pos
		var tmo = new_threat.find_child("TilemapObject")
		get_tree().current_scene.add_child(new_threat)
		tmo.SetCell(start_pos)

func SpawnSheep():
	active_sheep += 1
	var random_x : int = randi_range(sheep_zone.position.x, sheep_zone.end.x)
	var random_y : int = randi_range(sheep_zone.position.y, sheep_zone.end.y)
	var new_tile : Vector2i = Vector2i(random_x, random_y)
	print(new_tile)
	var new_sheep = sheep.instantiate()
	var tmo = new_sheep.find_child("TilemapObject")
	get_tree().current_scene.add_child(new_sheep)
	tmo.SetCell(new_tile)
	
func SheepReturn(saved : bool = true):
	active_sheep -= 1
	if saved:
		total_score += 50
		counter_text.text = str(total_score)
	if active_sheep <= 0:
		active_sheep = 0
		_start_round()
		
func GameOver():
	get_tree().change_scene_to_file("res://Scenes/mainmenue.tscn")
