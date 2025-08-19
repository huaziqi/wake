extends StaticBody2D
class_name HandKnife

signal hand_knife_finish()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hand_knife_finish.emit()
