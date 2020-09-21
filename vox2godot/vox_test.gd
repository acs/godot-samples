extends Node


const Util = preload("res://common/util.gd")

const _materials = [
	preload("./opaque_color_material.tres"),
	preload("./transparent_color_material.tres")
]

onready var _mesh_instance : MeshInstance = $MeshInstance
var _mesher = VoxelMesherCubes.new()
var _wireframe_bounds : MeshInstance


func _ready():
	var wireframe = Util.create_wirecube_mesh()
	var wireframe_instance = MeshInstance.new()
	wireframe_instance.mesh = wireframe
	_mesh_instance.add_child(wireframe_instance)
	_wireframe_bounds = wireframe_instance

	_generate()


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_G:
				_mesher.greedy_meshing_enabled = not _mesher.greedy_meshing_enabled
				print("Greedy meshing: ", _mesher.greedy_meshing_enabled)
				_generate()


func _generate():
	var voxels = VoxelBuffer.new()
	voxels.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	var palette = VoxelColorPalette.new()
	
	var loader = VoxelVoxLoader.new()
	var err = loader.load_from_file("res://vox/monu1.vox", voxels, palette)
	if err != OK:
		push_error(str("Error: ", err))
		return

	_mesher.palette = palette
	_mesher.color_mode = VoxelMesherCubes.COLOR_MESHER_PALETTE
	
	var padded_voxels = VoxelBuffer.new()
	padded_voxels.create(
		voxels.get_size().x + 2, 
		voxels.get_size().y + 2, 
		voxels.get_size().z + 2)
	padded_voxels.set_channel_depth(
		VoxelBuffer.CHANNEL_COLOR, voxels.get_channel_depth(VoxelBuffer.CHANNEL_COLOR))
	padded_voxels.copy_channel_from_area(
		voxels, Vector3(), voxels.get_size(), Vector3(1, 1, 1), VoxelBuffer.CHANNEL_COLOR)

	var time_before = OS.get_ticks_usec()
	var mesh = _mesher.build_mesh(padded_voxels, _materials)
	print("Spent ", OS.get_ticks_usec() - time_before, " us to mesh")

	var vertex_count = 0
	for si in mesh.get_surface_count():
		var arrays = mesh.surface_get_arrays(si)
		var vertices = arrays[Mesh.ARRAY_VERTEX]
		print("Surface ", si, " has ", len(vertices))
		vertex_count += len(vertices)
	print("Vertex count: ", vertex_count)

	_mesh_instance.mesh = mesh
	_wireframe_bounds.scale = voxels.get_size()


func _process(delta):
	#_mesh_instance.rotate_y(delta)
	pass
