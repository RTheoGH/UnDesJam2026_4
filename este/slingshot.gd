extends Node2D

var initial_mouse_pos = Vector2(0.0,0.0)
@onready var aim = $Sprite2D

@export var modeleShip:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		aim.visible = true
		initial_mouse_pos = get_global_mouse_position()
		aim.position = initial_mouse_pos
	
	if Input.is_action_pressed("click"):
		aim.rotate(aim.get_angle_to(get_global_mouse_position())+deg_to_rad(180))
		aim.scale.x = ((get_global_mouse_position() - initial_mouse_pos).length())/10
		
	if Input.is_action_just_released("click"):
		aim.visible = false
		spawn_ship()
		
		
func spawn_ship() -> void:
	var ship_scene = modeleShip
	var ship = ship_scene.instantiate()
	ship.velocity = (initial_mouse_pos - get_global_mouse_position()).normalized() * (get_global_mouse_position() - initial_mouse_pos).length()
	add_child(ship)
	ship.position = initial_mouse_pos
	
