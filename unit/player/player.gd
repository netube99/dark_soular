extends Area2D

#定义玩家移动速度
@export var speed = 300

#定义屏幕尺寸信息
var screen_size

#玩家信号
signal hit
signal gift()

func _ready() -> void:
	#获得屏幕尺寸数据
	screen_size = get_viewport_rect().size
	#设置玩家待机动画并临时隐藏
	$AnimatedSprite2D.set_animation("idel")
	$AnimatedSprite2D.play()
	hide()

func _process(delta: float) -> void:
	#判断玩家方向键操作并归一化，叠加到坐标属性上
	var velocity = Vector2.ZERO
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	position += velocity.normalized() * speed * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#设置玩家状态动画，待机状态根据玩家的位置切换眼睛方向
	if velocity.length() > 0:
		$AnimatedSprite2D.set_animation("move")
	else: 
		if position.x < screen_size.x / 2:
			$AnimatedSprite2D.flip_h = true
		else: $AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.set_animation("idel")

func start():
	#将玩家坐标回归屏幕中心
	position = screen_size / 2
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	var is_gift = body.get_meta("is_gift")
	if is_gift:
		gift.emit() #发送礼物加分信号
		body.free() #礼物已触发，删除该节点
	else:
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
