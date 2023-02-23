extends Control


onready var login_button: Button = $Login


func _ready():
	var file = Firebase.Auth.check_auth_file()
	login_button.visible = !Firebase.Auth.is_logged_in()


func _on_Gallery_pressed():
	get_tree().change_scene("res://Gallery.tscn")


func _on_Login_pressed():
	get_tree().change_scene("res://LoginScreen.tscn")
