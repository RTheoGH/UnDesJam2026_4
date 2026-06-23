extends Node

var score = 0
var player_name : String
var player_list = []
const FILE_NAME = "user://game-data.bin"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SilentWolf.configure({
		"api_key": "Cy1nUMiF6X5vGwCs62EM22TQMC4hMrI73tDCfwyt",
		"game_id": "Despioneer",
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/main.tscn"
	})
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	leaderboard()
	
func leaderboard() -> void:
	for score in PlayerInfo.score:
		PlayerInfo.player_list.append(PlayerInfo.player_name)

func set_score(new_score : int) -> void:
	score = new_score

func reset_game() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(load("res://scenes/end.tscn"))

#func add_score(name:String,score:int):
	#scores_sheet[name] = score
#
	
