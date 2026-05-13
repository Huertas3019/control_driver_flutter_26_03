@echo off
REM Script para desplegar reglas de Firestore en Windows

echo Instalando firebase-tools...
npm install -g firebase-tools

echo.
echo Haciendo login en Firebase (si no has hecho login)...
firebase login

echo.
echo Inicializando Firebase (si no esta inicializado)...
firebase init firestore

echo.
echo Desplegando reglas de Firestore...
firebase deploy --only firestore:rules

echo.
echo Listo!
pause
