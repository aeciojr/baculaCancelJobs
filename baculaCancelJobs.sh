#!/bin/bash
 
_Menu(){
   clear
   echo '
  Escolha....
 
  1. Cancelar job Waiting Incremental
  2. Cancelar job Waiting Differential
  3. Cancelar job Waiting Full
  4. Cancelar job Running Incremental
  5. Cancelar job Ruuning Differential
  6. Cancelar job Running Full
  7. Sair ( Crtl+C );
'
}
 
_Cancela(){
   local Status=$1
   local Level=$2
   local jobIds=`echo 'status dir running' | bconsole | fgrep "$Status" | fgrep "$Level" |  awk '{print $1}'`
 
   echo -e "\n\n Confirma o cancelamento dos jobs Status=$Status e Level=$Level (yes/no)?"
   read Confirmacao
   while :
   do
      if [ "$Confirmacao" == "yes" -o "$Confirmacao" == "no" ]; then
         break
      else
         echo -e "\n\n Confirma o cancelamento dos jobs Status=$Status e Level=$Level (yes/no)?"
         read Confirmacao
      fi
   done
   if [ "$Confirmacao" == "yes" ]; then
      for i in $jobIds
      do
          if [ -z `echo "$i" | grep '^[0-9]\+$'` ]
          then
              echo "Error: job ID $i is not a number!"
          else
              echo "Killing Bacula job $i Status $Status Level $Level"
              echo "cancel jobid=$i" | bconsole
              #echo "cancel jobid=$i"
          fi
      done
   elif [ "$Confirmacao" == "no" ]; then
      echo -e "\n\n Cancelamento nao confirmado"
   fi
   echo -e "\n\nPressione [ enter ] p/ voltar ao menu"
   read
}
 
while :
do
   _Menu
   read Opcao
   case $Opcao in
      1) { _Cancela 'is waiting' 'Incr'; } ;;
      2) { _Cancela 'is waiting' 'Diff'; } ;;
      3) { _Cancela 'is waiting' 'Full'; } ;;
      4) { _Cancela 'is running' 'Incr'; } ;;
      5) { _Cancela 'is running' 'Diff'; } ;;
      6) { _Cancela 'is running' 'Full'; } ;;
      7) { exit;  } ;;
      *) { _Menu; } ;;
   esac
done
