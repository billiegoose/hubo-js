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
  window.head = node
  window.geo = head.children[0].geometry
  c.scene.add(node)
  makeSphere()
  for face in geo.faces
    drawFaceNormal(geo,face)
  c.camera.near = 0
  c.render()

drawLine = (base, normal, length) ->
  lineGeometry = new THREE.Geometry()
  bob = new THREE.Vector3().copy( base )
  lineGeometry.vertices.push( bob )
  tip = new THREE.Vector3().copy( normal )
  tip.multiplyScalar(length)
  tip.add(base)
  lineGeometry.vertices.push( tip )

  line = new THREE.Line( lineGeometry, new THREE.LineBasicMaterial( { color: 0xFF0000 } ) )
  line.matrixAutoUpdate = false
  return line

makeSphere = () ->
  g = new THREE.SphereGeometry(0.2,24,24) #, widthSegments, heightSegments, phiStart, phiLength, thetaStart, thetaLength)
  foo = new THREE.Mesh(g, new THREE.MeshLambertMaterial( {color: 0xFF0000, transparent: true, opacity: 0.5 } ))
  c.scene.add(foo)

drawFaceNormal = (geo, face) ->
  va = geo.vertices[face.a]
  vb = geo.vertices[face.b]
  vc = geo.vertices[face.c]
  base = new THREE.Vector3(
    (va.x + vb.x + vc.x)/3,
    (va.y + vb.y + vc.y)/3,
    (va.z + vb.z + vc.z)/3
    )
  #arrow = new THREE.ArrowHelper(face.normal, base, 0.01, 0xFF0000)
  line = drawLine(base,face.normal,0.01)
  c.scene.add(line)

$(document).ready () ->
  # Create a THREE.WebGLRenderer() to host the robot. You can create your own, or use the provided code to generate default setup.
  window.c = new WebGLRobots.DefaultCanvas('#hubo_container')

  # Load Hubo's head
  filename = '/data/hubo-urdf/meshes/Body_Head_col.dae'
  # TODO: Do it with the nice geometry '/data/hubo-urdf/meshes/Body_Head_vis.dae'
  loadMesh(filename, partLoaded)