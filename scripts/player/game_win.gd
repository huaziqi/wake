extends Control

@export var win_sfx : AudioStream

func _ready() -> void:
		MusicManager.play_sfx(win_sfx)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test_scene.tscn")

func _on_quit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
