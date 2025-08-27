extends Control

var Cannon = preload("res://scenes/cannon_test/cannon.tscn")

func _on_button_pressed() -> void:
	var cannon = Cannon.instantiate()
	get_tree().current_scene.add_child.call_deferred(cannon)
	
	print(get_global_mouse_position())
