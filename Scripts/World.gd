extends Node

#Open Popup
func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = true
		get_node("PauseMenu").popup()
		get_node("PauseMenu/VBoxContainer/Label").text = "Paused !!1!"
		get_node("PauseMenu/VBoxContainer/Continue").show()
	if get_node("Player").current_HP <= 0 or  get_node("Player2").current_HP <= 0:
		get_tree().paused = true
		get_node("PauseMenu").popup()
		get_node("PauseMenu/VBoxContainer/Label").text = "You Win !!1!"
		get_node("PauseMenu/VBoxContainer/Continue").hide()

#Make sure that the game runs when the popup is closed
func _on_PauseMenu_popup_hide():
	get_tree().paused = false
