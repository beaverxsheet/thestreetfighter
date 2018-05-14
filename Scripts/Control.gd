extends Control

#AutoloadNode: can be accessed from ALL scenes
#To pass information from menu to scenes

#Main scene preloaded into constant
const WORLD_SCENE = preload("res://Scenes/World.tscn")

#When start button is pressed, set character to selection (from optionbutton) & load scene
func _on_BeginButton_pressed():
	AutoloadNode.choose_char = $VBoxContainer/OptionButton.selected
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_Quit_pressed():
	get_tree().quit()
