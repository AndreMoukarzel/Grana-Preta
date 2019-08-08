extends Control

const DEBT_SCN = preload("res://irs/debt/Debt.tscn")
const ROT_TIME = 1.0
const TWN_TIME = .2
const DEBT_OFFSET = 25
const TOP_OFFSET = 120

var total_height = 120

func _ready():
	for d in Save.debts:
		var Debt = add_debt($Debts)
		
		Debt.setup(d.source_name, d.buy_date, d.sell_date, d.ammount_sold, d.profit, d.taxes)


func add_debt(parent):
	var Debt = DEBT_SCN.instance()
	
	Debt.rect_position.y = total_height
	Debt.set_name(str(parent.get_child_count()))
	Debt.connect("opened", self, "debt_opened")
	Debt.connect("closed", self, "debt_closed")
	parent.add_child(Debt)
	
	total_height += 135
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


func close_all_debts(exception = null):
	for child in $Debts.get_children():
		if exception and child == exception:
			continue
		if child.is_open:
			child.close()
			debt_closed(child)


func disable_all_debts(disable = true):
	for child in $Debts.get_children():
		child.disabled = disable


func debt_opened(Debt):
	var pos_y = Debt.rect_global_position.y
	var group = Debt.get_parent().get_parent().get_name()
	var will_tween = false
	
	disable_all_debts()
	close_all_debts(Debt)
	for child in Debt.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * (Debt.CLOSED_SIZE + DEBT_OFFSET) + TOP_OFFSET
			
			will_tween = true
			$Tween.interpolate_property(child, "rect_position:y", null, pos + (Debt.OPENED_SIZE - Debt.CLOSED_SIZE), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if will_tween:
		$Tween.start()
		yield($Tween, "tween_completed")
	disable_all_debts(false)


func debt_closed(Debt):
	var pos_y = Debt.rect_global_position.y
	var group = Debt.get_parent().get_parent().get_name()
	var will_tween = false
	
	disable_all_debts()
	for child in Debt.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * (Debt.CLOSED_SIZE + DEBT_OFFSET) + TOP_OFFSET
			
			will_tween = true
			$Tween.interpolate_property(child, "rect_position:y", null, pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if will_tween:
		$Tween.start()
		yield($Tween, "tween_completed")
	disable_all_debts(false)
