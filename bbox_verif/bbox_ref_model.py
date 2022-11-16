#See LICENSE.iitm for license details
'''

Author   : Santhosh Pavan
Email id : santhosh@mindgrovetech.in
Details  : This file consists reference model which is used in verifying the bbox design (DUT).

--------------------------------------------------------------------------------------------------
'''
'''
TODO:
Task Description: Add logic for all instructions. One instruction is implemented as an example. 
                  Note - The value of instr (ANDN) is a temp value, it needed to be changed according to spec.

Note - if instr has single operand, take rs1 as an operand
Modified by: Sai Gautham Ravipati, Bachotti Sai Krishna Shanmukh, Niranjan J Nair
Email id : sai.gautham@smail.iitm.ac.in 
'''

# This function has been taken from https://stackoverflow.com/questions/12946116/twos-complement-binary-in-python
# Performs integer to string conversion of numbers 
def bindigits(n, bits):
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)

# This function has been referred to from GeeksforGeeks, performs sign extension of a 32-bit integer
def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)

#Reference model
def bbox_rm(instr, rs1, rs2, XLEN):

    """
    To test the functionality of Bluespec code, the same shall be compared 
    to the result obtained from computing the operation using Python3, here
    in this case based on the instruction generated for testing, each of the 
    sub-parts are decoded to the corresponding instruction. Then using the 
    operands as well as the immediate values the output is computed. 
    """

    istr = bindigits(instr, 32)     # Conversion of instruction from int to binary string 
    
    # Decoding of instruction to corresponding sub-parts 

    ip1 = istr[0:7]
    ip2 = istr[7:12]
    ip3 = istr[12:17]
    ip4 = istr[17:20]
    ip5 = istr[20:25]
    ip6 = istr[25:32]

    # print("IP1: ",ip1)
    # print("IP2: ",ip2)
    # print("IP4: ",ip4)
    # print("IP6: ",ip6)

    # The decoded instruction is matches with the opcodes to infer the operand 
    # All the instructions assume the input is being passed in as 2s complement 
    # The operations involved are self-explanatory to the pseudo-code in manual
    # Shamt[5] for RV32 and passing RV64 only instructions in RV32 mode shall be
    # handelled separately, with a result of 0. 

    # 1, adduw
    if ((ip1 == '0000100') & (ip4 == '000') & (ip6 == '0111011')):
        if(XLEN == 64):
            print("Testing instruction adduw")
            res = rs2 + (rs1&(2**32 - 1))
            valid = '1'
        else:
            res = 0
            print("adduw not defined in RV32 mode")
            valid = '1'
    
    # 2, andn
    elif ((ip1 == '0100000') & (ip4 == '111') & (ip6 == '0110011')):
        print("Testing instruction andn")
        res = rs1 & ~rs2
        valid = '1'

    # 3, blcr
    elif ((ip1 == '0100100') & (ip4 == '001') & (ip6 == '0110011')):
        print("Testing instruction bclr")
        res = (rs1 & ~(1 << (rs2 & (XLEN - 1))))
        valid = '1'

    # 4, bclri
    elif ((ip1[:-1] == '010010') & (ip4 == '001') & (ip6 == '0010011')):
        if((XLEN == 32) & (ip1[-1] == '0')):
            print("Testing instruction bclri")
            shamt = int(ip2, 2)
            res = (rs1 & ~(1 << (shamt & (XLEN - 1))))
            valid = '1'
        elif((XLEN == 32) & (ip1[-1] == '1')):
            res = 0
            print("*********************shamt[5] = 1 is reserved for RV32**********************")
            valid = '1'
        elif(XLEN == 64): 
            print("Testing instruction bclri")
            shamt = int(ip1[-1] + ip2, 2)
            res = (rs1 & ~(1 << (shamt & (XLEN - 1))))
            valid = '1'

    # 5, bext
    elif ((ip1 == '0100100') & (ip4 == '101') & (ip6 == '0110011')):
        print("Testing instruction bext")
        res = (rs1 >> (rs2 & (XLEN - 1))) & 1
        valid = '1'
    
    # 6, bexti
    elif ((ip1[:-1] == '010010') & (ip4 == '101') & (ip6 == '0010011')):
        if((XLEN == 32) & (ip1[-1] == '0')):
            print("Testing instruction bexti")
            shamt = int(ip2, 2)
            res = (rs1 >> (shamt & (XLEN - 1))) & 1
            valid = '1'
        elif((XLEN == 32) & (ip1[-1] == '1')):
            res = 0
            print("*********************shamt[5] = 1 is reserved for RV32**********************")
            valid = '1'
        elif(XLEN == 64): 
            print("Testing instruction bexti")
            shamt = int(ip1[-1] + ip2, 2)
            res = (rs1 >> (shamt & (XLEN - 1))) & 1
            valid = '1'

    # 7, binv
    elif ((ip1 == '0110100') & (ip4 == '001') & (ip6 == '0110011')):
        print("Testing instruction binv")
        res = (rs1 ^ (1 << (rs2 & (XLEN - 1))))
        valid = '1'

    # 8, binvi
    elif ((ip1[:-1] == '011010') & (ip4 == '001') & (ip6 == '0010011')):
        if((XLEN == 32) & (ip1[-1] == '0')):
            print("Testing instruction binvi")
            shamt = int(ip2, 2)
            res = (rs1 ^ (1 << (shamt & (XLEN - 1))))
            valid = '1'
        elif((XLEN == 32) & (ip1[-1] == '1')):
            res = 0
            print("*********************shamt[5] = 1 is reserved for RV32**********************")
            valid = '1'
        elif(XLEN == 64):
            print("Testing instruction binvi")
            shamt = int(ip1[-1] + ip2, 2)
            res = (rs1 ^ (1 << (shamt & (XLEN - 1))))
            valid = '1'

    # 9, bset
    elif ((ip1 == '0010100') & (ip4 == '001') & (ip6 == '0110011')):
        print("Testing instruction bset")
        res = (rs1 | (1 << (rs2 & (XLEN - 1))))
        valid = '1'
    
    # 10, bseti
    elif ((ip1[:-1] == '001010') & (ip4 == '001') & (ip6 == '0010011')):
        if((XLEN == 32) & (ip1[-1] == '0')):
            print("Testing instruction bseti")
            shamt = int(ip2, 2)
            res = (rs1 | (1 << (shamt & (XLEN - 1))))
            valid = '1'
        elif((XLEN == 32) & (ip1[-1] == '1')):
            res = 0
            print("*********************shamt[5] = 1 is reserved for RV32**********************")
            valid = '1'
        elif(XLEN == 64):
            print("Testing instruction bseti")
            shamt = int(ip1[-1] + ip2, 2)
            res = (rs1 | (1 << (shamt & (XLEN - 1))))
            valid = '1'
    
    # 11, clmul
    elif ((ip1 == '0000101') & (ip4 == '001') & (ip6 == '0110011')):
        print("Testing instruction clmul")
        res = 0
        for i in range(XLEN+1):
            cond = (rs2 >> i) % 2
            if(cond):
                res = res ^ (rs1 << i)
        valid = '1'

    # 12, clmulh
    elif ((ip1 == '0000101') & (ip4 == '011') & (ip6 == '0110011')):
        res = 0
        print("Testing instruction clmulh")
        for i in range(1,XLEN+1):
            cond = (rs2 >> i) % 2
            if(cond):
                res = res ^ (rs1 >> (XLEN - i))
        valid = '1'

    # 13, clmulr
    elif ((ip1 == '0000101') & (ip4 == '010') & (ip6 == '0110011')):
        res = 0
        print("Testing instruction clmulr")
        for i in range(0,XLEN):
            cond = (rs2 >> i) % 2
            if(cond):
                res = res ^ (rs1 >> (XLEN - i - 1))
        valid = '1'

    # 14, clz
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0010011') & (ip2 == '00000')):
        print("Testing instruction clz")
        res = 0
        if(rs1 == 0): 
            res = XLEN
        else:
            while ((rs1 & (1 << (XLEN - 1))) == 0):
                rs1 = (rs1 << 1)
                res += 1
        valid = '1'

    # 15, clzw
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0011011') & (ip2 == '00000')):
        if(XLEN == 64):
            print("Testing instruction clzw")
            if((rs1 & (4294967295)) == 0): 
                res = 32
            else: 
                res = 0
                while ((rs1 & (1 << 31)) == 0):
                    rs1 = (rs1 << 1)
                    res += 1
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("clzw not defined in RV32 mode")
            valid = '1'


    # 16, cpop
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0010011') & (ip2 == '00010')):   
        print("Testing instruction cpop") 
        res = 0
        i = 0
        while(i < XLEN):
            i += 1
            if((rs1 & 1) == 1): res += 1    
            rs1 = rs1 >> 1
        valid = '1'
    
    # 17, cpopw
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0011011') & (ip2 == '00010')): 
        if(XLEN == 64):
            print("Testing instruction cpopw")
            res = 0 
            i = 0
            while(i < 32):
                i += 1
                if((rs1 & 1) == 1): res += 1      
                rs1 = rs1 >> 1
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("cpopw not defined in RV32 mode")
            valid = '1'

    # 18, ctz
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0010011') & (ip2 == '00001')): 
        print("Testing instruction ctz")
        res = 0
        i = 0
        for i in range(XLEN):
            if((rs1 & 1) == 1): break
            else: res += 1
            rs1 = rs1 >> 1     
        valid = '1'

    # 19, ctzw
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0011011') & (ip2 == '00001')):
        if(XLEN == 64):
            print("Testing instruction ctzw")
            res = 0
            i = 0
            for i in range(32):
                if((rs1 & 1) == 1): break
                else: res += 1
                rs1 = rs1 >> 1     
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("ctzw not defined in RV32 mode")
            valid = '1'
        

    # 20, max 
    elif ((ip1 == '0000101') & (ip4 == '110') & (ip6 == '0110011')):
        print("Testing instruction max")
        if(rs1 >= 2**(XLEN - 1)): 
            rs1_temp = rs1 - 2**(XLEN)
        else: 
            rs1_temp = rs1

        if(rs2 >= 2**(XLEN - 1)): 
            rs2_temp = rs2 - 2**(XLEN)
        else:
            rs2_temp = rs2

        if(rs1_temp > rs2_temp):
            res = rs1 
        else: 
            res = rs2 
        valid = '1'
    
    # 21, maxu
    elif ((ip1 == '0000101') & (ip4 == '111') & (ip6 == '0110011')):
        print("Testing instruction maxu")
        if(rs1 > rs2):
            res = rs1 
        else: 
            res = rs2 
        valid = '1'
    
    # 22, min
    elif ((ip1 == '0000101') & (ip4 == '100') & (ip6 == '0110011')):
        print("Testing instruction min")
        if(rs1 >= 2**(XLEN - 1)): 
            rs1_temp = rs1 - 2**(XLEN)
        else: 
            rs1_temp = rs1

        if(rs2 >= 2**(XLEN - 1)): 
            rs2_temp = rs2 - 2**(XLEN)
        else:
            rs2_temp = rs2

        if(rs1_temp < rs2_temp):
            res = rs1 
        else: 
            res = rs2 
        valid = '1'

    # 23, minu
    elif ((ip1 == '0000101') & (ip4 == '101') & (ip6 == '0110011')):
        print("Testing instruction minu")
        if(rs1 < rs2):
            res = rs1 
        else: 
            res = rs2 
        valid = '1'

    # 24, orcb
    elif ((ip1 == '0010100') & (ip4 == '101') & (ip6 == '0010011') & (ip2 == '00111')):
        print("Testing instruction orcb")
        res = 0
        for i in range(int(XLEN/8)):
            if(rs1 & 255 != 0): 
                res += 255 << (8 * i)
            rs1 = rs1 >> 8
        valid = '1'

    # 25, orn
    elif ((ip1 == '0100000') & (ip4 == '110') & (ip6 == '0110011')):
        print("Testing instruction orn")
        res = rs1 | ~rs2
        valid = '1'

    # 26, rev8
    elif ((ip1[:-1] == '011010') & (ip4 == '101') & (ip6 == '0010011') & (ip2 == '11000')): 
        if((XLEN == 32) & (ip1[-1] == '0')): 
            print("Testing instruction rev8")
            res = 0 
            num_bytes = int(XLEN/8)
            for i in range(num_bytes):
                res += (rs1 & 255) << (8 * (num_bytes - i - 1))
                rs1 = rs1 >> 8 
            valid = '1'
        if((XLEN == 64) & (ip1[-1] == '1')): 
            print("Testing instruction rev8")
            res = 0 
            num_bytes = int(XLEN/8)
            for i in range(num_bytes):
                res += (rs1 & 255) << (8 * (num_bytes - i - 1))
                rs1 = rs1 >> 8 
            valid = '1'

    # 27, rol
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0110011')):
        print("Testing instruction rol")
        res = 0 
        if(XLEN == 32): 
            shamt = rs2 & 31
        else: 
            shamt = rs2 & 63

        res = (rs1 << shamt) | ((rs1) >> (XLEN - shamt))
        valid = '1'

    # 28, rolw
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0111011')):
        if(XLEN == 64):
            print("Testing instruction rolw")
            shamt = rs2 & 31
            rs1 = rs1 & (4294967295)
            res = (rs1 << shamt) | ((rs1) >> (32 - shamt))
            res = res & (4294967295)
            res = sign_extend(res, 32)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("rolw not defined in RV32 mode")
            valid = '1'

    # 29, ror
    elif ((ip1 == '0110000') & (ip4 == '101') & (ip6 == '0110011')): 
        print("Testing instruction ror")
        res = 0 
        if(XLEN == 32): 
            shamt = rs2 & 31
        else: 
            shamt = rs2 & 63

        res = (rs1 >> shamt) | ((rs1) << (XLEN - shamt))
        valid = '1'

    # 30, rori
    elif  ((ip1[:-1] == '011000') & (ip4 == '101') & (ip6 == '0010011')): 
        if((XLEN == 32) & (ip1[-1] == '0')):
            print("Testing instruction rori")
            shamt = int(ip2, 2)
            res = (rs1 >> shamt) | ((rs1) << (XLEN - shamt))
            valid = '1'
        elif((XLEN == 32) & (ip1[-1] == '1')):
            res = 0
            print("*********************shamt[5] = 1 is reserved for RV32**********************")
            valid = '1'
        elif(XLEN == 64):
            print("Testing instruction rori")
            shamt = int(ip1[-1] + ip2, 2)
            res = (rs1 >> shamt) | ((rs1) << (XLEN - shamt))
            valid = '1'

    # 31, roriw
    # '0110000' + shamt + '00000' + '101' + '00000' + '0011011'
    elif ((ip1 == '0110000') & (ip4 == '101') & (ip6 == '0011011')): 
        if(XLEN == 64):
            print("Testing instruction roriw")
            shamt = int(ip2, 2)
            rs1 = rs1 & (4294967295)
            res = (rs1 >> shamt) | ((rs1) << (32 - shamt))
            res = res & (4294967295)
            res = sign_extend(res, 32)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("roriw not defined in RV32 mode")
            valid = '1'

    # 32, rorw
    elif ((ip1 == '0110000') & (ip4 == '101') & (ip6 == '0111011')): 
        if(XLEN == 64):
            print("Testing instruction clz")
            shamt = rs2 & 31
            rs1 = rs1 & (4294967295)
            res = (rs1 >> shamt) | ((rs1) << (32 - shamt))
            res = res & (4294967295)
            res = sign_extend(res, 32)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("rorw not defined in RV32 mode")
            valid = '1'

    # 33, sext.b 
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0010011') & (ip2 == '00100')):
        print("Testing instruction sextb")
        byteval = rs1 % 256
        if(byteval < 128):
            res = byteval
            valid = '1'
        else:
            res = (2**(XLEN) - 256) + byteval
            valid = '1'

    # 34, sext.h 
    elif ((ip1 == '0110000') & (ip4 == '001') & (ip6 == '0010011') & (ip2 == '00101')):
        print("Testing instruction sexth")
        byteval = rs1 % (2**16)
        if(byteval < 2**15):
            res = byteval
            valid = '1'
        else:
            res = (2**(XLEN) - 2**16) + byteval
            valid = '1'


    # 35, sh1add
    elif ((ip1 == '0010000') & (ip4 == '010') & (ip6 == '0110011')): 
        print("Testing instruction sh1add")
        res = (rs2 + rs1*2)&(2**64-1)
        valid = '1'

    # 36, sh1add.uw 
    elif ((ip1 == '0010000') & (ip4 == '010') & (ip6 == '0111011')): 
        if(XLEN == 64):
            print("Testing instruction sh1add.uw")
            res = (rs2 + (rs1&(2**32 - 1))*2)&(2**64-1)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("sh1add.uw not defined in RV32 mode")
            valid = '1'

    # 37, sh2add 
    elif ((ip1 == '0010000') & (ip4 == '100') & (ip6 == '0110011')): 
        print("Testing instruction sh2add")
        res = (rs2 + rs1*4)&(2**64-1)
        valid = '1'

    # 38, sh2add.uw 
    elif ((ip1 == '0010000') & (ip4 == '100') & (ip6 == '0111011')): 
        if(XLEN == 64):
            print("Testing instruction sh2add.uw")
            res = (rs2 + (rs1&(2**32 - 1))*4)&(2**64-1)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("sh2.adduw not defined in RV32 mode")
            valid = '1'

    # 39, sh3add
    elif ((ip1 == '0010000') & (ip4 == '110') & (ip6 == '0110011')): 
        print("Testing instruction sh3add")
        res = (rs2 + rs1*8)&(2**64-1)
        valid = '1'

    # 40, sh3add.uw
    elif ((ip1 == '0010000') & (ip4 == '110') & (ip6 == '0111011')): 
        if(XLEN == 64):
            print("Testing instruction sh3add.uw")
            res = (rs2 + (rs1&(2**32 - 1))*8)&(2**64-1)
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("sh3add.uw not defined in RV32 mode")
            valid = '1'

    # 41, slli.uw
    elif ((ip1[:-1] == '000010') & (ip4 == '001') & (ip6 == '0011011')): 
        if(XLEN == 64):
            print("Testing instruction slli.uw")
            shamt = int(ip1[-1] + ip2, 2)
            rs1 = rs1 & (4294967295)
            res = rs1 << shamt 
            valid = '1'
        elif(XLEN == 32):
            res = 0
            print("slli.uw not defined in RV32 mode")
            valid = '1'

    # 42, xnor
    elif ((ip1 == '0100000') & (ip4 == '100') & (ip6 == '0110011')): 
        print("Testing instruction xnor")
        res = 2**(XLEN) - 1 - (rs1 ^ rs2)
        valid = '1'

    # 43, zext.h
    elif ((ip1 == '0000100') & (ip4 == '100')):
        if((XLEN == 32) & (ip6 == '0110011')):  
            print("Testing instruction zext.h")
            res = rs1 % (2**16)
            valid = '1'
        elif((XLEN == 64) & (ip6 == '0111011')):
            res = rs1 % (2**16)
            valid = '1'
        else:
            res = 0
            valid = '1'

    ## logic for all other instr ends
    else:
        print("Default Case\n")
        res = 0
        valid = '0'

    if XLEN == 32:
        result = bindigits(res, 32)
    elif XLEN == 64:
        result = bindigits(res, 64)

    """ 
    if XLEN == 32:
        result = '{:032b}'.format(res)
    elif XLEN == 64:
        result = '{:064b}'.format(res)
    """

    return valid+result