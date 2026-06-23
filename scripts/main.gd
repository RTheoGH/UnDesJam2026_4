extends Control

@onready var game : PackedScene = preload("res://scenes/game.tscn")
@onready var hs_box = $ScrollContainer/VBoxContainer
var i = 0
var player_list_with_pos = []


func _ready() -> void:
	$AudioStreamPlayer2D.play()
	
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(10).sw_get_scores_complete
	print(sw_result)
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	generate_hs_tab()
	
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_packed(game)

func generate_hs_tab():
	print("tab generated !!")
	for score_data in player_list_with_pos:
		var line_scene = load("res://scenes/HighscoreLine.tscn")
		var line = line_scene.instantiate()
		line.setup_line(score_data["position"],score_data["player_name"],score_data["score"])
		hs_box.add_child(line)


func sort_players_and_add_position(player_list):
	var position = 1
	
	for player in player_list:
		player["position"] = position
		position += 1
		
	return player_list
