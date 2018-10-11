extends Control

#AutoloadNode: can be accessed from ALL scenes
#To pass information from menu to scenes

var stream2 = load("res://Sounds/Music/SID_39.wav")

#Main scene preloaded into constant
const WORLD_SCENE = preload("res://Scenes/World.tscn")

func _ready():
	$MusicPlayer.play()
	get_node("/root/AutoloadNode").music = 0

func _process(delta):
	get_node("/root/AutoloadNode").music_pos = $MusicPlayer.get_playback_position()

#When start button is pressed, set character to selection (from optionbutton) & load scene
func _on_BeginButton_pressed():
	AutoloadNode.choose_char[0] = $VBoxContainer/OptionButton.selected
	AutoloadNode.choose_char[1] = $VBoxContainer/OptionButton2.selected
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_MusicPlayer_finished():
	$MusicPlayer.stream = stream2
	$MusicPlayer.play()
	get_node("/root/AutoloadNode").music = 0
