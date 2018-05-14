extends Area2D

const WINEBOTTLE_SPEED = 300

var flyright = true
var hit_ID = null

var protected_hit_ID = [1000]

func _process(delta):
	var speed_x = 1
	#Take var flyright from Main Scene (Player), determine direction of flight
	if !flyright:
		speed_x = -1
	var speed_y = 0
	var motion = Vector2(speed_x, speed_y)*WINEBOTTLE_SPEED
	self.position = self.position + motion*delta
	$AnimatedSprite.play("flying")
	
	#Check if item has left screen
	if !$VisibilityNotifier2D.is_on_screen():
		queue_free()


func _on_WineBottle_body_entered(body):
	#Do nothing if hits parent or protected object
	if body.hit_ID == hit_ID or body.hit_ID in protected_hit_ID:
		pass
	#Delete itself upon hitting something hittable. Also reduces objects HP
	else:
		queue_free()
		body.change_HP(-1)
