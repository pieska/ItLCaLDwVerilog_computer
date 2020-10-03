package common;

	timeunit 1ns/1ps;

	parameter clockperiod = 2;
	
	typedef logic [7:0] data_t;
	typedef logic [7:0] address_t;
	typedef logic [7:0] register_t;
	typedef logic [3:0] ccr_t;

	typedef logic [7:0] opc_t;

	typedef enum logic [2:0] {
		ALU_OP_ADD, ALU_OP_SUB,
		ALU_OP_AND, ALU_OP_OR,
		ALU_OP_INC, ALU_OP_DEC,
		ALU_OP_NUL, ALU_OP_ERR=3'bX} alu_op_t;

/*
		subtype RegisterType is std_logic_vector(63 downto 0);
--	subtype InstructionType is std_logic_vector(31 downto 0);
--	subtype RegisterAddress is std_logic_vector(4 downto 0);
--	subtype MemoryAddress is std_logic_vector(63 downto 0);
*/

	const opc_t OPC_LDA_IMM	= 8'h86;	// Load Register A with Immediate Addressing
	const opc_t OPC_LDA_DIR	= 8'h87;	// Load Register A with Direct Addressing
	const opc_t OPC_LDB_IMM	= 8'h88;	// Load Register B with Immediate Addressing
	const opc_t OPC_LDB_DIR	= 8'h89;	// Load Register B with Direct Addressing
	const opc_t OPC_STA_DIR	= 8'h96;	// Store Register A to memory (RAM or IO)
	const opc_t OPC_STB_DIR	= 8'h97;	// Store Register B to memory (RAM or IO)
	const opc_t OPC_ADD_AB	= 8'h42;	// A = A + B
	const opc_t OPC_SUB_AB	= 8'h43;	// A = A - B
	const opc_t OPC_AND_AB	= 8'h44;	// A = A and B
	const opc_t OPC_OR_AB		= 8'h45;	// A = A or B
	const opc_t OPC_INCA		= 8'h46;	// A = A + 1
	const opc_t OPC_INCB		= 8'h47;	// B = B - 1
	const opc_t OPC_DECA		= 8'h48;	// A = A - 1
	const opc_t OPC_DECB		= 8'h49;	// B = B - 1
	const opc_t OPC_BRA			= 8'h20;	// Branch Always
	const opc_t OPC_BMI			= 8'h21;	// Branch if minus (N = 1)
	const opc_t OPC_BPL			= 8'h22;	// Branch if plus (N =0)
	const opc_t OPC_BEQ			= 8'h23;	// Branch if equal to zero (Z = 1)
	const opc_t OPC_BNE			= 8'h24;	// Branch if not equal to zero (Z = 0)
	const opc_t OPC_BVS			= 8'h25;	// Branch if two's complement overflow occurred, or V is set (V = 1)
	const opc_t OPC_BVC			= 8'h26;	// Branch if two's complement overflow did not occur, or V is clear (V = 0)
	const opc_t OPC_BCS			= 8'h27;	// Branch if a carry occurred, or C is set (C = 1)
	const opc_t OPC_BCC			= 8'h28;	// Branch if a carry did not occur, or C is clear (C = 0)
	const opc_t OPC_BHI			= 8'h29;	// Branch if higher (C = 1 and Z = 0)
	const opc_t OPC_BLS			= 8'h2A;	// Branch if lower or the same (C = 0 and Z = 1)
	// Branches only valid for signed numbers
	const opc_t OPC_BGE			= 8'h2B;	// Branch if greater than or equal ((N = 0 and V = 0) or (N = 1 and V = 1))
	const opc_t OPC_BLT			= 8'h2C;	// Branch if less than ((N = 1 and V = 0) or (N = 0 and V = 1))
	const opc_t OPC_BGT			= 8'h2D;	// Branch if greater than ((N = 0 and V = 0 and Z = 0) or (N = 1 and V = 1 and Z = 0))
	const opc_t OPC_BLE			= 8'h2E;	// Branch if less than or equal ((N = 1 and V = 0) or (N = 0 and V = 1) or (Z = 1))

endpackage
