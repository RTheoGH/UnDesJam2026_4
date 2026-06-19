extends RigidBody2D

var orbites : Dictionary
#structure du dico {"planete" : [9.0,pos,lore]} 

var velocity := Vector2(0.0,0.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_force(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_central_force(velocity)
	
#itère à travers orbites et ajoute leur influences à la force principale
func calculate_attractions() -> Vector2:
	var force = Vector2(0.0,0.0) 
	
	for i in orbites.keys():
		var orbite = orbites[i]
		var dir = (orbite[1] - global_position).normalized()
		force = (force + dir * orbite[0]) 
	return force

#Ajoute l'orbite traversé au dictionaire "orbites" avec le nom en keys et les infos en values
func _on_detection_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	#On check le type d'area traversé grace aux groupes
	if parent.is_in_group("Planetes"):
		var info = parent.get_info()
		orbites[info[0]] = [info[1],info[2],info[3]]
	elif parent.is_in_group("Destructibles"):
		parent.hit()
		
#Retire l'orbite qu'on vient de quitter
func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Planetes"):
		var planete = area.get_parent()
		var info = planete.get_info()
		orbites.erase(info[0])
	elif area.get_parent().is_in_group("Destructibles"):
		pass
