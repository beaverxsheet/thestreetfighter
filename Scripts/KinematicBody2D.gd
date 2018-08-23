extends KinematicBody2D

onready var hit_ID = 2

onready var myHP_Label = get_node("../HUD/Row/Player2_Cols/Player2_HP/HP_Player2")
onready var myHP_Gauge = get_node("../HUD/Row/Player2_Cols/Player2_HP/HPGauge_P2")
onready var myINT_Label = get_node("../HUD/Row/Player2_Cols/Player2_INT2/INT_Player2")
onready var myINT_Gauge = get_node("../HUD/Row/Player2_Cols/Player2_INT2/INTGauge_P2")

#Set initial HP
var current_HP = 10
var disp_HP = '10'

#latency
var latency = 0 #in ticks (s/60)

func _process(delta):
	#Upon death, hide
	if current_HP <= 0:
		hide()
		$CollisionShape2D.disabled = true
		
	#Lower latency (natural resistance)
	if latency > 0:
		latency = latency - 0.4
	
	if current_HP < 10:
		disp_HP = '0' + str(current_HP)
	
	#Display data
	myHP_Label.text = "(" + disp_HP + "/10)"
	myHP_Gauge.value = current_HP
	
	myINT_Label.text = str(int(latency/100))
	myINT_Gauge.value = latency
	
	
#Change HP by given value (value is set by whoever calls it)
func change_HP(variance):
	current_HP = current_HP + variance
	
func change_INT(variance):
	if latency <= 500:
		latency = latency + variance