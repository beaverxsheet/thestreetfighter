extends AnimatedSprite

onready var chosen_char = get_node("../").chosen_char

func _ready():
	if chosen_char == 0:
		play("ConnorIdle")
	elif chosen_char == 1:
		play("NiklasIdle")

func playWalk():
	chosen_char = get_node("../").chosen_char
	if chosen_char == 0:
		play("ConnorWalking")
	elif chosen_char == 1:
		play("NiklasWalking")

func playIdle():
	chosen_char = get_node("../").chosen_char
	if chosen_char == 0:
		play("ConnorIdle")
	elif chosen_char == 1:
		play("NiklasIdle")

func playJump():
	chosen_char = get_node("../").chosen_char
	if chosen_char == 0:
		play("ConnorJumping")
	elif chosen_char == 1:
		play("NiklasJumping")

func playBasicAttack():
	chosen_char = get_node("../").chosen_char
	if chosen_char == 0:
		play("ConnorBasicAttack")
	elif chosen_char == 1:
		play("NiklasBasicAttack")
