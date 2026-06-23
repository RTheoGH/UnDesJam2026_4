extends Control
@onready var text_input = $Panel/LineEdit
@onready var menu : PackedScene = preload("res://scenes/main.tscn")
@onready var http_request = $HTTPRequest
@onready var error_panel: Panel = $Panel/ERRORPanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/Label3.text = str(PlayerInfo.score)
	if PlayerInfo.score == 99999:
		error_panel.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	PlayerInfo.player_name = text_input.text
	var sw_result : Dictionary = await SilentWolf.Scores.save_score(PlayerInfo.player_name, PlayerInfo.score).sw_save_score_complete
	print("Score persisted succesfully : " + str(sw_result.score_id))
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))
	pass # Replace with function body.


func _on_line_edit_text_changed(new_text: String) -> void:
	pass

func _on_button_3_button_down() -> void:
	get_tree().change_scene_to_packed(menu)


func _on_button_2_button_down() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
