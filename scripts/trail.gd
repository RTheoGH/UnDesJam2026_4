extends Line2D

@export var spawn_interval : float = 0.5
@export var max_points : int = 30

var temps_dernier_point : float = 0.0

func _process(delta: float) -> void:
	temps_dernier_point += delta
	if temps_dernier_point < spawn_interval:
		return
	temps_dernier_point = 0.0
	
	add_point(get_parent().global_position)
	if points.size() > max_points:
		remove_point(0)
