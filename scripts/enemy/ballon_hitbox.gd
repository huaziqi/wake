extends enemy_hitbox

@export var ballon : Node

func _on_area_entered(area: Area2D) -> void:
	ballon.current_health = 0
