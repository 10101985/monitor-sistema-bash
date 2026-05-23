#!/bin/bash

# =========================================
# Monitor de Sistema - Cristian Robledo
# =========================================

FECHA=$(date '+%Y-%m-%d %H:%M:%S')
REPORTE="reporte_$(date '+%Y%m%d_%H%M%S').txt"

echo "=========================================" | tee $REPORTE
echo "   REPORTE DE SISTEMA - $FECHA" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE

# CPU
echo "" | tee -a $REPORTE
echo "--- USO DE CPU ---" | tee -a $REPORTE
top -bn1 | grep "Cpu(s)" | tee -a $REPORTE

# RAM
echo "" | tee -a $REPORTE
echo "--- USO DE MEMORIA RAM ---" | tee -a $REPORTE
free -h | tee -a $REPORTE

# DISCO
echo "" | tee -a $REPORTE
echo "--- USO DE DISCO ---" | tee -a $REPORTE
df -h | tee -a $REPORTE

# RED
echo "" | tee -a $REPORTE
echo "--- INTERFACES DE RED ---" | tee -a $REPORTE
ip addr show | grep -E "inet |link/" | tee -a $REPORTE

# PROCESOS
echo "" | tee -a $REPORTE
echo "--- TOP 5 PROCESOS MAS ACTIVOS ---" | tee -a $REPORTE
ps aux --sort=-%cpu | head -6 | tee -a $REPORTE

echo "" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE
echo "   Reporte guardado en: $REPORTE" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE

