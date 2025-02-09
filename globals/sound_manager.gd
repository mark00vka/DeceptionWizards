extends Node

@export var ui_click: AudioStream
@export var ui_whoosh: AudioStream
@export var tile_select: AudioStream
@export var tile_rotate: AudioStream
@export var explosion_debris: AudioStream
@export var explosion_main: AudioStream
@export var explosion_accent: AudioStream

@onready var build_1_player: AudioStreamPlayer = $Build1Player
@onready var build_2_player: AudioStreamPlayer = $Build2Player
@onready var build_3_player: AudioStreamPlayer = $Build3Player

@onready var chase_1_player: AudioStreamPlayer = $Chase1Player
@onready var chase_2_player: AudioStreamPlayer = $Chase2Player
@onready var chase_3_player: AudioStreamPlayer = $Chase3Player

@onready var main_menu: AudioStreamPlayer = $MainMenu

var instance : AudioStreamPlayer

func play_sound(stream: AudioStream, volume: float):
	instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.volume_db = volume
	#instance.bus = bus
	add_child(instance)
	instance.play()
	instance.finished.connect(remove_stream.bind(instance))
	
func remove_stream(inst):
	inst.queue_free()

func play_sound_string(sound: String):
	match sound:
		"click":
			play_sound(ui_click, 0)
		"whoosh":
			play_sound(ui_whoosh, 10)
		"select":
			play_sound(tile_select, 5)
		"rotate":
			play_sound(tile_rotate, 7)
		"explosion":
			play_sound(explosion_main, 15)
			play_sound(explosion_debris, 15)
			play_sound(explosion_accent, 15)
	

func _ready() -> void:
	Global.change_phase.connect(change_phase)


func change_phase():
	if Global.is_tile_select_phase():
		match Global.level:
			1:
				build_1_player.play()
			2:
				build_2_player.play()
			3:
				build_3_player.play()
				
	elif Global.is_chase_phase():
		match Global.level:
			1:
				chase_1_player.play()
			2:
				chase_2_player.play()
			3:
				chase_3_player.play()
