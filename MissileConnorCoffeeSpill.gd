extends Area2D

var hit_ID = null
var flyright = true

var protected_hit_ID = [1000]
onready var Box = $CollisionShape2D
onready var Fin = int(Box.scale.x * 100)

func _ready():
	$Timer.start()
	if flyright:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("spilling")
	Box.scale.x = 0


func _physics_process(delta):
	for i in range(0, Fin):
		Box.scale.x = Fin * (i / 100)
		print(i)
	#pass


func _on_Timer_timeout():
	queue_free()


func _on_CoffeeSpill_body_entered(body):
	#If hits parent or protected item, do nothing
	if body.hit_ID == hit_ID or body.hit_ID in protected_hit_ID:
		pass
	#Reduce hittable objects HP
	else:
		body.change_HP(-1)
