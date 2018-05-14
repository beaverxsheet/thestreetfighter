extends Control


#Main scene preloaded into constant
const WORLD_SCENE = preload("res://Scenes/World.tscn")

#Continue (go back to game scene)
func _on_Continue_pressed():
	self.hide()
	get_tree().paused = false

#Quit
func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Control.tscn")
	#get_tree().quit()
