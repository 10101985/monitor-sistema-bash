#!/bin/bash
FECHA=$(date '+%Y-%m-%d %H:%M:%S')
REPORTE="reporte_$(date '+%Y%m%d_%H%M%S').txt"
UMBRAL_CPU=80
UMBRAL_RAM=80
UMBRAL_DISCO=90
ROJO='\033[0;31m'
VERDE='\033[0;32m'
NC='\033[0m'
alerta() { echo -e "${ROJO}[ALERTA] $1${NC}"; echo "[ALERTA] $1" >> $REPORTE; }
ok() { echo -e "${VERDE}[OK] $1${NC}"; echo "[OK] $1" >> $REPORTE; }
echo "=========================================" | tee $REPORTE
echo "   REPORTE DE SISTEMA v2.0 - $FECHA" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE
echo "" | tee -a $REPORTE
echo "--- USO DE CPU ---" | tee -a $REPORTE
CPU_USO=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d',' -f1)
echo "Uso actual: ${CPU_USO}%" | tee -a $REPORTE
if (( $(echo "$CPU_USO > $UMBRAL_CPU" | bc -l) )); then
    alerta "CPU al ${CPU_USO}% - supera el umbral de ${UMBRAL_CPU}%"
else
    ok "CPU en ${CPU_USO}% - dentro del rango normal"
fi
echo "" | tee -a $REPORTE
echo "--- USO DE MEMORIA RAM ---" | tee -a $REPORTE
RAM_TOTAL=$(free | grep Mem | awk '{print $2}')
RAM_USADA=$(free | grep Mem | awk '{print $3}')
RAM_PCT=$(echo "scale=1; $RAM_USADA * 100 / $RAM_TOTAL" | bc)
free -h | tee -a $REPORTE
echo "Porcentaje usado: ${RAM_PCT}%" | tee -a $REPORTE
if (( $(echo "$RAM_PCT > $UMBRAL_RAM" | bc -l) )); then
    alerta "RAM al ${RAM_PCT}% - supera el umbral de ${UMBRAL_RAM}%"
else
    ok "RAM en ${RAM_PCT}% - dentro del rango normal"
fi
echo "" | tee -a $REPORTE
echo "--- USO DE DISCO ---" | tee -a $REPORTE
df -h | tee -a $REPORTE
DISCO_PCT=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
echo "Particion raiz: ${DISCO_PCT}%" | tee -a $REPORTE
if [ "$DISCO_PCT" -gt "$UMBRAL_DISCO" ]; then
    alerta "DISCO al ${DISCO_PCT}% - supera el umbral de ${UMBRAL_DISCO}%"
else
    ok "DISCO en ${DISCO_PCT}% - dentro del rango normal"
fi
echo "" | tee -a $REPORTE
echo "--- INTERFACES DE RED ---" | tee -a $REPORTE
ip addr show | grep -E "inet |link/" | tee -a $REPORTE
echo "" | tee -a $REPORTE
echo "--- TOP 5 PROCESOS MAS ACTIVOS ---" | tee -a $REPORTE
ps aux --sort=-%cpu | head -6 | tee -a $REPORTE
echo "" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE
echo "   Reporte guardado en: $REPORTE" | tee -a $REPORTE
echo "=========================================" | tee -a $REPORTE
