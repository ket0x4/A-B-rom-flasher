@echo off
title Cleaning..
@shift /0
mode con cols=52 lines=20
color 3f
if exist .\bin\payload_output\boot.img del .\bin\payload_output\boot.img
if exist .\bin\payload_output\vendor.img del .\bin\payload_output\vendor.img
if exist .\bin\payload_output\system.img del .\bin\payload_output\system.img
if exist .\bin\payload_input\payload.bin del .\bin\payload_input\payload.bin
if exist .\sources\system.img del .\sources\system.img
if exist .\sources\vendor.img del .\sources\vendor.img
if exist .\sources\boot.img del .\sources\boot.img
if exist .\payload.bin del .\payload.bin