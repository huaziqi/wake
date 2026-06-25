extends CanvasLayer

signal upgrade_selected(upgrade:AbilityUpgrade)       #形参是能力类
@export var upgrade_card_scene:PackedScene
@export var upgrade_card_scene2:PackedScene
@onready var card_container:HBoxContainer=$%card_container_upgrade
@onready var upgrade_sfx: AudioStreamPlayer = $upgrade_sfx




	 
func _ready():
	get_tree().paused=true        #卡牌出现时，全场暂停
	upgrade_sfx.play()

func set_card_data_ui(upgrades:Array[AbilityUpgrade]):  #实例化卡牌
	var delay=0#卡片生成的时间差
	for upgrade in upgrades:
		var card_instance
		#var card_instance=upgrade_card_scene.instantiate() #实例化卡牌
		#var blue_card=upgrade_card_scene2.instantiate()
		if upgrade.rarity == AbilityUpgrade.Rarity.COMMON:
			card_instance=upgrade_card_scene.instantiate() #实例化卡牌
		elif upgrade.rarity == AbilityUpgrade.Rarity.RARE:
			card_instance=upgrade_card_scene2.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)       #设置数值
		card_instance.play_in(delay)	
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade)) #bind应该是把参数传到前面的函数，应该
		delay+=0.15
		
func on_upgrade_selected(upgrade:AbilityUpgrade):        
	upgrade_selected.emit(upgrade)                  #发出”玩家选择的能力卡牌“这一信号
	upgrade_sfx.stop()
	get_tree().paused=false   #选择卡牌后时间正常流逝
	queue_free()              #清空卡牌
	
