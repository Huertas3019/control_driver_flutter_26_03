#!/bin/bash

# Script para desplegar reglas de Firestore

echo "Instalando firebase-tools..."
npm install -g firebase-tools

echo "Haciendo login en Firebase (si no has hecho login)..."
firebase login

echo "Inicializando Firebase (si no está inicializado)..."
firebase init firestore

echo "Desplegando reglas de Firestore..."
firebase deploy --only firestore:rules

echo "¡Listo!"
