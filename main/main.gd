extends Node

# 反派登场桀桀桀~
@export var enemy_scene: PackedScene

# 敌人生成频率
var ememy_creat_time:float

# 玩家得分
var score:int = 0

# 奖励生成计数
var gift_count:int = 0

# 游戏音效
var bgm_audio = AudioStreamPlayer.new()
var one_audio = AudioStreamPlayer.new()

func _ready() -> void:
	#加载音频，创建子节点，连接播放完毕信号
	bgm_audio.stream = preload("res://art/House In a Forest Loop.ogg")
	add_child(bgm_audio)
	bgm_audio.finished.connect(_on_bgm_audio_finished)
	add_child(one_audio)
	#bgm_audio.play() #测试BGM无缝循环
	$enemy_timer.stop()
	$start_timer.stop()
	$score_timer.stop()

func new_game():
	score = 0
	$HUD.update_score(score)
	$player.start()
	$start_timer.start()
	bgm_audio.play()

# 玩家受到攻击后返回的信号
func _on_player_hit() -> void:
	$enemy_timer.stop()
	$start_timer.stop()
	$score_timer.stop()
	$HUD.show_game_over()
	bgm_audio.stop()
	one_audio.stream = preload("res://art/gameover.wav")
	one_audio.play()

# 当开始定时器触发时
func _on_start_timer_timeout() -> void:
	ememy_creat_time = 0.8
	$enemy_timer.wait_time = ememy_creat_time
	$enemy_timer.start()
	$score_timer.start()

# 当敌人计时器触发时
func _on_enemy_timer_timeout() -> void:
	# 加载敌人场景
	var enemy = enemy_scene.instantiate()
	
	# 判断本次生成的是敌人还是奖励
	var enemy_or_gift:int = 0 #默认0 生成敌人
	enemy.set_meta("is_gift", 0)
	gift_count += 1
	if gift_count > 8:
		gift_count = 0
		enemy_or_gift = 1
		enemy.set_meta("is_gift", 1) #给敌人场景添加一个礼物标签
		enemy.set
	# 在enemy_path路径上, 随机获取一个位置
	var enemy_spawn_location = $enemy_path/enemy_spawn_Location
	enemy_spawn_location.progress_ratio = randf()
	#敌人场景的位置设置为刚才得到的随机位置
	enemy.position = enemy_spawn_location.position
	#设置敌人的朝向屏幕内部，并设置一个随机的偏移角度，最终角度赋值给敌人
	var direction = enemy_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	#随机生成一个移动速度，并且将速度方向偏转到刚才生成的方向
	var velocity = Vector2(randf_range(150.0, 300.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	# 以混沌之名，深渊的宠儿——『终焉魔眼·阿撒托斯』，为吾撕碎这虚伪的光明吧！降临！
	add_child(enemy)
	if score%10 == 0:
		if ememy_creat_time > 0.2:
			ememy_creat_time -= 0.05
			$enemy_timer.wait_time = ememy_creat_time
			print(ememy_creat_time)

# UI发来开始新游戏信号
func _on_hud_start_game() -> void:
	new_game()

# 分数每秒+1
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

# 玩家触发分数奖励信号
func _on_player_gift() -> void:
	score += randi_range(5, 10)
	$HUD.update_score(score)
	$HUD/score_label.play_combined_effects()
	one_audio.stream = preload("res://art/Rise01.ogg")
	one_audio.play()

# BGM播放完毕触发重新播放
func _on_bgm_audio_finished() -> void:
	bgm_audio.play()
