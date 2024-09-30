//===- Ops.td - Tyo dialect operation definitions ----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Defines the operations of the Tyo dialect.
//
//===----------------------------------------------------------------------===//

#ifndef TYO_OPS
#define TYO_OPS

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// Provide a definition of the 'tyo' dialect in the ODS framework so that we can define our ops
def Tyo_Dialect : Dialect {
  let name = "tyo";
  let cppNamespace = "::mlir::toy";
}

// Base class for tyo dialect operations. This operation inherits from the base
// `Op` class in OpBase.td, and provides:
//  * The parent dialect of the operation
//  * The mnemonic for the operatoin, or the name without the dialect prefix.
//  * A list of traits for the operaition.

class Tyo_Op<string mnemonic, list<Trait> traits = []> :
  Op<Tyo_Dialect, mnemonic, traits>;

//===----------------------------------------------------------------------===//
// Tyo Operations
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// ConstantOp
//===----------------------------------------------------------------------===//

// We define a tyo operation by inheriting from our base 'Tyo_Op' class above.
// Here we provide the mnemonic and a list of traits for the operation. The
// constant operation is marked as 'Pure' as it is a pure operation
// and maybe removed if dead.

def ConstantOp : Tyo_Op<"constant", [Pure]> {
  // Provide a summary and description for this operation. This can be used to 
  // auto-generated documentation of the operations within our dialect.

  let summary = "constant";
  let description = [{
  Constant operation turns a literal into an SSA value. The data is attached to the operation as an attribute.
  For example:

    ```mlir
      %0 = tyo.constant dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf64>
    ```
  }];

  // The constant operation takes an attribute as the only input.
  let arguments = (ins F64ElementsAttr:$value);
  
  // The constant operation returns a single value of TensorType
  let results = (outs F64Tensor);

  // Indicate that the operation has a custom parser and printer method.
  let hasCustomAssemblyFormat = 1;

  // Add custom build methods for the constant
  let builders = [
    // Build a constant with a given constant tensor value.
    OpBuilder<(ins "DenseElementsAttr":$value), [{
        build($_builder, $_state, value.getType(), value);
    }]>,

    // Build a constant with a given constant floating-point value.
    OpBuilder<(ins "double":$value)>
  ];

  // Indicate that additional verification for this operation is necessary.
  let hasVerifier = 1;
}

 
//===----------------------------------------------------------------------===//
// AddOp
//===----------------------------------------------------------------------===//

def AddOp : Tyo_Op<"add"> {
  let summary = "element-wise addition operaton";
  let description = [{
    The "add" operation performs element-wise addition between two tensors.

    The shapes of the tensor operatnds are expected to match.
  }];

  let arguments = (ins F64Tensor:$lhs, F64Tensor:$rhs);
  let results = (outs F64Tensor);

  // Indicate that the operation has a custom parser and printer method.
  let hasCustomAssemblyFormat = 1;

  // Allow building an AddOp with from the two input operands.
  let builders = [
    OpBuilder<(ins "Value":$lhs, "Value":$rhs)>
  ];


}



#endif // TYO_OPS
