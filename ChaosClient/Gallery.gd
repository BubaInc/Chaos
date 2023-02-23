extends Control

onready var file_dialog: FileDialog = $"%FileDialog"
onready var wrong_resolution: PopupDialog = $"%WrongResolution"
onready var preview: TextureRect = $"%Preview"
onready var generation_progress_bar: ProgressBar = $"%GenerationProgress"
onready var generate_request: StableHordeClient = $"%StableHordeClient"
onready var generate_button: Button = $"%Generate"
onready var prompt_textbox: TextEdit = $"%Prompt"
onready var submit_button: Button = $"%Submit"

var first_wait_time = 0

# Stable Horde Client callbacks

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


# UI events

func _on_Upload_pressed():
	file_dialog.popup()

func _on_FileDialog_file_selected(path):
	var texture = ImageTexture.new()
	var image : Image = load(path).get_data()
	# Check the resolution of the loaded image
	if (image.get_width() == 1024 and image.get_height() == 1024) or (image.get_width() == 512 and image.get_height() == 512):
		texture.create_from_image(image)
		preview.texture = texture
		submit_button.visible = true
		preview.visible = true
	else:
		wrong_resolution.popup()

func userdata_received(data):
	var list_all_task = Firebase.Storage.ref("Artworks/" + data.local_id).list_all()
	yield(list_all_task, "task_finished")
	var num_files = len(list_all_task.data)
	var file_name = str(num_files + 1) + ".png"
	var texture_data = preview.texture.get_data()
	var buffer = texture_data.save_png("user://" + file_name)
	var upload_task = Firebase.Storage.ref("Artworks/" + data.local_id + "/" + file_name).put_file("user://" + file_name)
	yield(upload_task, "task_finished")
	
func _on_Submit_pressed():
	Firebase.Auth.connect("userdata_received", self, "userdata_received")
	Firebase.Auth.get_user_data()

func _on_GoBack_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
