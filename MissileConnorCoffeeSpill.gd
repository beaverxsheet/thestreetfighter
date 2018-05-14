extends Area2D

var hit_ID = null
var flyright = true

var protected_hit_ID = [1000]
onready var Box = $CollisionShape2D
onready var Fin = int(Box.scale.x*100)
var n = 0

func _ready():
	$Timer.start()
	$HitTimer.start()
	if flyright:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("spilling")
	#set hitbox to 0
	Box.scale.x = 0


func _on_Timer_timeout():
	queue_free()


func _on_CoffeeSpill_body_entered(body):
	#If hits parent or protected item, do nothing
	if body.hit_ID == hit_ID or body.hit_ID in protected_hit_ID:
		pass
	#Reduce hittable objects HP
	else:
		body.change_HP(-1)


func _on_HitTimer_timeout():
	#called every 0.01 seconds
	if n/30 >= 1:
		#make sure hitbox isn't larger than original hitbox
		pass
	else:
		#scale hitbox
		Box.scale.x = float(n)/30
		n += 1
