extends CharacterBody2D

const SPEED := 500.0
const JUMP_VELOCITY := -600.0
var health := 3


const MAX_MANA := 100.0
const FREEZE_COST := 25.0
const TELEPORT_COST := 40.0
var nearby_teleporter: Area2D = null

const FREEZE_RADIUS := 350.0
const FREEZE_DURATION := 3.0

var mana := MAX_MANA


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	if Input.is_action_just_pressed("freeze"):
		cast_freeze()

	if Input.is_action_just_pressed("teleport"):
		cast_teleport()

	move_and_slide()


func cast_freeze() -> void:
	if mana < FREEZE_COST:
		return

	mana -= FREEZE_COST

	
	var space_state := get_world_2d().direct_space_state

	var query := PhysicsShapeQueryParameters2D.new()
	var shape := CircleShape2D.new()

	shape.radius = FREEZE_RADIUS

	query.shape = shape
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 4

	var results := space_state.intersect_shape(query)

	for result in results:
		var object = result["collider"]

		if object.has_method("freeze"):
			object.freeze(FREEZE_DURATION)


func cast_teleport() -> void:
	if nearby_teleporter == null:
		return

	if mana < TELEPORT_COST:
		return

	mana -= TELEPORT_COST
	nearby_teleporter.teleport()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount

	print("Health: ", health)

	if health <= 0:
		die()


func die() -> void:
	get_tree().reload_current_scene()
