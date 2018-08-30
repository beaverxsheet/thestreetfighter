extends Area2D

const INTEGRAL_SPEED = 400

var flyright = true
var hit_ID = null
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
	$AnimatedSprite.play("default")
	
	#Check if item has left screen, delete
	if !$VisibilityNotifier2D.is_on_screen():
		queue_free()

func _on_Sneeze_body_entered(body):
	#If the body/object hit is in the protected list, do nothing
	if body.hit_ID in protected_hit_ID:
		pass
	#If hits parent object, do nothing
	elif body.hit_ID == hit_ID:
		pass
	#If hits enemy/hittable object, reduce its HP
	else:
		body.change_HP(-5)
		if body.do_AID_20:
			own.AID_20_fist()
		queue_free()