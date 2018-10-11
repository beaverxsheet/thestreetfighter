extends Node

const MUSICNBR = 2
var stream1 = load("res://Sounds/Music/SID_40.wav")
var stream2 = load("res://Sounds/Music/SID_39.wav")
export var play_music = false

var p1
var p2

func _ready():
	#stream1 = preload("res://Sounds/Music/BeepBox-Song.wav")
	#stream2 = preload("res://Sounds/Music/BeepBox-Song2.wav")
	p1 = $Player
	p2 = $Player2
	if get_node("/root/AutoloadNode").music == 0:
		$MusicPlayer.stream = stream1
	else:
		$MusicPlayer.stream = stream2
	$MusicPlayer.play(get_node("/root/AutoloadNode").music_pos)
#Open Popup
func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = true
		get_node("PauseMenu").popup()
		get_node("PauseMenu/VBoxContainer/Label").text = "Paused !!1!"
		get_node("PauseMenu/VBoxContainer/Continue").show()
	if get_node("Player").current_HP <= 0 or  get_node("Player2").current_HP <= 0:
		var winner
		if get_node("Player").current_HP <= 0:
			winner = get_node("Player2").p_name
			$VicSound.stream = get_node("Player2").vic_s
			$VicSound.play()
		else:
			winner = get_node("Player").p_name
			$VicSound.stream = get_node("Player").vic_s
			$VicSound.play()
		get_tree().paused = true
		get_node("PauseMenu").popup()
		get_node("PauseMenu/VBoxContainer/Label").text = "You Win !!1! " + winner
		get_node("PauseMenu/VBoxContainer/Continue").hide()
	
	#if not $MusicPlayer.playing && play_music:
	#	randomize()
	#	var pl = rand_range(0,100)
	#	#print(pl)
	#	if pl >= 50:
	#		$MusicPlayer.stream = stream1
	#		#print("1")
	#	else:
	#		$MusicPlayer.stream = stream2
	#		#print("2")
	#	$MusicPlayer.playing = true
	#	pass
	#if Input.is_action_just_pressed("ui_select"):
	#	pass
#Make sure that the game runs when the popup is closed
func _on_PauseMenu_popup_hide():
	get_tree().paused = false


func _on_MusicPlayer_finished():
	$MusicPlayer.stream = stream2
	$MusicPlayer.play()
