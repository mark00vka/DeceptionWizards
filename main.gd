#@tool

extends Node3D

@onready var union: CSGCombiner3D = $CSGCombiner3D/Union
@onready var subtraction: CSGCombiner3D = $CSGCombiner3D/Subtraction
@onready var intersection: CSGCombiner3D = $CSGCombiner3D/Intersection

var vertices : Array[Vector2]
var drawing : bool = false

func generate_indices(array: Array[Vector2]):
	var indices : Array[int] = []
	var n : int = array.size()
	
	#top and bottom
	for i in range(1, n - 1):
		indices.append_array([0, i, i+1])
		indices.append_array([n,i+n+1,i+n])
		#indices.append_array([i+1, i, 0])
		#indices.append_array([i+n,i+n+1,n])
		
	#sides
	for i in range(0, n - 1):
		indices.append_array([i+1, i, i+n])
		indices.append_array([i+1, i+n, i+n+1])
	indices.append_array([0, n-1, n])
	indices.append_array([n, n-1, n+n-1])
	return indices

func translate_vertices(v: Array[Vector2], translation: Vector3):
	var t = []
	for ver in v:
		t.append(Vector3(ver.x, 0 , ver.y))
		
	var res = t.duplicate()
	for ver in t:
		res.append(ver + translation)
	return PackedVector3Array(res)

func generate_mesh(verts: Array[Vector2]) -> void:
	var ind = generate_indices(verts)
	var inverse := vertices.duplicate()
	inverse.reverse()
	ind.append_array(generate_indices(inverse))
	var verts_final = translate_vertices(verts, Vector3.DOWN)
	
	var indices := PackedInt32Array([
		#bottom
		2,1,0,
		3,2,0,
		#sides
		7,2,3,
		7,6,2,
		
		6,1,2,
		6,5,1,
		
		5,4,1,
		4,0,1,
		
		7,3,0,
		7,0,4,
		# top
		4,5,6,
		6,7,4,	
	])
	
	var uvs := PackedVector2Array([
		Vector2(0,0),
		Vector2(1,0),
		Vector2(1,1),
		Vector2(0,1),
		
		Vector2(0,0),
		Vector2(1,0),
		Vector2(1,1),
		Vector2(0,1),
	])
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(verts_final.size()):
		#st.set_uv(uvs[i])
		st.add_vertex(verts_final[i])
		
	for i in ind:
		st.add_index(i)
	st.generate_normals()
	var mesh = st.commit()
	$CSGCombiner3D/Union/CSGMesh3D.mesh = mesh

func generate_sphere():
	var rings = 50
	var radial_segments = 50
	var height = 1
	var radius = 1

	# Vertex indices.
	var thisrow = 0
	var prevrow = 0
	var point = 0

	var verts := PackedVector3Array()
	var uvs := PackedVector2Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	# Loop over rings.
	for i in range(rings + 1):
		var v = float(i) / rings
		var w = sin(PI * v)
		var y = cos(PI * v)

		# Loop over segments in ring.
		for j in range(radial_segments):
			var u = float(j) / radial_segments
			var x = sin(u * PI * 2.0)
			var z = cos(u * PI * 2.0)
			var vert = Vector3(x * radius * w, y, z * radius * w)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(u, v))
			point += 1

			# Create triangles in ring using indices.
			if i > 0 and j > 0:
				indices.append(prevrow + j - 1)
				indices.append(prevrow + j)
				indices.append(thisrow + j - 1)

				indices.append(prevrow + j)
				indices.append(thisrow + j)
				indices.append(thisrow + j - 1)

		if i > 0:
			indices.append(prevrow + radial_segments - 1)
			indices.append(prevrow)
			indices.append(thisrow + radial_segments - 1)

			indices.append(prevrow)
			indices.append(prevrow + radial_segments)
			indices.append(thisrow + radial_segments - 1)

		prevrow = thisrow
		thisrow = point
		
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(verts.size()):
		st.set_uv(uvs[i])
		st.add_vertex(verts[i])
		
	for i in indices:
		st.add_index(i)
	st.generate_normals()
	var mesh = st.commit()
	$CSGCombiner3D/Union/CSGMesh3D.mesh = mesh

func add_point(pos: Vector3):
	var s = 5.0
	var res = Vector2(pos.x, pos.z) * s
	if not Geometry2D.is_point_in_polygon(res, PackedVector2Array(vertices)):
		vertices.append(res)

func _on_drawing_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:		
	if event is InputEventMouseButton:
		if event.is_released():
			if vertices.size() > 2:
				generate_mesh(vertices)
			vertices.clear()
			drawing = false
		if event.is_pressed():
			drawing = true
	
	if event is InputEventMouseMotion and drawing and Engine.get_process_frames() % 4 == 0:
		add_point(event_position - $DrawingPlane.global_position)

func _on_drawing_area_mouse_exited() -> void:
	if vertices.size() > 2:
		generate_mesh(vertices)
	drawing = false
	vertices.clear()
