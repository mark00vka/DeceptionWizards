extends Camera3D

var building_transform: Transform3D
var chase_transform: Transform3D
@onready var building_camera: Camera3D = $"../BuildingCamera"


func _ready():
	building_transform = building_camera.transform
	chase_transform = transform
	building()

func building():
	var tween = create_tween()
	tween.tween_property(self, "transform", building_transform, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func chase():
	var tween = create_tween()
	tween.tween_property(self, "transform", chase_transform, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
