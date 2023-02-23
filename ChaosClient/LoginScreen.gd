extends Control


# Log in panel
onready var login_email: TextEdit = $LogIn/Email
onready var login_password: TextEdit = $LogIn/Password

# Sign up panel
onready var signup_email: TextEdit = $SignUp/Email
onready var signup_password: TextEdit = $SignUp/Password
onready var signup_password_verified: TextEdit = $SignUp/PasswordVerified


func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_login_succeeded")
	Firebase.Auth.connect("signup_succeeded", self, "_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_login_failed")
	Firebase.Auth.connect("signup_failed", self, "_signup_failed")

func _on_login_pressed():
	var email = login_email.text
	var password = login_password.text
	Firebase.Auth.login_with_email_and_password(email, password)

func _on_register_pressed():
	var email = signup_email.text
	var password = signup_password.text
	if signup_password.text == signup_password_verified.text:
		Firebase.Auth.signup_with_email_and_password(email, password)

func _login_succeeded(auth):
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene("res://MainMenu.tscn")
	
func _login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))

func _signup_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))


func _on_GoBack_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
