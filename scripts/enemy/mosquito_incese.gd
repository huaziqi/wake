extends Enemy

@onready var mosquito_incese: CharacterBody2D = $"."

var rotate_rate : float = 100
var begin_rotate_timer : Timer
var rotate_timer : Timer

func _ready() -> void:
	init()
	begin_rotate_timer = Timer.new()
	begin_rotate_timer.one_shot = true
	begin_rotate_timer.wait_time = 1
	add_child(begin_rotate_timer)
	rotate_timer = Timer.new()
	rotate_timer.one_shot = true
	rotate_timer.wait_time = 5
	add_child(rotate_timer)
	begin_rotate_timer.start()
	
	
	begin_rotate_timer.timeout.connect( func():
		rotate_timer.start()
	)

func trace_decision(delta : float) -> void:
	print(begin_rotate_timer.time_left)
	rotate_attack(delta)

func rotate_attack(delta : float) -> void:
	if(rotate_timer.time_left > 0):
		mosquito_incese.rotate(delta * rotate_rate)
		print("rotation", mosquito_incese.rotation)
	elif(rotate_timer.is_stopped() and begin_rotate_timer.is_stopped()):
		begin_rotate_timer.start()
