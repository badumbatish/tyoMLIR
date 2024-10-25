
cmake_minimum_required(VERSION 3.28)

project(tyo)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(MLIR REQUIRED CONFIG)
find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")

include_directories(SYSTEM ${MLIR_INCLUDE_DIRS})
include(AddMLIR)
include(AddLLVM)
include(TableGen)

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS_LIST})
llvm_map_components_to_libnames(llvm_libs native orcjit core support irreader option)

message(${MLIR_DIR})

# This is to make sure we can link
#   typeinfo errors in general hint that LLVM is built without RTTI (the default) 
#   and your client code is built with it.



# set(NO_RTTI "-fno-rtti")
# add_definitions(${NO_RTTI})
add_subdirectory(include/tyo)



add_executable(tyo tyo.cpp parser/AST.cpp mlir/Dialect.cpp )
add_dependencies(tyo tyoIncGen)
target_link_libraries(tyo
  PRIVATE
  ${llvm_libs} LLVMSupport
    MLIRAnalysis
    MLIRFunctionInterfaces
    MLIRIR
    MLIRParser
    MLIRSideEffectInterfaces
    MLIRTransforms)
target_include_directories(tyo PUBLIC ${CMAKE_SOURCE_DIR}/include/)
target_include_directories(tyo PUBLIC ${CMAKE_BINARY_DIR}/include/)
llvm_update_compile_flags(tyo)

# set(LLVM_TARGET_DEFINITIONS toyDialect.td)

## Set your TableGen files
# mlir_tablegen(toyDialect.h.inc -gen-dialect-decls )
# mlir_tablegen(toyDialect.cpp.inc -gen-dialect-defs )
# add_public_tablegen_target(toyDialectIncGen) 
# add_mlir_library(
#     toy
#
#     a.cpp
#
#     DEPENDS toyDialectIncGen
#     LINK_LIBS PUBLIC
# )
