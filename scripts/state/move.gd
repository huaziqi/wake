extends State

func enter_state(): #进入该状态如何处理
	pass

func exit_state(): #退出该状态如何处理
	pass

func update_state(delta): #判断何时需要改变状态
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down") #get_vector可以实现360度方向获取
	if input_vector.length() > 0:
		player.direction = input_vector
		player.last_direction = input_vector
		if(not is_zero_approx(player.direction.x)):
			player.facing_direction = -1 if player.direction.x < 0 else 1
		if(player.graphics and player.graphics.scale.x * player.facing_direction < 0):
			player.graphics.scale.x *= -1
			player.collision_2d.scale.x *= -1

	else:
		player.direction = Vector2.ZERO
		transition_state("idle")
	
func tick_physics(delta): #每一帧要做什么
	if(not animation_player.is_playing()):
		animation_player.play("idle_0")
	var dot = player.direction.normalized().dot(player.velocity.normalized()) #向量的点积
	var acceleration = player.ACCELERATION
	if(dot < -0.8): #如果说速度方向和玩家输入方向反向，将加速度设置为很大，这样会让手感更好，不会漂移
		acceleration = 20000
	#print(player.direction.x)
	player.velocity = player.velocity.move_toward(player.direction * player.MAXSPEED,  acceleration * delta)
	
	player.move_and_slide()

func transition_state(next_state):  #更改状态 
	state_machine.switch_state(self, next_state)
