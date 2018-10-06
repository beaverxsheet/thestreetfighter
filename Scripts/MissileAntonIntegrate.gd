extends Area2D

const INTEGRAL_SPEED = 300

var flyright = true
var hit_ID = null
var returnflight = false

var own

var protected_hit_ID = [1000]

func _process(delta):
	var speed_x = 1
	#Take var flyright from Main Scene (Player), determine direction of flight
	if !flyright:
		speed_x = -1
	var speed_y = 0
	var motion = Vector2(speed_x, speed_y)*INTEGRAL_SPEED
	self.position = self.position + motion*delta
	$AnimatedSprite.play("flying")
	
	#Check if item has left screen
	if !$VisibilityNotifier2D.is_on_screen():
		#If leaves viewport (first time), place back into viewport, flip direction of travel
		if !returnflight:
			if flyright:
				self.position = self.position + Vector2(-30, 0)
				flyright = false
				returnflight = true
			else:
				self.position = self.position + Vector2(30,0)
				flyright = true
				returnflight = true
		#Second time leaving viewport, delete
		else:
			queue_free()

func _on_Integrate_body_entered(body):
	#If the body/object hit is in the protected list, do nothing
	if body.hit_ID in protected_hit_ID:
		pass
	#If hits parent object for the first time, do nothing
	elif body.hit_ID == hit_ID and !returnflight:
		pass
	#If hits parent object on the return flight, delete itself
	elif body.hit_ID == hit_ID and returnflight:
		queue_free()
	#If hits enemy/hittable object, reduce its HP
	else:
		body.change_HP(-40)
		if body.do_AID_20:
			own.AID_20_fist()
		queue_free()

