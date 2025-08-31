extends Area2D
@onready var player: Player = $"../.."

func _on_area_entered(area: Area2D) -> void:
	if("real_damage" in area):
		if(player.current_health == 0):
			return
		player.current_health = max(player.current_health - area.real_damage, 0)
		player.health_update()
