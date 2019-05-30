extends Control

const DEBT_SCN = preload("res://irs/debt/Debt.gd")


func _ready():
	for d in Save.debts:
		var Debt = add_debt()
		
		Debt.setup(d.source_name, d.value, d.buy_date, d.sell_date, d.initial_price, d.profit, d.taxes)


func add_debt():
	var Debt = DEBT_SCN.instance()
	
	add_child(Debt)
	
	return Debt