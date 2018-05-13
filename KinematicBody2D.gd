extends KinematicBody2D

onready var hit_ID = 2

#Set initial HP
var current_HP = 10

func _process(delta):
	#Upon death, hide
	if current_HP <= 0:
		hide()
		$CollisionShape2D.disabled = true
	
	#Display data
	$VBoxContainer/HP_Label.text = "HP: " + str(current_HP)
	
	
#Change HP by given value (value is set by whoever calls it)
func change_HP(variance):
	current_HP = current_HP + variance