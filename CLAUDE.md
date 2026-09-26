# vigilante

Para qué: avisarle a Santiago por correo si Ecommerce, Dashboard o Calendario se caen.
Para quién: Santiago (el correo le llega de GitHub); lo mantiene Claude.

## Cómo funciona
- `.github/workflows/vigilar.yml` corre en GitHub cada 15 minutos (no depende del Mac)
  y ejecuta `vigilar.sh`, que abre cada app y revisa: responde 200, muestra su
  pantalla de entrada y no trae un error de PHP.
- El aviso es el correo automático de GitHub cuando una corrida falla: uno al caer y
  uno por hora mientras siga caída (las demás corridas se cancelan solas, en gris).
- Las direcciones de las apps viven en el secreto `VIGILAR` del repo, NO en el código:
  el repo es público (así los minutos de Actions son gratis y no se come los de los
  repos privados, que desplegan). Nada con datos, claves ni direcciones va al repo.
  Formato del secreto, una línea por app: `nombre|url|texto que muestra sana`.
- Si el repo lleva 30 días sin commits, deja uno de latido: GitHub apaga los horarios de un repo
  público tras 60 días quieto.

## Probar
- Local: `VIGILAR='Prueba|https://…|texto' bash vigilar.sh` (sale 1 si alguna cae).
- Caída simulada: Actions → «Vigilar las apps» → Run workflow → marcar «simular caída».
  Tiene que salir en rojo y llegar el correo.

## Reglas
- Agregar o cambiar una app = cambiar el secreto (`gh secret set VIGILAR -R
  santiagodecombei-droid/vigilante-ocoa < archivo`), no el código.
- Si llega el correo: abrir la app; si está caída, volver a la versión anterior como
  dice el CLAUDE.md del proyecto (sección «Volver atrás»).
