dnl   configuration script for Guile-SSH
dnl   Process this file with autoconf to produce configure.
dnl

define(GUILE_SSH_CONFIGURE_COPYRIGHT, [[
Copyright (C) 2013, 2014, 2015, 2016, 2017, 2018 Artyom V. Poptsov <poptsov.artyom@gmail.com>

This file is part of Guile-SSH.

Guile-SSH is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Guile-SSH is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with Guile-SSH.  If not, see <http://www.gnu.org/licenses/>.
]])

AC_INIT([Guile-SSH], [0.12.0], [poptsov.artyom@gmail.com],
                     [guile-ssh],
                     [https://github.com/artyom-poptsov/guile-ssh])

AC_COPYRIGHT(GUILE_SSH_CONFIGURE_COPYRIGHT)

AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADER([libguile-ssh/config.h])

AM_INIT_AUTOMAKE([color-tests])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])], [AC_SUBST([AM_DEFAULT_VERBOSITY],1)])

AC_PROG_CC

if test "x$GCC" = "xyes"; then
  # Use compiler warnings.
  WARN_CFLAGS="-Wall"
else
  WARN_CFLAGS=""
fi
AC_SUBST([WARN_CFLAGS])

AC_ARG_WITH([guilesitedir],
            [AS_HELP_STRING([--with-guilesitedir],
                            [use the specified installation path for Guile modules])],
            [case "x$withval" in
             xyes|xno) guilesitedir="";;
             *)        guilesitedir="$withval";;
             esac],
             [guilesitedir=""])

# -------------------------------------------------------------------------------
# Check for needed libraries
# -------------------------------------------------------------------------------

PKG_CHECK_MODULES([LIBSSH], [libssh >= 0.6.4])
PKG_CHECK_MODULES([LIBSSH_0_7_3], [libssh >= 0.7.3],
                                [AC_DEFINE(HAVE_LIBSSH_0_7_3, 1, [Use libssh 0.7.3])],
                                [AC_WARN([
  Using a potentially vulnerable version of libssh
  <https://www.libssh.org/2016/02/23/libssh-0-7-3-security-and-bugfix-release/>])])

dnl Checking for libssh 0.8.x
PKG_CHECK_MODULES([LIBSSH_0_8], [libssh >= 0.8.0],
                                [AC_DEFINE(HAVE_LIBSSH_0_8, 1, [Use libssh 0.8])],
                                [AC_DEFINE(HAVE_LIBSSH_0_8, 0, [Use libssh < 0.8])])

AM_CONDITIONAL(HAVE_LIBSSH_0_8, $HAVE_LIBSSH_0_8)

PKG_CHECK_MODULES([LIBSSH_0_9], [libssh >= 0.9.0],
                                [AC_DEFINE(HAVE_LIBSSH_0_9, 1, [Use libssh 0.9])],
                                [AC_DEFINE(HAVE_LIBSSH_0_9, 0, [Use libssh < 0.9])])

AM_CONDITIONAL(HAVE_LIBSSH_0_9, $HAVE_LIBSSH_0_9)

# -------------------------------------------------------------------------------

dnl These macros must be provided by guile.m4.
m4_pattern_forbid([^GUILE_PKG$])
m4_pattern_forbid([^GUILE_PROGS$])

dnl Use this macro so that 'GUILE_EFFECTIVE_VERSION' is defined here.
dnl Try Guile 2.2, then Guile 2.0.
GUILE_PKG([2.2 2.0])

GUILE_PROGS
GUILE_FLAGS
GUILE_SITE_DIR

LT_INIT()

if test "x$guilesitedir" = "x"; then
   guilesitedir="$datadir/guile/site/$GUILE_EFFECTIVE_VERSION"
fi
AC_SUBST([guilesitedir])

LIBGUILE_SSH_INTERFACE="11:0:0"
AC_SUBST(LIBGUILE_SSH_INTERFACE)

GUILE_EFFECTIVE_VERSION=`$GUILE -c '(display (effective-version))'`
AC_SUBST(GUILE_EFFECTIVE_VERSION)

AC_CONFIG_FILES([Makefile libguile-ssh/Makefile examples/Makefile build-aux/Makefile])
AC_CONFIG_FILES([m4/Makefile doc/Makefile tests/Makefile am/Makefile])
AC_CONFIG_FILES([modules/Makefile modules/ssh/Makefile modules/ssh/dist/Makefile])
AC_CONFIG_FILES([modules/srfi/Makefile])

AM_CONDITIONAL([CROSS_COMPILING], [test "x$cross_compiling" = "xyes"])

# Generate a Makefile, based on the results.
AC_OUTPUT

if test "$guilesitedir" != "$GUILE_SITE"; then
   # Guile has a different prefix than this module
   AC_MSG_WARN([]
   [The Guile modules will be installed in ${guilesitedir}.]
   [You should probably re-run `configure' with]
   [`--with-guilesitedir=$GUILE_SITE']
   [Otherwise, you will have to adjust the `GUILE_LOAD_PATH' environment]
   [variable.])
fi
