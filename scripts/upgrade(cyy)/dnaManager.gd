
extends Node

signal dna_updated(current_dna:float,target_dna:float)
signal level_up(new_level:int)
const TARGET_GROWTH : float = 5           #每一级增加的所需经验量

var current_dna : float = 0 
var current_level=1
var target_dna : float = 1                  #初始化等级，经验，所需经验量

func _ready():	
	Gameevent.dna_collected.connect(on_dna_collected)     
	
func increment_dna(number:float):                       #   更新经验量，如果升级则增加所需的经验量，这个函数主要是处理函数
	current_dna=min(current_dna+number,target_dna)

	dna_updated.emit(current_dna,target_dna)
	if current_dna>=target_dna:
		current_level+=1
		current_dna-=target_dna
		target_dna+=TARGET_GROWTH
		
		dna_updated.emit(current_dna,target_dna)
		level_up.emit(current_level)



func on_dna_collected(number:float):         
	increment_dna(number)

	
 
