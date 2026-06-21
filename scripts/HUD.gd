extends CanvasLayer

@export var score_label : Label
@export var annoncer : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_score(278)
	annoncer.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	score_label.text = "SCORE : " + create_score(PlayerInfo.score)

func create_score(score) -> String:
	var base = ""
	var new_score = str(score)
	for i in 5:
		if i - (4 - (new_score.length() -1)) >= 0:
			base += new_score[i-(4 - (new_score.length() -1))]
		else :
			base += "0"
	return base

@onready var tween:= get_tree().create_tween()

func fade_in(label: String, duration := 0.5):
	var obj = self.get_node(label)
	obj.modulate.a = 0.0
	obj.visible = true
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(obj, "modulate:a", 1.0, duration)
	
func fade_out(obj_name: String, duration := 0.5):
	var obj = self.get_node(obj_name)
	obj.modulate.a = 1.0
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(obj, "modulate:a", 0.0, duration)
	#obj.visible = false

func type_text(label: String, s: String, total_duration := 0.5):
	var obj = self.get_node(label)
	obj.text = s
	obj.visible_characters = 0
	
	if s.length() == 0:
		return
	
	var delay = total_duration / float(s.length())
	
	for i in range(s.length()):
		obj.visible_characters = i + 1
		await get_tree().create_timer(delay).timeout
	
	#emit_signal("text_finished")
