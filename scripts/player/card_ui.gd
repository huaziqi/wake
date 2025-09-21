extends CanvasLayer

@onready var control_2: Control = $Control2

func _on_button_pressed() -> void:
	control_2.show()
