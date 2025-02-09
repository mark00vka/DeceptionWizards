extends Node

@onready var build_1_player: AudioStreamPlayer = $Build1Player
@onready var build_2_player: AudioStreamPlayer = $Build2Player
@onready var chase_1_player: AudioStreamPlayer = $Chase1Player
@onready var chase_2_player: AudioStreamPlayer = $Chase2Player
@onready var stop_player: AudioStreamPlayer = $StopPlayer
@onready var transition: AudioStreamPlayer = $Transition

func _ready() -> void:
	Global.change_phase.connect(change_phase)

func change_phase():
	if Global.is_tile_select_phase():
		match Global.level:
			1:
				build_1_player.play()
			2:
				transition.play()
				await transition.finished
				build_2_player.play()
			3:
				pass
				
	elif Global.is_chase_phase():
		match Global.level:
			1:
				await stop_player.finished
				chase_1_player.play()
			2:
				transition.play()
				await transition.finished
				chase_2_player.play()
			3:
				pass


func _on_build_1_player_finished() -> void:
	stop_player.play()
