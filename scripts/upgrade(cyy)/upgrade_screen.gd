extends CanvasLayer

signal upgrade_selected(upgrade:AbilityUpgrade)       #形参是能力类
@export var upgrade_card_scene:PackedScene
@onready var card_container:HBoxContainer=$%card_container_upgrade

	 
func _ready():
	get_tree().paused=true        #卡牌出现时，全场暂停

func set_ability_upgrades(upgrades:Array[AbilityUpgrade]):  #实例化卡牌
	for upgrade in upgrades:
		var card_instance=upgrade_card_scene.instantiate() #实例化卡牌
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)       #设置数值
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade)) #bind应该是把参数传到前面的函数，应该

func on_upgrade_selected(upgrade:AbilityUpgrade):        
	upgrade_selected.emit(upgrade)                  #发出”玩家选择的能力卡牌“这一信号
	get_tree().paused=false   #选择卡牌后时间正常流逝
	queue_free()              #清空卡牌
	
