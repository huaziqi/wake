extends Area2D
class_name enemy_hurtbox

@export var enemy: Enemy
var area_name : String = "hurt_box"

func hurt_event(area: Area2D) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if("real_damage" in area):
		hurt_event(area)
		enemy.current_health -= area.real_damage
		enemy.health_update()
	if(area.has_method("check_penetrate")):
		area.check_penetrate()
