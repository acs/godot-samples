extends Sprite

# Let's interact with the shader

var blue_value = 0.4

func _init():
	material.set_shader_param("blue", blue_value)
