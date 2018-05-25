extends Area2D

var hit_ID = null
var flyright = true

var protected_hit_ID = [1000]

var bod
var pos = self.position.x
var rang = 0

var off = false

func _ready():
	$Timer.start()
	$HitTimer.start()
	if flyright:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("spilling")


func _on_Timer_timeout():
	queue_free()

func _physics_process(delta):
	pos = self.position.x

func _on_CoffeeSpill_body_entered(body):
	#If hits parent or protected item, do nothing
	if body.hit_ID == hit_ID or body.hit_ID in protected_hit_ID:
		pass
	#Reduce hittable objects HP
	else:
		bod = body


func _on_HitTimer_timeout():
#called every 0.01 sec
	
	rang += 4
	
	if not bod == null and not off:
		if bod.position.x <= pos:
			if bod.position.x >= pos - rang:
				bod.change_HP(-1)
				off = true
		else:
			if bod.position.x <= pos + rang:
				bod.change_HP(-1)
				off = true
