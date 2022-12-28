.ORIG x3000

start   LEA, R0, startmsg ;load startmsg into R0, loads address of startmsg to R0
        PUTS ;load startmsg onto the screen, show R0 in terminal

        ; print prompt for input and get input
getIN   LEA, R0, query ; load query into R0, loads address of query to R0
        PUTS ; load query onto the screen, show R0 in terminal
        GETC ; get in put from user without echo, save the input at an address so R0 is free, 
                                                                         ; its used later on!!!!
    ; check what operation should be completed
    ; check if E
        AND R4 R4 #0 ; clearing r4, where address to subroutine will be stored
        LD R6 E
        NOT R1 R6
        ADD R1 R1 #1 ; get 2'c to subtract
        ADD R6 R0 R1 ; R0(holds input) - R1(holds 2'c of E)
        BRnp checkD ; goes to to check D if not E
        LEA, R0, keymsg ;load keymsg into R0, loads address of keymsg to R0
        PUTS
        LD R5 cnt
        LD R6 goIN
        JSRR R6
        LEA, R0, promptmsg ;load promptmsg into R0, loads address of promptmsg to R0
        PUTS
        LD R4 saveStr ; load address of where Str will be stored
        LD R5 cntStr ; counter for getting str loop, when reaches 0 all char have been collected
        STR R4 R0 #0 ; put saveStr address to R0, so char are stored starting at that address
        LD R6 goStr
        JSRR R6
        ; start vignere encrypt
        LD R5 cntEV
        LD R4 saveStr ; load address of where Str will be stored
        LD R6 goEV ; put encrypt subroutine address in R4
        JSRR R6
        ; start caeser cipher
        LD R5 cntEC
        LD R4 saveStr ; load address of where Str will be stored
        LD R1 N ; load 128 into R1
        LD R6 goEC ; put encrypt subroutine address in R6
        JSRR R6
        ; start bit shift
        ;LD R6 goEnB
        ;JSRR R6
        BRnzp start
        
checkD  AND R4 R4 #0 ; clearing r4, where address to subroutine will be stored
        LD R6 D
        NOT R1 R6
        ADD R1 R1 #1 ; get 2'c to subtract
        ADD R6 R0 R1 ; R0(holds input) - R1(holds 2'c of D)
        BRnp checkX ; goes to to check X if not D
        LEA, R0, keymsg ;load keymsg into R0, loads address of keymsg to R0
        PUTS
        LD R4 goInD
        JSRR R4
        ; start caeser decrypt
        LD R5 cntEC
        LD R4 saveStr ; load address of where Str will be stored
        LD R1 N ; load 128 into R1
        LD R6 goDeC ; put encrypt subroutine address in R6
        JSRR R6
        ; start vignere decrypt
        LD R5 cntEV
        LD R4 saveStr ; load address of where Str will be stored
        LD R6 goDeV ; put encrypt subroutine address in R4
        JSRR R6
        BRnzp start
        
checkX  AND R4 R4 #0 ; clearing r4, where address to subroutine will be stored
        LD R6 X
        NOT R1 R6
        ADD R1 R1 #1 ; get 2'c to subtract
        ADD R6 R0 R1 ; R0(holds input) - R1(holds 2'c of X)
        BRnp notValid ; goes to to check X if not go to invalid
        LD R4 goX ; put subroutine address in R4
        JSRR R4
        BRnzp start

; invalid
notValid    LEA R0 invalid 
            PUTS ; displays invalid input message
            BRnzp getIN ; go back to asking for and getting input
    
haltIT  HALT


startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
query       .STRINGZ "\nENTER E OR D OR X\n"
keymsg      .STRINGZ "\nENTER KEY\n"
promptmsg   .STRINGZ "\nENTER MESSAGE\n"
invalid     .STRINGZ "\nINVALID INPUT\n"

E  .FILL x45 ; fill the achii hex value of 'E' into E
D  .FILL x44 ; fill the achii hex value of 'D' into D
X  .FILL x58 ; fill the achii hex value of 'S' into S
Zero   .FILL x30
One   .FILL x31
Seven   .FILL x37
Nine   .FILL x39
; fill addresses of subroutines to access later
goStr   .FILL getStr
goEV    .FILL EnV
goEC    .FILL EnC
goDeV    .FILL DeV
goDeC   .FILL DeC
goX     .FILL Xin
goIN    .FILL getInput
goInD   .FILL getInputD
;goEnB   .Fill EnB
saveKey .FILL x4500
saveKeyD    .FILL x4600
saveStr .FILL x4A00
saveCurStrPnt   .FILL x4900
saveCnt .FILL x4901
saveCurCalc  .FILL x4902
MESSAGE .FILL x4000 ; where encrypted message will go
K1      .FILL x4700 ; address to hold parts of K which will be added together to get K
K2      .FILL x4701
K3      .FILL x4702
finalK  .FILL x4703
finalDecryption .FILL x5000
modCheck    .FILL #-127
getDec  .FILL #-48
cntEV   .FILL #-10
cntEC   .FILL #-10
cntA    .FILL #-10
cntM    .FILL #-10
cntStr  .FILL #-11
cnt     .FILL #-4
N       .FILL #128 ; value to mod
hund    .FILL #100 ; values to multiply the y's by to get K
ten     .FILL #10
oneX     .FILL #1
ZeroE   .FILL #0
notV    .FILL notValid

; subroutines
; get input (Z1X1Y1Y2Y3) and check validity, R6 = hex to check against(can be cleared after this sub), R5 = cnt for loop(can be cleared after sub), R0 = input(needs to be set to original pointer address at end of sub)
getInput    LD R3 saveKey
            GETC
            STR R0 R3 #0
            ; check Z1
            ; check char is greater than or equal to 0
            LD R6 Zero
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 0 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 30, store in R6
            BRn notValid
            ; check if greater than or equal to 7
            LD R6 Seven
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 0 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 37, store in R6
            BRp notValid ; if positive -> number is greater than 7
            ADD R3 R3 #1
            GETC
            STR R0 R3 #0
            ; check X1
            LD R6 One ; check if X1 >= 1
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 1 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 31, store in R6
            BRzp check9 ; if zero or positive check9, since its possible its less than 9
            BRn checkY ; valid
            ; check if X1 <= 9
check9      LD R6 Nine
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 39 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 39, store in R6
            BRnz notValid ; if neg -> number is less than 9
            ;check Y1-Y3, can be anything between 0 and 9
checkY      ADD R5 R5 #1 ; increment cnt
            BRz doneLoop
            ADD R3 R3 #1
            GETC
            STR R0 R3 #0
            ; check if Yi is greater than 0, if less than 0, BR invalid
            LD R6 Zero
            NOT R6 R6
            ADD R6 R6 #1 ; 2'c of 0
            ADD R6 R0 R6 ; char - 30
            BRn notValid
            ; check if Yi is less than 9, if greater than 9 invalid
            LD R6 Nine
            NOT R6 R6 
            ADD R6 R6 #1 ; 2'c of 9
            ADD R6 R0 R6 ; char - 39
            BRp notValid ; greater than 9 = invalid input
            BRnz checkY ; loop to next Y
            LD R3 saveKey ; set R3 to point to start of key, R3 = key
            ; subtract 48 from y1, y2, and y3 to get dec. value, store in same spot
            ; do same for z1
doneLoop    LD R1 getDec
            LD R3 saveKey
            
            ADD R4 R3 #0 ; get z1, r4 hold address
            LDR R2 R4 #0 ; get value at z1
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #2 ; get y1, r4 hold address
            LDR R2 R4 #0 ; get value at y1
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #3 ; get y2, r4 hold address
            LDR R2 R4 #0 ; get value at y2
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #4 ; get y3, r4 hold address
            LDR R2 R4 #0 ; get value at y3
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ; calculate k and determine if its in range of 0-127
            LD R3 saveKey
        LDR R2 R3 #2 ; load Y1 into R2
        LD R3 hund ; load 100 into R3
        LD R1 K1 ; load address of K1 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes1 ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes1 ; branch to automatically make result 0
zeroRes1 ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop1    BRnz Done1
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop1
Done1    STR R5 R1 #0 ; Y1 * 100 -> address K1
        
        ; calculate k2
        LD R3 saveKey
        LDR R2 R3 #3 ; load Y2 into R2
        LD R3 ten ; load 10 into R3
        LD R1 K2 ; load address of K2 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes2 ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes2 ; branch to automatically make result 0
zeroRes2 ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop2    BRnz Done2
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop2
Done2    STR R5 R1 #0 ; Y2 * 10 -> address K2
        
        ; calculate k3
        LD R3 saveKey
        LDR R2 R3 #4 ; load Y3 into R2
        LD R3 oneX ; load 1 into R3
        LD R1 K3 ; load address of K3 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes3 ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes3 ; branch to automatically make result 0
zeroRes3 ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop3    BRnz Done3
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop3
Done3    STR R5 R1 #0 ; Y3 * 10 -> address K3
        
        ; atp add values in x3700, x3701, and x3702, registers R1, R2, and R6 can be used
        LD R1 K1
        LDR R1 R1 #0 ; R1 = value at K1
        LD R2 K2
        LDR R2 R2 #0 ; R2 = K2
        ADD R6 R1 R2 ; R6 = K1 + K2
        LD R1 K3
        LDR R1 R1 #0 ; R1 = K3
        ADD R6 R6 R1 ; R6 = (K1+K2)+K3
        LD R1 finalK ; holds 3 digit value of y
        STR R6 R1 #0
        ; atp R6 = K
        LD R1 modCheck
        ADD R0 R6 R1
        BRp notVa ; go to invalid sub
        BRnz V
notVa   LD R1 notV; go to invalid sub
        JSRR R1
V       RET
        
saveKeyext .FILL x4500
saveKeyDext    .FILL x4600
saveStrext .FILL x4A00
saveCurStrPntext   .FILL x4900
saveCntext .FILL x4901
saveCurCalcext  .FILL x4902
MESSAGEext .FILL x4000 ; where encrypted message will go
K1ext      .FILL x4700 ; address to hold parts of K which will be added together to get K
K2ext      .FILL x4701
K3ext      .FILL x4702
finalKext  .FILL x4703
modCheckext    .FILL #-127
cntEVext   .FILL #-10
cntAext    .FILL #-10
cntMext    .FILL #-10
Next       .FILL #128 ; value to mod
ZeroEext   .FILL #0
notVext    .FILL notValid

        
getInputD   LD R3 saveKeyDext
            GETC
            STR R0 R3 #0
            ; check Z1
            ; check char is greater than or equal to 0
            LD R6 Zero
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 0 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 30, store in R6
            BRn notV
            ; check if greater than or equal to 7
            LD R6 Seven
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 0 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 37, store in R6
            BRp notV ; if positive -> number is greater than 7
            ADD R3 R3 #1
            GETC
            STR R0 R3 #0
            ; check X1
            LD R6 One ; check if X1 >= 1
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 1 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 31, store in R6
            BRzp check9D ; if zero or positive check9, since its possible its less than 9
            BRn checkYD ; valid
            ; check if X1 <= 9
check9D      LD R6 Nine
            NOT R6 R6 
            ADD R6 R6 #1 ; get 2'c of hex of 39 so we can subtract it from char
            ADD R6 R0 R6 ; R0 + R6 -> R0 - R6 -> char - 39, store in R6
            BRnz notV ; if neg -> number is less than 9
            ;check Y1-Y3, can be anything between 0 and 9
            LD R5 cnt
checkYD     ADD R5 R5 #1 ; increment cnt
            BRz doneLoopD
            ADD R3 R3 #1
            GETC
            STR R0 R3 #0
            ; check if Yi is greater than 0, if less than 0, BR invalid
            LD R6 Zero
            NOT R6 R6
            ADD R6 R6 #1 ; 2'c of 0
            ADD R6 R0 R6 ; char - 30
            BRn notV
            ; check if Yi is less than 9, if greater than 9 invalid
            LD R6 Nine
            NOT R6 R6 
            ADD R6 R6 #1 ; 2'c of 9
            ADD R6 R0 R6 ; char - 39
            BRp notV ; greater than 9 = invalid input
            BRnz checkYD ; loop to next Y
            LD R3 saveKeyDext ; set R3 to point to start of key, R3 = key
            ; subtract 48 from y1, y2, and y3 to get dec. value, store in same spot
            ; do same for z1
doneLoopD    LD R1 getDec
            LD R3 saveKeyDext
            
            ADD R4 R3 #0 ; get z1, r4 hold address
            LDR R2 R4 #0 ; get value at z1
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #2 ; get y1, r4 hold address
            LDR R2 R4 #0 ; get value at y1
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #3 ; get y2, r4 hold address
            LDR R2 R4 #0 ; get value at y2
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ADD R4 R3 #4 ; get y3, r4 hold address
            LDR R2 R4 #0 ; get value at y3
            ADD R2 R2 R1
            STR R2 R4 #0
            
            ; calculate k and determine if its in range of 0-127
            LD R3 saveKeyDext
        LDR R2 R3 #2 ; load Y1 into R2
        LD R3 hund ; load 100 into R3
        LD R1 K1 ; load address of K1 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes1Din ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes1Din ; branch to automatically make result 0
zeroRes1Din ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop1Din    BRnz Done1Din
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop1Din
Done1Din    STR R5 R1 #0 ; Y1 * 100 -> address K1
        
        ; calculate k2
        LD R3 saveKeyDext
        LDR R2 R3 #3 ; load Y2 into R2
        LD R3 ten ; load 10 into R3
        LD R1 K2 ; load address of K2 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes2Din ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes2Din ; branch to automatically make result 0
zeroRes2Din ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop2Din    BRnz Done2Din
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop2Din
Done2Din    STR R5 R1 #0 ; Y2 * 10 -> address K2
        
        ; calculate k3
        LD R3 saveKeyDext
        LDR R2 R3 #4 ; load Y3 into R2
        LD R3 oneX ; load 1 into R3
        LD R1 K3ext ; load address of K3 to R1, store N in R1 after all calculations for K are done
        ; multiplication part
        AND R5 R5 #0
        ADD R2 R2 #0
        BRz zeroRes3Din ; branch to automatically make result 0
        ADD R3 R3 #0
        BRz zeroRes3Din ; branch to automatically make result 0
zeroRes3Din ADD R5 R5 #0 ; clear R5
        ADD R6, R2, #0 ; copy R2 to R6
loop3Din    BRnz Done3Din
        ADD R5, R5, R3 ; add to product
        ADD R6, R6, #-1 ; decrement X
        BRnzp loop3Din
Done3Din    STR R5 R1 #0 ; Y3 * 10 -> address K3
        
        ; atp add values in x3700, x3701, and x3702, registers R1, R2, and R6 can be used
        LD R1 K1ext
        LDR R1 R1 #0 ; R1 = value at K1
        LD R2 K2ext
        LDR R2 R2 #0 ; R2 = K2
        ADD R6 R1 R2 ; R6 = K1 + K2
        LD R1 K3ext
        LDR R1 R1 #0 ; R1 = K3
        ADD R6 R6 R1 ; R6 = (K1+K2)+K3
        LD R1 finalKext
        STR R6 R1 #0
        ; atp R6 = K
        LD R1 modCheckext
        ADD R0 R6 R1
        BRp notVextJ
        BRnz nextOp
notVextJ LD R1 notVext
        JSRR R1
        
        ; check if keyD is same as key from encrypt
nextOp      LD R2 ZeroEext
            LD R6 cntEVext
loopDcheck  BRz doneCheckDKey
            LD R0 saveKeyDext ; x4600
            LD R1 saveKeyext ; x4500
            ADD R0, R0, R2 
            ADD R1, R1, R2
            LDR R5 R0 #0
            LDR R3 R1 #0
            NOT R3 R3
            ADD R3 R3 #1 ; get 2'c of R3
            ADD R4 R5 R3
            BRnp notVextJ
            ADD R2 R2 #1
            ADD R6 R6 #1
            BRnzp loopDcheck
            
doneCheckDKey        RET


getStr  ADD R5 R5 #1
        Brz doneStr
        GETC
        ; store r0 to r4 then increment r4
        STR R0 R4 #0 ; store the address of r4 (which is now incremented) into R0 so next char can be stored in next space
        ADD R4 R4 #1 ; increment r4 to point to next addresss space
        BRnzp getStr
doneStr RET
       
    
; encrypt using Vignere cipher, clear key address after final encryption, dont know if it works but it steps through
; copy Str to MESSAGE
EnV         LD R2, ZeroEext
            LD R4 cntEVext
loopStrCopy BRz startEn
            LD R0, MESSAGEext      ; address of beginning of finalDecryption
            LD R1, saveStrext     ; address of beginning of MESSAGE
            ADD R0, R0, R2 ; compute saveStr + i (address of i-th element)
            ADD R1, R1, R2 ; compute MESSAGE + i (address of i-th element)
            LDR R3, R1 #0     ; load MESSAGE[i]
            STR R3, R0 #0     ; store it back (now finalDecryption[i] = MESSAGE[i])
            ADD R2 R2 #1
            ADD R4 R4 #1
            BRnzp loopStrCopy

startEn     LD R4 MESSAGEext
loopEnV     BRz doneEV ; when cntEV == 0, done encrypting all 10 char
            LDR R0 R4 #0
            LD R3 saveKeyext ; load address where key is in R3
            LDR R1 R3 #1 ; load X1 into R1
            STI R4 saveCurStrPntext ; save address of str so we can use R4
            STI R5 saveCntext ; save value of cnt so we can use R5
            
            ; XOR
            AND R3 R3, #0 ; clearing address R3
            AND R4 R4, #0 ; clearing address R4
            AND R5 R5, #0 ; clearing address R5
            NOT R3 R0 ; NOT A
            NOT R4 R1 ; NOT B
            AND R5 R3 R1 ; (!A and B)
            NOT R5 R5 ; !(!A and B)
            AND R6 R4 R0 ; (A and !B)
            NOT R6 R6 ; !(!B and A)
            AND R2 R5 R6 ; !(!A and B) and !(!B and A)
            NOT R2 R2 ; put final answer in R0
            
            LDI R5 saveCntext ; load back value of cnt
            LDI R4 saveCurStrPntext ; load back address of str
            STR R2 R4 #0 
            ADD R4 R4 #1 ; increment r4 to point to next addresss space
            ADD R5 R5 #1 ; increment cntEV
            BRnzp loopEnV
doneEV      RET

; encrypt using Caeser cipher
        ; calculate k1
EnC     LD R1 finalKext
        LDR R6 R1 #0
        ; atp R6 = K, now add the value at Str address and K, store it at the Str address, then mod 128 and store it in same place
        LD R4 MESSAGEext ; load address of where Str starts
        LD R1 saveCurCalcext
        LD R5 cntAext ; load R5 with cnt for loop
loopA   BRz doneAdding ; when R5 = 0, done adding all chars with K
        LDR R0 R4 #0 ; load value at r4
        ADD R2 R6 R0 ; R6 + R1 = K + Pi
        STR R2 R4 #0 ; store value at R2 back in R4
        ADD R4 R4 #1 ; increment r4 to next address spot
        ADD R5 R5 #1 ; increment cnt for loop
        BRnzp loopA
doneAdding  LD R4 MESSAGEext ; after done adding all chars with K, loop again but MOD
            LD R5 cntMext
            LD R6 Next
            NOT R6 R6
            ADD R6 R6 #1 ; 2'c of 128, -128
        LD R0 saveDCurCalc
loopMod BRz doneEC ; when R5 = 0, done with encryption
        LDR R2 R4 #0
        STR R2 R0 #0 ; get value at R4 and put in R0, r0 = value at address of message
        LD R1 Next ; R1 = 128
        ; atp, r0 = value at address of message, R1 = 128, r6 = -128
        AND R2 R2 #0 ; clear R2
        LDR R2 R0 #0 ; copy K to temp, R0 -> R2
loopM   ADD R2 R2 R6 ; temp = temp - N
        BRzp loopM ; if temp >= 0, loop
        ADD R3 R2 R1 ; result in R3
        STR R3 R4 #0
        ADD R4 R4 #1 ; increment r4 to next address spot
        ADD R5 R5 #1 ; increment cnt for loop
        BRnzp loopMod            
doneEC  RET

two .FILL #2
saveCurStrPntext2   .FILL x4900
saveCntext2 .FILL x4901
saveMult    .FILL x4902

 ; left bit shift
; EnB     LD R1 saveKeyext
;        LDR R1 R1 #0 ; put value of z1 in R1
;        ; calculate 2^z1
;        BRz res1 ; if z1 == 0, no shifting and RET
;        LD R2 two ; R2 = #2
;        ADD R1 R1 #-1
; loopex  BRnz doneMult
;        ADD R2 R2 R2
;        ADD R1 R1 #-1
;        BRp loopex
;doneMult    LD R3, ZeroEext ; i
;            LD R5 cntEVext
;            LD R4 MESSAGEext
;loopEnB     BRz res1 ; when cntEV == 0, done encrypting all 10 char
;            LDR R0 R4 #0
;            STI R4 saveCurStrPntext2 ; save address of str so we can use R4
;            STI R5 saveCntext2 ; save value of cnt so we can use R5
;            STI R2 saveMult
;            ADD R6 R2 #0; copy R2 to R6
;            AND R2 R2 #0
;            ADD R6 R6 #0
;loopenB2    BRnz doneMult2
;            ADD R2 R2 R0
;            ADD R6 R6 #-1
;            BRp loopenB2
;
;doneMult2   LDI R5 saveCntext2 ; load back value of cnt
;            LDI R4 saveCurStrPntext2 ; load back address of str
;            STR R2 R4 #0 
;            LDI R2 saveMult
;            ADD R4 R4 #1 ; increment r4 to point to next addresss space
;            ADD R5 R5 #1 ; increment cntEV
;            BRnzp loopEnB    
;res1    RET
        

; refill since stuff are too far a way
finalKext2  .FILL x4703
saveDKey .FILL x4500
saveDStr .FILL x4A00
saveDCurStrPnt   .FILL x4900
saveDCnt .FILL x4901
saveDCurCalc  .FILL x4902
MESSAGED .FILL x4000 ; where encrypted message will go
K1D      .FILL x4700 ; address to hold parts of K which will be added together to get K
K2D      .FILL x4701
K3D      .FILL x4702
finalDecryptionD .FILL x5000
cntEVD   .FILL #-10
cntStrD  .FILL #-11
cntD     .FILL #-4
ND       .FILL #128 ; value to mod
hundD    .FILL #100 ; values to multiply the y's by to get K
tenD     .FILL #10
oneXD     .FILL #1
ZeroD   .FILL #0
            
; decrypt
        
; copy everything at message to finalDecryption
DeC     LD R1 finalKext2
        LDR R6 R1 #0
        ; atp R6 = K
        NOT R6 R6 ; get 2'c of K, since to decrypt we need to subtract k 
        ADD R6 R6 #1
        ; atp R6 = -K, now add the value at Str address and K, store it at the Str address, then mod 128 and store it in same place
        LD R4 MESSAGED ; load address of where encrypted Str starts
        LD R1 saveDCurCalc
        LD R3 finalDecryptionD
        LD R5 cntEVD ; load R5 with cnt for loop
loopDA  BRz doneDAdding ; when R5 = 0, done adding all chars with K
        LDR R0 R4 #0 ; load value at r4 -> R0
        ADD R2 R6 R0 ; R6 + R1 = K + Pi
        STR R2 R3 #0 ; store value at R2 at x5000
        ADD R3 R3 #1
        ADD R4 R4 #1 ; increment r4 to next address spot
        ADD R5 R5 #1 ; increment cnt for loop
        BRnzp loopDA
doneDAdding LD R4 finalDecryptionD ; after done adding all chars with K, MOD. (Ci - K) mod N
            LD R5 cntEVD
            LD R6 ND
            NOT R6 R6
            ADD R6 R6 #1 ; 2'c of 128, -128
            LD R0 saveDCurCalc
loopDMod BRz doneDeC ; when R5 = 0, done with encryption
        LDR R0 R4 #0
        LD R1 ND ; R1 = 128
        
        AND R2 R2 #0 ; clear R2 
        ADD R2 R0 #0 ; copy K to temp, R0 -> R2
loopDM   ADD R2 R2 R6 ; temp = temp - N
        BRzp loopDM ; if temp >= 0, loop
        ADD R3 R2 R1 ; result in R3
        STR R3 R4 #0
        ADD R4 R4 #1 ; increment r4 to next address spot
        ADD R5 R5 #1 ; increment cnt for loop
        BRnzp loopDMod            
doneDeC  RET

; just XOR again
DeV         LD R4 finalDecryptionD
loopDeV     BRz doneDeV ; when cntEV == 0, done encrypting all 10 char
            LDR R0 R4 #0
            LD R3 saveDKey ; load address where key is in R3
            LDR R1 R3 #1 ; load X1 into R1
            STI R4 saveDCurStrPnt ; save address of str so we can use R4
            STI R5 saveDCnt ; save value of cnt so we can use R5
            
            ; XOR
            AND R3 R3, #0 ; clearing address R3
            AND R4 R4, #0 ; clearing address R4
            AND R5 R5, #0 ; clearing address R5
            NOT R3 R0 ; NOT A
            NOT R4 R1 ; NOT B
            AND R5 R3 R1 ; (!A and B)
            NOT R5 R5 ; !(!A and B)
            AND R6 R4 R0 ; (A and !B)
            NOT R6 R6 ; !(!B and A)
            AND R2 R5 R6 ; !(!A and B) and !(!B and A)
            NOT R2 R2 ; put final answer in R0
            
            LDI R5 saveDCnt ; load back value of cnt
            LDI R4 saveDCurStrPnt ; load back address of str
            STR R2 R4 #0 
            ADD R4 R4 #1 ; increment r4 to point to next addresss space
            ADD R5 R5 #1 ; increment cntEV
            BRnzp loopDeV
doneDeV      RET


; clear the contents where the encrypt is(and everything with 0), then go to haltIt(HALT)
Xin         LD R2, ZeroD
            LD R4 cntEVD
            LD R0, MESSAGED      ; address of beginning of finalDecryption
loopXin     BRz doneXin
            ADD R1, R0, R2 ; compute MESSAGE + i (address of i-th element)
            LDR R3, R1 #0      ; load MESSAGE
            AND R3 R3 #0
            STR R3, R1 #0     ; store it back (now finalDecryption[i] = MESSAGE[i])
            ADD R2 R2 #1
            ADD R4 R4 #1
            BRnzp loopXin
doneXin     RET


.END
