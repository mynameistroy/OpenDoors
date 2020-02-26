#  OpenDoors 6.23
#  (C} Copyright 1991 - 1997 by Brian Pirie. All Rights Reserved.
#
#  Oct-2001 door32.sys/socket modifications by Rob Swindell (www.synchro.net}
#
#
#         File: Win32.mak
#
#  Description: Makefile used to build the Win32 OpenDoors libraries from
#               the sources. Usage is described below.
#
#    Revisions: Date          Ver   Who  Change
#               ---------------------------------------------------------------
#               Aug 09, 2003  6.23  SH   *nix port
#
###############################################################################
#
# USAGE INFORMATION
#
###############################################################################
#
# Command Line:   make -fWin32.mak
#                     or
#                 nmake /f Win32.mak
#
###############################################################################
#
# CONFIGURATION
#
# Customize this section of the makefile to provide the relevant information
# for your compiler, assembler (if any} and build environment.
#
###############################################################################
# Compiler executable file name. Use:
#
#                  tcc - For Borland Turbo C and Turbo C++
#                  bcc - For Borland C++
#                   cl - For Microsoft compilers
#
CC	:=	gcc
#
#------------------------------------------------------------------------------
#
# Linker executable file name. Use:
#
#                tlink - For Borland compilers
#                 link - For Microsoft compilers
#
# Get OS name
OS      :=      dos
# os	:=	$(shell echo $(OS) | tr '[A-Z]' '[a-z]' | tr ' ' '_')
OBJDIR	:=	objs-$(OS)
LIBDIR	:=	libs-$(OS)
EXEDIR	:=	exe-$(OS)

LD	:=	gcc

ifdef DEBUG
 CFLAGS	+=	-g -DOD_DEBUG
 BUILDTYPE	:=	debug
else
 BUILDTYPE	:=	release
endif
#
#------------------------------------------------------------------------------
#
# Compiler command-line flags.
#
CFLAGS	+= -DHAS_INTTYPES_H -fomit-frame-pointer
LDFLAGS	+=	
CFLAGS	+=	-O2 -L${LIBDIR} -I../xpdev -Wall -Wno-unused-variable -Wno-unused-label \
			-Wno-unused-but-set-variable
ifeq ($(OS),Darwin)
 CFLAGS		+=	-D__unix__
 LDFLAGS	+=	$(CFLAGS) -dynamiclib -single_module
else
 LDFLAGS	+=	$(CFLAGS) -shared
endif

# /MTd /Zi - for debug
#
#------------------------------------------------------------------------------
#
# Link flags.
#
LDFLAGS	+=	-L../xpdev/$(LD).$(os).lib.$(BUILDTYPE)
#
#------------------------------------------------------------------------------
#
# Output directories. customize for your own preferences. Note that trailing
# backslash (\} characters are required.
#
SHLIB		:=	.so
STATICLIB	:=	.a
OBJFILE 	:=	.o
ifdef PROFILE
	CFLAGS	+=	-pg
	SHLIB	:=	_p${SHLIB}
	STATICLIB	:=	_p.a
endif
#
###############################################################################
#
# DEPENDENCIES
#
# You won't normally have to change anything after this point in this makefile.
#
###############################################################################
#
# Define primary target.
#
#all: ${OBJDIR} ${LIBDIR} $(EXEDIR) ${LIBDIR}/libODoors${SHLIB} \
all: dirs  

dirs: $(LIBDIR) $(EXEDIR) $(OBJDIR) ${LIBDIR}/libODoors${STATICLIB} \
	$(EXEDIR)/ex_chat.exe $(EXEDIR)/ex_diag.exe $(EXEDIR)/ex_hello.exe $(EXEDIR)/ex_music.exe
#
#------------------------------------------------------------------------------
#
# Name of all headers.
#
HEADERS= ${HEADERDIR}/ODCom.h\
         ${HEADERDIR}/ODCore.h\
         ${HEADERDIR}/ODGen.h\
         ${HEADERDIR}/ODInEx.h\
         ${HEADERDIR}/ODInQue.h\
         ${HEADERDIR}/ODKrnl.h\
         ${HEADERDIR}/ODPlat.h\
         ${HEADERDIR}/ODRes.h\
         ${HEADERDIR}/ODScrn.h\
         ${HEADERDIR}/ODStat.h\
         ${HEADERDIR}/ODSwap.h\
         ${HEADERDIR}/ODTypes.h\
         ${HEADERDIR}/ODUtil.h\
         ${HEADERDIR}/OpenDoor.h
#
#------------------------------------------------------------------------------
#
# Build DLL from objects.
#
OBJECTS := ${OBJDIR}/ODAuto${OBJFILE}\
         ${OBJDIR}/ODBlock${OBJFILE}\
         ${OBJDIR}/ODCFile${OBJFILE}\
         ${OBJDIR}/ODCmdLn${OBJFILE}\
         ${OBJDIR}/ODCom${OBJFILE}\
         ${OBJDIR}/ODCore${OBJFILE}\
         ${OBJDIR}/ODDrBox${OBJFILE}\
         ${OBJDIR}/ODEdit${OBJFILE}\
         ${OBJDIR}/ODEdStr${OBJFILE}\
         ${OBJDIR}/ODEmu${OBJFILE}\
         ${OBJDIR}/ODGetIn${OBJFILE}\
         ${OBJDIR}/ODGraph${OBJFILE}\
         ${OBJDIR}/ODInEx1${OBJFILE}\
         ${OBJDIR}/ODInEx2${OBJFILE}\
         ${OBJDIR}/ODInQue${OBJFILE}\
         ${OBJDIR}/ODKrnl${OBJFILE}\
         ${OBJDIR}/ODList${OBJFILE}\
         ${OBJDIR}/ODLog${OBJFILE}\
         ${OBJDIR}/ODMulti${OBJFILE}\
         ${OBJDIR}/ODPlat${OBJFILE}\
         ${OBJDIR}/ODPCB${OBJFILE}\
         ${OBJDIR}/ODPopup${OBJFILE}\
         ${OBJDIR}/ODPrntf${OBJFILE}\
         ${OBJDIR}/ODRA${OBJFILE}\
         ${OBJDIR}/ODScrn${OBJFILE}\
         ${OBJDIR}/ODSpawn${OBJFILE}\
         ${OBJDIR}/ODStand${OBJFILE}\
         ${OBJDIR}/ODStat${OBJFILE}\
         ${OBJDIR}/ODStr${OBJFILE}\
         ${OBJDIR}/ODUtil${OBJFILE}\
         ${OBJDIR}/ODWCat${OBJFILE}\
	 ${OBJDIR}/ODWin${OBJFILE}
#         ${OBJDIR}ODoor.res
#         ${OBJDIR}odsys${OBJFILE}\	this file is missing

${OBJDIR}:
	echo $@
	mkdir ${OBJDIR}

${LIBDIR}:
	echo $@
	mkdir ${LIBDIR}

${EXEDIR}:
	echo $@
	mkdir ${EXEDIR}

$(OBJDIR)/%$(OBJFILE) : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

${LIBDIR}/libODoors${SHLIB} : ${OBJECTS}
	$(LD) $(LDFLAGS) -o ${LIBDIR}/libODoors${SHLIB}.6.2 ${OBJECTS}
	ln -fs libODoors${SHLIB}.6.2 ${LIBDIR}/libODoors${SHLIB}

${LIBDIR}/libODoors${STATICLIB} : ${OBJECTS} ${OBJDIR}
	ar -r ${LIBDIR}/libODoors${STATICLIB} ${OBJECTS}
	ranlib ${LIBDIR}/libODoors${STATICLIB}
	
${EXEDIR}/ex_chat.exe: ex_chat.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_chat.c -o $@ ${LIBDIR}/libODoors${STATICLIB}

${EXEDIR}/ex_diag.exe: ex_diag.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_diag.c -o $@ ${LIBDIR}/libODoors${STATICLIB}

${EXEDIR}/ex_hello.exe: ex_hello.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_hello.c -o $@ ${LIBDIR}/libODoors${STATICLIB}

${EXEDIR}/ex_music.exe: ex_music.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_music.c -o $@ ${LIBDIR}/libODoors${STATICLIB}

${EXEDIR}/ex_ski.exe: ex_ski.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_ski.c -o $@ ${LIBDIR}/libODoors${STATICLIB}

${EXEDIR}/ex_vote: ex_vote.c ${LIBDIR}/libODoors${STATICLIB}
	$(CC) $(CFLAGS) ex_vote.c ../xpdev/filewrap.c -o $@ -lODoors -DMULTINODE_AWARE
	
clean:
	rmdir /s /q ${OBJDIR}

distclean:
	rmdir /s /q ${OBJDIR} ${EXEDIR} ${LIBDIR}
#
#------------------------------------------------------------------------------
