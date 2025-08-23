extends Node
@export var bullet:PackedScene
func _on_timer_timeout() -> void:
	var targets=get_parent().targets
	if targets.size()!=0:
		shoot()
func shoot():
	var shooted_bullet=bullet.instantiate()
	shooted_bullet.rotation_angle=get_parent().rotation_angle
	shooted_bullet.base_position=get_parent().global_position
	get_tree().root.get_child(0).add_child(shooted_bullet)

		
