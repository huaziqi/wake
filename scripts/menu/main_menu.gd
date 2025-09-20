extends Control
"""
接下来要写的代码，是将按钮与游戏场景连接上
路漫漫其修远兮，吾将上下而求索
"""
const TEST_SCENE = preload("uid://c1wko1rfba2e7")

func _on_quit_pressed() -> void:  
	get_tree().quit() #点击"QUIT"退出游戏

func _on_begin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test_scene.tscn")
