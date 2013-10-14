# -*- cmake -*-

SET(DEBUG_PKG_CONFIG "YES")

# Don't change this if manually set by user.
IF("$ENV{PKG_CONFIG_LIBDIR}" STREQUAL "")

  # Guess at architecture-specific system library paths.
  if (WORD_SIZE EQUAL 32)
    SET(PKG_CONFIG_NO_MULTI_GUESS /usr/lib32 /usr/lib)
    SET(PKG_CONFIG_NO_MULTI_LOCAL_GUESS /usr/local/lib32 /usr/local/lib)
    SET(PKG_CONFIG_MULTI_GUESS /usr/lib/i386-linux-gnu)
    SET(PKG_CONFIG_MULTI_LOCAL_GUESS /usr/local/lib/i386-linux-gnu)
  else (WORD_SIZE EQUAL 32)
    SET(PKG_CONFIG_NO_MULTI_GUESS /usr/lib64 /usr/lib)
    SET(PKG_CONFIG_NO_MULTI_LOCAL_GUESS /usr/local/lib64 /usr/local/lib)
    SET(PKG_CONFIG_MULTI_GUESS /usr/lib/x86_64-linux-gnu)
    SET(PKG_CONFIG_MULTI_LOCAL_GUESS /usr/local/lib/x86_64-linux-gnu)
  endif (WORD_SIZE EQUAL 32)
  
  # Use DPKG architecture, if available.
  IF (${DPKG_ARCH})
    SET(PKG_CONFIG_MULTI_GUESS /usr/lib/${DPKG_ARCH})
    SET(PKG_CONFIG_MULTI_LOCAL_GUESS /usrlocal/lib/${DPKG_ARCH})
  ENDIF (${DPKG_ARCH})
  
  # Explicitly include anything listed in PKG_CONFIG_PATH
  string(REPLACE ":" ";" PKG_CONFIG_PATH_LIST "$ENV{PKG_CONFIG_PATH}")
  FOREACH(PKG_CONFIG_DIR ${PKG_CONFIG_PATH_LIST})
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_DIR}/pkgconfig")
  ENDFOREACH(PKG_CONFIG_DIR)

  # Look for valid pkgconfig directories.
  FIND_PATH(PKG_CONFIG_ENV pkgconfig ENV LD_LIBRARY_PATH)
  FIND_PATH(PKG_CONFIG_MULTI pkgconfig HINT ${PKG_CONFIG_MULTI_GUESS})
  FIND_PATH(PKG_CONFIG_MULTI_LOCAL pkgconfig HINT ${PKG_CONFIG_MULTI_LOCAL_GUESS})
  FIND_PATH(PKG_CONFIG_NO_MULTI pkgconfig HINT ${PKG_CONFIG_NO_MULTI_GUESS})
  FIND_PATH(PKG_CONFIG_NO_MULTI_LOCAL pkgconfig HINT ${PKG_CONFIG_NO_MULTI_LOCAL_GUESS})

  # Add anything we found to our list.
  IF(NOT PKG_CONFIG_ENV STREQUAL PKG_CONFIG_ENV-NOTFOUND) 
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_ENV}/pkgconfig")
  ENDIF(NOT PKG_CONFIG_ENV STREQUAL PKG_CONFIG_ENV-NOTFOUND) 

  IF(NOT PKG_CONFIG_MULTI STREQUAL PKG_CONFIG_MULTI-NOTFOUND) 
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_MULTI}/pkgconfig")
  ENDIF(NOT PKG_CONFIG_MULTI STREQUAL PKG_CONFIG_MULTI-NOTFOUND) 

  IF(NOT PKG_CONFIG_MULTI_LOCAL STREQUAL PKG_CONFIG_MULTI_LOCAL-NOTFOUND) 
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_MULTI_LOCAL}/pkgconfig")
  ENDIF(NOT PKG_CONFIG_MULTI_LOCAL STREQUAL PKG_CONFIG_MULTI_LOCAL-NOTFOUND) 

  IF(NOT PKG_CONFIG_NO_MULTI STREQUAL PKG_CONFIG_NO_MULTI-NOTFOUND) 
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_NO_MULTI}/pkgconfig")
  ENDIF(NOT PKG_CONFIG_NO_MULTI STREQUAL PKG_CONFIG_NO_MULTI-NOTFOUND) 

  IF(NOT PKG_CONFIG_NO_MULTI_LOCAL STREQUAL PKG_CONFIG_NO_MULTI_LOCAL-NOTFOUND) 
    SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:${PKG_CONFIG_NO_MULTI_LOCAL}/pkgconfig")
  ENDIF(NOT PKG_CONFIG_NO_MULTI_LOCAL STREQUAL PKG_CONFIG_NO_MULTI_LOCAL-NOTFOUND) 

  # Also add some non-architecture specific package locations.
  SET(VALID_PKG_LIBDIRS "${VALID_PKG_LIBDIRS}:/usr/share/pkgconfig:/usr/local/share/pkgconfig")

  # Remove first unwanted ':'
  string(SUBSTRING ${VALID_PKG_LIBDIRS} 1 -1 VALID_PKG_LIBDIRS)

  # Set PKG_CONFIG_LIBDIR environment.
  SET(ENV{PKG_CONFIG_LIBDIR} ${VALID_PKG_LIBDIRS})
ENDIF("$ENV{PKG_CONFIG_LIBDIR}" STREQUAL "")

IF(DEBUG_PKG_CONFIG)
  MESSAGE(STATUS "Using PKG_CONFIG_LIBDIR=$ENV{PKG_CONFIG_LIBDIR}")
ENDIF(DEBUG_PKG_CONFIG)

