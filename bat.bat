{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 @echo off\
rem This is a simple batch script to create a backup of a folder\
\
rem Define source and destination folders\
set source_folder=C:\\Path\\To\\Your\\Folder\
set destination_folder=D:\\Backup\\Folder\
\
rem Create destination folder if it doesn't exist\
if not exist "%destination_folder%" (\
    mkdir "%destination_folder%"\
)\
\
rem Copy contents of the source folder to the destination folder\
xcopy "%source_folder%\\*" "%destination_folder%\\" /E /C /H /R /Y\
\
echo Backup completed.\
pause\
}