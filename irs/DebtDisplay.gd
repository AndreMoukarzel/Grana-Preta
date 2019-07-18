extends Control

const DEBT_SCN = preload("res://irs/debt/Debt.tscn")

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