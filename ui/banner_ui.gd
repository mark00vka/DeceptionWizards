extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var sprite_build: Sprite2D = $SpriteBuild
@onready var sprite_chase: Sprite2D = $SpriteChase

func show_build_now_banner():
	color_rect.show()
	var tween = get_tree().create_tween()
	sprite_build.scale = Vector2.ZERO
	tween.tween_property(sprite_build, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(1).timeout
	color_rect.hide()
	sprite_build.hide()
