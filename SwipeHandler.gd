extends Node

onready var LocalCamera = $SwipingCamera

var swiping = false
var max_cam_pos = Vector2()
var min_cam_pos = Vector2()


func _ready():
	var window_size_by_2 = OS.get_real_window_size()/2
	max_cam_pos.x = LocalCamera.limit_right - window_size_by_2.x
	max_cam_pos.y = LocalCamera.limit_bottom - window_size_by_2.y
	min_cam_pos = window_size_by_2


func _input(event):
	if event.is_action_pressed("click"):
		swiping = true
	elif event.is_action_released("click"):
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
	var dist = direction * log(speed) * 1.5
	move_camera(dist)


func move_camera(movement):
	var init_pos = LocalCamera.get_position()
	var sum = init_pos + movement
	sum = Vector2(clamp(sum.x, min_cam_pos.x, max_cam_pos.x), 
				  clamp(sum.y, min_cam_pos.y, max_cam_pos.y))
	LocalCamera.set_position(sum)
