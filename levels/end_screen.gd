extends Node3D

@onready var winner: Sprite2D = $Winner

func _ready() -> void:
	Global.control.hide()
	if not Global.winner_player1:
		winner.texture = preload("res://ui/player2won.png")
