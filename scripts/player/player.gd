extends CharacterBody2D
class_name Player

@onready var graphics: Node2D = $graphics
@onready var collision_2d: CollisionPolygon2D = $CollisionPolygon2D

const ACCELERATION := 9000
const MAXSPEED := 500
const MAX_HEALTH := 100

var direction : Vector2 = Vector2.DOWN
var last_direction : Vector2 = Vector2.DOWN #记录最后一次的位置
var facing_direction : int = 1 # 1表示右边，-1表示左边
var push_force := 50.0 #推力
var current_health : int

func _ready() -> void:
	add_to_group("player")
	current_health = MAX_HEALTH
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	z_index = 99 # 保证显示在大部分图片上方
	
