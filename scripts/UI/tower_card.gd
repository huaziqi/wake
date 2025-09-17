extends Control

var Cannon = preload("res://scenes/cannon_test/cannon.tscn")

var in_plant : bool = false
var cannon : Node = null

func _on_button_pressed() -> void:
	if(in_plant):
		return
	in_plant = true
	cannon = Cannon.instantiate()
	cannon.planted_signal.connect(func():
		in_plant = false
		cannon = null
	)
	get_tree().current_scene.add_child.call_deferred(cannon)
