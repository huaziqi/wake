extends StaticBody2D
class_name Master

@export var interaction_icon : AnimatedSprite2D
@export var blood_bar : TextureProgressBar
@export var eased_bar : TextureProgressBar
@export var recover_timer : Timer
@export var sleep_area: Area2D

var current_sleepness : float
var max_sleepness : float = 100

const MAX_BLOOD : float = 20
var current_blood : float
var current_max_blood : float
var in_recover : bool #正在回血
var recover_rate : float = 60 #回血速率
var empty_blood : bool = false

func init() -> void:
	current_max_blood = MAX_BLOOD
	current_blood = current_max_blood
	interaction_icon.visible = false
	
func _ready() -> void:
	init()
	current_sleepness = max_sleepness
	recover_timer.timeout.connect(func(): #回血冷却结束，开始回血
		in_recover = true
	)

func _on_blood_area_area_entered(area: Area2D) -> void:
	interaction_icon.visible = true

func _on_blood_area_area_exited(area: Area2D) -> void:
	interaction_icon.visible = false

func blood_update() -> void: #更新血条状态
	var percent = current_blood / current_max_blood
	if(percent == 0.0 and not empty_blood):
		empty_blood = true
		current_sleepness = max(0, current_sleepness - 0.2 * max_sleepness)
		sleep_area.sleepness_update()
	if(percent != 0):
		empty_blood = false
	blood_bar.value = percent
	create_tween().tween_property(eased_bar, "value", percent, 0.1)

func _physics_process(delta: float) -> void:
	if(in_recover):
		current_blood = min(current_blood + delta * recover_rate, current_max_blood)
		blood_update()

func _on_bomb_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
