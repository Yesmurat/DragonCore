.global _boot
.text

_boot:
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, -5        # x2 = -5
    addi x3, x1, 20        # x3 = 30

    # Register arithmetic
    add  x4, x1, x3        # x4 = 10 + 30 = 40
    sub  x5, x4, x1        # x5 = 40 - 10 = 30

    # Logical ops
    and  x6, x4, x3        # x6 = 40 & 30
    or   x7, x4, x3        # x7 = 40 | 30
    xor  x8, x4, x3        # x8 = 40 ^ 30

    # Shifts (lower 5 bits used for RV32)
    slli x9,  x1, 2        # x9 = 10 << 2 = 40
    srli x10, x9, 1        # x10 = 40 >> 1 = 20 (logical)
    srai x11, x2, 1        # x11 = -5 >> 1 (arithmetic)

    # Comparisons
    slt  x12, x2, x1       # x12 = 1 (-5 < 10)
    sltu x13, x2, x1       # unsigned compare

    # Load upper immediate
    lui  x14, 0x12345      # x14 = 0x12345000
    addi x14, x14, 0x678   # x14 = 0x12345678

    # Memory test
    addi x15, x0, 0x100 # base address
    sw   x14, 0(x15)    # store word
    lw   x16, 0(x15)    # load word

    # Branches
    beq  x14, x16, equal32
    addi x17, x0, 0 # should be skipped if equal
    j    end32          # jump to end if not equal
    
equal32:
    la x6, variable
    addi x6, x6, 4

    bne  x14, x16, skip_set
    addi x17, x0, 1 # executed if equal

skip_set:
    # Jump
    jal  x18, jump_target32
    addi x19, x0, 0 # skipped

jump_target32:
    jalr x0, 0(x18) # return (comes back here)
    j    end32      # jump to end

end32:
    nop

.data
variable:
    .word 0xdeadbeef