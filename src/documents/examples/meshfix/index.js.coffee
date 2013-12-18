loadMesh = (filename, callback) ->
  if not filename?
      callback(filename, new THREE.Object3D())
  else
      # Determine file type
      ext = filename.match(/\.[^\.]+$/)[0]
      # TODO: Add useful messages if the loaders error
      if (ext == ".dae")
          # Load mesh
          loader = new THREE.ColladaLoader()
          loader.load(filename, (collada) ->
                  node = collada.scene
                  callback(filename, node))
      else if (ext == ".stl")
          # Load mesh
          loader = new THREE.STLLoader()
          loader.addEventListener( 'load', (event) ->
              geometry = event.content
              mat = new THREE.MeshLambertMaterial({color: 0xCCCCCC})
              mesh = new THREE.Mesh(geometry,mat)
              node = new THREE.Object3D()
              node.add(mesh)
              callback(filename, node)
          )
          loader.addEventListener('progress', onProgress)
          loader.load(filename)

partLoaded = (filename, node) ->
  console.log("Finished loading " + filename)
  window.head = node
  window.geo = head.children[0].geometry
  c.scene.add(node)
  makeSphere()
  makeBox()

  head.children[0].material.vertexColors = THREE.FaceColors;
  for face in geo.faces
    #drawFaceNormal(geo,face)
    # Do collision test
    base = getFaceCentroid(face)
    raycaster = new THREE.Raycaster( base, face.normal )
    intersects = raycaster.intersectObjects( Array(head, shell, cube), true)
    if ( intersects.length > 0 )
      # for i in [0..intersects.length-1] by 1
      #   console.log(intersects[i].object.name)
      # console.log(intersects[0].object.name)
      tip = intersects[0].point     
      
      # console.log(intersects[0].point.x + ',' + intersects[0].point.y + ',' + intersects[0].point.z)
      
      if (intersects[0].object.name == "sphere")
        color_hex = 0x00FF00
      else if (intersects[0].object.name == "cube")
        color_hex = 0x0000FF
      else
        color_hex = 0x000000
      face.color = new THREE.Color(color_hex)

      # line = drawLine(base, new THREE.Vector3().copy( tip ), color_hex)
      # c.scene.add(line)
  c.camera.near = 0
  c.render()

# Const base, normal, length
drawNormal = (base, normal, length, color_hex) ->
  base_copy = new THREE.Vector3().copy( base )
  tip = new THREE.Vector3().copy( normal )
  tip.multiplyScalar(length)
  tip.add(base_copy)
  return drawLine(base_copy, tip, color_hex)

# Passed by ref: base, tip
# Returns: THREE.Line
drawLine = (base, tip, color_hex) ->
  lineGeometry = new THREE.Geometry()
  lineGeometry.vertices.push( base )
  lineGeometry.vertices.push( tip )
  line = new THREE.Line( lineGeometry, new THREE.LineBasicMaterial( { color: color_hex } ) )
  line.matrixAutoUpdate = false
  return line

makeFancyCage = () ->
  mat = new THREE.MeshLambertMaterial(
    color: 0xFF0000
    transparent: true
    opacity: 0.2
    side: THREE.DoubleSide
    )  
  g = new THREE.PlaneGeometry(0.5,.5)
  p = new THREE.Mesh(g, mat)
  p.name = "plane"
  c.scene.add(p)
  # TO BE CONTINUED HERE

makeSphere = () ->
  mat = new THREE.MeshLambertMaterial(
    color: 0xFF0000
    transparent: true
    opacity: 0.2
    side: THREE.DoubleSide
    )
  g = new THREE.SphereGeometry(0.2,24,24) #radius, widthSegments, heightSegments, phiStart, phiLength, thetaStart, thetaLength)
  window.shell = new THREE.Mesh(g, mat)
  shell.name = "sphere"
  c.scene.add(shell)

makeBox = () ->
  mat = new THREE.MeshLambertMaterial(
    color: 0xFF00FF
    transparent: true
    opacity: 0.3
    side: THREE.DoubleSide
    )
  g = new THREE.CubeGeometry(0.35,.35,.35) #width, height, depth, widthSegments, heightSegments, depthSegments)
  window.cube = new THREE.Mesh(g, mat)
  cube.name = "cube"
  c.scene.add(cube)


getFaceCentroid = (face) ->
  va = geo.vertices[face.a]
  vb = geo.vertices[face.b]
  vc = geo.vertices[face.c]
  return new THREE.Vector3(
    (va.x + vb.x + vc.x)/3,
    (va.y + vb.y + vc.y)/3,
    (va.z + vb.z + vc.z)/3
    )

drawFaceNormal = (geo, face) ->
  base = getFaceCentroid(face)
  #arrow = new THREE.ArrowHelper(face.normal, base, 0.01, 0xFF0000)
  line = drawNormal(base,face.normal,0.01, 0xFF0000)
  c.scene.add(line)

$(document).ready () ->
  # Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
  window.c = new WebGLRobots.DefaultCanvas('#hubo_container')

  # Load Hubo's head
  filename = '/data/hubo-urdf/meshes/Body_Head_vis.dae'
  # TODO: Do it with the nice geometry '/data/hubo-urdf/meshes/Body_Head_vis.dae'
  loadMesh(filename, partLoaded)