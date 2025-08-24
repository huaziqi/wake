extends Area2D

@export var player : Player

var get_blood_rate : float = 500 #吸血速率
var in_blood_area : bool = false 
var master : Master = null

func _on_area_entered(area: Area2D) -> void:
	if("area_name" in area and area.area_name == "blood_area" and "master" in area):
		master = area.master
		in_blood_area = true

func _on_area_exited(area: Area2D) -> void:
	if(area.area_name == "blood_area"):
		in_blood_area = false
		if(master):
			master.recover_timer.start()
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("interact") and in_blood_area):
		var increase_blood = min(master.current_blood, delta * get_blood_rate) #防止血被吸成负数
		increase_blood = min(player.current_max_health - player.current_health, increase_blood)
		#print("increase_blood : ", increase_blood)
		if(increase_blood != 0):
			master.in_recover = false
			master.recover_timer.stop()
			master.current_blood -= increase_blood
			master.blood_update()
			player.current_health += increase_blood
			player.health_update()
		
