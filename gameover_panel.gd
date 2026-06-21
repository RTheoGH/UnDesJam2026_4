extends Control
@onready var text_input = $Panel/LineEdit
@onready var menu : PackedScene = preload("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/Label3.text = str(PlayerInfo.score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	print("enregistrer")
	PlayerInfo.add_score(text_input.text,PlayerInfo.score)
	#PlayerInfo.save_game()
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))
	pass # Replace with function body.


func _on_line_edit_text_changed(new_text: String) -> void:
	if PlayerInfo.scores_sheet.has(new_text) :
		$Panel/Button.disabled = true
	else :
		$Panel/Button.disabled = false


func _on_button_3_button_down() -> void:
	get_tree().change_scene_to_packed(menu)


func _on_button_2_button_down() -> void:
	get_tree().quit()
