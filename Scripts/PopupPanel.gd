extends PopupPanel

var currShow = null

#Close Panel
func _on_CloseCredits_pressed():
	self.hide()

#Show
func _on_Credits_pressed():
	self.popup()

func _ready():
	currShow = $BasicPTainer
	currShow.show()

func _on_CreditsCont_pressed():
	currShow.hide()
	currShow = $CreditsTainer
	currShow.show()


func _on_BasicP_pressed():
	currShow.hide()
	currShow = $BasicPTainer
	currShow.show()


func _on_Connor_pressed():
	currShow.hide()
	currShow = $ConnorTainer
	currShow.show()


func _on_Niklas_pressed():
	currShow.hide()
	currShow = $NiklasTainer
	currShow.show()


func _on_Anton_pressed():
	currShow.hide()
	currShow = $AntonTainer
	currShow.show()


func _on_Ben_pressed():
	currShow.hide()
	currShow = $BenTainer
	currShow.show()


func _on_Alina_pressed():
	currShow.hide()
	currShow = $AlinaTainer
	currShow.show()


func _on_Eoghan_pressed():
	currShow.hide()
	currShow = $EoghanTainer
	currShow.show()
