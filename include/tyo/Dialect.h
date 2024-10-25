#ifndef MLIR_TYO_DIALECT_H_
#define MLIR_TYO_DIALECT_H_
#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

// Include the auto-generated header file containing the dialect
#include "tyo/Dialect.h.inc"

// INclude the auto-generated header file containing tyo ops
#define GET_OP_CLASSES
#include "tyo/Ops.h.inc"
#endif // MLIR_TYO_DIALECT_H_
