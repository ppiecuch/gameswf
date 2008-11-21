#!/bin/bash

# Simple build script to bootstrap a build of dmb.exe

sysname=`uname`

# Windows:
if echo "$sysname" | grep -q 'CYGWIN' ; then
  mkdir -p dmb_out/bootstrap
  cd dmb_out/bootstrap

  # Make lib_json.lib
  cl -c -GX ../../jsoncpp/src/lib_json/*.cpp -I../../jsoncpp/include
  lib /OUT:lib_json.lib json_reader.obj json_value.obj json_writer.obj

  # Make dmb.exe
  cl -Fedmb.exe \
    ../../config.cpp \
    ../../context.cpp \
    ../../dumbuild.cpp \
    ../../exe_target.cpp \
    ../../object.cpp \
    ../../os.cpp \
    ../../res.cpp \
    ../../target.cpp \
    ../../util.cpp \
    -Zi -GX -I../../jsoncpp/include -link lib_json.lib -subsystem:console

  cd ../..

else
  # Non-windows.  Assume gcc is going to work.

  mkdir -p dmb_out/bootstrap
  cd dmb_out/bootstrap

  # Make lib_json.a
  gcc -c -g ../../jsoncpp/src/lib_json/*.cpp -I../../jsoncpp/include
  ar rc lib_json.a json_reader.o json_value.o json_writer.o

  # Make dmb executable
  gcc -o dmb \
    ../../config.cpp \
    ../../context.cpp \
    ../../dumbuild.cpp \
    ../../exe_target.cpp \
    ../../object.cpp \
    ../../os.cpp \
    ../../res.cpp \
    ../../target.cpp \
    ../../util.cpp \
    -g -I../../jsoncpp/include lib_json.a -lstdc++

fi