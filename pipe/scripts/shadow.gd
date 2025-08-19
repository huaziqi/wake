extends Sprite2D
var shadow_distance:float = 1
var alpha:float = 0.45

func _physics_process(delta: float) -> void:
	var parent_position=get_parent().global_position
	global_position.x=parent_position.x
	var ground_y=get_tree().root.get_child(0).get_node("ground").global_position.y
	global_position.y=ground_y
	var distance=parent_position.y-ground_y
	var scale_fix=1+(-distance/300)
	var alpha_fix=1-(-distance/300)*0.5
	global_rotation=0
	z_index=get_parent().z_index-1
	if get_parent().is_in_group("enemies"):
		var size=get_parent().size
		scale=Vector2(size,size)*0.5*scale_fix
	if get_parent().is_in_group("player"):
		scale=Vector2(1,1)*0.5*scale_fix
	modulate.a=alpha*alpha_fix
