extends Area2D
var base_position : Vector2
var base_damage : float = 100000000 #基础伤害
var current_damage : float #现在的伤害
@export var rotation_angle:float
var move_dir
@export var bullet_speed:float=50
func _ready() -> void:
	add_to_group("cannon")
	global_position=base_position
	current_damage = base_damage
	rotation=rotation_angle
	move_dir=Vector2.from_angle(rotation_angle).normalized()
func _physics_process(delta: float) -> void:
	position+=move_dir*bullet_speed
	
func _on_timer_timeout() -> void:
	queue_free()
