extends CharacterBody3D

@onready var player_nav_agent := $NavigationAgent3D
@onready var player_cam := $Camera3D

@export var player_move_speed: float = 5.0 
@export var player_gravity: float = 2500.0
@export var player_rotation_speed: float = 8.0


func _physics_process(delta: float) -> void:
    if player_nav_agent.is_navigation_finished():
        return

    var next_path_pos = player_nav_agent.get_next_path_position()
    var direction = global_position.direction_to(next_path_pos)
# Commented until separation of the camera from the CharacterBody3D
#    if(direction != Vector3.ZERO):
 #       var horizontal_direction = Vector3(direction.x, 0, direction.z).normalized()
  #      var target_rotation = atan2(-horizontal_direction.x, -horizontal_direction.z)
#
 #       rotation.y = lerp_angle(rotation.y, target_rotation, player_rotation_speed * delta)
    velocity = direction * player_move_speed
    move_and_slide()

func _input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("left_mouse"):
        
        var mouse_pos = get_viewport().get_mouse_position()
        
        # Ray properties
        var ray_length = 1000
        var ray_origin = player_cam.project_ray_origin(mouse_pos)
        var ray_direction = player_cam.project_ray_normal(mouse_pos)
        var ray_destiny = ray_origin + ray_direction * ray_length
        
        var space = get_world_3d().direct_space_state
        var ray_query = PhysicsRayQueryParameters3D.new()
        
        # Configure ray query
        ray_query.from = ray_origin
        ray_query.to = ray_destiny
        ray_query.collide_with_areas = true  
        ray_query.collide_with_bodies = true 
        # Set a different collision layer
        # ray_query.collision_mask = 1

        var ray_result = space.intersect_ray(ray_query)

        if ray_result:
            print("Hit: ", ray_result.position)
            player_nav_agent.target_position = ray_result.position
