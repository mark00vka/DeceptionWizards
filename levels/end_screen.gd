extends Node3D

@onready var winner: Sprite2D = $Winner

func _ready() -> void:
	Global.control.hide()
	if Global.drawing:
		winner.texture = preload("res://ui/titles/draw.png")
	if not Global.winner_player1:
		winner.texture = preload("res://ui/player2won.png")


func _on_replay_pressed() -> void:
	SoundManager.play_sound_string("click")
	Global.starting_screen = false
	get_tree().change_scene_to_file("res://levels/main.tscn")
