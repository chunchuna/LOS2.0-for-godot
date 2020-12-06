extends Node
# consoleMain.gd
var console_active =false
onready var console_ui =get_tree().get_root().find_node("Console",true,false).get_node("ConsoleBox")
onready var weaponNode =get_tree().get_root().find_node("weaponNode",true,false)

func _ready():
	#print(console_ui)
	Console.add_command("weapon:change",self,"Weapon_CHANGE").set_description("更换当前装备中的武器").add_argument("weaponString",TYPE_STRING).register()
	Console.add_command("weapon:bulletMax",self,"Weapon_BULLET_MAX").set_description("无限子弹").register()
	Console.add_command("mod:get_mod_list",self,"mod_get_mod_list").set_description("获取mod列表").register()
	Console.add_command("characterAI:reback",self,"rebackCharacterAI").set_description("重置所有AI玩家").register()
	Console.add_command("characterAI:StopMovement",self,"stopCharacterAImove").set_description("停止AI玩家的移动").register()
	Console.add_command("debug:drawtarge",self,"debugdraw").set_description("开关AIdebug模式").add_argument("quest",TYPE_STRING).register()
	
	Console.connect("click_meta",self,"click_meta")
	pass

func _process(delta):

	console_active=console_ui.visible
	pass

# func --------------------------

# weapon @@ 

func Weapon_CHANGE(weaponString):
	
	# 更换当前武器

	var data =WeaponData.weaponString

	if data.has(weaponString):
		weaponNode.weapon_name=weaponString
		weaponNode.LoadWeaponData() # 重新读取数据 
		Console.write_line("已更改当前武器")
	else:
		Console.write_line('数据库找不到此武器')
		Console.write_line(data)	
	#print("data",data)


	
func Weapon_BULLET_MAX():
	# 子弹无限
	WeaponData.allBulletNumber = 99999
	Console.write_line("已修改子弹")
	pass
	
	
	
# 方法

func mod_get_mod_list():
	
	# get mod list
	var mod_system =get_tree().get_root().find_node("modSystem",true,false)
	var mod_list_ =mod_system.mod_list
	Console.write_line("[b][shake rete=10 level=10]### MOD LIST ###[/shake]")
	if mod_list_.size()>0:
			
		for i in mod_list_.keys().size():
			var mod_name=mod_list_ [mod_list_.keys()[i]]["name"]
			Console.write_line("[color=yellow][url="+mod_name+"]"+mod_name+"[/url]")
			pass
	else:
		Console.write_line("you do not have any mods...")		
	pass


func rebackCharacterAI():
	
	# reback ai position
	for characterAI in get_tree().get_nodes_in_group("characterAI"):
		characterAI.position=characterAI.homePosition
		bug.log("console","已经初始化AI玩家",false)
		

	pass


func stopCharacterAImove ():
	
	# stop ai movementsa
	
	for characterAI in get_tree().get_nodes_in_group("characterAI"):
		if ! characterAI.stopMovement:
			characterAI.stopMovement=true
			characterAI.moveVec=Vector2.ZERO
		else:
			characterAI.stopMovement=false	

	bug.log("console","已经转换AI的移动状态",false)	
	
	pass


func debugdraw (quest="null"):
	 
	# AI debugDraw target
	for debugg in get_tree().get_nodes_in_group("debugDrawGroup"):
		print(debugg)
		Console.write_line("正在修改debug状态")
		if debugg.debugDraw:
			debugg.debugDraw=false
		else:
			debugg.debugDraw=true
			# 参数

			# --enbleLine 导航条绘制
			# --enbleCbox cbox绘制
			if quest=="enbleLine":
				debugg.isDrawLine=true
				pass
			if quest=="enbleCbox":
				debugg.isDrawCbox=true
				pass		
	
	
	
	pass
# CKICK META
	
func click_meta(meta):
	for mods in get_tree().get_nodes_in_group("mods"):
		print("点击了Mod")
		if mods.name_==meta:
			mods.active=!mods.active
			Console.write_line("切换mod状态，当前状态是"+str(mods.active))
		pass
	pass	
	
