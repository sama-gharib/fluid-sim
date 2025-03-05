

program main
    use omp_lib
    use raylib
    use simulation

    implicit none

    integer :: i

    integer, parameter :: window_width  = 800
    integer, parameter :: window_height = 600
    integer, parameter :: world_size = 1000

    type(particle), dimension(world_size) :: world
    integer, dimension(8) :: timeinfo

    ! Random seed initialisation
    call date_and_time(values= timeinfo)
    call srand(timeinfo(8))

    ! Putting particles randomly
    do i = 1, size(world)
        world(i) = particle(vector2_type(rand()*window_width, rand() * window_height), vector2_type(0, 0))
    end do

    call init_window(window_width, window_height, "Fluid Sim - GHARIB ALI BARURA Sama" // char(0))
    call set_target_fps(120)

    do while (.not. window_should_close())
        call begin_drawing()
            call clear_background(black)
            
            ! Update code
            !$OMP PARALLEL
            !$OMP DO
            do i = 1, size(world)
                call world(i)%recalculate_velocity(world, world_size)
                call world(i)%update()
            end do
            !$OMP END DO
            !$OMP END PARALLEL

            do i = 1, size(world)
                call world(i)%draw()
            end do

            ! Infos
            call draw_text("By: sama.gharib-ali-barura@proton.me" // char(0), 350, 10, 24, darkgray)
            call draw_text("Left click: Push away" // char(0), 350, 40, 32, white)
            call draw_text("Right click: Pull closer" // char(0), 350, 80, 32, white)

            call draw_fps(10, 10)  
        call end_drawing()
    end do

    call close_window()
end program main
