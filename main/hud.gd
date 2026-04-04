extends CanvasLayer

signal start_game

func _ready() -> void:
	$company/version.text = "V" + ProjectSettings.get_setting("application/config/version")

# 游戏结束显示
func show_game_over():
	$message_label.text = "YOU DIED"
	$message_label.show()
	$message_timer.start()
	await $message_timer.timeout
	$message_label.text = "Dark Soular"
	$message_label.show()
	$company.show()
	await get_tree().create_timer(2.0).timeout
	$start_button.show()

# 更新玩家分数
func update_score(score):
	$score_label.text = str(score)

func _on_start_button_pressed() -> void:
	$start_button.hide()
	$message_label.hide()
	$company.hide()
	start_game.emit()
