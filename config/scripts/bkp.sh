#!/bin/bash

# TODO : ajouter un paramètre -n (ou autre) pour permettre de creer une backup par dessus celle existante : test.bkp -> test.bkp.bkp ou test.bkp -> test.backup

if [[ -f $1.bkp && -f $1 ]] || [[ -d $1.bkp && -d $1 ]]
  then
  mv $1 $1.temp
  mv $1.bkp $1
  mv $1.temp $1.bkp
  echo "switched $1 and $1.bkp"

elif [[ -f $1 && ! -f $1.bkp ]] || [[ -d $1 && ! -d $1.bkp ]]
then
  mv $1 $1.bkp
  echo "created a backup of $1"

elif [[ -f $1.bkp && ! -f $1 ]] || [[ -d $1.bkp && ! -d $1 ]]
then
  mv $1.bkp $1
  echo "bringed back $1.bkp"
fi
