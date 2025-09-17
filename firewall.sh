#!/bin/bash

echo "Reseteando configuración de UFW..."
ufw reset

echo "Estableciendo política por defecto restrictiva..."
ufw default deny incoming
ufw default allow outgoing

# ---------------------------------------------------------------------
# 1. Reglas para conexiones desde el host anfitrión
# ---------------------------------------------------------------------
# SFTP/SSH (TCP 22)
ufw allow from 10.11.0.52 to any port 22 proto tcp
# SMB (TCP 139 y 445)
ufw allow from 10.11.0.52 to any port 139 proto tcp
ufw allow from 10.11.0.52 to any port 445 proto tcp
# SNMP (UDP 161)
ufw allow from 10.11.0.52 to any port 161 proto udp
# Rango de puertos 31010-31110 solo TCP
ufw allow from 10.11.0.52 to any port 31010:31110 proto tcp
# Rango de puertos 50505-50509 (TCP)
ufw allow from 10.11.0.52 to any port 50505:50509 proto tcp

# ---------------------------------------------------------------------
# 2. Reglas para la IP especial 172.16.2.201
# ---------------------------------------------------------------------
# Puerto 4444 solo UDP
ufw allow from 172.16.2.201 to any port 4444 proto udp
# SMB (139 y 445)
ufw allow from 172.16.2.201 to any port 139 proto tcp
ufw allow from 172.16.2.201 to any port 445 proto tcp
# RDP (3389)
ufw allow from 172.16.2.201 to any port 3389 proto tcp

# ---------------------------------------------------------------------
# 3. Puertos públicos de correo (no seguros)
# ---------------------------------------------------------------------
# SMTP (25), IMAP (143), POP3 (110)
ufw allow 25/tcp
ufw allow 143/tcp
ufw allow 110/tcp

# ---------------------------------------------------------------------
# 4. MySQL/MariaDB desde la subred
# ---------------------------------------------------------------------
ufw allow from 10.11.0.0 to any port 3306 proto tcp

# ---------------------------------------------------------------------
# Activar UFW y mostrar reglas
# ---------------------------------------------------------------------
echo "Activando UFW..."
ufw enable

echo
echo "Reglas aplicadas:"
ufw status verbose
