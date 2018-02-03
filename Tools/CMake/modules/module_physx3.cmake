# -----------------------------------------------------------------------------
# Copyright (c) 2017 GarageGames, LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
# -----------------------------------------------------------------------------

# module Physx 3.4

#do note the inconsistent upper/lower case nvidia use for directory names in physx

option(TORQUE_PHYSICS_PHYSX3 "Use PhysX 3.4 physics" OFF)

if( NOT TORQUE_PHYSICS_PHYSX3 )
   return()
endif()

if("${PHYSX3_BASE_PATH}" STREQUAL "")
   set(PHYSX3_BASE_PATH "" CACHE PATH "PhysX 3.4 path" FORCE)
endif()

#still no path we can't go any further
if("${PHYSX3_BASE_PATH}" STREQUAL "")
   message(FATAL_ERROR "No PhysX path selected")
   return()
endif()

#set physx path
set(PHYSX3_PATH "${PHYSX3_BASE_PATH}/PhysX_3.4")

# Windows/ Visual Studio
if(MSVC)
if(TORQUE_CPU_X32)
   if(MSVC11)
      set(PHYSX3_LIBPATH_PREFIX vc11win32)
   elseif(MSVC12)
      set(PHYSX3_LIBPATH_PREFIX vc12win32)
   elseif(MSVC14)
      set(PHYSX3_LIBPATH_PREFIX vc14win32)
   else()
      message(FATAL_ERROR "This version of VS is not supported")
      return()
   endif()
set(PHYSX3_LIBNAME_POSTFIX _x86)

elseif(TORQUE_CPU_X64)
   if(MSVC11)
      set(PHYSX3_LIBPATH_PREFIX vc11win64)
   elseif(MSVC12)
      set(PHYSX3_LIBPATH_PREFIX vc12win64)
   elseif(MSVC14)
      set(PHYSX3_LIBPATH_PREFIX vc14win64)
   else()
      message(FATAL_ERROR "This version of VS is not supported")
      return()
   endif()
   set(PHYSX3_LIBNAME_POSTFIX _x64)

   endif()
endif()

# Only suport 64bit on macOS and linux
if(APPLE)
   set(PHYSX3_LIBPATH_PREFIX osx64)
   set(PHYSX3_LIBNAME_POSTFIX _x64)
elseif(UNIX)
   set(PHYSX3_LIBPATH_PREFIX linux64)
   set(PHYSX3_LIBNAME_POSTFIX _x64)
endif()

MACRO(FIND_PHYSX3_LIBRARY VARNAME LIBNAME WITHPOSTFIX SEARCHDIR)

   set(LIBPOSTFIX "")
   if(${WITHPOSTFIX})
      set(LIBPOSTFIX ${PHYSX3_LIBNAME_POSTFIX})
   endif(${WITHPOSTFIX})
   #release
   find_library(PHYSX3_${VARNAME}_LIBRARY NAMES ${LIBNAME}${LIBPOSTFIX} PATHS ${SEARCHDIR}${PHYSX3_LIBPATH_PREFIX})
   #debug
   find_library(PHYSX3_${VARNAME}_LIBRARY_DEBUG NAMES ${LIBNAME}DEBUG${LIBPOSTFIX} PATHS ${SEARCHDIR}${PHYSX3_LIBPATH_PREFIX})

ENDMACRO()

# Find the Libs
if( WIN32 )
   FIND_PHYSX3_LIBRARY(CORE PhysX3 1 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(COMMON PhysX3Common 1 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(COOKING PhysX3Cooking 1 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(CHARACTER PhysX3CharacterKinematic 1 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(EXTENSIONS PhysX3Extensions 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(TASK PxTask 1 ${PHYSX3_BASE_PATH}/PxShared/Lib/)
   FIND_PHYSX3_LIBRARY(FOUNDATION PxFoundation 1 ${PHYSX3_BASE_PATH}/PxShared/Lib/)
   FIND_PHYSX3_LIBRARY(PVD PxPvdSDK 1 ${PHYSX3_BASE_PATH}/PxShared/Lib/)

   if(NOT PHYSX3_CORE_LIBRARY)
      message(FATAL_ERROR "Could not find core PhysX lib")
      return()
   endif()

   #Add the libs
   set(PHYSX_LIBRARIES
      ${PHYSX3_CORE_LIBRARY}
      ${PHYSX3_COMMON_LIBRARY}
      ${PHYSX3_EXTENSIONS_LIBRARY}
      ${PHYSX3_COOKING_LIBRARY}
      ${PHYSX3_CHARACTER_LIBRARY}
      ${PHYSX3_TASK_LIBRARY}
      ${PHYSX3_PVD_LIBRARY}
      ${PHYSX3_FOUNDATION_LIBRARY}
   )

   set(PHYSX_LIBRARIES_DEBUG
      ${PHYSX3_CORE_LIBRARY_DEBUG}
      ${PHYSX3_COMMON_LIBRARY_DEBUG}
      ${PHYSX3_EXTENSIONS_LIBRARY_DEBUG}
      ${PHYSX3_COOKING_LIBRARY_DEBUG}
      ${PHYSX3_CHARACTER_LIBRARY_DEBUG}
      ${PHYSX3_TASK_LIBRARY_DEBUG}
      ${PHYSX3_PVD_LIBRARY_DEBUG}
      ${PHYSX3_FOUNDATION_LIBRARY_DEBUG}
   )
#macOS & linux
elseif(UNIX)
   #common
   FIND_PHYSX3_LIBRARY(EXTENSIONS PhysX3Extensions 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(CONTROLLER SimulationController 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(SCENEQUERY SceneQuery 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(LOWLEVEL LowLevel 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(LOWLEVEL_DYNAMICS LowLevelDynamics 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(LOWLEVEL_AABB LowLevelAABB 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(LOWLEVEL_CLOTH LowLevelCloth 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(LOWLEVEL_PARTICLES LowLevelParticles 0 ${PHYSX3_PATH}/Lib/)
   FIND_PHYSX3_LIBRARY(TASK PxTask 0 ${PHYSX3_BASE_PATH}/PxShared/lib/)
   #platform dependent
   if(APPLE)
      FIND_PHYSX3_LIBRARY(CORE PhysX3 0 ${PHYSX3_PATH}/Lib/)
      FIND_PHYSX3_LIBRARY(COMMON PhysX3Common 0 ${PHYSX3_PATH}/Lib/)
	  FIND_PHYSX3_LIBRARY(COOKING PhysX3Cooking 0 ${PHYSX3_PATH}/Lib/)
	  FIND_PHYSX3_LIBRARY(CHARACTER PhysX3CharacterKinematic 0 ${PHYSX3_PATH}/Lib/)
      FIND_PHYSX3_LIBRARY(FOUNDATION PxFoundation 0 ${PHYSX3_BASE_PATH}/PxShared/lib/)
      FIND_PHYSX3_LIBRARY(PVD PxPvdSDK 0 ${PHYSX3_BASE_PATH}/PxShared/lib/)
  else() #linux
      FIND_PHYSX3_LIBRARY(CORE PhysX3 1 ${PHYSX3_PATH}/Bin/)
      FIND_PHYSX3_LIBRARY(COMMON PhysX3Common 1 ${PHYSX3_PATH}/Bin/)
      FIND_PHYSX3_LIBRARY(GPU PhysX3Gpu 1 ${PHYSX3_PATH}/Bin/)
      FIND_PHYSX3_LIBRARY(CHARACTER PhysX3CharacterKinematic 1 ${PHYSX3_PATH}/Bin/)
      FIND_PHYSX3_LIBRARY(COOKING PhysX3Cooking 1 ${PHYSX3_PATH}/Bin/)
      FIND_PHYSX3_LIBRARY(FOUNDATION PxFoundation 1 ${PHYSX3_BASE_PATH}/PxShared/bin/)
      FIND_PHYSX3_LIBRARY(PVD PxPvdSDK 1 ${PHYSX3_BASE_PATH}/PxShared/bin/)
	  FIND_PHYSX3_LIBRARY(XML PsFastXml 0 ${PHYSX3_BASE_PATH}/PxShared/lib/)
   endif()

   if(NOT PHYSX3_CORE_LIBRARY)
      message(FATAL_ERROR "Could not find core PhysX lib")
      return()
   endif()

   #Add the libs
   set(PHYSX_LIBRARIES
      ${PHYSX3_CORE_LIBRARY}
      ${PHYSX3_CHARACTER_LIBRARY}
      ${PHYSX3_COOKING_LIBRARY}
      ${PHYSX3_COMMON_LIBRARY}
      ${PHYSX3_GPU_LIBRARY}
      ${PHYSX3_EXTENSIONS_LIBRARY}
      ${PHYSX3_CONTROLLER_LIBRARY}
      ${PHYSX3_SCENEQUERY_LIBRARY}
      ${PHYSX3_LOWLEVEL_LIBRARY}
      ${PHYSX3_LOWLEVEL_AABB_LIBRARY}
      ${PHYSX3_LOWLEVEL_DYNAMICS_LIBRARY}
      ${PHYSX3_LOWLEVEL_CLOTH_LIBRARY}
      ${PHYSX3_LOWLEVEL_PARTICLES_LIBRARY}
      ${PHYSX3_TASK_LIBRARY}
      ${PHYSX3_XML_LIBRARY}
      ${PHYSX3_FOUNDATION_LIBRARY}
      ${PHYSX3_PVD_LIBRARY}
   )

   set(PHYSX_LIBRARIES_DEBUG
      ${PHYSX3_CORE_LIBRARY_DEBUG}
      ${PHYSX3_CHARACTER_LIBRARY_DEBUG}
      ${PHYSX3_COOKING_LIBRARY_DEBUG}
      ${PHYSX3_COMMON_LIBRARY_DEBUG}
      ${PHYSX3_GPU_LIBRARY_DEBUG}
      ${PHYSX3_EXTENSIONS_LIBRARY_DEBUG}
      ${PHYSX3_CONTROLLER_LIBRARY_DEBUG}
      ${PHYSX3_SCENEQUERY_LIBRARY_DEBUG}
      ${PHYSX3_LOWLEVEL_LIBRARY_DEBUG}
      ${PHYSX3_LOWLEVEL_AABB_LIBRARY_DEBUG}
      ${PHYSX3_LOWLEVEL_DYNAMICS_LIBRARY_DEBUG}
      ${PHYSX3_LOWLEVEL_CLOTH_LIBRARY_DEBUG}
      ${PHYSX3_LOWLEVEL_PARTICLES_LIBRARY_DEBUG}
      ${PHYSX3_TASK_LIBRARY_DEBUG}
      ${PHYSX3_XML_LIBRARY_DEBUG}
      ${PHYSX3_FOUNDATION_LIBRARY_DEBUG}
      ${PHYSX3_PVD_LIBRARY_DEBUG}
   )

endif()

# Defines
addDef( "TORQUE_PHYSICS_PHYSX3" )
addDef( "TORQUE_PHYSICS_ENABLED" )

# Source
addPath( "${srcDir}/T3D/physics/physx3" )

# Includes
addInclude( "${PHYSX3_BASE_PATH}/PxShared/include" )
addInclude( "${PHYSX3_BASE_PATH}/PxShared/src/foundation/include" )
addInclude( "${PHYSX3_BASE_PATH}/PxShared/src/pvd/include" )
addInclude( "${PHYSX3_PATH}/Include" )

# Libs
addLibRelease( "${PHYSX_LIBRARIES}" )
addLibDebug( "${PHYSX_LIBRARIES_DEBUG}" )

#Install files
if( WIN32 )
   # File Copy for Release
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3Gpu${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3CharacterKinematic${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3Common${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3Cooking${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/PxFoundation${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/PxPvdSDK${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)

   # File Copy
   if(TORQUE_CPU_X32)
      INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysXDevice.dll"             DESTINATION "${projectOutDir}")
      INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/nvToolsExt32_1.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   elseif(TORQUE_CPU_X64)
      INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysXDevice64.dll"             DESTINATION "${projectOutDir}")
      INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/nvToolsExt64_1.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   endif()
   
   #File copy for Debug
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3DEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3GpuDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3CharacterKinematicDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3CommonDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/PhysX3CookingDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/PxFoundationDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/PxPvdSDKDEBUG${PHYSX3_LIBNAME_POSTFIX}.dll"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)

endif()

#linux - apple xcode physx build generates static libs
if(UNIX AND NOT APPLE)
   # File Copy for Release
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3CharacterKinematic${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3Common${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3Cooking${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/libPxFoundation${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/libPxPvdSDK${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3Gpu${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Release)

   # File Copy for Debug
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3DEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3CharacterKinematicDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3CommonDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3CookingDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/libPxFoundationDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_BASE_PATH}/PxShared/bin/${PHYSX3_LIBPATH_PREFIX}/libPxPvdSDKDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)
   INSTALL(FILES "${PHYSX3_PATH}/Bin/${PHYSX3_LIBPATH_PREFIX}/libPhysX3GpuDEBUG${PHYSX3_LIBNAME_POSTFIX}.so"             DESTINATION "${projectOutDir}" CONFIGURATIONS Debug)

endif()
