
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
	.DB  0x7C
_0x4:
	.DB  0x7C
_0x5:
	.DB  0xA
_0x6:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F

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
;
;
;// Declare your global variables here
;
;volatile int d_type=0, donvi, chuc, tram, d_anod=0, cou_dr=0, cou_dg=0, cou_dy=0, i=0;
;volatile int cou_r=0, cou_g=0, cou_y=0, cou_1s=0, f_yell=0, cou_lm=0;
;volatile int cou_r_pre=124, cou_g_pre=124, cou_y_pre=10, f_red=0, f_gree=0, kds_cv=0;

	.DSEG
;volatile bit f_cv=0, gree=0, yell=0, red=0;
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
;TCNT1H=0xFC;
	RCALL SUBOPT_0x0
;TCNT1L=0x17;
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
;// Watchdog Timer initialization
;// Watchdog Timer Prescaler: OSC/32k
;#pragma optsize-
;WDTCR=0x19;
	LDI  R30,LOW(25)
	OUT  0x21,R30
;WDTCR=0x09;
	LDI  R30,LOW(9)
	OUT  0x21,R30
;#ifdef _OPTIMIZE_SIZE_
;#pragma optsize+
;#endif
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
	RJMP _0x16B
;                break;
;        case 1: PORTD=seg_array[1];
_0xA:
	RCALL SUBOPT_0x2
	BRNE _0xB
	__GETB1MN _seg_array,2
	RJMP _0x16B
;                break;
;        case 2: PORTD=seg_array[2];
_0xB:
	RCALL SUBOPT_0x3
	BRNE _0xC
	__GETB1MN _seg_array,4
	RJMP _0x16B
;                break;
;        case 3: PORTD=seg_array[3];
_0xC:
	RCALL SUBOPT_0x4
	BRNE _0xD
	__GETB1MN _seg_array,6
	RJMP _0x16B
;                break;
;        case 4: PORTD=seg_array[4];
_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE
	__GETB1MN _seg_array,8
	RJMP _0x16B
;                break;
;        case 5: PORTD=seg_array[5];
_0xE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF
	__GETB1MN _seg_array,10
	RJMP _0x16B
;                break;
;        case 6: PORTD=seg_array[6];
_0xF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x10
	__GETB1MN _seg_array,12
	RJMP _0x16B
;                break;
;        case 7: PORTD=seg_array[7];
_0x10:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x11
	__GETB1MN _seg_array,14
	RJMP _0x16B
;                break;
;        case 8: PORTD=seg_array[8];
_0x11:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x12
	__GETB1MN _seg_array,16
	RJMP _0x16B
;                break;
;        case 9: PORTD=seg_array[9];
_0x12:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x13
	__GETB1MN _seg_array,18
	RJMP _0x16B
;                break;
;        case 10: PORTD=seg_array[10];
_0x13:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x9
	__GETB1MN _seg_array,20
_0x16B:
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
;    ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;    ledddv = 0;
	RCALL SUBOPT_0x6
;    leddch = 0;
;    leddtr = 0;
;    seg_display(10);
;
;    switch (d_type)
	RCALL SUBOPT_0x7
;        {
;        case 1:
	BRNE _0x26
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x8
	SBIW R26,10
	BRLT _0x27
	RCALL SUBOPT_0x9
;        if (d_anod <= 2)
_0x27:
	RCALL SUBOPT_0xA
	BRGE _0x28
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 1;
	SBI  0x15,4
;            leddch = 0;
	RCALL SUBOPT_0xB
;            leddtr = 0;
;            seg_display(donvi);
	RCALL SUBOPT_0xC
;            }
;        if ((d_anod > 2)&&(d_anod <= 3))
_0x28:
	RCALL SUBOPT_0xA
	BRLT _0x38
	RCALL SUBOPT_0xD
	BRLT _0x39
_0x38:
	RJMP _0x37
_0x39:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	RCALL SUBOPT_0x6
;            leddch = 0;
;            leddtr = 0;
;            seg_display(10);
;            }
;        if ((d_anod > 3)&&(d_anod <= 5))
_0x37:
	RCALL SUBOPT_0xD
	BRLT _0x49
	RCALL SUBOPT_0xE
	BRLT _0x4A
_0x49:
	RJMP _0x48
_0x4A:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	CBI  0x15,4
;            leddch = 1;
	SBI  0x15,0
;            leddtr = 0;
	CBI  0x18,5
;            seg_display(chuc);
	RCALL SUBOPT_0xF
;            }
;        if ((d_anod > 5)&&(d_anod <= 6))
_0x48:
	RCALL SUBOPT_0xE
	BRLT _0x5A
	RCALL SUBOPT_0x10
	BRLT _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	RCALL SUBOPT_0x6
;            leddch = 0;
;            leddtr = 0;
;            seg_display(10);
;            }
;        if ((d_anod > 6)&&(d_anod <= 8))
_0x59:
	RCALL SUBOPT_0x10
	BRLT _0x6B
	RCALL SUBOPT_0x11
	BRLT _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	CBI  0x15,4
;            leddch = 0;
	CBI  0x15,0
;            leddtr = 1;
	SBI  0x18,5
;            seg_display(tram);
	RCALL SUBOPT_0x12
;            }
;        if ((d_anod > 8)&&(d_anod <= 9))
_0x6A:
	RCALL SUBOPT_0x11
	BRLT _0x7C
	RCALL SUBOPT_0x13
	BRLT _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	RCALL SUBOPT_0x6
;            leddch = 0;
;            leddtr = 0;
;            seg_display(10);
;            }
;        break;
_0x7B:
	RJMP _0x25
;        }
;        case 2:
_0x26:
	RCALL SUBOPT_0x3
	BRNE _0x8C
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x13
	BRLT _0x8D
	RCALL SUBOPT_0x9
;        if (d_anod <= 2)
_0x8D:
	RCALL SUBOPT_0xA
	BRGE _0x8E
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=1;
	SBI  0x15,3
;            ledxch=0;
	RCALL SUBOPT_0x15
;            ledxtr=0;
;            seg_display(donvi);
	RCALL SUBOPT_0xC
;            }
;        if ((d_anod > 2)&&(d_anod <= 3))
_0x8E:
	RCALL SUBOPT_0xA
	BRLT _0x9E
	RCALL SUBOPT_0xD
	BRLT _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=0;
	RCALL SUBOPT_0x16
;            ledxch=0;
;            ledxtr=0;
;            seg_display(10);
	RCALL SUBOPT_0x17
;            }
;        if ((d_anod > 3)&&(d_anod <= 5))
_0x9D:
	RCALL SUBOPT_0xD
	BRLT _0xAF
	RCALL SUBOPT_0xE
	BRLT _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=0;
	CBI  0x15,3
;            ledxch=1;
	SBI  0x15,1
;            ledxtr=0;
	CBI  0x15,5
;            seg_display(chuc);
	RCALL SUBOPT_0xF
;            }
;        if ((d_anod > 5)&&(d_anod <= 6))
_0xAE:
	RCALL SUBOPT_0xE
	BRLT _0xC0
	RCALL SUBOPT_0x10
	BRLT _0xC1
_0xC0:
	RJMP _0xBF
_0xC1:
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=0;
	RCALL SUBOPT_0x16
;            ledxch=0;
;            ledxtr=0;
;            seg_display(10);
	RCALL SUBOPT_0x17
;            }
;        if ((d_anod > 6)&&(d_anod <= 8))
_0xBF:
	RCALL SUBOPT_0x10
	BRLT _0xD1
	RCALL SUBOPT_0x11
	BRLT _0xD2
_0xD1:
	RJMP _0xD0
_0xD2:
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=0;
	CBI  0x15,3
;            ledxch=0;
	CBI  0x15,1
;            ledxtr=1;
	SBI  0x15,5
;            seg_display(tram);
	RCALL SUBOPT_0x12
;            }
;        if ((d_anod > 8)&&(d_anod <= 9))
_0xD0:
	RCALL SUBOPT_0x11
	BRLT _0xE2
	RCALL SUBOPT_0x13
	BRLT _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
;            {
;            ledvdv=0; ledddv = 0; leddch = 0; leddtr = 0;
	RCALL SUBOPT_0x14
;            ledxdv=0;
	RCALL SUBOPT_0x16
;            ledxch=0;
;            ledxtr=0;
;            seg_display(10);
	RCALL SUBOPT_0x17
;            }
;        break;
_0xE1:
	RJMP _0x25
;        }
;        case 3:
_0x8C:
	RCALL SUBOPT_0x4
	BRNE _0x25
;        {
;        if (d_anod > 9) d_anod=1;
	RCALL SUBOPT_0x13
	BRLT _0xF3
	RCALL SUBOPT_0x9
;        if (d_anod <= 2)
_0xF3:
	RCALL SUBOPT_0xA
	BRGE _0xF4
;            {
;            ledddv=0; ledxdv=0; ledxch=0; ledxtr=0;
	CBI  0x15,4
	RCALL SUBOPT_0x16
;            ledvdv = 1;
	SBI  0x15,2
;            leddch = 0;
	RCALL SUBOPT_0xB
;            leddtr = 0;
;            seg_display(donvi);
	RCALL SUBOPT_0xC
;            }
;        if ((d_anod > 2)&&(d_anod <= 9))
_0xF4:
	RCALL SUBOPT_0xA
	BRLT _0x104
	RCALL SUBOPT_0x13
	BRLT _0x105
_0x104:
	RJMP _0x103
_0x105:
;            {
;            ledvdv=0; ledxdv=0; ledxch=0; ledxtr=0;
	RCALL SUBOPT_0x5
;            ledddv = 0;
	RCALL SUBOPT_0x6
;            leddch = 0;
;            leddtr = 0;
;            seg_display(10);
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
	RCALL SUBOPT_0x18
	BRNE _0x114
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x19
;            cou_r_pre--;
;            tram  = cou_r_pre/100;
;            chuc  = (cou_r_pre-tram*100)/10;
;            donvi = (cou_r_pre%10)&0x0f;
;
;            if (chuc == 0) chuc=10;
	BRNE _0x115
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
;            if (tram == 0) tram=10;
_0x115:
	RCALL SUBOPT_0x1C
	BRNE _0x116
	RCALL SUBOPT_0x1D
;            while(d_type ==1)
_0x116:
_0x117:
	RCALL SUBOPT_0x18
	BRNE _0x119
;                {
;                if (cou_1s >=40)
	RCALL SUBOPT_0x1E
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
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
;                    cou_1s =0;
_0x11B:
	RCALL SUBOPT_0x19
;                    cou_r_pre--;
;                    tram  = cou_r_pre/100;
;
;                    chuc  = (cou_r_pre-tram*100)/10;
;                    donvi = (cou_r_pre%10)&0x0f;
;
;                    if (chuc == 0){ if (cou_r_pre > 99) chuc = 0; else chuc = 10; }
	BRNE _0x11E
	RCALL SUBOPT_0x21
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x11F
	RCALL SUBOPT_0x22
	RJMP _0x120
_0x11F:
	RCALL SUBOPT_0x23
_0x120:
;                    if (tram == 0) tram=10;
_0x11E:
	RCALL SUBOPT_0x1C
	BRNE _0x121
	RCALL SUBOPT_0x1D
;                    if (cou_r_pre <=-1)
_0x121:
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x24
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x122
;                        {
;                        cou_r_pre =-1;
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
;                        donvi=10;
	RCALL SUBOPT_0x26
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x1D
;                        }
;                    }
_0x122:
;                }
_0x11A:
	RJMP _0x117
_0x119:
;            }
; /////////////////////////////////////////////////////////////////////
;        if (d_type ==2)
_0x114:
	RCALL SUBOPT_0x27
	BRNE _0x123
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x28
;            cou_g_pre--;
;            tram  = cou_g_pre/100;
;            chuc  = (cou_g_pre-tram*100)/10;
;            donvi = (cou_g_pre%10)&0x0f;
;
;            if (chuc == 0) chuc=10;
	BRNE _0x124
	RCALL SUBOPT_0x23
;            if (tram == 0) tram=10;
_0x124:
	RCALL SUBOPT_0x1C
	BRNE _0x125
	RCALL SUBOPT_0x1D
;            while(d_type ==2)
_0x125:
_0x126:
	RCALL SUBOPT_0x27
	BRNE _0x128
;                {
;                if (cou_1s >=40)
	RCALL SUBOPT_0x1E
	BRLT _0x129
;                    {
;                    cou_1s =0;
	RCALL SUBOPT_0x28
;                    cou_g_pre--;
;                    tram  = cou_g_pre/100;
;                    chuc  = (cou_g_pre-tram*100)/10;
;                    donvi = (cou_g_pre%10)&0x0f;
;
;                    if (chuc == 0){ if (cou_g_pre > 99) chuc = 0; else chuc = 10; }
	BRNE _0x12A
	RCALL SUBOPT_0x29
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x12B
	RCALL SUBOPT_0x22
	RJMP _0x12C
_0x12B:
	RCALL SUBOPT_0x23
_0x12C:
;                    if (tram == 0) tram=10;
_0x12A:
	RCALL SUBOPT_0x1C
	BRNE _0x12D
	RCALL SUBOPT_0x1D
;                    if (cou_g_pre <=-1)
_0x12D:
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x24
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x12E
;                        {
;                        cou_g_pre =-1;
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x2A
;                        donvi=10;
	RCALL SUBOPT_0x26
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x1D
;                        }
;                    }
_0x12E:
;                }
_0x129:
	RJMP _0x126
_0x128:
;            }
; /////////////////////////////////////////////////////////////////////
;        if (d_type ==3)
_0x123:
	RCALL SUBOPT_0x2B
	BRNE _0x12F
;            {
;            cou_1s=0;
	RCALL SUBOPT_0x2C
;            cou_y_pre--;
	RCALL SUBOPT_0x2D
;            donvi = (cou_y_pre%10)&0x0f;
;            chuc=10;
;            tram=10;
	RCALL SUBOPT_0x1D
;            while(d_type ==3)
_0x130:
	RCALL SUBOPT_0x2B
	BRNE _0x132
;                {
;                if (cou_y >440)
	RCALL SUBOPT_0x2E
	CPI  R26,LOW(0x1B9)
	LDI  R30,HIGH(0x1B9)
	CPC  R27,R30
	BRLT _0x133
;                    {
;                    reset_interupt01();
	RCALL _reset_interupt01
;                    cou_r =0; cou_g =0; cou_y =0;
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x31
;                    cou_dr =0;
	RCALL SUBOPT_0x32
;                    cou_dg =0;
	RCALL SUBOPT_0x33
;                    cou_dy =0;
	RCALL SUBOPT_0x34
;                    cou_1s=0;
	RCALL SUBOPT_0x2C
;                    d_type =0;
	LDI  R30,LOW(0)
	STS  _d_type,R30
	STS  _d_type+1,R30
;                    kds_cv =3;
	RCALL SUBOPT_0x1F
	STS  _kds_cv,R30
	STS  _kds_cv+1,R31
;                    f_cv =1;
	SET
	BLD  R2,0
;                    }
;                if (cou_1s >=39)
_0x133:
	LDS  R26,_cou_1s
	LDS  R27,_cou_1s+1
	SBIW R26,39
	BRLT _0x134
;                    {
;                    cou_1s =0;
	RCALL SUBOPT_0x2C
;                    cou_y_pre--;
	RCALL SUBOPT_0x2D
;                    donvi = (cou_y_pre%10)&0x0f;
;                    chuc=10;
;                    tram=10;
	RCALL SUBOPT_0x1D
;                    if (cou_y_pre <=-1)
	LDS  R26,_cou_y_pre
	LDS  R27,_cou_y_pre+1
	RCALL SUBOPT_0x24
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x135
;                        {
;                        cou_y_pre =-1;
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x35
;                        donvi=10;
	RCALL SUBOPT_0x26
;                        chuc=10;
;                        tram=10;
	RCALL SUBOPT_0x1D
;                        }
;                    }
_0x135:
;                }
_0x134:
	RJMP _0x130
_0x132:
;            }
;    }
_0x12F:
	RET
;
;
;// Timer 0 overflow interrupt service routine: overflow at 1ms
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0026 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
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
; 0000 002A cou_lm++;
	LDI  R26,LOW(_cou_lm)
	LDI  R27,HIGH(_cou_lm)
	RCALL SUBOPT_0x36
; 0000 002B 
; 0000 002C if (cou_lm >=25){
	LDS  R26,_cou_lm
	LDS  R27,_cou_lm+1
	SBIW R26,25
	BRGE PC+2
	RJMP _0x136
; 0000 002D     cou_lm =0;
	LDI  R30,LOW(0)
	STS  _cou_lm,R30
	STS  _cou_lm+1,R30
; 0000 002E     //#asm("WDR");
; 0000 002F     switch (d_type)
	RCALL SUBOPT_0x7
; 0000 0030             {
; 0000 0031             case 1: cou_r++;
	BRNE _0x13A
	LDI  R26,LOW(_cou_r)
	LDI  R27,HIGH(_cou_r)
	RCALL SUBOPT_0x36
; 0000 0032                     if ((li_r ==1)&&(li_g ==0))
	SBIS 0x16,1
	RJMP _0x13C
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x13D
_0x13C:
	RJMP _0x13B
_0x13D:
; 0000 0033                         {
; 0000 0034                         cou_dr++; d_type=2;
	LDI  R26,LOW(_cou_dr)
	LDI  R27,HIGH(_cou_dr)
	RCALL SUBOPT_0x36
	SBIW R30,1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x37
; 0000 0035                         if (kds_cv <=0) cou_r_pre =cou_r/40;
	BRLT _0x13E
	LDS  R26,_cou_r
	LDS  R27,_cou_r+1
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x25
; 0000 0036                         cou_r =0;
_0x13E:
	RCALL SUBOPT_0x2F
; 0000 0037                         }
; 0000 0038                     if (cou_dr >=5)
_0x13B:
	LDS  R26,_cou_dr
	LDS  R27,_cou_dr+1
	SBIW R26,5
	BRLT _0x13F
; 0000 0039                         {cou_dr =0; f_red =cou_r_pre; }
	RCALL SUBOPT_0x32
	LDS  R30,_cou_r_pre
	LDS  R31,_cou_r_pre+1
	STS  _f_red,R30
	STS  _f_red+1,R31
; 0000 003A                     break;
_0x13F:
	RJMP _0x139
; 0000 003B             case 2: cou_g++;
_0x13A:
	RCALL SUBOPT_0x3
	BRNE _0x140
	LDI  R26,LOW(_cou_g)
	LDI  R27,HIGH(_cou_g)
	RCALL SUBOPT_0x36
; 0000 003C                     if ((li_r ==1)&&(li_g ==1))
	SBIS 0x16,1
	RJMP _0x142
	SBIC 0x16,2
	RJMP _0x143
_0x142:
	RJMP _0x141
_0x143:
; 0000 003D                         {
; 0000 003E                         cou_dg++; d_type=3;
	LDI  R26,LOW(_cou_dg)
	LDI  R27,HIGH(_cou_dg)
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x37
; 0000 003F                         if (kds_cv <=0) cou_g_pre =cou_g/40;
	BRLT _0x144
	LDS  R26,_cou_g
	LDS  R27,_cou_g+1
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x2A
; 0000 0040                         cou_g =0;
_0x144:
	RCALL SUBOPT_0x30
; 0000 0041                         }
; 0000 0042                     if (cou_dg >=5)
_0x141:
	LDS  R26,_cou_dg
	LDS  R27,_cou_dg+1
	SBIW R26,5
	BRLT _0x145
; 0000 0043                         {cou_dg =0; f_gree =cou_g_pre; }
	RCALL SUBOPT_0x33
	LDS  R30,_cou_g_pre
	LDS  R31,_cou_g_pre+1
	STS  _f_gree,R30
	STS  _f_gree+1,R31
; 0000 0044                     break;
_0x145:
	RJMP _0x139
; 0000 0045             case 3: cou_y++;
_0x140:
	RCALL SUBOPT_0x4
	BRNE _0x139
	LDI  R26,LOW(_cou_y)
	LDI  R27,HIGH(_cou_y)
	RCALL SUBOPT_0x36
; 0000 0046                     if ((li_r ==0)&&(li_g ==1))
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x148
	SBIC 0x16,2
	RJMP _0x149
_0x148:
	RJMP _0x147
_0x149:
; 0000 0047                         {
; 0000 0048                         cou_dy++; d_type=1;
	LDI  R26,LOW(_cou_dy)
	LDI  R27,HIGH(_cou_dy)
	RCALL SUBOPT_0x36
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x37
; 0000 0049                         if (kds_cv <=0) cou_y_pre =cou_y/40;
	BRLT _0x14A
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x35
; 0000 004A                         cou_y =0;
_0x14A:
	RCALL SUBOPT_0x31
; 0000 004B                         }
; 0000 004C                     if (cou_dy >=5)
_0x147:
	LDS  R26,_cou_dy
	LDS  R27,_cou_dy+1
	SBIW R26,5
	BRLT _0x14B
; 0000 004D                         {cou_dy =0; f_yell =cou_y_pre; }
	RCALL SUBOPT_0x34
	LDS  R30,_cou_y_pre
	LDS  R31,_cou_y_pre+1
	STS  _f_yell,R30
	STS  _f_yell+1,R31
; 0000 004E                     break;
_0x14B:
; 0000 004F             }
_0x139:
; 0000 0050         cou_1s++;
	LDI  R26,LOW(_cou_1s)
	LDI  R27,HIGH(_cou_1s)
	RCALL SUBOPT_0x36
; 0000 0051     }
; 0000 0052 
; 0000 0053 }
_0x136:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer1 overflow interrupt service routine: overflow at 1ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0057 {
_timer1_ovf_isr:
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
; 0000 0058 // Reinitialize Timer1 value
; 0000 0059 TCNT1H=0xFC17 >> 8;
	RCALL SUBOPT_0x0
; 0000 005A TCNT1L=0xFC17 & 0xff;
; 0000 005B // Place your code here
; 0000 005C d_anod++;
	LDI  R26,LOW(_d_anod)
	LDI  R27,HIGH(_d_anod)
	RCALL SUBOPT_0x36
; 0000 005D dislay7seg();
	RCALL _dislay7seg
; 0000 005E 
; 0000 005F }
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
;// Declare your global variables here
;
;void main(void)
; 0000 0064 {
_main:
; 0000 0065 
; 0000 0066 // Input/Output Ports initialization
; 0000 0067 // Port B initialization
; 0000 0068 // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0069 // State7=T State6=T State5=1 State4=T State3=T State2=T State1=T State0=T
; 0000 006A PORTB=0x20;
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 006B DDRB=0x20;
	OUT  0x17,R30
; 0000 006C 
; 0000 006D // Port C initialization
; 0000 006E // Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 006F // State6=T State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 0070 PORTC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 0071 DDRC=0x3F;
	OUT  0x14,R30
; 0000 0072 
; 0000 0073 // Port D initialization
; 0000 0074 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0075 // State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 0076 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0077 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0078 
; 0000 0079 if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3;
	SBIC 0x16,1
	RJMP _0x14C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x16C
_0x14C:
	SBIC 0x16,2
	RJMP _0x14E
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x16C
_0x14E:
	RCALL SUBOPT_0x1F
_0x16C:
	STS  _d_type,R30
	STS  _d_type+1,R31
; 0000 007A 
; 0000 007B set_interupt01();
	RCALL _set_interupt01
; 0000 007C 
; 0000 007D while (1)
; 0000 007E       {
; 0000 007F       // Place your code here
; 0000 0080       if(kds_cv <=0) { kds_cv =0; calculate();}
	RCALL SUBOPT_0x39
	BRLT _0x153
	RCALL SUBOPT_0x3A
; 0000 0081 
; 0000 0082       while(1)
_0x153:
_0x154:
; 0000 0083         {
; 0000 0084         if(kds_cv <=0) { kds_cv =0; calculate();}
	RCALL SUBOPT_0x39
	BRLT _0x157
	RCALL SUBOPT_0x3A
; 0000 0085 
; 0000 0086         if(kds_cv >1)
_0x157:
	LDS  R26,_kds_cv
	LDS  R27,_kds_cv+1
	SBIW R26,2
	BRGE PC+2
	RJMP _0x158
; 0000 0087         {
; 0000 0088         while(f_cv ==1)
_0x159:
	SBRS R2,0
	RJMP _0x15B
; 0000 0089             {
; 0000 008A             if ((li_r ==0)|(li_g ==0))
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	RCALL SUBOPT_0x3B
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	RCALL SUBOPT_0x3B
	OR   R30,R0
	BREQ _0x15C
; 0000 008B                 {
; 0000 008C                 set_interupt01();
	RCALL _set_interupt01
; 0000 008D                 f_cv=0;
	CLT
	BLD  R2,0
; 0000 008E                 if (li_r ==0) d_type=1; else if (li_g ==0) d_type=2; else d_type=3;
	SBIC 0x16,1
	RJMP _0x15D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x16D
_0x15D:
	SBIC 0x16,2
	RJMP _0x15F
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x16D
_0x15F:
	RCALL SUBOPT_0x1F
_0x16D:
	STS  _d_type,R30
	STS  _d_type+1,R31
; 0000 008F                 }
; 0000 0090             }
_0x15C:
	RJMP _0x159
_0x15B:
; 0000 0091         for(i=0; i <2; i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x162:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,2
	BRGE _0x163
; 0000 0092         {
; 0000 0093         gree =0; yell =0; red =0;
	CLT
	BLD  R2,1
	BLD  R2,2
	BLD  R2,3
; 0000 0094         cou_r_pre =f_red;
	LDS  R30,_f_red
	LDS  R31,_f_red+1
	RCALL SUBOPT_0x25
; 0000 0095         cou_g_pre =f_gree;
	LDS  R30,_f_gree
	LDS  R31,_f_gree+1
	RCALL SUBOPT_0x2A
; 0000 0096         cou_y_pre =f_yell;
	LDS  R30,_f_yell
	LDS  R31,_f_yell+1
	RCALL SUBOPT_0x35
; 0000 0097         while ((gree ==0)&(yell ==0)&(red ==0))
_0x164:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RCALL SUBOPT_0x3B
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	RCALL SUBOPT_0x3B
	AND  R0,R30
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	RCALL SUBOPT_0x3B
	AND  R30,R0
	BREQ _0x166
; 0000 0098             {
; 0000 0099             if (d_type ==1) red =1;
	RCALL SUBOPT_0x18
	BRNE _0x167
	SET
	BLD  R2,3
; 0000 009A             if (d_type ==2)    gree =1;
_0x167:
	RCALL SUBOPT_0x27
	BRNE _0x168
	SET
	BLD  R2,1
; 0000 009B             if (d_type ==3) yell =1;
_0x168:
	RCALL SUBOPT_0x2B
	BRNE _0x169
	SET
	BLD  R2,2
; 0000 009C             calculate();
_0x169:
	RCALL _calculate
; 0000 009D             }
	RJMP _0x164
_0x166:
; 0000 009E         }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x36
	RJMP _0x162
_0x163:
; 0000 009F         kds_cv =0;
	LDI  R30,LOW(0)
	STS  _kds_cv,R30
	STS  _kds_cv+1,R30
; 0000 00A0         }
; 0000 00A1 
; 0000 00A2       }
_0x158:
	RJMP _0x154
; 0000 00A3     }
; 0000 00A4 
; 0000 00A5 }
_0x16A:
	RJMP _0x16A

	.DSEG
_d_type:
	.BYTE 0x2
_donvi:
	.BYTE 0x2
_chuc:
	.BYTE 0x2
_tram:
	.BYTE 0x2
_d_anod:
	.BYTE 0x2
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
_cou_lm:
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
	LDI  R30,LOW(252)
	OUT  0x2D,R30
	LDI  R30,LOW(23)
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
	CBI  0x15,2
	CBI  0x15,3
	CBI  0x15,1
	CBI  0x15,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x6:
	CBI  0x15,4
	CBI  0x15,0
	CBI  0x18,5
	LDI  R30,LOW(10)
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDS  R30,_d_type
	LDS  R31,_d_type+1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x8:
	LDS  R26,_d_anod
	LDS  R27,_d_anod+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _d_anod,R30
	STS  _d_anod+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x8
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	CBI  0x15,0
	CBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDS  R30,_donvi
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x8
	SBIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x8
	SBIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R30,_chuc
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x8
	SBIW R26,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0x8
	SBIW R26,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDS  R30,_tram
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x8
	SBIW R26,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	CBI  0x15,2
	CBI  0x15,4
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	CBI  0x15,1
	CBI  0x15,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CBI  0x15,3
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RJMP _seg_display

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDS  R26,_d_type
	LDS  R27,_d_type+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x19:
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
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	STS  _tram,R30
	STS  _tram+1,R31
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _chuc,R30
	STS  _chuc+1,R31
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STS  _donvi,R30
	STS  _donvi+1,R31
	LDS  R30,_chuc
	LDS  R31,_chuc+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1B:
	STS  _chuc,R30
	STS  _chuc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1C:
	LDS  R30,_tram
	LDS  R31,_tram+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x1A
	STS  _tram,R30
	STS  _tram+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDS  R26,_cou_1s
	LDS  R27,_cou_1s+1
	SBIW R26,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	STS  _d_type,R30
	STS  _d_type+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R26,_cou_r_pre
	LDS  R27,_cou_r_pre+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _chuc,R30
	STS  _chuc+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x1A
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	STS  _cou_r_pre,R30
	STS  _cou_r_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x1A
	STS  _donvi,R30
	STS  _donvi+1,R31
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	LDS  R26,_d_type
	LDS  R27,_d_type+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x28:
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
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	STS  _tram,R30
	STS  _tram+1,R31
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	SUB  R26,R30
	SBC  R27,R31
	RCALL SUBOPT_0x1A
	RCALL __DIVW21
	RCALL SUBOPT_0x1B
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	RCALL SUBOPT_0x1A
	RCALL __MODW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STS  _donvi,R30
	STS  _donvi+1,R31
	LDS  R30,_chuc
	LDS  R31,_chuc+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDS  R26,_cou_g_pre
	LDS  R27,_cou_g_pre+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	STS  _cou_g_pre,R30
	STS  _cou_g_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LDS  R26,_d_type
	LDS  R27,_d_type+1
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	STS  _cou_1s,R30
	STS  _cou_1s+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_cou_y_pre)
	LDI  R27,HIGH(_cou_y_pre)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_cou_y_pre
	LDS  R27,_cou_y_pre+1
	RCALL SUBOPT_0x1A
	RCALL __MODW21
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STS  _donvi,R30
	STS  _donvi+1,R31
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDS  R26,_cou_y
	LDS  R27,_cou_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _cou_r,R30
	STS  _cou_r+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	STS  _cou_g,R30
	STS  _cou_g+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(0)
	STS  _cou_y,R30
	STS  _cou_y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	STS  _cou_dr,R30
	STS  _cou_dr+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(0)
	STS  _cou_dg,R30
	STS  _cou_dg+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	STS  _cou_dy,R30
	STS  _cou_dy+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	STS  _cou_y_pre,R30
	STS  _cou_y_pre+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x36:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x20
	LDS  R26,_kds_cv
	LDS  R27,_kds_cv+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	LDS  R26,_kds_cv
	LDS  R27,_kds_cv+1
	RCALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(0)
	STS  _kds_cv,R30
	STS  _kds_cv+1,R30
	RJMP _calculate

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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
