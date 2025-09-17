extends Area2D
@onready var player: Player = $"../.."
@onready var hurt_particles: GPUParticles2D = $hurt
@export var hurt_sound : AudioStream
var in_hurt : bool = false

func _on_area_entered(area: Area2D) -> void:
	if("real_damage" in area):
		if(player.current_health == 0):
			return
		player.current_health = max(player.current_health - area.real_damage, 0)
		if(not in_hurt):
			hurt_particles.emitting = true
			in_hurt = true
			MusicManager.play_sfx(hurt_sound)
			get_tree().create_timer(1, false).timeout.connect( func():
				hurt_particles.emitting = false
				in_hurt = false
				)
		player.health_update()
