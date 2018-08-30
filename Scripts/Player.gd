extends KinematicBody2D

#latency
var latency = 0 #in ticks (s/60) (doesnt work on all systems, idk why)

#some things for the latency to work
var time = 0 #time var
var dotimes = {} #times to do things time:"command" (dictionary)
var tbf = 0 #time before

#Declaring Constants
const UP = Vector2(0, -1)
const GRAV = 20
const SPEED = 200
const JUMP_HEIGHT = -500
var hit_ID = 1

#Import Winebottle missile
const WINEBOTTLE_SCENE = preload("res://Scenes/WineBottle.tscn")
const INTEGRAL_SCENE = preload("res://Scenes/MissileAntonIntegrate.tscn")
const COFFEE_SCENE = preload("res://Scenes/MissileConnorCoffeeSpill.tscn")
const AID_1_SNEEZE_SCENE = preload("res://Scenes/AID1SneezeScene.tscn")
const AID_10_HALO_SCENE = preload("res://Scenes/AID10_Halo.tscn")
const AID_18_ZERO_SCENE = preload("res://Scenes/AID18_Zero.tscn")
const AID_18_ONE_SCENE = preload("res://Scenes/AID18_One.tscn")

#Motion var. Altered to represent direction and speed of travel.
var motion = Vector2()

#Setting variables
var can_shoot = true
var current_HP = 10
var looks_right = true
var basic_range = false
var AID_9_range = false
var AID_9_inRange = null
var in_basic_range = null
var Asprite = null
var firstJump = true
var doubleSpeedNiklas = false
var isStunned = false

var CooldownA1 = float(0)
var CooldownA2 = float(0)
var CooldownA3 = float(0)
var CooldownA4 = float(0)
var CooldownA5 = float(0)

var insults
var errorInsults = ["Error"]

var up_key = ""
var right_key = ""
var left_key = ""
var AB_1_key = ""
var AB_2_key = ""
var At_key = ""
var Ulti_key = ""
var ins_key = ""

onready var CoolLabelA1 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability1/Label")
onready var CoolLabelA2 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability2/Label")
onready var CoolLabelA3 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability3/Label")
onready var CoolLabelA4 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability4/Label")
onready var CoolLabelA5 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability5/Label")

onready var myHP_Label = get_node("../HUD/Row/Player1_Cols/Player1_HP/HP_P1")
onready var myHP_Gauge = get_node("../HUD/Row/Player1_Cols/Player1_HP/HPGauge_P1")
onready var myINT_Label = get_node("../HUD/Row/Player1_Cols/Player1_INT/INT_P1")
onready var myINT_Gauge = get_node("../HUD/Row/Player1_Cols/Player1_INT/INTGauge_P1")

onready var myAbility1 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability1")
onready var myAbility2 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability2")
onready var myAbility3 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability3")
onready var myAbility4 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability4")
onready var myAbility5 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability5")

var ab0 = preload("res://Sprites/GUI/Icons/Icon00.png")
var ab1 = preload("res://Sprites/GUI/Icons/Icon01.png")
var ab2 = preload("res://Sprites/GUI/Icons/Icon02.png")
var ab3 = preload("res://Sprites/GUI/Icons/Icon03.png")
var ab4 = preload("res://Sprites/GUI/Icons/Icon04.png")
var ab5 = preload("res://Sprites/GUI/Icons/Icon05.png")
var ab6 = preload("res://Sprites/GUI/Icons/Icon06.png")
var ab7 = preload("res://Sprites/GUI/Icons/Icon07.png")
var ab8 = preload("res://Sprites/GUI/Icons/Icon08.png")
var ab9 = preload("res://Sprites/GUI/Icons/Icon09.png")
var ab10 = preload("res://Sprites/GUI/Icons/Icon10.png")
var ab11 = preload("res://Sprites/GUI/Icons/Icon11.png")
var ab12 = preload("res://Sprites/GUI/Icons/Icon12.png")
var ab13 = preload("res://Sprites/GUI/Icons/Icon13.png")
var abID_18 = preload("res://Sprites/GUI/Icons/AID_18_logo.png")
var abID_20 = preload("res://Sprites/GUI/Icons/AID20_Icon.png")

export var PID = 0
onready var chosen_char = AutoloadNode.choose_char[PID]

var enemy
var p_name

var first_run = true
var d_latency = 0
func _ready():
	if PID == 0:
		myAbility1 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability1")
		myAbility2 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability2")
		myAbility3 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability3")
		myAbility4 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability4")
		myAbility5 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability5")
		
		myHP_Label = get_node("../HUD/Row/Player1_Cols/Player1_HP/HP_P1")
		myHP_Gauge = get_node("../HUD/Row/Player1_Cols/Player1_HP/HPGauge_P1")
		myINT_Label = get_node("../HUD/Row/Player1_Cols/Player1_INT/INT_P1")
		myINT_Gauge = get_node("../HUD/Row/Player1_Cols/Player1_INT/INTGauge_P1")
		
		CoolLabelA1 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability1/Label")
		CoolLabelA2 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability2/Label")
		CoolLabelA3 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability3/Label")
		CoolLabelA4 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability4/Label")
		CoolLabelA5 = get_node("../HUD/Row/Player1_Cols/Player1_ABL/Ability5/Label")
		
		up_key = "key_up"
		right_key = "key_right"
		left_key = "key_left"
		At_key = "Attack"
		AB_1_key = "Ability1"
		AB_2_key = "Ability2"
		Ulti_key = "AbilityUlti"
		hit_ID = 1
		ins_key = "Insult"
		
		enemy = get_node("../Player2")
		#print(hit_ID)
	else:
		myAbility1 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability1")
		myAbility2 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability2")
		myAbility3 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability3")
		myAbility4 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability4")
		myAbility5 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability5")
		myAbility5 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability5")
		
		myHP_Label = get_node("../HUD/Row/Player2_Cols/Player2_HP/HP_Player2")
		myHP_Gauge = get_node("../HUD/Row/Player2_Cols/Player2_HP/HPGauge_P2")
		myINT_Label = get_node("../HUD/Row/Player2_Cols/Player2_INT2/INT_Player2")
		myINT_Gauge = get_node("../HUD/Row/Player2_Cols/Player2_INT2/INTGauge_P2")
		
		CoolLabelA1 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability1/Label")
		CoolLabelA2 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability2/Label")
		CoolLabelA3 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability3/Label")
		CoolLabelA4 = get_node("../HUD/Row/Player2_Cols/Player2_ABL/Ability4/Label")
		
		up_key = "key_upP2"
		right_key = "key_rightP2"
		left_key = "key_leftP2"
		At_key = "AttackP2"
		AB_1_key = "Ability1P2"
		AB_2_key = "Ability2P2"
		Ulti_key = "AbilityUltiP2"
		hit_ID = 2
		ins_key = "InsultP2"
		enemy = get_node("../Player")


#Setting Timer Function, called within the main loop
func playerDependentCooldowns():
	if Asprite == $AntonSprite:
		CooldownA1 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA2 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA3 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA4 = $PlayerSpecificCooldowns/AID_4
		CooldownA5 = $PlayerSpecificCooldowns/Anton_4Cooldown
	elif Asprite == $ConnorSprite:
		CooldownA1 = $BasicAttackCooldown
		CooldownA2 = $PlayerSpecificCooldowns/AID_0
		CooldownA3 = $PlayerSpecificCooldowns/AID_11
		CooldownA4 = $PlayerSpecificCooldowns/AID_1
		CooldownA5 = $PlayerSpecificCooldowns/AID_8
	elif Asprite == $BenSprite:
		CooldownA1 = $BasicAttackCooldown
		CooldownA2 = $PlayerSpecificCooldowns/AID_18
		CooldownA3 = $PlayerSpecificCooldowns/AID_19
		CooldownA4 = $PlayerSpecificCooldowns/AID_20
		CooldownA5 = $PlayerSpecificCooldowns/AID_17
	elif Asprite == $NiklasSprite:
		CooldownA1 = $BasicAttackCooldown
		CooldownA2 = $PlayerSpecificCooldowns/AID_10
		CooldownA3 = $PlayerSpecificCooldowns/AID_12
		CooldownA4 = $PlayerSpecificCooldowns/AID_7
		CooldownA5 = $PlayerSpecificCooldowns/AID_13
	else:
		CooldownA1 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA2 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA3 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA4 = $PlayerSpecificCooldowns/Anton_4Cooldown
		CooldownA5 = $PlayerSpecificCooldowns/Anton_4Cooldown
	CoolLabelA1.text = str(int(CooldownA1.time_left*10))
	CoolLabelA2.text = str(int(CooldownA2.time_left*10))
	CoolLabelA3.text = str(int(CooldownA3.time_left*10))
	CoolLabelA4.text = str(int(CooldownA4.time_left*10))
	CoolLabelA5.text = str(int(CooldownA5.time_left*10))

#Check which sprite to show (in a function, called later)
func chooseSprite():
	if chosen_char == 0:
		$NiklasSprite.hide()
		$AntonSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab2
		myAbility2.texture = ab0
		myAbility3.texture = ab11
		myAbility4.texture = ab1
		myAbility5.texture = ab8
		
		p_name = "Conner"
		
		return $ConnorSprite
	elif chosen_char == 1:
		$ConnorSprite.hide()
		$AntonSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab2
		myAbility2.texture = ab10
		myAbility3.texture = ab12
		myAbility4.texture = ab7
		myAbility5.texture = ab13
		
		p_name = "Niklas"
		
		return $NiklasSprite
	elif chosen_char == 2:
		$ConnorSprite.hide()
		$NiklasSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab2
		myAbility2.texture = ab5
		myAbility3.texture = ab6
		myAbility4.texture = ab4
		myAbility5.texture = ab9
		
		p_name = "Anton"
		return $AntonSprite
	elif chosen_char == 3:
		$ConnorSprite.hide()
		$NiklasSprite.hide()
		$AntonSprite.hide()
		
		myAbility1.texture = ab2
		myAbility2.texture = abID_18
		myAbility3.texture = ab2
		myAbility4.texture = abID_20
		myAbility5.texture = ab2
		
		p_name = "Ben"
		return $BenSprite


#Movement func called between frames
func _physics_process(delta):
	
	#update time (delta is the time between each tick in s)
	time += int(delta * 1000)
	#call the latency function
	do_latency(time)
	#Effect Connors Stupidity Cyclic Function AID_8 Passive
	if Asprite == $ConnorSprite:
		AID_8(time)
	#Natural resistance to stupidity
	else:
		if latency > 0:
			#pass
			d_latency += 0.4
			#print(d_latency)
			if d_latency >= 1:
				latency -= 1
				d_latency = 0
	#Effect Antons AID_9 Passive
	if((Asprite == $AntonSprite) && AID_9_range):
		AID_9_inRange.change_INT(1)
	#Effect STUN
	if $PlayerSpecificCooldowns/AID_10_StunDuration.is_stopped():
		isStunned = false
		$StunStarSprite.hide()
	else:
		isStunned = true
		dotimes[time] = "stop"
		$StunStarSprite.show()
		$StunStarSprite.play("spin")
	
	tbf = time #set time before
	
	#Gravity
	#check y movement then allow gravity
	if not is_on_floor():
		motion.y += GRAV
	
	#checking which sprite to show
	#Asprite = necessary sprite
	Asprite = chooseSprite()
	Asprite.show()
	
	#Horizontal movement: right
	if Input.is_action_pressed(right_key) && !isStunned:
		dotimes[time + latency] = "right"
	#Horizontal movement: left
	elif Input.is_action_pressed(left_key) && !isStunned:
		dotimes[time + latency] = "left"
	#If BasicA cooldown timer is on, then the animation should run
	elif $BasicAttackCooldown.time_left > 0:
		dotimes[time + latency] = "stopc"
	else:
		dotimes[time + latency] = "stop"

	#Ability 1 (Winebottle for now), everyone is eligible
	#if(Input.is_action_just_pressed("Ability1") && ($MissileCooldown.time_left == 0) && !isStunned):
	#	dotimes[time + latency] = "ability1"
	#	$MissileCooldown.start()
	
	
	#AID4, Anton Ultimate, Integral 
	if(Input.is_action_just_pressed(Ulti_key) && ($PlayerSpecificCooldowns/AID_4.time_left == 0)
	&& (Asprite == $AntonSprite) && !isStunned):
		dotimes[time + latency] = "AID_4"
		$PlayerSpecificCooldowns/AID_4.start()

	#AID0, Connor Primary, Coffeespill
	if(Input.is_action_just_pressed(AB_1_key) && ($PlayerSpecificCooldowns/AID_0.time_left == 0)
	&& (Asprite == $ConnorSprite) && !isStunned):
		dotimes[time + latency] = "AID_0"
		$PlayerSpecificCooldowns/AID_0.start()

	#AID1, Connor Ultimate, Manly Sneeze
	if(Input.is_action_just_pressed(Ulti_key) && (Asprite == $ConnorSprite) &&
	($PlayerSpecificCooldowns/AID_1.time_left == 0) && !isStunned):
		dotimes[time + latency] = "AID_1"
		$PlayerSpecificCooldowns/AID_1.start()
		
	#AID12, Niklas Secondary, E-Bike
	if((Input.is_action_just_pressed(AB_2_key)) && (Asprite == $NiklasSprite)
	&& ($PlayerSpecificCooldowns/AID_12.time_left == 0) && !isStunned):
		dotimes[time + latency] = "AID_12"
		$PlayerSpecificCooldowns/AID_12.start()
		
	#AID10, Niklas Primary, Sweet Melody
	if((Input.is_action_just_pressed(AB_1_key)) && (Asprite == $NiklasSprite)
	&& ($PlayerSpecificCooldowns/AID_10.time_left == 0) && !isStunned):
		dotimes[time + latency] = "AID_10"
		$PlayerSpecificCooldowns/AID_10.start()
	
	#AID18, Ben Primary, I Know Programming
	if(Input.is_action_just_pressed(AB_1_key) && (Asprite == $BenSprite)
	&& ($PlayerSpecificCooldowns/AID_18.time_left == 0) && !isStunned):
		dotimes[time + latency] = "AID_18"
		$PlayerSpecificCooldowns/AID_18.start()

	#BASIC ATTACK all. Only if an object is in basic attack range and if the cooldown is 0		
	if(Input.is_action_just_pressed(At_key) && ($BasicAttackCooldown.time_left == 0) && basic_range && !isStunned):
		dotimes[time + latency] = "attack"
		$BasicAttackCooldown.start()

	#If on the floor, allow for jumps
	if is_on_floor():
		if Input.is_action_just_pressed(up_key) && !isStunned:
			dotimes[time + latency] = "jump"
			firstJump = true
	# Niklas Doublejump
	elif((Asprite == $NiklasSprite) && firstJump && Input.is_action_just_pressed(up_key)):
		firstJump = false
		dotimes[time + latency] = "jump"
	else:
		#Sprite and anim
		Asprite.play("Jumping")

	if Input.is_action_just_pressed(ins_key):
		insult(insults)

	#Put movement into actual action
	move_and_slide(motion, UP)

	#Communication with the HUD
	myHP_Label.text = "(" + str(current_HP) + "/10)"
	myHP_Gauge.value = current_HP
	myINT_Label.text = str(int(latency/100))
	myINT_Gauge.value = latency
	
	#Set cooldowns
	playerDependentCooldowns()

	#modulate opacity to show cooldown
	myAbility1.modulate.a = abs(CooldownA1.wait_time-CooldownA1.time_left)/CooldownA1.wait_time
	myAbility2.modulate.a = abs(CooldownA2.wait_time-CooldownA2.time_left)/CooldownA2.wait_time
	myAbility3.modulate.a = abs(CooldownA3.wait_time-CooldownA3.time_left)/CooldownA3.wait_time
	myAbility4.modulate.a = abs(CooldownA4.wait_time-CooldownA4.time_left)/CooldownA4.wait_time
	myAbility5.modulate.a = abs(CooldownA5.wait_time-CooldownA5.time_left)/CooldownA5.wait_time
	
	#if you want to use shaders to achieve this use the code below and put the Ability_material.tres into all sprites you use. Doesnt work on sprites with alpha
	#myAbility1.shader.set("shader_param/opac", abs(1 - CooldownA1))
	#myAbility2.shader.set("shader_param/opac", abs(1 - CooldownA2))
	#myAbility3.shader.set("shader_param/opac", abs(1 - CooldownA3))
	#myAbility4.shader.set("shader_param/opac", abs(1 - CooldownA4))
	#myAbility5.shader.set("shader_param/opac", abs(1 - CooldownA5))
	
	if $PlayerSpecificCooldowns/AID_10_StunDuration.is_stopped():
		isStunned = false
		$StunStarSprite.hide()
	else:
		isStunned = true
		$StunStarSprite.show()
		$StunStarSprite.play("spin")
	
	if first_run and enemy.p_name != null:
		if enemy.p_name == "Conner":
			insults = load_insults("Connor.txt")
			first_run = false
		elif enemy.p_name == "Niklas":
			insults = load_insults("Niklas.txt")
			first_run = false
		elif enemy.p_name == "Anton":
			insults = load_insults("Anton.txt")
			first_run = false
		elif enemy.p_name == "Ben":
			insults = load_insults("Ben.txt")
			first_run = false
		else:
			print("error" + enemy.p_name)
		
	#debug key
	if Input.is_action_pressed("ui_select"):
		pass
	
#Create Winebottle to throw
func create_WineBottle():
	#Instance the winebottle
	var winebottle = WINEBOTTLE_SCENE.instance()
	get_parent().add_child(winebottle)
	winebottle.hit_ID = hit_ID
	winebottle.set_position(get_node("Position2D").global_position)
	#Check for direction player is facing, pass information on to child
	if looks_right:
		winebottle.flyright = true
	else:
		winebottle.flyright = false



#AID4, Anton Ultimate, Integral
func create_Integral():
	var integral = INTEGRAL_SCENE.instance()
	get_parent().add_child(integral)
	integral.hit_ID = hit_ID
	integral.set_position(get_node("Position2D").global_position)
	#Check for direction player is facing, pass information on to child
	if looks_right:
		integral.flyright = true
	else:
		integral.flyright = false

#AID0, Connor Primary, Coffee Spill
func create_ConnorCoffeeSpill():
	print("HO:"+str(hit_ID))
	var coffee = COFFEE_SCENE.instance()
	get_parent().add_child(coffee)
	coffee.hit_IDE = hit_ID
	coffee.set_position($Position2D.global_position)
	if looks_right:
		coffee.flyright = true
	else:
		coffee.flyright = false

#Checking if basic attach possible (enemy within rangebox)
func _on_BasicAttackArea_body_entered(body):
	#Ignore own body
	if(body.hit_ID == hit_ID or body.hit_ID == 1000):
		pass
	else:
		basic_range = true
		print("entered body " + str(body.hit_ID))
		in_basic_range = body

#Upon enemy leaving basic attack rangebox
func _on_BasicAttackArea_body_exited(body):
	print("left body " +  str(body.hit_ID))
	in_basic_range = null
	basic_range = false
	
#Relevant for AID_9, Anton Passive
func _on_AID_9Effector_body_entered(body):
	#Ignore own body
	if(body.hit_ID == hit_ID or body.hit_ID == 1000):
		pass
	else:
		AID_9_range = true
		AID_9_inRange = body

#Relevamt for AID_9, Anton Passive
func _on_AID_9Effector_body_exited(body):
	AID_9_inRange = null
	AID_9_range = false

#AID8, Connor Passive, Ingenious ...?
func AID_8(time):
	self.latency = int((cos(float(float(time)/3000))*150)+152)
	#pass

#AID1, Connor Ultimate, Manly Sneeze
func AID_1():
	var sneeze = AID_1_SNEEZE_SCENE.instance()
	get_parent().add_child(sneeze)
	sneeze.hit_ID = hit_ID
	sneeze.set_position(get_node("Position2D").global_position)
	if looks_right:
		sneeze.flyright = true
	else:
		sneeze.flyright = false

#AID12, Niklas Secondary, E-Bike
func AID_12():
	$PlayerSpecificCooldowns/AID_12_runtime.start()

#AID10, Niklas Primary, Sweet Melody
func AID_10():
	enemy.done_AID_10()

func done_AID_10():
	$PlayerSpecificCooldowns/AID_10_StunDuration.start()
	#get_node("../Enemy").done_AID_10()
	var halo = AID_10_HALO_SCENE.instance()
	get_parent().add_child(halo)
	halo.set_position(get_node("Position2D").global_position)
	
#AID18, Ben Primary, I Know Programming
func AID_18():
	randomize()
	var childnums_z = []
	for i in range(0, 8):
		var xloc = int(rand_range(0, 512))
		childnums_z.append(AID_18_ZERO_SCENE.instance())
		get_parent().add_child(childnums_z[i])
		childnums_z[i].hit_ID = hit_ID
		childnums_z[i].set_position(Vector2(xloc,50))
	randomize()
	var childnums_o = []
	for i in range(0, 6):
		var xloc = int(rand_range(0, 512))
		childnums_o.append(AID_18_ONE_SCENE.instance())
		get_parent().add_child(childnums_o[i])
		childnums_o[i].hit_ID = hit_ID
		childnums_o[i].set_position(Vector2(xloc,50))

func load_insults(filename):
	var outlist = []
	var insult_file = File.new()
	if not insult_file.file_exists("res://Insults/" + filename):
		return errorInsults
		print("Error: No file called res://Insults/" + filename)
	insult_file.open("res://Insults/" + filename, File.READ)
	while not insult_file.eof_reached():
		var current_line = insult_file.get_line()
		outlist.append(str(current_line))
	insult_file.close()
	return outlist

func insult(insults_l):
	var ins = insults_l[randi()%(len(insults_l))+0]
	$Insult_Label.text = ins
	$Insult_timer.start()
	pass

func do_latency(time):
	#for every milisecond between the last and this tick
	for i in range(tbf, int(time + 1), 1):
		#see if dotimes has that millisecond
		if dotimes.has(i):
			#find which command was put in the dictionary for this time
			if dotimes[i] == "right":
				#Relevant for AID_12 Niklas E-Bike
				if((Asprite == $NiklasSprite)
				&& ($PlayerSpecificCooldowns/AID_12_runtime.is_stopped() == false)):
					motion.x = SPEED*2
					Asprite.play("Bicycle")
				else:
					motion.x = SPEED
					Asprite.play("Walking")
				#Flip sprite into right direction
				Asprite.flip_h = false
				#Important for missiles (should fly into the correct direction)
				looks_right = true
			if dotimes[i] == "left":
				#Relevant for AID_12 Niklas E-Bike
				if((Asprite == $NiklasSprite)
				&& ($PlayerSpecificCooldowns/AID_12_runtime.is_stopped() == false)):
					motion.x = -SPEED*2
					Asprite.play("Bicycle")
				else:
					motion.x = -SPEED
					Asprite.play("Walking")
				#Flip sprite into right direction
				Asprite.flip_h = true
				#Play walking animation
				#Important for missiles (should fly into the correct direction)
				looks_right = false
			if dotimes[i] == "stopc":
				Asprite.play("BasicA")
				motion.x = 0
			if dotimes[i] == "stop":
				motion.x = 0
				#Sprite and anim
				Asprite.play("Idle")
			if dotimes[i] == "ability1":
				create_WineBottle() #Create bottle (see function)
			if dotimes[i] == "AID_4":
				create_Integral() #Create bottle (see function)
			if dotimes[i] == "AID_0":
				create_ConnorCoffeeSpill() #Create coffee spill see function
			if dotimes[i] == "attack":
				in_basic_range.change_HP(-1)
			if dotimes[i] == "jump":
				motion.y = JUMP_HEIGHT
			if dotimes[i] == "AID_1":
				AID_1()
			if dotimes[i] == "AID_12":
				AID_12()
			if dotimes[i] == "AID_10":
				AID_10()
			if dotimes[i] == "AID_18":
				AID_18()
				
			dotimes.erase(i)

func _on_Insult_timer_timeout():
	$Insult_Label.text = ""

#Stun test
func _on_Button_pressed_STUN():
	$PlayerSpecificCooldowns/AID_10_StunDuration.start()
	
func change_HP(variance):
	current_HP = current_HP + variance

func change_INT(variance):
	if latency <= 500:
		latency = latency + variance
