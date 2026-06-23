extends Control
@onready var l_pos: Label = $Panel/HBoxContainer/L_pos
@onready var l_name: Label = $Panel/HBoxContainer/l_name
@onready var l_score: Label = $Panel/HBoxContainer/l_score
@onready var panel: Panel = $Panel

var pos = 1
var player_name = ""
var score = 0



func _ready() -> void:
	var new_stylebox = panel.get_theme_stylebox("panel").duplicate()

	if pos == 1 :
		new_stylebox.border_color = Color.GOLD
	elif pos == 2:
		new_stylebox.border_color = Color.SILVER
	elif pos == 3:
		new_stylebox.border_color = Color.SANDY_BROWN
	panel.add_theme_stylebox_override("panel",new_stylebox)
	
	l_pos.text = str(pos)
	l_name.text = player_name
	l_score.text = str(int(score))
	
	
func setup_line(new_pos,new_name,new_score):
	pos = new_pos
	player_name = new_name
	score = new_score
	
	
func set_border_color(color : Color):
	$Panel.get_theme_stylebox("panel").border_color = color
