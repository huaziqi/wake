extends FengYouJing

@onready var sprite_2d: Sprite2D = $graphics/Sprite2D
@export var animation_player : AnimationPlayer
@export var dead_particles : GPUParticles2D
@export var hit_collision : CollisionShape2D
@export var hurt_collision : CollisionShape2D
@export var dead_damage_area : CollisionShape2D
@onready var damage_area_notice : Sprite2D = $graphics/hitbox/Sprite2D

func attack_event(delta : float) -> void:
	if((current_health / current_max_health) < 0.5):
		animation_player.play("attack")

func dead_damage() -> void: #亡语
	animation_player.stop()
	damage_area_notice.visible = true
	sprite_2d.visible = false
	dead_particles.emitting = true
	hurt_collision.disabled = true
	hit_collision.disabled = true
	dead_damage_area.disabled = false
	await get_tree().create_timer(2, false).timeout
	queue_free()
