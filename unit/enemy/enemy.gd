extends RigidBody2D

func _ready() -> void:
	if self.get_meta("is_gift") == 1:
		$AnimatedSprite2D.animation = "gift"
	else:
		# 从动画列表中选择一个随机动画
		var enemy_types = "type%d" % randi_range(1, 3)
		$AnimatedSprite2D.animation = enemy_types
	$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
