extends Node
#Cy1nUMiF6X5vGwCs62EM22TQMC4hMrI73tDCfwyt

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "Cy1nUMiF6X5vGwCs62EM22TQMC4hMrI73tDCfwyt",
		"game_id": "",
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"opne_scene_on_configure": "res://scenes/main.tscn"
	})

func _physics_process(delta: float) -> void:
	leaderboard()
	
func leaderboard():
	for 
