extends Area2D

@onready var weapon: StaticBody2D = $".."
var enemy_num : int = 0
var enemys : Array[Enemy]

func compare(a : Enemy, b : Enemy) -> bool:
	return weapon.position.distance_to(a.position) < weapon.position.distance_to(b.position)
	
func get_closest() -> Enemy:
	enemys.sort_custom(compare)
	return enemys[0]

func _on_area_entered(area: Area2D) -> void:
	enemys.append(area.get_parent())
	#print(area.get_parent())
	#print("enter:", enemys.size())
	enemy_num += 1

func _on_area_exited(area: Area2D) -> void:
	enemys.erase(area.get_parent())
	enemy_num -= 1	
