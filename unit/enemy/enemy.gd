extends RigidBody2D

func _ready() -> void:
	# 从动画列表中选择一个随机动画
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
