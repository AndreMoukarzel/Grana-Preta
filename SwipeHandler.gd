extends Node

onready var LocalCamera = $SwipingCamera

var swiping = false
var max_cam_pos = Vector2()
var min_cam_pos = Vector2()


func _ready():
	var window_size_by_2 = Vector2(576, 1024)/2
	max_cam_pos.x = LocalCamera.limit_right - window_size_by_2.x
	max_cam_pos.y = LocalCamera.limit_bottom - window_size_by_2.y
	min_cam_pos = window_size_by_2
	activate()

func activate():
	set_process_input(true)
	$SwipingCamera.current = true

func deactivate():
	set_process_input(false)
	LocalCamera.set_position(Vector2(0, 0))
	LocalCamera.call_deferred("set_current", false)

func update_cam_minmax():
	var window_size_by_2 = Vector2(576, 1024)/2
	max_cam_pos.x = LocalCamera.limit_right - window_size_by_2.x
	max_cam_pos.y = LocalCamera.limit_bottom - window_size_by_2.y
	min_cam_pos.x = LocalCamera.limit_left + window_size_by_2.x
	min_cam_pos.y = LocalCamera.limit_top + window_size_by_2.y

func _input(event):
	if event.is_pressed() and (event is InputEventScreenTouch or event is InputEventMouseButton):
		swiping = true
	elif not event.is_pressed() and (event is InputEventScreenTouch or event is InputEventMouseButton):
		swiping = false
	elif swiping:
		_calculate_swipe(Input.get_last_mouse_speed())


func _calculate_swipe(swipe_speed):
	if not swiping: 
		return
	var swipe_direction = -swipe_speed.normalized()
	swipe(swipe_direction, swipe_speed.length())


func swipe(direction, speed):
	if speed < 80:
		return
	var dist = direction * speed/40.0 * LocalCamera.zoom.x
	move_camera(dist)


func move_camera(movement):
	if LocalCamera.zooming:
		return
	
	var init_pos = LocalCamera.get_position()
	var zoom = LocalCamera.zoom.x
	var sum = init_pos + movement
	sum = Vector2(clamp(sum.x, min_cam_pos.x * zoom, max_cam_pos.x + (1.0 - zoom) * 576/2), 
				  clamp(sum.y, min_cam_pos.y * zoom, max_cam_pos.y + (1.0 - zoom) * 1024/2))
	LocalCamera.set_position(sum)
