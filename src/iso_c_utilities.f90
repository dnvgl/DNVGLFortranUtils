! Copyright (C) 2010 by Germanischer Lloyd AG

! ======================================================================
! Task      Provide utilities for FORTRAN/C Mixed language programming.
! ----------------------------------------------------------------------
! Author    Berthold Hoellmann <hoel@GL-group.com>
! Project   GLPy
! ======================================================================


! ID: $Id$

MODULE ISO_C_UTILITIES
  USE, INTRINSIC :: ISO_C_BINDING ! Intrinsic module

  CHARACTER(C_CHAR), DIMENSION(1), SAVE, TARGET, PRIVATE :: dummy_string="?"

CONTAINS

  FUNCTION C_F_STRING(CPTR) RESULT(FPTR)
    ! Convert a null-terminated C string into a Fortran character array pointer
    TYPE(C_PTR), INTENT(IN) :: CPTR ! The C address
    CHARACTER(C_CHAR), DIMENSION(:), POINTER :: FPTR

    INTERFACE ! strlen is a standard C function from <string.h>
       ! int strlen(char *string)
       FUNCTION strlen(string) RESULT(len) BIND(C,NAME="strlen")
         USE, INTRINSIC :: ISO_C_BINDING
         TYPE(C_PTR), VALUE :: string ! A C pointer
         INTEGER(C_SIZE_T) :: len
       END FUNCTION strlen
    END INTERFACE

    IF(C_ASSOCIATED(CPTR)) THEN
       CALL C_F_POINTER(FPTR=FPTR, CPTR=CPTR, SHAPE=[strlen(CPTR)])
    ELSE
       ! To avoid segfaults, associate FPTR with a dummy target:
       FPTR => dummy_string
    END IF

  END FUNCTION C_F_STRING

END MODULE ISO_C_UTILITIES

! Local Variables:
! End:
