extends Node

var completed_lessons = []
var completed_subjects = []
var completed_themes = []
var failed_questions = []
var failed_questions_time = []
var money = 0
var selic_last100 = []
var inflation_last100 = []
var last_index_iteration_date
var available_bonds = []
var bought_bonds = []


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
		last_index_iteration_date = last_index_iteration_date
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
		money = 10000
		Selic.create(10.0, 3.0, 6.0, 15.0)
		Inflation.create(3.0, 1.0, -0.5, 10.0)
		
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
	Selic.create(selic_last100[99], 3.0, 6.0, 15.0)
	Inflation.create(inflation_last100[99], 1.0, -0.5, 10.0)
	last_index_iteration_date = savedata.last_index_iteration_date
	
	var days = get_days_to_today(last_index_iteration_date)
	if days > 0:
		for i in range(days):
			Selic.iterate()
			Inflation.iterate()
			selic_last100.pop_front()
			inflation_last100.pop_front()
			selic_last100.append(Selic.value)
			inflation_last100.append(Inflation.value)
		last_index_iteration_date = OS.get_date()


func clear_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")


# Returns the numbers of days from past_date to today
func get_days_to_today(past_date):
	var today = OS.get_date()
	var months = 0
	var days = 0
	
	if today.year > past_date.year:
		months += 12 * (today.year - past_date.year)
	if today.month + months > past_date.month:
		var m = past_date.month
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
	
	var diff = [time2.day - time1.day - 1, time2.hour - time1.hour + 24]
	
	if time1.month < time2.month:
		var m = time2.month - 1
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


func save_available_bond(Bond):
	var bond_json = {
		"name" : Bond.bond_name,
		"display_rentability" : Bond.display_rentability,
		"rentability_type" : Bond.rentability_type,
		"expiration" : Bond.expiration,
		"min_investment" : Bond.min_investment,
		"min_time" : Bond.min_time,
		"taxes" : Bond.taxes,
		"creation_time" : Bond.creation_time
	}
	available_bonds.append(bond_json)
	save_game()


func save_bought_bond(Bond, ammount):
	var bond_json = {
		"ammount" : ammount,
		"bought_time" : OS.get_datetime(),
		"name" : Bond.bond_name,
		"display_rentability" : Bond.display_rentability,
		"rentability_type" : Bond.rentability_type,
		"expiration" : Bond.expiration,
		"min_investment" : Bond.min_investment,
		"min_time" : Bond.min_time,
		"taxes" : Bond.taxes,
		"creation_time" : Bond.creation_time
	}
	bought_bonds.append(bond_json)
	save_game()
