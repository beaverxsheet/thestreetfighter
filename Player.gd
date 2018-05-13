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
const JUMP_HEIGHT = -550
const hit_ID = 1

#Import Winebottle missile
const WINEBOTTLE_SCENE = preload("res://WineBottle.tscn")
const INTEGRAL_SCENE = preload("res://MissileAntonIntegrate.tscn")
const COFFEE_SCENE = preload("res://MissileConnorCoffeeSpill.tscn")

#Motion var. Altered to represent direction and speed of travel.
var motion = Vector2()

#Setting variables
var can_shoot = true
var current_HP = 10
var looks_right = true
var basic_range = false
var in_basic_range = null
var Asprite = null

var CooldownA1 = float(0)
var CooldownA2 = float(0)
var CooldownA3 = float(0)
var CooldownA4 = float(0)
var CooldownA5 = float(0)

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

onready var chosen_char = AutoloadNode.choose_char

#Check which sprite to show (in a function, called later)
func chooseSprite():
	if chosen_char == 0:
		$NiklasSprite.hide()
		$AntonSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab0
		myAbility2.texture = ab1
		myAbility3.texture = ab8
		myAbility4.texture = ab11
		#myAbility5.texture = "res://jjswjw"
		return $ConnorSprite
	elif chosen_char == 1:
		$ConnorSprite.hide()
		$AntonSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab7
		myAbility2.texture = ab10
		myAbility3.texture = ab12
		myAbility4.texture = ab13
		#myAbility5.texture = "res://jjswjw"
		return $NiklasSprite
	elif chosen_char == 2:
		$ConnorSprite.hide()
		$NiklasSprite.hide()
		$BenSprite.hide()
		
		myAbility1.texture = ab4
		myAbility2.texture = ab5
		myAbility3.texture = ab6
		myAbility4.texture = ab9
		#myAbility5.texture = "res://jjswjw"
		return $AntonSprite
	elif chosen_char == 3:
		$ConnorSprite.hide()
		$NiklasSprite.hide()
		$AntonSprite.hide()
		
		#:-(
		#myAbility1.texture = ab188888
		#myAbility2.texture = ab188888
		#myAbility3.texture = ab188888
		#myAbility4.texture = ab188888
		#myAbility5.texture = ab188888
		return $BenSprite


#Movement func called between frames
func _physics_process(delta):
	
	#update time (delta is the time between each tick in s)
	time += int(delta * 1000)
	#call the latency function
	do_latency(time)
	tbf = time #set time before
	
	#Gravity
	motion.y += GRAV
	
	#checking which sprite to show
	#Asprite = necessary sprite
	Asprite = chooseSprite()
	Asprite.show()
	
	#Horizontal movement: right
	if Input.is_action_pressed("key_right"):
		dotimes[time + latency] = "right"
	#Horizontal movement: left
	elif Input.is_action_pressed("key_left"):
		dotimes[time + latency] = "left"
	#If BasicA cooldown timer is on, then the animation should run
	elif $BasicAttackCooldown.time_left > 0:
		dotimes[time + latency] = "stopc"
	else:
		dotimes[time + latency] = "stop"

	#Ability 1 (Winebottle for now), everyone is eligible
	if(Input.is_action_just_pressed("Ability1") && ($MissileCooldown.time_left == 0)):
		dotimes[time + latency] = "ability1"
		$MissileCooldown.start()

	#Ability 2 (Integral) ONLY Anton
	if(Input.is_action_just_pressed("Ability2") && ($PlayerSpecificCooldowns/Anton_4Cooldown.time_left == 0) && (Asprite == $AntonSprite)):
		dotimes[time + latency] = "ability2A"
		$PlayerSpecificCooldowns/Anton_4Cooldown.start()
		
	if(Input.is_action_just_pressed("Ability2") && ($PlayerSpecificCooldowns/Anton_4Cooldown.time_left == 0) && (Asprite == $ConnorSprite)):
		dotimes[time + latency] = "ability2C"
		$PlayerSpecificCooldowns/Anton_4Cooldown.start()
		
	#Basic attack, all. Only if an object is in basic attack range and if the cooldown is 0		
	if(Input.is_action_just_pressed("Attack") && ($BasicAttackCooldown.time_left == 0) && basic_range):
		dotimes[time + latency] = "attack"
		$BasicAttackCooldown.start()
		
	#If on the floor, allow for jumps
	if is_on_floor():
		if Input.is_action_just_pressed("key_up"):
			dotimes[time + latency] = "jump"
	else:
		#Sprite and anim
		Asprite.play("Jumping")
	
	#Put movement into actual action
	move_and_slide(motion, UP)
	
	#Communication with the HUD
	myHP_Label.text = "(" + str(current_HP) + "/10)"
	myHP_Gauge.value = current_HP
	myINT_Label.text = str(int(latency/100))
	myINT_Gauge.value = latency
	
	#TODO:Change timer
	CooldownA1 = $PlayerSpecificCooldowns/Anton_4Cooldown.time_left
	CooldownA2 = $PlayerSpecificCooldowns/Anton_4Cooldown.time_left
	CooldownA3 = $PlayerSpecificCooldowns/Anton_4Cooldown.time_left
	CooldownA4 = $PlayerSpecificCooldowns/Anton_4Cooldown.time_left
	CooldownA5 = $PlayerSpecificCooldowns/Anton_4Cooldown.time_left
	
	CoolLabelA1.text = str(int(CooldownA1*10))
	CoolLabelA2.text = str(int(CooldownA2*10))
	CoolLabelA3.text = str(int(CooldownA3*10))
	CoolLabelA4.text = str(int(CooldownA4*10))
	CoolLabelA5.text = str(int(CooldownA5*10))
	
	#Passives
	if Asprite == $ConnorSprite:
		AID_8(time)
	
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

#Create Anton's integral
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

#Create Conners spill 

func create_ConnorCoffeeSpill():
	var coffee = COFFEE_SCENE.instance()
	get_parent().add_child(coffee)
	coffee.hit_ID = hit_ID
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

#Connors Passive AID 8 (intelligence is a cyclic function)
func AID_8(time):
	self.latency = (cos(float(float(time)/3000))*150)+152

func do_latency(time):
	#for every milisecond between the last and this tick
	for i in range(tbf, time + 1, 1):
		#see if dotimes has that millisecond
		if dotimes.has(i):
			#find which command was put in the dictionary for this time
			if dotimes[i] == "right":
				motion.x = SPEED
				#Flip sprite into right direction
				Asprite.flip_h = false
				#Play walking animation
				Asprite.play("Walking")
				#Important for missiles (should fly into the correct direction)
				looks_right = true
			if dotimes[i] == "left":
				#definde motion vector for left
				motion.x = -SPEED
				#Flip sprite into right direction
				Asprite.flip_h = true
				#Play walking animation
				Asprite.play("Walking")
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
			if dotimes[i] == "ability2A":
				create_Integral() #Create bottle (see function)
			if dotimes[i] == "ability2C":
				create_ConnorCoffeeSpill() #Create bottle (see function)
			if dotimes[i] == "attack":
				in_basic_range.change_HP(-1)
			if dotimes[i] == "jump":
				motion.y = JUMP_HEIGHT
				
			dotimes.erase(i)