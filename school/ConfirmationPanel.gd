extends Control


var title
var id
var content


func add_questionnaire_info(title, id, content):
	self.title = title
	self.id = id
	self.content = content
	show()


func _on_Continue_pressed():
	if title: # Confirmation to enter a Questionnaire
		var School = get_tree().get_root().get_node("School")
		
		School.add_question(title, content, id)
	else: # Confirmation to leave a Questionnaire
		var School = get_tree().get_root().get_node("School")
	
		School.lock_questionnaire(id)
		School.add_subject_tree(School.theme_entered)


func _on_Back_pressed():
	hide()
