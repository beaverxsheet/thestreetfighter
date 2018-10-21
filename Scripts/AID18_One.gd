extends Area2D

var hit_ID = null
var protected_hit_ID = [1000]
var speed = 200

func _ready():
	randomize()
	speed = int(rand_range(80, 300))

func _process(delta):
	var motion = Vector2(0, 1)*speed
	self.position = self.position + motion*delta
	if !$VisibilityNotifier2D.is_on_screen():
		queue_free()


func _on_Area2D_body_entered(body):
	#If the body/object hit is in the protected list, do nothing
	if body.hit_ID in protected_hit_ID:
		pass
	#If hits parent object for the first time, do nothing
	elif body.hit_ID == hit_ID:
		pass
	#If hits enemy/hittable object, reduce its HP
	else:
		queue_free()
		body.change_HP(-4, false)
