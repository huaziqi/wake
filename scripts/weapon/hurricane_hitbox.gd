extends "res://scripts/weapon/shoot_weapon_hitbox.gd"

func init() -> void:
	base_damage = 0.1

func check_penetrate() -> bool: #返回是否销毁掉了
	return false
