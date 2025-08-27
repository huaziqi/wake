extends StaticBody2D
class_name  enemy_barrage

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var stop_timer: Timer = $StopTimer
@onready var free_timer: Timer = $FreeTimer
@export var particles : GPUParticles2D

var velocity : float = 1
var direction : Vector2 = Vector2(1, 0)

func _ready() -> void:
	stop_timer.start()

func _physics_process(delta: float) -> void:
	position += velocity * direction

func _on_stop_timer_timeout() -> void:
	collision_shape_2d.disabled = true
	particles.emitting = false
	free_timer.start()

func _on_free_timer_timeout() -> void:
	queue_free()
