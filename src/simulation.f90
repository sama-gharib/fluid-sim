module simulation
    use raylib
    use raylib_math
    use vector_operations

    implicit none

    type particle
        type(vector2_type) :: position
        type(vector2_type) :: velocity
    contains
        procedure :: update
        procedure :: draw
        procedure :: recalculate_velocity
    end type particle

contains
    
    subroutine recalculate_velocity(this, world, count)
        class(particle), intent(inout) :: this
        integer :: count
        type(particle), dimension(count) :: world

        type(vector2_type) :: direction
        real :: distance
        integer :: i
        real :: force
        real :: mouse_sign

        real, parameter :: distance_factor    = 0.04
        real, parameter :: mouse_force_factor = 2.0
        real, parameter :: mouse_distance_factor = 0.004

        ! Mouse force computing

        direction = get_mouse_position() - this%position
        distance  = vector2_length(direction)
        direction = vector2_normalize(direction)

        ! Redundant with the next exp call, TODO: factorize
        force = exp(-(distance * mouse_distance_factor)**2) * mouse_force_factor
        
        mouse_sign = 0.0
        ! Attraction and repulsion
        if (is_mouse_button_down(mouse_button_left)) then
            mouse_sign = -1.0
        else if (is_mouse_button_down(mouse_button_right)) then
            mouse_sign = 1.0
        end if

        this%velocity = this%velocity + direction * force * mouse_sign

        do i = 1, size(world)
            if (this%position == world(i)%position) cycle

            direction = world(i)%position - this%position
            distance = vector2_length(direction)

            if (distance > 100.0) cycle

            direction = vector2_normalize(direction)

            ! Nice bell function :D
            force = exp(-(distance * distance_factor)**2)

            this%velocity = this%velocity - direction * force
        end do
    end subroutine recalculate_velocity

    subroutine update(p)
        class(particle), intent(inout) :: p

        real, parameter :: friction = 0.92
        type(vector2_type), parameter :: gravity  = vector2_type(0, 1)

        ! Wall collisions
        p%velocity%y = p%velocity%y + min(600.0 - p%position%y, 0.0) * 0.1
        p%velocity%x = p%velocity%x + min(800.0 - p%position%x, 0.0) * 0.1
        p%velocity%x = p%velocity%x + max(0.0 - p%position%x, 0.0) * 0.1

        ! Movement
        p%position = p%position + p%velocity
        

        ! Misc forces
        p%velocity = p%velocity * friction
        p%velocity = p%velocity + gravity

    end subroutine update

    subroutine draw(p)
        class(particle), intent(in) :: p

        type(vector3_type) :: color
        type(vector3_type), parameter :: slow = vector3_type(0, 0, 255)
        type(vector3_type), parameter :: fast = vector3_type(255, 0, 0)

        ! Nice gradient
        color = slow + (fast - slow) * (vector2_length(p%velocity)/20.0)

        call draw_circle_v(p%position, 5.0, color_type(color%x, color%y, color%z, 127))
    end subroutine draw

end module simulation