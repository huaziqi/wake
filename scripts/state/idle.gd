extends State

func enter_state(): #进入该状态如何处理
	#if(player.graphics and player.graphics.scale.x * player.facing_direction < 0):
		#player.graphics.scale.x *= -1
	pass
	
func exit_state(): #退出该状态如何处理
	if(animation_player.current_animation == "idle_1"):
		animation_player.play("idle_0")
	
func update_state(delta): #判断何时需要改变状态
	if(Input.get_vector("move_left", "move_right", "move_up", "move_down").length() > 0): #向量的模大于0
		transition_state("move")
	
func tick_physics(delta):
	if(not animation_player.is_playing()): 
		var posi = randf();
		if(posi < 0.1): #随机眨眼
			animation_player.play("idle_1")
		else:
			animation_player.play("idle_0")

func transition_state(next_state):  #更改状态 /或者用发送信号实现，可以不需要这个函数？/先用着吧
	state_machine.switch_state(self, next_state)
