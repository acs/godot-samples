extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# The full process is described in https://github.com/Zylann/godot_voxel/issues/194

# TODO: how this materials are created?
const _materials = [
	preload("./red_material.tres")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the Voxel and add it to a MeshInstance
	var voxel = VoxelMesherBlocky.new()
	var voxel_buffer = VoxelBuffer.new()
	# TODO: understand this line
	voxel_buffer.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	
	voxel_buffer.set_voxel(1, 0, 0, 1)
	voxel.build_mesh(voxel_buffer, _materials)
	$VoxelMesh.mesh = voxel
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
