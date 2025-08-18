extends Node
class_name  State
#状态模板函数

var state_machine : StateMachine
var animation_player: AnimationPlayer
var player : Player

func _ready() -> void:
	animation_player = $"../../AnimationPlayer";
	state_machine = $"..";
	player = $"../..";

func enter_state(): #进入该状态如何处理
	pass
	
func exit_state(): #退出该状态如何处理
	pass
	
func update_state(delta): #判断何时需要改变状态
	pass
	
func tick_physics(delta): #每一帧要做什么
	pass

func transition_state(next_state):  #更改状态 
	state_machine.switch_state(self, next_state)
