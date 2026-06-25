extends Cannon_Shooter


var bullet_num : int = 3
var gun_height : float = 60

func shoot():
	if(!cannon):
		return
	var basic_y = cannon.global_position.y - gun_height
	for i in range(bullet_num):
		var shooted_bullet=bullet.instantiate()
		get_tree().current_scene.add_child.call_deferred(shooted_bullet)
		shooted_bullet.rotation_angle = cannon.rotation_angle
		shooted_bullet.base_position = cannon.global_position
		shooted_bullet.hitbox.real_damage *= 0.5
		shooted_bullet.bullet_speed *= 1.5
		shooted_bullet.base_position.y = basic_y
		basic_y += gun_height / bullet_num
