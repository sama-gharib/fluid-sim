module vector_operations
    use raylib, only: vector2_type
    use raylib_math

    implicit none

    ! Maps raylib's Vector operations to operators

    interface operator(+)
        module procedure vector2_add
        module procedure vector3_add
    end interface
    interface operator(-)
        module procedure vector2_subtract
        module procedure vector3_subtract
    end interface
    interface operator(*)
        module procedure vector2_dot_product
        module procedure vector2_scale
        module procedure vector3_dot_product
        module procedure vector3_scale
    end interface
    interface operator(==)
        module procedure vector2_equal
    end interface

contains

    logical function vector2_equal(u, v)
        type(vector2_type), intent(in) :: u
        type(vector2_type), intent(in) :: v

        vector2_equal = v%x == u%x .and. v%y == u%y
    end function vector2_equal

end module