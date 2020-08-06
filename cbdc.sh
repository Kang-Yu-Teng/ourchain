#!/bin/bash

shopt -s expand_aliases

target="./example/cbdc_contract.c"
alias b1="bitcoin-cli -datadir=1"
address=`b1 getnewaddress`

echo \
"
#include <ourcontract.h>
#include <stdlib.h>

int contract_main(int argc, char **argv)
{
	if(argc == 2){
		if(send_money(\"$address\",amount_from_string(argv[1]))!=0){
			err_printf(\"%s : send_money error\n\", argv[0]);
			exit(0);
		}
	
		err_printf(\"%s: create %lld coins\n\", argv[0], amount_from_string(argv[1])/COIN);
	}
	else
		err_printf(\"%s : too many or too few argument \n\",argv[0]);
		
	return 0;
}" \
> ${target}

b1 generate 1
b1 getbalance
sleep 2
s=`b1 deploycontract ${target}`
b1 getbalance
echo $s
s=${s##*:}
s=`echo ${s:2:64}`
b1 sendtocontract ${s} 20999999
sleep 2
b1 generate 1
rm ${target}

b1 callcontract ${s} 20000
sleep 2
b1 generate 1
