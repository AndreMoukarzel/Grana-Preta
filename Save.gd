extends Node

var money = 0
var selic_last100 = []
var inflation_last100 = []
var last_index_iteration_date
########### School ###########
var completed_lessons = []
var completed_subjects = []
var completed_themes = []
var failed_questions = []
var failed_questions_time = []
########### Broker ###########
var available_bonds = []
var available_bonds_id = 0
var bought_bonds = []
var bought_bonds_id = 0
############ IRS #############
var debts = []
############ Home ############
var elements = []
var accumulated_patrimony = "0.00"


func save():
	var savedict = {
		completed_lessons = completed_lessons,
		completed_subjects = completed_subjects,
		completed_themes = completed_themes,
		failed_questions = failed_questions,
		failed_questions_time = failed_questions_time,
		money = money,
		selic_last100 = selic_last100,
		inflation_last100 = inflation_last100,
		last_index_iteration_date = last_index_iteration_date,
		available_bonds = available_bonds,
		available_bonds_id = available_bonds_id,
		bought_bonds = bought_bonds,
		bought_bonds_id = bought_bonds_id,
		debts = debts,
		elements = elements,
		accumulated_patrimony = accumulated_patrimony
	}
	return savedict


func save_game():
	var savegame = File.new()
	var savedata = save()
	savegame.open("user://savegame.save", File.WRITE)
	savegame.store_line(to_json(savedata))
	savegame.close()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		Selic.create(10.0, 3.0, 6.0, 15.0)
		Inflation.create(3.0, 1.0, -0.5, 10.0)
		
#warning-ignore:unused_variable
		for i in range(100):
			Selic.iterate()
			Inflation.iterate()
			selic_last100.append(Selic.value)
			inflation_last100.append(Inflation.value)
		last_index_iteration_date = OS.get_date()
		
		return #Error!  We don't have a save to load
	
	savegame.open("user://savegame.save", File.READ)
	var savedata = {}
	savedata = parse_json(savegame.get_as_text())
	savegame.close()
	
	# Converts savadata's float arrays to int arrays
	for element in savedata.completed_lessons:
		completed_lessons.append(int(element))
	for element in savedata.completed_subjects:
		completed_subjects.append(int(element))
	for element in savedata.completed_themes:
		completed_themes.append(int(element))
	for element in savedata.failed_questions:
		failed_questions.append(int(element))
	for element in savedata.failed_questions_time:
		failed_questions_time.append(element)
	money = int(savedata.money)
	for element in savedata.selic_last100:
		selic_last100.append(float(element))
	for element in savedata.inflation_last100:
		inflation_last100.append(float(element))
	for element in savedata.available_bonds:
		available_bonds.append(element)
	available_bonds_id = int(savedata.available_bonds_id)
	for element in savedata.bought_bonds:
		bought_bonds.append(element)
	bought_bonds_id = int(savedata.bought_bonds_id)
	for element in savedata.debts:
		debts.append(element)
	for element in savedata.elements:
		elements.append(element)
	accumulated_patrimony = savedata.accumulated_patrimony
	
	Selic.create(selic_last100[99], 3.0, 6.0, 15.0)
	Inflation.create(inflation_last100[99], 1.0, -0.5, 10.0)
	last_index_iteration_date = savedata.last_index_iteration_date
	
	var days = get_days_to_today(last_index_iteration_date)
	if days > 0:
#warning-ignore:unused_variable
		for i in range(days):
			Selic.iterate()
			Inflation.iterate()
			selic_last100.pop_front()
			inflation_last100.pop_front()
			selic_last100.append(Selic.value)
			inflation_last100.append(Inflation.value)
		last_index_iteration_date = OS.get_date()
	
	var elements_to_remove = []
	for el in elements:
		var days_since_creation = get_days_to_today(el.creation_date)
		if days_since_creation > 0:
			if el.date == null:
				elements_to_remove.append(el)
				accumulated_patrimony = add_values(accumulated_patrimony, el.value)
			elif get_days_to_today(el.update_date) >= el.update_date.month \
			     and int(OS.get_datetime().day) >= int(el.date): # Has not been collected this month yet and can be collected
				el.update_date = OS.get_datetime()
				accumulated_patrimony = add_values(accumulated_patrimony, el.value)
	
	for el in elements_to_remove:
		var index = elements.find(el)
		elements.remove(index)
	elements_to_remove.clear()


func clear_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")


func add_values(v1 : String, v2 : String):
	var v1_int = int(v1.split(".")[0])
	var v2_int = int(v2.split(".")[0])
	var v1_float = 0
	var v2_float = 0
	
	if len(v1.split(".")) > 1:
		v1_float = int(v1.split(".")[1])
	if len(v2.split(".")) > 1:
		v2_float = int(v2.split(".")[1])
	
	var sum_int = v1_int + v2_int
	var sum_float = v1_float + v2_float
	
	if sum_float >= 100:
		sum_float -= 100
		sum_int += 1
	if sum_float < 10:
		sum_float = "0" + str(sum_float)
	
	return str(sum_int) + "." + str(sum_float)


# Returns the numbers of days from past_date to today
func get_days_to_today(past_date):
	var today = OS.get_date()
	var months = 0
	var days = 0
	
	if today.year > past_date.year:
		months += 12 * (today.year - past_date.year)
	if today.month + months > past_date.month:
		var m = int(past_date.month)
#warning-ignore:unused_variable
		for i in range((today.month + months) - past_date.month):
			if m % 2 == 0:
				if m == 2: # February
					days += 28
					if past_date.year % 4 == 0: # leap year
						days += 1
				else:
					days += 30
			else:
				days += 31
	days += today.day - past_date.day
	
	return days


# Returns [days, hours] of difference between time1 and time2 datetimes. 
# Used on Bonds
func get_time_difference(time1, time2):
	if time1.year > time2.year or time1.month > time2.month:
		return [-1, -1]
	
	var diff = [int(time2.day - time1.day - 1), int(time2.hour - time1.hour + 24)]
	
	if time1.month < time2.month:
		var m = int(time2.month) - 1
		if m % 2 == 1:
			diff[0] += 31
		else:
			if m == 2:
				if time2.year % 4 == 0: # leap year
					diff[0] += 29
				else:
					diff[0] += 28
			else:
				diff[0] += 30
	
	if diff[1] > 23:
		diff[1] -= 24
		diff[0] += 1
	
	return diff


func get_min_datetime(time1, time2):
	if time1.year < time2.year:
		return time1
	elif time1.year > time2.year:
		return time2
	
	if time1.month < time2.month:
		return time1
	elif time1.month > time2.month:
		return time2
	
	if time1.day < time2.day:
		return time1
	elif time1.day > time2.day:
		return time2
	
	if time1.hour < time2.hour:
		return time1
	elif time1.hour > time2.hour:
		return time2
	
	if time1.minute < time2.minute:
		return time1
	elif time1.minute > time2.minute:
		return time2
	
	if time1.second < time2.second:
		return time1
	elif time1.second > time2.second:
		return time2


func save_available_bond(Bond):
	var bond_json = {
		"id" : available_bonds_id,
		"name" : Bond.bond_name,
		"display_rentability" : Bond.display_rentability,
		"rentability_type" : Bond.rentability_type,
		"expiration" : Bond.expiration,
		"min_investment" : Bond.min_investment,
		"min_time" : Bond.min_time,
		"taxes" : Bond.taxes,
		"creation_time" : Bond.creation_time,
		"index_value" : Bond.index_value # used only on chanceful bonds
	}
	available_bonds.append(bond_json)
	available_bonds_id = (available_bonds_id + 1) % 30
	save_game()


func save_bought_bond(Bond, ammount, first_buy = true):
	var bt = OS.get_datetime()
	var lut = OS.get_datetime()
	var profit = 1.0
	var ia = ammount
	
	if not first_buy: # The bond has been bought before and is being re-saved
		bt = Bond.bought_time
		lut = Bond.last_updated_time
		profit = Bond.profit
		ia = Bond.initial_ammount

	var bond_json = {
		"id" : bought_bonds_id,
		"ammount" : ammount,
		"bought_time" : bt,
		"last_updated_time" : lut,
		"profit" : profit,
		"initial_ammount": ia,
		"name" : Bond.bond_name,
		"display_rentability" : Bond.display_rentability,
		"rentability_type" : Bond.rentability_type,
		"expiration" : Bond.expiration,
		"min_investment" : Bond.min_investment,
		"min_time" : Bond.min_time,
		"taxes" : Bond.taxes,
		"creation_time" : Bond.creation_time,
		"index_value" : Bond.index_value # used only on chanceful bonds
	}
	bought_bonds.append(bond_json)
	bought_bonds_id = (bought_bonds_id + 1) % 10000
	save_game()


func delete_bought_bond(id):
	var i = 0
	for bond in bought_bonds:
		if bond.id == id:
			break
		i += 1
	if i < bought_bonds.size():
		bought_bonds.remove(i)
		save_game()


func save_debt(Bond, ammount_sold : int, profit : int):
	var debt_json = {
		"source_name" : Bond.bond_name,
		"buy_date" : Bond.bought_time,
		"sell_date" : OS.get_datetime(),
		"ammount_sold" : ammount_sold,
		"profit" : profit,
		"taxes" : Bond.taxes
	}
	debts.append(debt_json)
	save_game()


func delete_debt(Debt):
	var i = 0
	for d in debts:
		if d.source_name == Debt.source_name and d.buy_date == Debt.buy_date and d.sell_date == Debt.sell_date and \
		   d.ammount_sold == Debt.ammount_sold and d.profit == Debt.profit and d.taxes == Debt.taxes:
			break
		i += 1
	if i < debts.size():
		debts.remove(i)
		save_game()


func save_element(Element):
	var elem_json = {
		"value" : Element.value,
		"date" : Element.date,
		"creation_date" : Element.creation_date,
		"update_date" : OS.get_datetime() # Used on monthly elements
	}
	elements.append(elem_json)
	save_game()


func delete_element(Element):
	var i = 0
	for e in elements:
		if e.value == Element.value and e.date == Element.date and e.creation_date == Element.creation_date:
			break
		i += 1

	if i < elements.size():
		elements.remove(i)
		save_game()