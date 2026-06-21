extends Node2D

var initial_mouse_pos = Vector2(0.0,0.0)
@onready var aim = $Sprite2D

var ship_scene : PackedScene = preload("res://scenes/space_ship.tscn")

var is_aiming = false

var current_ship : RigidBody2D = null
var ship_spawned = false
var camera_following = false
var camera_catching_up = false
@export var cam_catchup_speed : float = 5.0
var cam_directed = false

#var pos_tween: Tween
var zoom_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aim.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and \
		get_parent().mouse_in_launch_zone and \
	 	not Input.is_key_pressed(KEY_CTRL) and \
		not ship_spawned:
		
		is_aiming = true
		aim.visible = true
		initial_mouse_pos = get_global_mouse_position()
		aim.position = initial_mouse_pos
	
	if Input.is_action_pressed("click") and is_aiming:
		aim.rotate(aim.get_angle_to(get_global_mouse_position())+deg_to_rad(180))
		aim.scale.x = ((get_global_mouse_position() - initial_mouse_pos).length())/10
		
	if Input.is_action_just_released("click") and is_aiming:
		is_aiming = false
		aim.visible = false
		spawn_ship()
		get_parent().get_node("music").play()
		
	if Input.is_action_just_pressed("center_cam_on_ship") and ship_spawned:
		start_directed_cam()
		

	if Input.is_action_just_released("center_cam_on_ship") and ship_spawned:
		end_directed_cam()
	
	if camera_catching_up and is_instance_valid(current_ship):
		var cam = get_parent().get_node("Camera2D")
		var catchup_factor = clamp(current_ship.velocity.length() * 0.0001, 0.05, 0.5)
		cam.position = cam.position.lerp(
			current_ship.position, 
			catchup_factor
		)
		
		if cam.position.distance_to(current_ship.position) < 5.0:
			camera_catching_up = false
			camera_following = true
	
	if camera_following and is_instance_valid(current_ship):
		get_parent().get_node("Camera2D").position = current_ship.position
	
	if Input.is_action_just_pressed("reset") and ship_spawned:
		current_ship.get_node("Mbappe").visible = false
		current_ship.get_node("propulseur").stop()
		current_ship.get_node("explosion_son").play()
		current_ship.linear_velocity = Vector2.ZERO
		var explosion = current_ship.get_node("explosion")
		explosion.emitting = true
		await explosion.finished
		delete_ship("Space ship recalled")
		
func spawn_ship() -> void:
	var ship = ship_scene.instantiate()
	ship.velocity = (initial_mouse_pos - get_global_mouse_position()).normalized() * (get_global_mouse_position() - initial_mouse_pos).length()
	ship_spawned = true
	add_child(ship)
	ship.position = initial_mouse_pos
	current_ship = ship
	
func delete_ship(cause : String) -> void:
	get_node("SpaceShip").queue_free()
	remove_child(get_node("SpaceShip"))
	get_parent().get_node("music").stop()
	ship_spawned = false
	current_ship = null
	cam_directed = false
	end_directed_cam()
	var canvas = get_parent().get_node("CanvasLayer")
	#canvas.get_node("Annoncer").text = cause
	canvas.fade_in("Annoncer")
	await canvas.type_text("Annoncer", cause)
	await get_tree().create_timer(0.25).timeout
	canvas.fade_out("Annoncer")
	
	
func start_directed_cam() -> void:
	var cam = get_parent().get_node("Camera2D")
	camera_following = false
	camera_catching_up = true
	
	if zoom_tween and zoom_tween.is_running():
		zoom_tween.kill()
	
	if cam.zoom.x != 0.4:
		zoom_tween = get_tree().create_tween()
		zoom_tween.tween_property(cam, "zoom", Vector2(0.4, 0.4), 1.0)
	
var reset_cam_tween: Tween
		
func end_directed_cam() -> void:
	var cam = get_parent().get_node("Camera2D")
	
	if reset_cam_tween and reset_cam_tween.is_running():
		reset_cam_tween.kill()
	if zoom_tween and zoom_tween.is_running():
		zoom_tween.kill()
	
	reset_cam_tween = get_tree().create_tween()
	reset_cam_tween.tween_property(cam, "position", Vector2(0,0), 1.0)
	
	if cam.zoom.x != 0.06:
		zoom_tween = get_tree().create_tween()
		zoom_tween.tween_property(cam, "zoom", Vector2(0.06, 0.06), 1.0)
	
	#cam.position = Vector2(0,0)
	#cam.zoom = Vector2(0.06, 0.06)
	camera_catching_up = false
	camera_following = false
