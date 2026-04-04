extends Label

@export var shake_intensity: float = 2.8
@export var shake_duration: float = 0.2
@export var scale_amount: float = 1.5
@export var scale_duration: float = 0.3
var original_position: Vector2
var is_shaking: bool = false

func _ready():
	original_position = position

func play_combined_effects():
	var tween_scale = create_tween()
	tween_scale.set_trans(Tween.TRANS_BACK)
	tween_scale.set_ease(Tween.EASE_OUT)
	tween_scale.tween_property(self, "scale", Vector2(scale_amount, scale_amount), scale_duration * 0.5)
	tween_scale.tween_property(self, "scale", Vector2.ONE, scale_duration * 0.5)
	await shake_effect()

func shake_effect():
	is_shaking = true
	var elapsed = 0.0
	while elapsed < shake_duration:
		var offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity))
		position = original_position + offset
		elapsed += get_process_delta_time()
		await get_tree().create_timer(0.02).timeout
	position = original_position
	is_shaking = false
