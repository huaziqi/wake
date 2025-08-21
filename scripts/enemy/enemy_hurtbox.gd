extends Area2D

@onready var enemy: Enemy = $".."

func _on_area_entered(area: Area2D) -> void:
	if("current_damage" in area):
		enemy.current_health -= area.current_damage
	if(area.has_method("check_penetrate")):
		area.check_penetrate()
