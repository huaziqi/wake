extends Node2D
"""
接下来要写的代码，是将按钮与游戏场景连接上
路漫漫其修远兮，吾将上下而求索
"""


func _on_quit_pressed() -> void:  
	get_tree().quit() #点击"QUIT"退出游戏
