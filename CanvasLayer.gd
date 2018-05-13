extends CanvasLayer

#Setting variables
onready var Player = get_node("../Player")
onready var Enemy = get_node("../Enemy")

#Change label texts (essentially update UI)
func _process(delta):
	$VisionDirection.text = "Character ID: " + str(get_node("../Player").chosen_char)
	$Cooldown.text = "Cooldown: " + str(get_node("../Player/BasicAttackCooldown").time_left)