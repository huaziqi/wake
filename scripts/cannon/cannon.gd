extends Node2D
# 旋转速度
@export var rotation_speed = 360
var targets=[]
func _process(delta):
	if targets.size()!=0:
		var target_position = find_closest_enemy().global_position
		var direction = target_position - global_position
		var rotation_angle = direction.angle()
		rotation = rotation_angle

func _on_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		targets.append(area)
		


func _on_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		targets.erase(area)
		
func find_closest_enemy():
	var closest_enemy = null
	var closest_distance = -1
	for target in targets:
		var distance = (target.global_position - global_position).length()
		if closest_distance == -1 or distance < closest_distance:
			closest_distance = distance
			closest_enemy = target
			print("fuck")
	return closest_enemy		
