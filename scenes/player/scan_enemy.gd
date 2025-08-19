extends Area2D

var enemy_num : int = 0
signal player_meet_enemy(int)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if(enemy_num > 0):
		player_meet_enemy.emit(enemy_num)
		
func _on_area_entered(area: Area2D) -> void:
	enemy_num += 1

func _on_area_exited(area: Area2D) -> void:
	enemy_num -= 1
