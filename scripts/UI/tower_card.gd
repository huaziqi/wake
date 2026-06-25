extends Control
class_name Tower_card
@export var CANNON : PackedScene
@export var player : Player
@onready var color_rect: ColorRect = $Panel/ColorRect

var in_plant : bool = false
var cannon : Node = null
var required_money : int = 2
var enough : bool = false

func _physics_process(delta: float) -> void:
	if(player.money >= required_money):
		color_rect.color = Color(0.761, 0.976, 0.651, 1.0)
		enough = true
	else:
		color_rect.color = Color(0.521, 0.521, 0.521, 1.0)
		enough = false

func init():
	pass

func _ready():
	
	init()

func _on_button_pressed() -> void:
	if(not enough):
		return
	if(in_plant):
		return
	in_plant = true
	cannon = CANNON.instantiate()
	cannon.planted_false.connect(func():
		in_plant = false
		)
	cannon.planted_signal.connect(func():
		in_plant = false
		cannon = null
		player.money -= required_money
		player.money_label.text = str(player.money)
	)
	get_tree().current_scene.add_child.call_deferred(cannon)
