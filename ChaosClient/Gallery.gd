extends Control


onready var preview: TextureRect = $"%Preview"

# {elapsed_time:83830, image_textures:[[ImageTexture:4557]]}
func _on_HTTPRequest_images_generated(completed_payload):
	preview.texture = completed_payload["image_textures"][0]
	print(completed_payload)


func _on_HTTPRequest_image_processing(stats):
	print(stats)


func _on_HTTPRequest_request_failed(error_msg):
	print(error_msg)


func _on_HTTPRequest_request_initiated():
	print("Buba init")


func _on_HTTPRequest_request_warning(warning_msg):
	print(warning_msg)
