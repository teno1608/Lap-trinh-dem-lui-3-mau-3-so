
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _d_type=R4
	.DEF _donvi=R6
	.DEF _chuc=R8
	.DEF _tram=R10
	.DEF _d_anod=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x29
_0x4:
	.DB  0x29
_0x5:
	.DB  0xA
_0x6:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F
_0x154:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _cou_r_pre
	.DW  _0x3*2

	.DW  0x01
	.DW  _cou_g_pre
	.DW  _0x4*2

	.DW  0x01
	.DW  _cou_y_pre
	.DW  _0x5*2

	.DW  0x13
	.DW  _seg_array
	.DW  _0x6*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x154*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Declare your global variables here
;
;int d_type=0, donvi, chuc, tram, d_anod=0, cou_dr=0, cou_dg=0, cou_dy=0, i=0;
;int cou_r=0, cou_g=0, cou_y=0, cou_1s=0, f_yell=0;
;int cou_r_pre=41, cou_g_pre=41, cou_y_pre=10, f_red=0, f_gree=0, kds_cv=0;

	.DSEG
;bit f_cv=0, gree=0, yell=0, red=0;
;
;#define li_r PINB.1
;#define li_g PINB.2
;
;#define leddch PORTC.0
;#define ledxch PORTC.1
;#define ledvdv PORTC.2
;#define ledxdv PORTC.3
;#define ledddv PORTC.4
;#define ledxtr PORTC.5
;#define leddtr PORTB.5
;
;#include <setup_interupt.c>
;
;
;void set_interupt01(){
; 0000 001F void set_interupt01(){

	.CSEG
_set_interupt01:
;
;// Timer/Counter 0 initialization
;// Clock source: System Clock
;// Clock value: 125.000 kHz
;TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;TCNT0=0x82;
	LDI  R30,LOW(130)
	OUT  0x32,R30
;
;// Timer/Counter 1 initialization
;// Clock source: System Clock
;// Clock value: 1000.000 kHz
;// Mode: Normal top=0xFFFF
;// OC1A output: Discon.
;// OC1B output: Discon.
;// Noise Canceler: Off
;// Input Capture on Falling Edge
;// Timer1 Overflow Interrupt: On
;// Input Capture Interrupt: Off
;// Compare A Match Interrupt: Off
;// Compare B Match Interrupt: Off
;TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
;TCNT1H=0x9E;
	RCALL SUBOPT_0x0
;TCNT1L=0x57;
;ICR1H=0x00;
	RCALL SUBOPT_0x1
;ICR1L=0x00;
;OCR1AH=0x00;
;OCR1AL=0x00;
;OCR1BH=0x00;
;OCR1BL=0x00;
;
;// Timer(s)/Counter(s) Interrupt(s) initialization
;TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
;
;// Global enable interrupts
;#asm("sei")
	sei
;
;}
	RET
;
;void reset_interupt01(){
_reset_interupt01:
;
;// Timer/Counter 0 initialization
;// Clock source: System Clock
;// Clock value: Timer 0 Stopped
;TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;TCNT0=0x00;
	OUT  0x32,R30
;
;// Timer/Counter 1 initialization
;// Clock source: System Clock
;// Clock value: Timer1 Stopped
;// Mode: Normal top=0xFFFF
;// OC1A output: Discon.
;// OC1B output: Discon.
;// Noise Canceler: Off
;// Input Capture on Falling Edge
;// Timer1 Overflow Interrupt: Off
;// Input Capture Interrupt: Off
;// Compare A Match Interrupt: Off
;// Compare B Match Interrupt: Off
;TCCR1A=0x00;
	OUT  0x2F,R30
;TCCR1B=0x00;
	OUT  0x2E,R30
;TCNT1H=0x00;
	OUT  0x2D,R30
;TCNT1L=0x00;
	OUT  0x2C,R30
;ICR1H=0x00;
	RCALL SUBOPT_0x1
;ICR1L=0x00;
;OCR1AH=0x00;
;OCR1AL=0x00;
;OCR1BH=0x00;
;OCR1BL=0x00;
;
;// Timer(s)/Counter(s) Interrupt(s) initialization
;TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
;
;// Global disable interrupts
;#asm("cli")
	cli
;
;}
	RET
;#include <segdisplay.c>
;
;
;// Define seg a >>> g PORTD
;
;int seg_array[11]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x00};

	.DSEG
;
;void seg_display(char var7seg)
; 0000 0020     {

	.CSEG
_seg_display:
;    switch (var7seg)
;	var7seg -> Y+0
	LD   R30,Y
	LDI  R31,0
;        {
;        case 0: PORTD=seg_array[0];
	SBIW R30,0
	BRNE _0xA
	LDS  R30,_seg_array
	RJMP _0x151
;                break;
;        case 1: PORTD=seg_array[1];
_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
	__GETB1MN _seg_array,2
	RJMP _0x151
;                break;
;        case 2: PORTD=seg_array[2];
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC
	__GETB1MN _seg_array,4
	RJMP _0x151
;                break;
;        case 3: PORTD=seg_array[3];
_0xC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD
	__GETB1MN _seg_array,6
	RJMP _0x151
;                break;
;        case 4: PORTD=seg_array[4];
_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE
	__GETB1MN _seg_array,8
	RJMP _0x151
;                break;
;        case 5: PORTD=seg_array[5];
_0xE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF
	__GETB1MN _seg_array,10
	RJMP _0x151
;                break;
;        case 6: PORTD=seg_array[6];
_0xF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x10
	__GETB1MN _seg_array,12
	RJMP _0x151
;                break;
;        case 7: PORTD=seg_array[7];
_0x10:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x11
	__GETB1MN _seg_array,14
	RJMP _0x151
;                break;
;        case 8: PORTD=seg_array[8];
_0x11:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x12
	__GETB1MN _seg_array,16
	RJMP _0x151
;                break;
;        case 9: PORTD=seg_array[9];
_0x12:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x13
	__GETB1MN _seg_array,18
	RJMP _0x151
;                break;
;        case 10: PORTD=seg_array[10];
_0x13:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x9
	__GETB1MN _seg_array,20
_0x151:
	OUT  0x12,R30
;                break;
;        }
_0x9:
;	}
	ADIW R28,1
	RET
;
;void dislay7seg()
;    {
_dislay7seg:
;    ledvdv=1;
	RCALL SUBOPT_0x2
;    ledxdv=1; ledxch=1; ledxtr=1;
;    ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0x3
;    seg_display(10);
;
;    switch (d_type)
	MOVW R30,R4
;        {
;        case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x4
	BRGE _0x27
	RCALL SUBOPT_0x5
;        if (d_anod <= 2)
_0x27:
	RCALL SUBOPT_0x6
	BRLT _0x28
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 0;
	CBI  0x15,4
;            leddch = 1;
	RCALL SUBOPT_0x7
;            leddtr = 1;
;            seg_display(donvi);
	ST   -Y,R6
	RCALL _seg_display
;            }
;        if ((d_anod > 2)&&(d_anod <= 3))
_0x28:
	RCALL SUBOPT_0x6
	BRGE _0x38
	RCALL SUBOPT_0x8
	BRGE _0x39
_0x38:
	RJMP _0x37
_0x39:
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 1;
	RCALL SUBOPT_0x3
;            leddch = 1;
;            leddtr = 1;
;            seg_display(10);
;            }
;        if ((d_anod > 3)&&(d_anod <= 5))
_0x37:
	RCALL SUBOPT_0x8
	BRGE _0x49
	RCALL SUBOPT_0x9
	BRGE _0x4A
_0x49:
	RJMP _0x48
_0x4A:
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 1;
	SBI  0x15,4
;            leddch = 0;
	CBI  0x15,0
;            leddtr = 1;
	SBI  0x18,5
;            seg_display(chuc);
	ST   -Y,R8
	RCALL _seg_display
;            }
;        if ((d_anod > 5)&&(d_anod <= 6))
_0x48:
	RCALL SUBOPT_0x9
	BRGE _0x5A
	RCALL SUBOPT_0xA
	BRGE _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 1;
	RCALL SUBOPT_0x3
;            leddch = 1;
;            leddtr = 1;
;            seg_display(10);
;            }
;        if ((d_anod > 6)&&(d_anod <= 8))
_0x59:
	RCALL SUBOPT_0xA
	BRGE _0x6B
	RCALL SUBOPT_0xB
	BRGE _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 1;
	SBI  0x15,4
;            leddch = 1;
	SBI  0x15,0
;            leddtr = 0;
	CBI  0x18,5
;            seg_display(tram);
	ST   -Y,R10
	RCALL _seg_display
;            }
;        if ((d_anod > 8)&&(d_anod <= 9))
_0x6A:
	RCALL SUBOPT_0xB
	BRGE _0x7C
	RCALL SUBOPT_0x4
	BRGE _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
;            {
;            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
	RCALL SUBOPT_0x2
;            ledddv = 1;
	RCALL SUBOPT_0x3
;            leddch = 1;
;            leddtr = 1;
;            seg_display(10);
;            }
;        break;
_0x7B:
	RJMP _0x25
;        }
;        case 2:
_0x26:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8C
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x4
	BRGE _0x8D
	RCALL SUBOPT_0x5
;        if (d_anod <= 2)
_0x8D:
	RCALL SUBOPT_0x6
	BRLT _0x8E
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=0;
	CBI  0x15,3
;            ledxch=1;
	RCALL SUBOPT_0xD
;            ledxtr=1;
;            seg_display(donvi);
	ST   -Y,R6
	RCALL _seg_display
;            }
;        if ((d_anod > 2)&&(d_anod <= 3))
_0x8E:
	RCALL SUBOPT_0x6
	BRGE _0x9E
	RCALL SUBOPT_0x8
	BRGE _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=1;
	RCALL SUBOPT_0xE
;            ledxch=1;
;            ledxtr=1;
;            seg_display(10);
	RCALL SUBOPT_0xF
;            }
;        if ((d_anod > 3)&&(d_anod <= 5))
_0x9D:
	RCALL SUBOPT_0x8
	BRGE _0xAF
	RCALL SUBOPT_0x9
	BRGE _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=1;
	SBI  0x15,3
;            ledxch=0;
	CBI  0x15,1
;            ledxtr=1;
	SBI  0x15,5
;            seg_display(chuc);
	ST   -Y,R8
	RCALL _seg_display
;            }
;        if ((d_anod > 5)&&(d_anod <= 6))
_0xAE:
	RCALL SUBOPT_0x9
	BRGE _0xC0
	RCALL SUBOPT_0xA
	BRGE _0xC1
_0xC0:
	RJMP _0xBF
_0xC1:
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=1;
	RCALL SUBOPT_0xE
;            ledxch=1;
;            ledxtr=1;
;            seg_display(10);
	RCALL SUBOPT_0xF
;            }
;        if ((d_anod > 6)&&(d_anod <= 8))
_0xBF:
	RCALL SUBOPT_0xA
	BRGE _0xD1
	RCALL SUBOPT_0xB
	BRGE _0xD2
_0xD1:
	RJMP _0xD0
_0xD2:
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=1;
	SBI  0x15,3
;            ledxch=1;
	SBI  0x15,1
;            ledxtr=0;
	CBI  0x15,5
;            seg_display(tram);
	ST   -Y,R10
	RCALL _seg_display
;            }
;        if ((d_anod > 8)&&(d_anod <= 9))
_0xD0:
	RCALL SUBOPT_0xB
	BRGE _0xE2
	RCALL SUBOPT_0x4
	BRGE _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
;            {
;            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
	RCALL SUBOPT_0xC
;            ledxdv=1;
	RCALL SUBOPT_0xE
;            ledxch=1;
;            ledxtr=1;
;            seg_display(10);
	RCALL SUBOPT_0xF
;            }
;        break;
_0xE1:
	RJMP _0x25
;        }
;        case 3:
_0x8C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x4
	BRGE _0xF3
	RCALL SUBOPT_0x5
;        if (d_anod <= 2)
_0xF3:
	RCALL SUBOPT_0x6
	BRLT _0xF4
;            {
;            ledddv = 1; leddch = 1; leddtr = 1; ledxdv=1; ledxch=1; ledxtr=1;
	SBI  0x15,4
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xE
;            ledvdv=0;
	CBI  0x15,2
;            seg_display(donvi);
	ST   -Y,R6
	RCALL _seg_display
;            }
;        if ((d_anod > 2)&&(d_anod <= 9))
_0xF4:
	RCALL SUBOPT_0x6
	BRGE _0x104
	RCALL SUBOPT_0x4
	BRGE _0x105
_0x104:
	RJMP _0x103
_0x105:
;            {
;            ledddv = 1; leddch = 1; leddtr = 1; ledxdv=1; ledxch=1; ledxtr=1;
	SBI  0x15,4
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xE
;            ledvdv=1;
	SBI  0x15,2
;            seg_display(10);
	RCALL SUBOPT_0xF
;            }
;        break;
_0x103:
;        }
;        }
_0x25:
;    }
	RET
;#include <calculate.c>
;
;
;void calculate()
; 0000 0021     {
_calculate:
;          if (d_type ==1)
	RCALL SUBOPT_0x10
	BRNE _0x114
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x11
;            cou_r_pre--;
;            donvi = cou_r_pre&0xf;
;            chuc  = (cou_r_pre/10)&0xf;
;            tram  = (cou_r_pre/100)&0xf;
;            if (chuc == 0) chuc=10;
	BRNE _0x115
	RCALL SUBOPT_0x12
	MOVW R8,R30
;            if (tram == 0) tram=10;
_0x115:
	RCALL SUBOPT_0x13
	BRNE _0x116
	RCALL SUBOPT_0x14
;            while(d_type ==1)
_0x116:
_0x117:
	RCALL SUBOPT_0x10
	BRNE _0x119
;                {
;                if (cou_1s >=40)
	RCALL SUBOPT_0x15
	BRLT _0x11A
;                    {
;                    if ((li_r ==1)&&(li_g ==1)) d_type=3;
	SBIS 0x16,1
	RJMP _0x11C
	SBIC 0x16,2
	RJMP _0x11D
_0x11C:
	RJMP _0x11B
_0x11D:
	RCALL SUBOPT_0x16
	MOVW R4,R30
;                    cou_1s =0;
_0x11B:
	RCALL SUBOPT_0x11
;                    cou_r_pre--;
;                    donvi = cou_r_pre&0xf;
;                    chuc  = (cou_r_pre/10)&0xf;
;                    tram  = (cou_r_pre/100)&0xf;
;                    if (chuc == 0) chuc=10;
	BRNE _0x11E
	RCALL SUBOPT_0x17
;                    if (tram == 0) chuc=10;
_0x11E:
	RCALL SUBOPT_0x13
	BRNE _0x11F
	RCALL SUBOPT_0x17
;                    if (cou_r_pre <=-1)
_0x11F:
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	RCALL SUBOPT_0x18
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x120
;                        {
;                        cou_r_pre =-1;
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
;                        donvi=10;
	RCALL SUBOPT_0x1A
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x14
;                        }
;                    }
_0x120:
;                }
_0x11A:
	RJMP _0x117
_0x119:
;            }
; /////////////////////////////////////////////////////////////////////
;        if (d_type ==2)
_0x114:
	RCALL SUBOPT_0x1B
	BRNE _0x121
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x1C
;            cou_g_pre--;
;            donvi = cou_g_pre&0xf;
;            chuc  = (cou_g_pre/10)&0xf;
;            tram  = (cou_g_pre/100)&0xf;
;            if (chuc == 0) chuc=10;
	BRNE _0x122
	RCALL SUBOPT_0x17
;            if (tram == 0) tram=10;
_0x122:
	RCALL SUBOPT_0x13
	BRNE _0x123
	RCALL SUBOPT_0x14
;            while(d_type ==2)
_0x123:
_0x124:
	RCALL SUBOPT_0x1B
	BRNE _0x126
;                {
;                if (cou_1s >=40)
	RCALL SUBOPT_0x15
	BRLT _0x127
;                    {
;                    cou_1s =0;
	RCALL SUBOPT_0x1C
;                    cou_g_pre--;
;                    donvi = cou_g_pre&0xf;
;                    chuc  = (cou_g_pre/10)&0xf;
;                    tram  = (cou_g_pre/100)&0xf;
;                    if (chuc == 0) chuc=10;
	BRNE _0x128
	RCALL SUBOPT_0x17
;                    if (tram == 0) tram=10;
_0x128:
	RCALL SUBOPT_0x13
	BRNE _0x129
	RCALL SUBOPT_0x14
;                    if (cou_g_pre <=-1)
_0x129:
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	RCALL SUBOPT_0x18
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x12A
;                        {
;                        cou_g_pre =-1;
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1D
;                        donvi=10;
	RCALL SUBOPT_0x1A
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x14
;                        }
;                    }
_0x12A:
;                }
_0x127:
	RJMP _0x124
_0x126:
;            }
; /////////////////////////////////////////////////////////////////////
;        if (d_type ==3)
_0x121:
	RCALL SUBOPT_0x1E
	BREQ PC+2
	RJMP _0x12B
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x1F
;            cou_y_pre--;
	RCALL SUBOPT_0x20
;            donvi = cou_y_pre&0xf;
;            chuc=10;
;            tram=10;
	RCALL SUBOPT_0x14
;            while(d_type ==3)
_0x12C:
	RCALL SUBOPT_0x1E
	BREQ PC+2
	RJMP _0x12E
;                {
;                if (cou_y >440)
	LDS  R26,_cou_y
	LDS  R27,_cou_y+1
	CPI  R26,LOW(0x1B9)
	LDI  R30,HIGH(0x1B9)
	CPC  R27,R30
	BRLT _0x12F
;                    {
;                    reset_interupt01();
	RCALL _reset_interupt01
;                    cou_r =0; cou_g =0; cou_y =0;
	LDI  R30,LOW(0)
	STS  _cou_r,R30
	STS  _cou_r+1,R30
	STS  _cou_g,R30
	STS  _cou_g+1,R30
	STS  _cou_y,R30
	STS  _cou_y+1,R30
;                    cou_dr =0;
	STS  _cou_dr,R30
	STS  _cou_dr+1,R30
;                    cou_dg =0;
	STS  _cou_dg,R30
	STS  _cou_dg+1,R30
;                    cou_dy =0;
	STS  _cou_dy,R30
	STS  _cou_dy+1,R30
;                    cou_1s=0;
	RCALL SUBOPT_0x1F
;                    d_type =0;
	CLR  R4
	CLR  R5
;                    kds_cv =3;
	RCALL SUBOPT_0x16
	STS  _kds_cv,R30
	STS  _kds_cv+1,R31
;                    f_cv =1;
	SET
	BLD  R2,0
;                    }
;                if (cou_1s >=39)
_0x12F:
	LDS  R26,_cou_1s
	LDS  R27,_cou_1s+1
	SBIW R26,39
	BRLT _0x130
;                    {
;                    cou_1s =0;
	RCALL SUBOPT_0x1F
;                    cou_y_pre--;
	RCALL SUBOPT_0x20
;                    donvi = cou_y_pre&0xf;
;                    chuc=10;
;                    tram=10;
	RCALL SUBOPT_0x14
;                    if (cou_y_pre <=-1)
	LDS  R26,_cou_y_pre
	LDS  R27,_cou_y_pre+1
	RCALL SUBOPT_0x18
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x131
;                        {
;                        cou_y_pre =-1;
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x21
;                        donvi=10;
	RCALL SUBOPT_0x1A
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x14
;                        }
;                    }
_0x131:
;                }
_0x130:
	RJMP _0x12C
_0x12E:
;            }
;    }
_0x12B:
	RET
;
;
;// Timer 0 overflow interrupt service routine: overflow at 1ms
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0026 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0027 // Reinitialize Timer 0 value
; 0000 0028 TCNT0=0x82;
	LDI  R30,LOW(130)
	OUT  0x32,R30
; 0000 0029 // Place your code here
; 0000 002A dislay7seg();
	RCALL _dislay7seg
; 0000 002B 
; 0000 002C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer1 overflow interrupt service routine: overflow at 25ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0030 {
_timer1_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0031 // Reinitialize Timer1 value
; 0000 0032 TCNT1H=0x9E57 >> 8;
	RCALL SUBOPT_0x0
; 0000 0033 TCNT1L=0x9E57 & 0xff;
; 0000 0034 // Place your code here
; 0000 0035 /*
; 0000 0036 switch (d_type)
; 0000 0037 			{
; 0000 0038 			case 1: cou_r++;
; 0000 0039 					if ((li_r ==1)&&(li_g ==0))
; 0000 003A 						{
; 0000 003B 						cou_dr++; d_type=2;
; 0000 003C 						if (kds_cv <=0) cou_r_pre =cou_r/40;
; 0000 003D 						cou_r =0;
; 0000 003E 						}
; 0000 003F 					if (cou_dr >=5)
; 0000 0040 						{cou_dr =0; f_red =cou_r_pre; }
; 0000 0041 					break;
; 0000 0042 			case 2: cou_g++;
; 0000 0043 					if ((li_r ==1)&&(li_g ==1))
; 0000 0044 						{
; 0000 0045 						cou_dg++; d_type=3;
; 0000 0046 						if (kds_cv <=0) cou_g_pre =cou_g/40;
; 0000 0047 						cou_g =0;
; 0000 0048 						}
; 0000 0049 					if (cou_dg >=5)
; 0000 004A 						{cou_dg =0; f_gree =cou_g_pre; }
; 0000 004B 					break;
; 0000 004C 			case 3: cou_y++;
; 0000 004D 					if ((li_r ==0)&&(li_g ==1))
; 0000 004E 						{
; 0000 004F 						cou_dy++; d_type=1;
; 0000 0050 						if (kds_cv <=0) cou_y_pre =cou_y/40;
; 0000 0051 						cou_y =0;
; 0000 0052 						}
; 0000 0053 					if (cou_dy >=5)
; 0000 0054 						{cou_dy =0; f_yell =cou_y_pre; }
; 0000 0055 					break;
; 0000 0056 			}
; 0000 0057 */
; 0000 0058 
; 0000 0059 		cou_1s++;
	LDI  R26,LOW(_cou_1s)
	LDI  R27,HIGH(_cou_1s)
	RCALL SUBOPT_0x22
; 0000 005A 
; 0000 005B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 0060 {
_main:
; 0000 0061 
; 0000 0062 // Input/Output Ports initialization
; 0000 0063 // Port B initialization
; 0000 0064 // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0065 // State7=T State6=T State5=1 State4=T State3=T State2=T State1=T State0=T
; 0000 0066 PORTB=0x20;
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 0067 DDRB=0x20;
	OUT  0x17,R30
; 0000 0068 
; 0000 0069 // Port C initialization
; 0000 006A // Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 006B // State6=T State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 006C PORTC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 006D DDRC=0x3F;
	OUT  0x14,R30
; 0000 006E 
; 0000 006F // Port D initialization
; 0000 0070 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0071 // State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 0072 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0073 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0074 
; 0000 0075 if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3;
	SBIC 0x16,1
	RJMP _0x132
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x152
_0x132:
	SBIC 0x16,2
	RJMP _0x134
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x152
_0x134:
	RCALL SUBOPT_0x16
_0x152:
	MOVW R4,R30
; 0000 0076 
; 0000 0077 set_interupt01();
	RCALL _set_interupt01
; 0000 0078 
; 0000 0079 while (1)
; 0000 007A       {
; 0000 007B       // Place your code here
; 0000 007C       if(kds_cv <=0) { kds_cv =0; calculate();}
	RCALL SUBOPT_0x23
	BRLT _0x139
	RCALL SUBOPT_0x24
; 0000 007D 
; 0000 007E       while(1)
_0x139:
_0x13A:
; 0000 007F 		{
; 0000 0080 		if(kds_cv <=0) { kds_cv =0; calculate();}
	RCALL SUBOPT_0x23
	BRLT _0x13D
	RCALL SUBOPT_0x24
; 0000 0081 
; 0000 0082 		if(kds_cv >1)
_0x13D:
	LDS  R26,_kds_cv
	LDS  R27,_kds_cv+1
	SBIW R26,2
	BRGE PC+2
	RJMP _0x13E
; 0000 0083 		{
; 0000 0084 		while(f_cv ==1)
_0x13F:
	SBRS R2,0
	RJMP _0x141
; 0000 0085 			{
; 0000 0086 			if ((li_r ==0)|(li_g ==0))
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	RCALL SUBOPT_0x25
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	RCALL SUBOPT_0x25
	OR   R30,R0
	BREQ _0x142
; 0000 0087 				{
; 0000 0088 				set_interupt01();
	RCALL _set_interupt01
; 0000 0089 				f_cv=0;
	CLT
	BLD  R2,0
; 0000 008A 				if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3;
	SBIC 0x16,1
	RJMP _0x143
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x153
_0x143:
	SBIC 0x16,2
	RJMP _0x145
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x153
_0x145:
	RCALL SUBOPT_0x16
_0x153:
	MOVW R4,R30
; 0000 008B 				}
; 0000 008C 			}
_0x142:
	RJMP _0x13F
_0x141:
; 0000 008D 		for(i=0; i <2; i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x148:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,2
	BRGE _0x149
; 0000 008E 		{
; 0000 008F 		gree =0; yell =0; red =0;
	CLT
	BLD  R2,1
	BLD  R2,2
	BLD  R2,3
; 0000 0090 		cou_r_pre =f_red;
	LDS  R30,_f_red
	LDS  R31,_f_red+1
	RCALL SUBOPT_0x19
; 0000 0091 		cou_g_pre =f_gree;
	LDS  R30,_f_gree
	LDS  R31,_f_gree+1
	RCALL SUBOPT_0x1D
; 0000 0092 		cou_y_pre =f_yell;
	LDS  R30,_f_yell
	LDS  R31,_f_yell+1
	RCALL SUBOPT_0x21
; 0000 0093 		while ((gree ==0)&(yell ==0)&(red ==0))
_0x14A:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RCALL SUBOPT_0x25
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	RCALL SUBOPT_0x25
	AND  R0,R30
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	RCALL SUBOPT_0x25
	AND  R30,R0
	BREQ _0x14C
; 0000 0094 			{
; 0000 0095 			if (d_type ==1) red =1;
	RCALL SUBOPT_0x10
	BRNE _0x14D
	SET
	BLD  R2,3
; 0000 0096 			if (d_type ==2)	gree =1;
_0x14D:
	RCALL SUBOPT_0x1B
	BRNE _0x14E
	SET
	BLD  R2,1
; 0000 0097 			if (d_type ==3) yell =1;
_0x14E:
	RCALL SUBOPT_0x1E
	BRNE _0x14F
	SET
	BLD  R2,2
; 0000 0098 			calculate();
_0x14F:
	RCALL _calculate
; 0000 0099 			}
	RJMP _0x14A
_0x14C:
; 0000 009A 		}
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x22
	RJMP _0x148
_0x149:
; 0000 009B 		kds_cv =0;
	LDI  R30,LOW(0)
	STS  _kds_cv,R30
	STS  _kds_cv+1,R30
; 0000 009C 		}
; 0000 009D 
; 0000 009E       }
_0x13E:
	RJMP _0x13A
; 0000 009F     }
; 0000 00A0 
; 0000 00A1 }
_0x150:
	RJMP _0x150

	.DSEG
_cou_dr:
	.BYTE 0x2
_cou_dg:
	.BYTE 0x2
_cou_dy:
	.BYTE 0x2
_i:
	.BYTE 0x2
_cou_r:
	.BYTE 0x2
_cou_g:
	.BYTE 0x2
_cou_y:
	.BYTE 0x2
_cou_1s:
	.BYTE 0x2
_f_yell:
	.BYTE 0x2
_cou_r_pre:
	.BYTE 0x2
_cou_g_pre:
	.BYTE 0x2
_cou_y_pre:
	.BYTE 0x2
_f_red:
	.BYTE 0x2
_f_gree:
	.BYTE 0x2
_kds_cv:
	.BYTE 0x2
_seg_array:
	.BYTE 0x16

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(158)
	OUT  0x2D,R30
	LDI  R30,LOW(87)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x26,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2:
	SBI  0x15,2
	SBI  0x15,3
	SBI  0x15,1
	SBI  0x15,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	SBI  0x15,4
	SBI  0x15,0
	SBI  0x18,5
	LDI  R30,LOW(10)
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	SBI  0x15,0
	SBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	SBI  0x15,2
	SBI  0x15,4
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	SBI  0x15,1
	SBI  0x15,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	SBI  0x15,3
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _cou_1s,R30
	STS  _cou_1s+1,R30
	LDI  R26,LOW(_cou_r_pre)
	LDI  R27,HIGH(_cou_r_pre)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cou_r_pre
	LDS  R31,_cou_r_pre+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R6,R30
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R8,R30
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R10,R30
	MOV  R0,R8
	OR   R0,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	MOV  R0,R10
	OR   R0,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x12
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDS  R26,_cou_1s
	LDS  R27,_cou_1s+1
	SBIW R26,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x12
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	STS  _cou_r_pre,R30
	STS  _cou_r_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x12
	MOVW R6,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _cou_1s,R30
	STS  _cou_1s+1,R30
	LDI  R26,LOW(_cou_g_pre)
	LDI  R27,HIGH(_cou_g_pre)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cou_g_pre
	LDS  R31,_cou_g_pre+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R6,R30
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	RCALL SUBOPT_0x12
	RCALL __DIVW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R8,R30
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R10,R30
	MOV  R0,R8
	OR   R0,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STS  _cou_g_pre,R30
	STS  _cou_g_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x16
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	STS  _cou_1s,R30
	STS  _cou_1s+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_cou_y_pre)
	LDI  R27,HIGH(_cou_y_pre)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cou_y_pre
	LDS  R31,_cou_y_pre+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R6,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	STS  _cou_y_pre,R30
	STS  _cou_y_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDS  R26,_kds_cv
	LDS  R27,_kds_cv+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	STS  _kds_cv,R30
	STS  _kds_cv+1,R30
	RJMP _calculate

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	RCALL __EQB12
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
