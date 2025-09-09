extends Control
class_name NextWaveController

@export var next_wave_show: Control
@export var next_wave_button: Button
@export var rest_time: Label

signal next_wave_start

func _on_button_pressed() -> void:
	next_wave_button.hide()
	next_wave_start.emit()

func current_wave_show(wave_num : int) -> void:
	next_wave_show.show_wave(wave_num)
	
func current_wave_stop(wave_num: int) -> void:
	next_wave_button.show()
