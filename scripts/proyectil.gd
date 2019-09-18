extends KinematicBody2D

var dir

# Función dirección del proyectil.
func direccion(dir2):
	# Almacenamos la dirección enviada en la variable dir.
	dir = dir2
	# Si la dirección es abajo o arriba:
	if dir == "SOUTH" || dir == "NORTH":
		# Si es arriba
		if dir == "NORTH":
			# Voltear verticalmente (ahorra dibujar sprites en 4 direcciones).
			$spr.flip_v = true
		# Y ejecuta animación "anim" que es para las verticales.
		$anim.play("anim")
	else:
		# Si la dirección es izquierda.
		if dir == "WEST":
			# Voltear horizontalmente.
			$spr.flip_h = true
		# Ejecutar animación para las horizontales.
		$anim.play("anim2")

func _process(delta):
	var motion = Vector2()
	# Movimiento según la dirección.
	if dir == "NORTH":
		motion += Vector2(0, -1)
	if dir == "SOUTH":
		motion += Vector2(0, 1)
	if dir == "WEST":
		motion = Vector2(-1, 0)
	if dir == "EAST":
		motion = Vector2(1, 0)
	# Almacenar la animación según la velocidad y el tiempo.
	motion = motion.normalized()*140*delta
	# Mover.
	move_and_collide(motion)

func explotar():
	var exp_node = load("res://escenas/explosion.tscn").instance()
	# Colocar la explosión en la posición del proyectil.
	exp_node.position = position
	# Hacer hija la explosión del padre de proyectil (Node2D:Juego)
	get_parent().add_child(exp_node)
	exp_node.explotar()
	# Eliminar proyectil.
	queue_free()