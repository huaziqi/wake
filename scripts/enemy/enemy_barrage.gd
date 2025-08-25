extends StaticBody2D
class_name  enemy_barrage

@export var particles : GPUParticles2D
var velocity : float = 0
var direction : Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	position += velocity * direction
