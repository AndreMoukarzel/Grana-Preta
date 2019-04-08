extends Control

const OFFSET = Vector2(10, 5)
const TEXT_OFFSET = 10
const ALTERNATIVE_SCN = preload("res://school/Lessons/Alternative.tscn")
const ALTER_HEIGHT = 50

var questions = []
var answers = []
var selected_answers = []
var correct_answers = []
var current_question = 0
var text_font
var id


func _ready():
	randomize()
	rect_size = OS.get_window_size() - OFFSET
	rect_position = OFFSET/2
	$Title.rect_size.x = OS.get_window_size().x - OFFSET.x
	text_font = DynamicFont.new()
	text_font.font_data = load("res://school/Lessons/LessonFont.otf")
	text_font.use_filter = true
	$Result.rect_position = Vector2(OS.get_window_size().x/4, -OS.get_window_size().y/2)


# Must be setup after being added to tree, or label height will be gotten incorrectly
func setup(name, content, id):
	self.id = id
	get_all_questions_and_answers(content)
	var title_height = add_title(name)
	for i in range(questions.size()):
		var question_height = add_question(i, title_height + 60)
		add_answers(i, question_height + 80)
	var answers_height = show_question_and_answer(0)
	set_questionnaire_size(answers_height)


func add_title(title):
	$Title.text = title
	
	return $Title.rect_size.y


func add_text(parent, content, pos_y, centralize=false):
	var l = Label.new()
	
	l.add_color_override("font_color", Color(0, 0, 0))
	l.rect_position = Vector2(TEXT_OFFSET, pos_y)
	l.text = content
	l.set("custom_fonts/font", text_font)
	if centralize:
		l.rect_size.x = parent.rect_size.x - 2 * TEXT_OFFSET
		l.align = Label.ALIGN_CENTER
	parent.add_child(l)
	
	return l.rect_size.y


func add_image(parent, pos_y, texture_name):
	var texture = load(str("res://school/Lessons/", texture_name))
	var tr = TextureRect.new()
	var tex_size = texture.get_size()
	
	tr.texture = texture
	if tex_size.x > parent.rect_size.x - 2 * TEXT_OFFSET:
		var scale = (parent.rect_size.x - 2 * TEXT_OFFSET)/tex_size.x
		tex_size *= scale
		tr.expand = true
		tr.rect_size = tex_size
	tr.rect_position = Vector2((parent.rect_size.x - tex_size.x)/2, pos_y)
	parent.add_child(tr)
	
	return tex_size.y


func add_question(index, pos_y):
	var Cont = Control.new()
	
	Cont.set_name(str("Question", index))
	Cont.rect_position = Vector2(0, pos_y)
	add_child(Cont)
	text_font.size = 30
	Cont.rect_size.x = OS.get_window_size().x - OFFSET.x
	Cont.rect_size.y = parse_content(Cont, questions[index], true)
	
	return 20 + Cont.rect_size.y + Cont.rect_position.y


# Randomizes answer order and creates a Conteiner containing all the Alternatives
func add_answers(index, pos_y):
	var Cont = Control.new()
	var current_answers = answers[index]
	var correct = current_answers[0]
	var answer_pos = 0
	
	current_answers.shuffle()
	correct_answers[index] = current_answers.find(correct)
	Cont.set_name(str("Answer", index))
	Cont.rect_position = Vector2(0, pos_y)
	add_child(Cont)
	
	for i in range(current_answers.size()):
		var Alt = ALTERNATIVE_SCN.instance()
		
		Alt.rect_position = Vector2(TEXT_OFFSET, answer_pos)
		Alt.set_name(str("Alternative", i))
		Cont.add_child(Alt)
		Alt.rect_size.x = OS.get_window_size().x - 3 * TEXT_OFFSET
		Alt.rect_size.y = max(parse_content(Alt, current_answers[i]), 50)
		Alt.get_node("Panel").rect_size = Alt.rect_size
		Alt.connect("pressed", self, "Alternative_selected", [Alt])
		
		answer_pos += Alt.rect_size.y + 5
	Cont.rect_size.y = answer_pos


func parse_content(parent, content, centralize=false):
	var vpos = 0
	
	for c in content:
		if c.find(".png") != -1: # is an image
			vpos += add_image(parent, vpos, c) + 5
		else:
			vpos += add_text(parent, c, vpos, centralize) + 5
	
	return vpos


func position_back_and_next(pos_y):
	$Back.rect_position = Vector2(OS.get_window_size().x/3 - $Back.rect_size.x/2, pos_y + 50)
	$Next.rect_position = Vector2(2 * OS.get_window_size().x/3 - $Next.rect_size.x/2, pos_y + 50)
	
	return $Next.rect_size.y + $Next.rect_position.y + 20


# Returns bottom of current answers
func show_question_and_answer(index):
	for i in range(questions.size()):
		get_node(str("Question",i)).hide()
		get_node(str("Answer",i)).hide()
	get_node(str("Question",index)).show()
	var CurAns = get_node(str("Answer",index))
	CurAns.show()
	
	return CurAns.rect_size.y + CurAns.rect_position.y


func display_results():
	var School = get_tree().get_root().get_node("School")
	var wrong_answers = 0
	var Twn = $Result/Tween
	
	for i in range(selected_answers.size()):
		if selected_answers[i] == -1:
			pass # didn't answer all questions!
		if selected_answers[i] != correct_answers[i]:
			wrong_answers += 1
	
	if wrong_answers == 0:
		$Result.text = "PASSED"
		$Result.set("custom_colors/font_color",Color(.03, .26, .03))
		move_child($Result, get_child_count() - 1)
		Twn.interpolate_property($Result, "rect_position:y", null,  OS.get_window_size().y/2, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		Twn.interpolate_property($Result, "rect_scale", Vector2(0.1, 0.1), Vector2(1.5, 1.5), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		Twn.start()
		yield(Twn, "tween_completed")
		
		if not Save.completed_lessons.has(id): # if not completed, complete
			complete()
		else:
			School._on_Back_pressed()
	else:
		$Result.text = "FAILED"
		$Result.set("custom_colors/font_color",Color(.5, .08, .08))
		move_child($Result, get_child_count() - 1)
		Twn.interpolate_property($Result, "rect_position:y", null,  OS.get_window_size().y/2, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		Twn.interpolate_property($Result, "rect_scale", Vector2(0.1, 0.1), Vector2(1.5, 1.5), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		Twn.start()
		yield(Twn, "tween_completed")
		
		print(wrong_answers, " incorrect answers")
		if not Save.completed_lessons.has(id): # if not completed, lock
			lock()
		else:
			School._on_Back_pressed()


func complete():
	var School = get_tree().get_root().get_node("School")
	
	School.complete_lesson(id)
	School._on_Back_pressed()


func lock():
	var School = get_tree().get_root().get_node("School")
	
	School.lock_questionnaire(id)
	School._on_Back_pressed()


func get_all_questions_and_answers(content):
	var odd = false
	
	for c in content:
		if odd:
			answers.append(c)
		else:
			questions.append(c)
		selected_answers.append(-1)
		correct_answers.append(-1)
		odd = not odd


func set_camera_limits(height):
	var LocalCamera = $SwipeHandler/SwipingCamera
	LocalCamera.limit_right = OS.get_window_size().x
	LocalCamera.limit_bottom = height + 10


func set_height(height):
	var h = max(OS.get_window_size().y, height)
	rect_size.y = h


func set_questionnaire_size(answers_height):
	var total_height = position_back_and_next(answers_height + 60)

	set_camera_limits(total_height)
	set_height(total_height + 25)


func _on_Next_pressed():
	if current_question == questions.size() - 1:
		display_results()
	else:
		$Back.set_modulate(Color(1, 1, 1))
		current_question += 1
		var answers_height = show_question_and_answer(current_question)
		set_questionnaire_size(answers_height)
		
		if current_question == questions.size() - 1:
			$Next/Label.text = "Finish"
			$Next/Panel.set_modulate(Color(.3, 1, .3))


func _on_Back_pressed():
	$Next/Label.text = "NEXT"
	$Next/Panel.set_modulate(Color(1, 1, 1))
	current_question = max(current_question - 1, 0)
	var answers_height = show_question_and_answer(current_question)
	set_questionnaire_size(answers_height)
	
	if current_question == 0:
		$Back.set_modulate(Color(.6, .6, .6))


func Alternative_selected(Alternative):
	var Answers = Alternative.get_parent()
	var alt_num = int(Alternative.get_name()[-1])
	
	for Alt in Answers.get_children():
		Alt.get_node("Panel").set_modulate(Color(1, 1, 1))
	Alternative.get_node("Panel").set_modulate(Color(.3, 1, .3))
	selected_answers[current_question] = alt_num
