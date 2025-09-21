extends Control


func _on_mainvolslide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)


func _on_musicvolslide_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,value)


func _on_sfxvolslide_3_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,value)


func _on_back_pressed() -> void:
	hide()

func _on_quit_pressed() -> void:
	MusicManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
