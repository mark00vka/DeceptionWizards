extends Camera3D

var building_transform: Transform3D
var chase_transform: Transform3D
@onready var camera_pos_2: Camera3D = $"../CameraPos2"

func _ready():
	building_transform = camera_pos_2.transform
	chase_transform = transform
	building()

func building():
	var tween = create_tween()
	tween.tween_property(self, "transform", building_transform, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func chase():
	var tween = create_tween()
	tween.tween_property(self, "transform", chase_transform, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
