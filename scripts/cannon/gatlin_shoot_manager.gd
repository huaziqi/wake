extends Cannon_Shooter


var bullet_num : int = 3
var gun_height : float = 60

func shoot():
	var basic_y = cannon.global_position.y - gun_height
	for i in range(bullet_num):
		var shooted_bullet=bullet.instantiate()
		get_tree().current_scene.add_child.call_deferred(shooted_bullet)
		shooted_bullet.rotation_angle = get_parent().rotation_angle
		shooted_bullet.base_position = get_parent().global_position
		shooted_bullet.base_position.y = basic_y
		basic_y += gun_height / bullet_num
