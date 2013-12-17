//
//  config.h
//  MacBoard
//
//  Created by C.W. Betts on 12/17/13.
//  Copyright (c) 2013 GNU Software. All rights reserved.
//

#ifndef MacBoard_config_h
#define MacBoard_config_h

/* template */
#undef ATTENTION

/* template */
#undef DEFINED_SYS_ERRLIST

/* Define to 1 if translation of program messages to the user's native
 language is requested. */
#undef ENABLE_NLS

/* template */
#undef FIRST_PTY_LETTER

/* Define to 1 if you have the MacOS X function CFLocaleCopyCurrent in the
 CoreFoundation framework. */
#define HAVE_CFLOCALECOPYCURRENT 1

/* Define to 1 if you have the MacOS X function CFPreferencesCopyAppValue in
 the CoreFoundation framework. */
#define HAVE_CFPREFERENCESCOPYAPPVALUE 1

/* Define if the GNU dcgettext() function is already present or preinstalled.
 */
#undef HAVE_DCGETTEXT

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
 */
#define HAVE_DIRENT_H 1

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have the `ftime' function. */
#undef HAVE_FTIME

/* Define to 1 if you have the `gethostname' function. */
#define HAVE_GETHOSTNAME 1

/* Define if the GNU gettext() function is already present or preinstalled. */
#undef HAVE_GETTEXT

/* Define to 1 if you have the `gettimeofday' function. */
#define HAVE_GETTIMEOFDAY 1

/* Define to 1 if you have the `grantpt' function. */
#undef HAVE_GRANTPT

/* Define if you have the iconv() function and it works. */
#define HAVE_ICONV 1

/* Define to 1 if you have the <inttypes.h> header file. */
#undef HAVE_INTTYPES_H

/* Define to 1 if you have the <lan/socket.h> header file. */
#undef HAVE_LAN_SOCKET_H

/* Define to 1 if you have the `i' library (-li). */
#undef HAVE_LIBI

/* Define to 1 if you have the `seq' library (-lseq). */
#undef HAVE_LIBSEQ

/* template */
#undef HAVE_LIBXPM

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
#undef HAVE_NDIR_H

/* Define to 1 if you have the `rand48' function. */
#define HAVE_RAND48 1

/* Define to 1 if you have the `random' function. */
#define HAVE_RANDOM 1

/* Define to 1 if you have the `setitimer' function. */
#undef HAVE_SETITIMER

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#undef HAVE_STDLIB_H

/* Define to 1 if you have the <strings.h> header file. */
#undef HAVE_STRINGS_H

/* Define to 1 if you have the <string.h> header file. */
#undef HAVE_STRING_H

/* Define to 1 if you have the <stropts.h> header file. */
#undef HAVE_STROPTS_H

/* Define to 1 if you have the `sysinfo' function. */
#undef HAVE_SYSINFO

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
 */
#define HAVE_SYS_DIR_H 1

/* Define to 1 if you have the <sys/fcntl.h> header file. */
#define HAVE_SYS_FCNTL_H 1

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
 */
#undef HAVE_SYS_NDIR_H

/* Define to 1 if you have the <sys/socket.h> header file. */
#define HAVE_SYS_SOCKET_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/systeminfo.h> header file. */
#undef HAVE_SYS_SYSTEMINFO_H

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
#define HAVE_SYS_WAIT_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the `usleep' function. */
#define HAVE_USLEEP 1

/* Define to 1 if you have the <X11/xpm.h> header file. */
#undef HAVE_X11_XPM_H

/* Define to 1 if you have the `_getpty' function. */
#undef HAVE__GETPTY

/* template */
#undef IBMRTAIX

/* template */
#undef LAST_PTY_LETTER

/* Define to 1 if your C compiler doesn't accept -c and -o together. */
#undef NO_MINUS_C_MINUS_O

/* Name of package */
#define PACKAGE "MacBoard"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "computers57@hotmail.com"

/* Define to the full name of this package. */
#define PACKAGE_NAME "xboard"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "MacBoard 1.7.4"

/* Define to the one symbol short name of this package. */
#undef PACKAGE_TARNAME

/* Define to the home page for this package. */
#undef PACKAGE_URL

/* Define to the version of this package. */
#define PACKAGE_VERSION "1.7.4"

/* template */
#undef PTY_ITERATION

/* template */
#undef PTY_NAME_SPRINTF

/* template */
#undef PTY_OPEN

/* template */
#undef PTY_TTY_NAME_SPRINTF

/* template */
#undef REMOTE_SHELL

/* Define as the return type of signal handlers (`int' or `void'). */
#define RETSIGTYPE void

/* template */
#undef RTU

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
#define TIME_WITH_SYS_TIME 1

/* template */
#undef UNIPLUS

/* template */
#undef USE_PTYS

/* Define if you want to use Xaw3d */
#undef USE_XAW3D

/* Version number of package */
#undef VERSION

/* Define to 1 if the X Window System is missing or not being used. */
#define X_DISPLAY_MISSING 1

/* template */
#undef X_LOCALE

/* template */
#undef X_WCHAR

/* should zippy be enabled */
#undef ZIPPY
#endif
