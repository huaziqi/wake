extends StaticBody2D
class_name Master

@export var interaction_icon : AnimatedSprite2D
@export var blood_bar : TextureProgressBar
@export var eased_bar : TextureProgressBar
@export var recover_timer : Timer

const MAX_BLOOD : float = 200.0
var current_blood : float
var current_max_blood : float
var in_recover : bool #正在回血
var recover_rate : float = 100 #回血速率

func init() -> void:
	current_max_blood = MAX_BLOOD
	current_blood = current_max_blood
	interaction_icon.visible = false
	
func _ready() -> void:
	init()
	recover_timer.timeout.connect(func(): #回血冷却结束，开始回血
		in_recover = true
	)

func _on_blood_area_area_entered(area: Area2D) -> void:
	interaction_icon.visible = true

func _on_blood_area_area_exited(area: Area2D) -> void:
	interaction_icon.visible = false

func blood_update() -> void: #更新血条状态
	var percent = current_blood / current_max_blood
	blood_bar.value = percent
	create_tween().tween_property(eased_bar, "value", percent, 0.3)

func _physics_process(delta: float) -> void:
	if(in_recover):
		current_blood = min(current_blood + delta * recover_rate, current_max_blood)
		blood_update()
