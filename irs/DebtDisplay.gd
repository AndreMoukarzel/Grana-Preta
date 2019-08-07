extends Control

const DEBT_SCN = preload("res://irs/debt/Debt.tscn")
const ROT_TIME = 1.0

var total_height = 120

func _ready():
	for d in Save.debts:
		var Debt = add_debt()
		
		Debt.setup(d.source_name, d.buy_date, d.sell_date, d.ammount_sold, d.profit, d.taxes)
		total_height += 135


func add_debt():
	var Debt = DEBT_SCN.instance()
	
	Debt.rect_position.y = total_height
	add_child(Debt)
	
	$SwipeHandler/SwipingCamera.limit_bottom = max(1024, total_height)
	$SwipeHandler.update_cam_minmax()
	
	return Debt


# Used when Debt has three strikes.
# Subtracts the Debt's cost from Player, destroys Debt and then updated positions
func rot_debt(Debt):
	Debt.get_node('Pay').disabled = true
	$RotTween.interpolate_property(Debt, 'modulate', null, Color(.6, 0, 0), ROT_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$RotTween.interpolate_property(Debt, 'modulate', null, Color(.6, 0, 0, 0), .3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, ROT_TIME)
	$RotTween.interpolate_property(Debt, 'rect_scale', null, Vector2(5, 5), .3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, ROT_TIME)
	$RotTween.start()
	
	Save.delete_debt(Debt)
	yield($RotTween, 'tween_completed')
	Debt.queue_free()
	# update_display_positions()