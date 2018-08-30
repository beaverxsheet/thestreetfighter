extends Area2D

var acc = 10
var speed = 0
var own
var one_shot = true
func _physics_process(delta):
	speed += acc * delta
	position.y += speed
	position.x = own.position.x
	
	if position.y >= 260 && one_shot:
		speed = 0
		acc = 0
		$Timer.start()
		one_shot = false
		
	print($Timer.time_left)
func _on_Timer_timeout():
	queue_free()
