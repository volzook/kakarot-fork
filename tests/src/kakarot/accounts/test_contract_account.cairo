%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy

from kakarot.accounts.contract.library import ContractAccount

func test__initialize__should_store_given_evm_address{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // Given
    local evm_address: felt;
    local kakarot_address: felt;
    %{
        ids.evm_address = program_input["evm_address"]
        ids.kakarot_address = program_input["kakarot_address"]
    %}

    // When
    ContractAccount.initialize(kakarot_address, evm_address);

    return ();
}

func test__get_evm_address__should_return_stored_address{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() -> felt {
    let (evm_address) = ContractAccount.get_evm_address();

    return evm_address;
}

func test__write_bytecode{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    // Given
    local bytecode_len: felt;
    let (bytecode: felt*) = alloc();
    %{
        ids.bytecode_len = len(program_input["bytecode"])
        segments.write_arg(ids.bytecode, program_input["bytecode"])
    %}

    ContractAccount.write_bytecode(bytecode_len, bytecode);

    return ();
}

func test__read_bytecode{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() -> (bytecode_len: felt, bytecode: felt*) {
    alloc_locals;
    let (bytecode_len, bytecode) = ContractAccount.bytecode();
    return (bytecode_len, bytecode);
}
