extends Resource
class_name  AbilityUpgrade    #能力类

enum Rarity {
	COMMON,      # 普通
	RARE,        # 稀有
	EPIC,        # 史诗
	LEGENDARY    # 传说
}
enum AbilityType {
	BUFF,        # 增益类
	WEAPON,      # 武器类
	SUMMON       # 召唤物类
}

@export var id:String           #描述
@export var name:String
@export_multiline var description:String


# --- 新增的分类属性 ---
@export var rarity: Rarity = Rarity.COMMON          # 默认是普通品质
@export var ability_type: AbilityType = AbilityType.BUFF # 默认是增益类
@export var prerequisites: Array[String] = []
@export var max_chosen_time:int 
