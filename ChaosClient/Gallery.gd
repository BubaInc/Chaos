extends Control

onready var file_dialog: FileDialog = $FileDialog
onready var wrong_resolution: PopupDialog = $WrongResolution
onready var preview: TextureRect = $CreateArtwork/VBoxContainer/TextureRect
onready var generation_progress_bar: ProgressBar = $CreateArtwork/VBoxContainer/Buttons/GenerateButton/ProgressBar
onready var generate_request: StableHordeClient = $StableHordeClient
onready var generate_button: Button = $CreateArtwork/VBoxContainer/Buttons/GenerateButton/Generate
onready var prompt_textbox: TextEdit = $CreateArtwork/VBoxContainer/Buttons/Prompt
onready var submit_button: Button = $CreateArtwork/VBoxContainer/Buttons/Submit

var first_wait_time = 0

func _on_HTTPRequest_images_generated(completed_payload):
	preview.texture = completed_payload["image_textures"][0]
	generate_button.visible = true
	generation_progress_bar.visible = false
	submit_button.visible = true
	preview.visible = true


func _on_HTTPRequest_image_processing(stats):
	if first_wait_time == 0:
		first_wait_time = stats["wait_time"]
	generation_progress_bar.value = (1 - float(stats["wait_time"]) / float(first_wait_time)) * 100

func _on_Generate_pressed():
	generate_request.generate(prompt_textbox.text)
	generate_button.visible = false
	generation_progress_bar.visible = true

func _on_HTTPRequest_request_failed(error_msg):
	generate_button.visible = true
	generation_progress_bar.visible = false


func _on_HTTPRequest_request_initiated():
	pass


func _on_HTTPRequest_request_warning(warning_msg):
	pass


func _on_Upload_pressed():
	file_dialog.popup()


func _on_FileDialog_file_selected(path):
	var texture = ImageTexture.new()
	var image : Image = load(path).get_data()
	# Check the resolution of the loaded image
	if image.get_width() == 1024 and image.get_height() == 1024:
		texture.create_from_image(image)
		preview.texture = texture
		submit_button.visible = true
		preview.visible = true
	else:
		wrong_resolution.popup()


func _on_Submit_pressed():
	pass # Replace with function body.
