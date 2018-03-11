@echo off
docker run ^
      -it ^
      --rm ^
      --name "EvDev-Container" ^
      --hostname "EvDev-Container" ^
      --volume %cd%:/workdir ^
      --volume %HOMEDRIVE%%HOMEPATH%:/home/host ^
      ler0ever/evdev %*
