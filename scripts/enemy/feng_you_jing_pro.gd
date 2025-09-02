extends FengYouJing

@export var animation_player : AnimationPlayer

func attack_event(delta : float) -> void:
	if((current_health / current_max_health) < 0.5):
		animation_player.play("attack")
