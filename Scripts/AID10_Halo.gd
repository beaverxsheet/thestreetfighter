extends Area2D

func _ready():
	$Timer.start()

func _process(delta):
	if $Timer.time_left == 0:
		queue_free()