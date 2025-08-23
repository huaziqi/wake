extends Area2D

@export var enemy: Enemy


func _on_area_entered(area: Area2D) -> void:
	if("real_damage" in area):
		enemy.current_health -= area.real_damage
		enemy.health_update()
	if(area.has_method("check_penetrate")):
		area.check_penetrate()
