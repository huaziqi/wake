extends enemy_hitbox
@onready var ghost_2: CharacterBody2D = $"../.."


func _on_area_entered(area: Area2D) -> void:
	ghost_2.current_health = 0
