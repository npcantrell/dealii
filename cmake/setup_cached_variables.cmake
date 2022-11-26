## ---------------------------------------------------------------------
##
## Copyright (C) 2012 - 2022 by the deal.II authors
##
## This file is part of the deal.II library.
##
## The deal.II library is free software; you can use it, redistribute
## it, and/or modify it under the terms of the GNU Lesser General
## Public License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.
## The full text of the license can be found in the file LICENSE.md at
## the top level directory of deal.II.
##
## ---------------------------------------------------------------------

#
# Set up cached variables (prior to the project(deal.II) call)
#
# This file sets up the following cached Options:
#
# General configuration options:
#
#     DEAL_II_ALLOW_BUNDLED
#     DEAL_II_COMPONENT_DOCUMENTATION
#     DEAL_II_COMPONENT_EXAMPLES
#     DEAL_II_COMPONENT_PACKAGE
#     DEAL_II_COMPONENT_PYTHON_BINDINGS
#     DEAL_II_ALLOW_AUTODETECTION
#     DEAL_II_FORCE_AUTODETECTION
#
# Options regarding compilation and linking:
#
#     CMAKE_BUILD_TYPE
#     DEAL_II_ALLOW_PLATFORM_INTROSPECTION
#     DEAL_II_SETUP_DEFAULT_COMPILER_FLAGS
#     DEAL_II_SETUP_COVERAGE
#     DEAL_II_UNITY_BUILD
#     DEAL_II_EARLY_DEPRECATIONS
#     BUILD_SHARED_LIBS
#     DEAL_II_PREFER_STATIC_LIBS
#     DEAL_II_STATIC_EXECUTABLE
#     CMAKE_INSTALL_RPATH_USE_LINK_PATH
#     DEAL_II_CXX_FLAGS                    *)
#     DEAL_II_CXX_FLAGS_DEBUG
#     DEAL_II_CXX_FLAGS_RELEASE
#     DEAL_II_LINKER_FLAGS                 *)
#     DEAL_II_LINKER_FLAGS_DEBUG
#     DEAL_II_LINKER_FLAGS_RELEASE
#     DEAL_II_DEFINITIONS
#     DEAL_II_DEFINITIONS_DEBUG
#     DEAL_II_DEFINITIONS_RELEASE
#
# Components and miscellaneous options:
#
#     DEAL_II_WITH_64BIT_INDICES
#     DEAL_II_WITH_COMPLEX_VALUES
#     DEAL_II_COMPILE_EXAMPLES
#     DEAL_II_DOXYGEN_USE_MATHJAX
#     DEAL_II_DOXYGEN_USE_ONLINE_MATHJAX
#     DEAL_II_CPACK_EXTERNAL_LIBS
#     DEAL_II_CPACK_BUNDLE_NAME
#
# *)  May also be set via environment variable (CXXFLAGS, LDFLAGS)
#     (a nonempty cached variable has precedence and will not be
#     overwritten by environment)
#


########################################################################
#                                                                      #
#                    General configuration options:                    #
#                                                                      #
########################################################################

if(DEAL_II_HAVE_BUNDLED_DIRECTORY)
  option(DEAL_II_ALLOW_BUNDLED
    "Allow the use of libraries bundled with the source tarball. (DEAL_II_FORCE_BUNDLED* will overwrite this option.)"
    ON
    )
endif()

if(DEAL_II_HAVE_DOC_DIRECTORY)
  option(DEAL_II_COMPONENT_DOCUMENTATION
    "Enable configuration, build and installation of the documentation. This adds a COMPONENT \"documentation\" to the build system."
    OFF
    )
  list(APPEND DEAL_II_COMPONENTS DOCUMENTATION)

endif()

option(DEAL_II_COMPONENT_EXAMPLES
  "Enable configuration and installation of the example steps. This adds a COMPONENT \"examples\" to the build system."
  ON
  )
list(APPEND DEAL_II_COMPONENTS EXAMPLES)

option(DEAL_II_COMPONENT_PACKAGE
  "Generates additional targets for packaging deal.II"
  OFF
  )
list(APPEND DEAL_II_COMPONENTS PACKAGE)

option(DEAL_II_COMPONENT_PYTHON_BINDINGS
  "Enable configuration and installation of the python bindings. This adds a COMPONENT \"PYTHON_BINDINGS\" to the build system."
  OFF
  )
list(APPEND DEAL_II_COMPONENTS PYTHON_BINDINGS)

option(DEAL_II_ALLOW_AUTODETECTION
  "Allow to automatically set up features by setting all undefined DEAL_II_WITH_* variables to ON or OFF"
  ON
  )

option(DEAL_II_FORCE_AUTODETECTION
  "Force feature autodetection by undefining all DEAL_II_WITH_* variables prior to configure"
  OFF
  )


########################################################################
#                                                                      #
#           Configuration options for Compilation and linking:         #
#                                                                      #
########################################################################

#
# Setup CMAKE_BUILD_TYPE:
#

set(CMAKE_BUILD_TYPE
  "DebugRelease"
  CACHE STRING
  "Choose the type of build, options are: Debug, Release and DebugRelease."
  )

# This is cruel, I know. But it is better to only have a known number of
# options for CMAKE_BUILD_TYPE...
if( NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Release" AND
    NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug" AND
    NOT "${CMAKE_BUILD_TYPE}" STREQUAL "DebugRelease" )
  message(FATAL_ERROR
    "CMAKE_BUILD_TYPE does neither match Release, Debug, nor DebugRelease!"
    )
endif()

#
# Configuration behaviour:
#

option(DEAL_II_ALLOW_PLATFORM_INTROSPECTION
  "Allow platform introspection for CPU command sets, SSE and AVX"
  ON
  )
mark_as_advanced(DEAL_II_ALLOW_PLATFORM_INTROSPECTION)

option(DEAL_II_SETUP_DEFAULT_COMPILER_FLAGS
  "Configure sensible default CFLAGS and CXXFLAGS depending on platform, compiler and build target."
  ON
  )
mark_as_advanced(DEAL_II_SETUP_DEFAULT_COMPILER_FLAGS)

option(DEAL_II_SETUP_COVERAGE
  "Setup debug compiler flags to provide additional test coverage information. Currently only gprof is supported."
  OFF
  )
mark_as_advanced(DEAL_II_SETUP_COVERAGE)

option(DEAL_II_UNITY_BUILD
  "Compile the library by concatenating together source files to form a few large targets instead of many small ones. This lowers total compilation wall time by about 25%."
  OFF)
mark_as_advanced(DEAL_II_UNITY_BUILD)

option(DEAL_II_EARLY_DEPRECATIONS
  "Enable deprecation warnings for features deprecated since the last release."
  OFF)
mark_as_advanced(DEAL_II_EARLY_DEPRECATIONS)

set(BUILD_SHARED_LIBS "ON" CACHE BOOL
  "Build a shared library"
  )

option(DEAL_II_PREFER_STATIC_LIBS
  "Prefer static libraries over dynamic libraries when searching for features and corresponding link interface"
  OFF
  )
mark_as_advanced(DEAL_II_PREFER_STATIC_LIBS)

option(DEAL_II_STATIC_EXECUTABLE
  "Provide a link interface that is suitable for static linkage of executables. Enabling this option forces BUILD_SHARED_LIBS=OFF and DEAL_II_PREFER_STATIC_LIBS=ON"
  OFF
  )
mark_as_advanced(DEAL_II_STATIC_EXECUTABLE)

if(DEAL_II_STATIC_EXECUTABLE)
  set(BUILD_SHARED_LIBS "OFF" CACHE BOOL
    "Build a shared library"
    FORCE
    )
  set(DEAL_II_PREFER_STATIC_LIBS "ON" CACHE BOOL
    "Prefer static libraries over dynamic libraries when searching for features and corresponding link interface"
    FORCE
    )
endif()

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH "ON" CACHE BOOL
  "Set the rpath of the library to the external link paths on installation"
  )
mark_as_advanced(CMAKE_INSTALL_RPATH_USE_LINK_PATH)


########################################################################
#                                                                      #
#                       Compilation and linking:                       #
#                                                                      #
########################################################################

#
# Hide all unused CMake variables:
#

set(DEAL_II_REMOVED_FLAGS
  CMAKE_CXX_FLAGS
  CMAKE_CXX_FLAGS_RELEASE
  CMAKE_CXX_FLAGS_DEBUG
  CMAKE_CXX_FLAGS_MINSIZEREL
  CMAKE_CXX_FLAGS_RELWITHDEBINFO
  CMAKE_C_FLAGS
  CMAKE_C_FLAGS_RELEASE
  CMAKE_C_FLAGS_DEBUG
  CMAKE_C_FLAGS_MINSIZEREL
  CMAKE_C_FLAGS_RELWITHDEBINFO
  CMAKE_Fortran_FLAGS
  CMAKE_Fortran_FLAGS_RELEASE
  CMAKE_Fortran_FLAGS_DEBUG
  CMAKE_Fortran_FLAGS_MINSIZEREL
  CMAKE_Fortran_FLAGS_RELWITHDEBINFO
  CMAKE_SHARED_LINKER_FLAGS
  CMAKE_SHARED_LINKER_FLAGS_DEBUG
  CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL
  CMAKE_SHARED_LINKER_FLAGS_RELEASE
  CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO
  )
foreach(_flag ${DEAL_II_REMOVED_FLAGS})
  #
  # Promote all variables to internal cache. This prevents CMake from
  # populating these variables with default values. Further, store the
  # actual content of the variables such that users can still use
  # CMAKE_CXX_FLAGS(|_RELEASE|_DEBUG).
  #
  set(${_flag} ${${_flag}} CACHE INTERNAL "" FORCE)
endforeach()

#
# Promote our configuration variables to cache:
#

set(DEAL_II_USED_FLAGS
  DEAL_II_CXX_FLAGS
  DEAL_II_CXX_FLAGS_DEBUG
  DEAL_II_CXX_FLAGS_RELEASE
  DEAL_II_LINKER_FLAGS
  DEAL_II_LINKER_FLAGS_DEBUG
  DEAL_II_LINKER_FLAGS_RELEASE
  )
foreach(_flag ${DEAL_II_USED_FLAGS})
  set(${_flag} "${${_flag}}" CACHE STRING
    "The user supplied cache variable will be appended _at the end_ of the configuration step to the auto generated ${_flag} variable"
    )
  mark_as_advanced(${_flag})
endforeach()

foreach(_variable
  DEAL_II_DEFINITIONS
  DEAL_II_DEFINITIONS_DEBUG
  DEAL_II_DEFINITIONS_RELEASE
  )
  set(${_variable} ${${_variable}} CACHE STRING
    "Additional, user supplied compile definitions"
    )
  mark_as_advanced(${_variable})
endforeach()

#
# Translate CMake specific variables to deal.II naming:
#

foreach(_flag
    CXX_FLAGS CXX_FLAGS_RELEASE CXX_FLAGS_DEBUG
    )
  if(NOT "${CMAKE_${_flag}}" STREQUAL "")
    message(STATUS
      "Prepending \${CMAKE_${_flag}} to \${DEAL_II_${_flag}}"
      )
    set(DEAL_II_${_flag} "${CMAKE_${_flag}} ${DEAL_II_${_flag}}")
  endif()
endforeach()

foreach(_flag LINKER_FLAGS LINKER_FLAGS_DEBUG LINKER_FLAGS_RELEASE)
  if(NOT "${CMAKE_SHARED_${_flag}}" STREQUAL "")
    message(STATUS
      "Prepending \${CMAKE_SHARED_${_flag}} to \${DEAL_II_${_flag}}"
      )
    set(DEAL_II_${_flag} "${CMAKE_${_flag}} ${DEAL_II_${_flag}}")
  endif()
endforeach()



#
# Store user supplied flags in ${_flag}_SAVED and clear configuration
# variables.
#

foreach(_flag ${DEAL_II_USED_FLAGS})
  #
  # The order of compiler and linker flags is important. In order to
  # provide an override mechanism we have to save the initial (cached)
  # variable at this point and clear it.
  # ${flags}_SAVED will be appended to ${flags} again in
  # setup_finalize.cmake (called at the end of the main CMakeLists.txt
  # file).
  #
  set(${_flag}_SAVED ${${_flag}})
  set(${_flag} "")
endforeach()

#
# Also set all unused CMAKE_* flags to an empty string for the
# configuration run so that it does not confuse the build system (to unset
# is not an option - it is cached...)
#
foreach(_flag ${DEAL_II_REMOVED_FLAGS})
  set(${_flag} "")
endforeach()

#
# Finally, read in CXXFLAGS, LDFLAGS and NVCCFLAGS from environment and
# prepend them to the saved variables:
#
# Also strip leading and trailing whitespace from linker flags to make
# old cmake versions happy
#

set(DEAL_II_CXX_FLAGS_SAVED "$ENV{CXXFLAGS} ${DEAL_II_CXX_FLAGS_SAVED}")
string(STRIP "${DEAL_II_CXX_FLAGS_SAVED}" DEAL_II_CXX_FLAGS_SAVED)
set(DEAL_II_LINKER_FLAGS_SAVED "$ENV{LDFLAGS} ${DEAL_II_LINKER_FLAGS_SAVED}")
string(STRIP "${DEAL_II_LINKER_FLAGS_SAVED}" DEAL_II_LINKER_FLAGS_SAVED)
unset(ENV{CXXFLAGS})
unset(ENV{LDFLAGS})
unset(ENV{NVCCFLAGS})


########################################################################
#                                                                      #
#                Components and miscellaneous setup:                   #
#                                                                      #
########################################################################

option(DEAL_II_WITH_64BIT_INDICES
  "If set to ON, then use 64-bit data types to represent global degree of freedom indices. The default is to OFF. You only want to set this to ON if you will solve problems with more than 2^31 (approximately 2 billion) unknowns. If set to ON, you also need to ensure that both Trilinos and/or PETSc support 64-bit indices."
  OFF
  )
list(APPEND DEAL_II_FEATURES 64BIT_INDICES)

option(DEAL_II_WITH_COMPLEX_VALUES
  "If set to OFF, the classes that take a number type are not explicitly instantiated for std::complex<float> and std::complex<double>. This effectively disables the support for computing with complex values. If PETSc is built with complex scalar type, this option must be ON."
  ON
  )
list(APPEND DEAL_II_FEATURES COMPLEX_VALUES)

option(DEAL_II_COMPILE_EXAMPLES
  "If set to ON, all configurable example executables will be built and installed as well. If set to OFF, the examples component only installs the source code of example steps."
  ON
  )
mark_as_advanced(DEAL_II_COMPILE_EXAMPLES)

option(DEAL_II_DOXYGEN_USE_MATHJAX
  "If set to ON, doxygen documentation is generated using mathjax"
  OFF
  )
mark_as_advanced(DEAL_II_DOXYGEN_USE_MATHJAX)

option(DEAL_II_DOXYGEN_USE_ONLINE_MATHJAX
  "If set to ON, doxygen documentation is generated using online (from CDN) mathjax copy"
  ON
  )
mark_as_advanced(DEAL_II_DOXYGEN_USE_ONLINE_MATHJAX)

set(DEAL_II_CPACK_EXTERNAL_LIBS "opt" CACHE STRING
    "A relative path to tree of external libraries that will be installed in bundle package. The path is relative to the /Applications/${DEAL_II_CPACK_BUNDLE_NAME}.app/Contents/Resources directory. It defaults to opt, but you may want to use a different value, for example if you want to distribute a brew based package."
  )
mark_as_advanced(DEAL_II_CPACK_EXTERNAL_LIBS)

set(DEAL_II_CPACK_BUNDLE_NAME "${DEAL_II_PACKAGE_NAME}" CACHE STRING
    "Name of the application bundle to generate."
  )
mark_as_advanced(DEAL_II_CPACK_BUNDLE_NAME)


########################################################################
#                                                                      #
#                               Finalize:                              #
#                                                                      #
########################################################################

#
# We do not support installation into the binary directory any more ("too
# much pain, not enough profit"):
#

if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_INSTALL_PREFIX}")
  message(FATAL_ERROR "
Error CMAKE_INSTALL_PREFIX is equal to CMAKE_BINARY_DIR.
It is not possible to install into the build directory. Please set
CMAKE_INSTALL_PREFIX to a designated install directory different than
CMAKE_BINARY_DIR.
(Please note that you can use deal.II directly out of a build directory
without the need to install it, if this is what you tried to do.)
"
    )
endif()

#
# Miscellaneous renaming:
#

get_cmake_property(_res VARIABLES)
foreach(_var ${_res})
  #
  # Rename (ALLOW|WITH|FORCE|COMPONENT)_* by DEAL_II_(ALLOW|WITH|FORCE|COMPONENT)_*
  #
  foreach(_match ALLOW_ WITH_ FORCE_ COMPONENT_)
    if(_var MATCHES "^${_match}")
      set(DEAL_II_${_var} ${${_var}} CACHE BOOL "" FORCE)
      unset(${_var} CACHE)
    endif()
  endforeach()

  #
  # Same for components:
  #
  if(_var MATCHES "^(DOCUMENTATION|EXAMPLES|PACKAGE|PYTHON_BINDINGS)")
    set(DEAL_II_COMPONENT_${_var} ${${_var}} CACHE BOOL "" FORCE)
    unset(${_var} CACHE)
  endif()

  #
  # If DEAL_II_FORCE_AUTODETECTION is set undefine all feature toggles
  # DEAL_II_WITH_* prior to configure:
  #
  if(DEAL_II_FORCE_AUTODETECTION AND _var MATCHES "^DEAL_II_WITH_"
     # Exclude FEATURES that do not represent external libraries:
     AND NOT _var MATCHES "^DEAL_II_WITH_64BIT_INDICES" )
    unset(${_var} CACHE)
  endif()
endforeach()
