extends Node2D
# 旋转速度
@export var rotation_speed = 360
var targets=[]
var rotation_angle
func _process(delta):
	if targets.size()!=0:
		var target_position = find_closest_enemy().global_position
		var direction = target_position - global_position
		rotation_angle = direction.angle()
		rotation = rotation_angle
		
func find_closest_enemy():
	var closest_enemy = null
	var closest_distance = -1
	for target in targets:
		var distance = (target.global_position - global_position).length()
		if closest_distance == -1 or distance < closest_distance:
			closest_distance = distance
			closest_enemy = target
	return closest_enemy		


func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		targets.append(body)


func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		targets.erase(body)
