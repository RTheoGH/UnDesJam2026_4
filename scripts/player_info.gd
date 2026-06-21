extends Node

var score: int = 0
var scores_sheet = {}
const FILE_NAME = "user://game-data.bin"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_game()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_score(new_score : int) -> void:
	score = new_score

func reset_game() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(load("res://scenes/end.tscn"))

func add_score(name:String,score:int):
	scores_sheet[name] = score
#
#func save_game():
	#var file = FileAccess.open(FILE_NAME,FileAccess.WRITE)
	#var jstr = JSON.stringify(scores_sheet)
	#
	#file.store_line(jstr)
				#
#
#func load_game():
	#var file = FileAccess.open(FILE_NAME, FileAccess.READ)
	#if not file :
		#return
	#else :
		#while !file.eof_reached():
			#var data_set = Array(file.get_csv_line())
			#scores_sheet[scores_sheet.size()] = data_set
 	#
	#file.close()
