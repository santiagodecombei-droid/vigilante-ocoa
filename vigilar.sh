#!/usr/bin/env bash
#
# Abre cada app y dice si está viva. Sale con 1 si alguna cayó.
#
# Las apps vienen en la variable VIGILAR (un secreto de GitHub, no del repo:
# el repo es público para no gastar los minutos de Actions de los privados).
# Una línea por app:   nombre|url|texto que la página sana tiene que mostrar
#
#     VIGILAR="$(cat apps.txt)" ./vigilar.sh
#
# Caída = no responde en 20 s, responde distinto de 200, no trae el texto
# esperado, o trae un error de PHP a la vista.

set -uo pipefail
cayo=0
while IFS='|' read -r nombre url texto; do
    [ -z "${nombre// }" ] && continue
    [ -n "${GITHUB_ACTIONS:-}" ] && echo "::add-mask::$url"
    pagina="$(mktemp)"
    codigo="$(curl -s -L --max-time 20 -o "$pagina" -w '%{http_code}' "$url" 2>/dev/null)"
    motivo=""
    if [ "$codigo" != "200" ]; then
        motivo="respondió $codigo"
    elif ! grep -qF "$texto" "$pagina"; then
        motivo="no muestra «$texto»"
    elif grep -qE 'Fatal error|Parse error|Uncaught|Warning</b>:' "$pagina"; then
        motivo="muestra un error de PHP"
    fi
    rm -f "$pagina"
    if [ -n "$motivo" ]; then
        echo "✗ $nombre: CAÍDA — $motivo"
        cayo=1
    else
        echo "✓ $nombre"
    fi
done <<< "${VIGILAR:?falta la variable VIGILAR}"
exit $cayo
