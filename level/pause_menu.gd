extends Control

var is_paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if !is_paused:
			is_paused = !is_paused
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			self.show()
			get_tree().paused = true
		else:
			unpause()

func unpause():
	is_paused = !is_paused
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	self.hide()
	get_tree().paused = false

func _on_resume_pressed():
	unpause()
