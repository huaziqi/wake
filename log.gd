# Log.gd (全局单例)
extends Node

# 1. 定义日志级别
enum Level {
	DEBUG,   # 开发时的琐碎信息（位置、临时变量）
	INFO,    # 游戏正常流程（关卡加载、玩家升级）
	WARN,    # 潜在的问题（资源没加载成功、找不到配置）
	ERROR    # 严重错误（游戏玩不下去了、闪退隐患）
}

# 设置当前允许打印的最低级别（比如开发时设为 DEBUG，上线前设为 WARN）
var current_filter_level: Level = Level.DEBUG

## 打印日常调试日志（仅在开发版本生效）
func debug(module_name: String, message: String):
	if current_filter_level <= Level.DEBUG and OS.is_debug_build():
		print_rich("[color=gray][DEBUG][%s][/color] %s" % [module_name, message])

## 打印重要流程日志
func info(module_name: String, message: String):
	if current_filter_level <= Level.INFO:
		print_rich("[color=green][INFO ][%s][/color] %s" % [module_name, message])

## 打印警告日志
func warn(module_name: String, message: String):
	if current_filter_level <= Level.WARN:
		print_rich("[color=yellow][WARN ][%s][/color] %s" % [module_name, message])
		push_warning("[%s] %s" % [module_name, message])

## 打印错误日志
func error(module_name: String, message: String):
	if current_filter_level <= Level.ERROR:
		print_rich("[color=red][ERROR][%s][/color] [b]%s[/b]" % [module_name, message])
		push_error("[%s] %s" % [module_name, message])
		
## 专用的富文本分割线
func separator(module_name: String, title: String = ""):
	if current_filter_level <= Level.INFO:
		if title == "":
			# 如果没传标题，就画一根纯纯的灰色虚线
			print_rich("[color=gray]------------------------------------------------------------[/color]")
		else:
			# 如果传了标题，就画一根带模块名、有颜色的尊贵分割线
			print_rich("[color=cyan]▶▶▶ [%s] %s ◀◀◀[/color]" % [module_name, title])
