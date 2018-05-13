extends PopupPanel

#Close Panel
func _on_CloseCredits_pressed():
	self.hide()

#Show
func _on_Credits_pressed():
	self.popup()
