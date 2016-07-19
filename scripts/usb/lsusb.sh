#!/bin/sh

TFILE1="$PWD"/temp1.txt
TFILE2="$PWD"/temp2.txt
die="$PWD"

usb_list()
{
	ls /sys/bus/usb/devices/ > $TFILE2
	while read line;
	do
		cat /sys/bus/usb/devices/$line/uevent | grep "BUSNUM" 1>/dev/null
		if [ $? -eq 0 ];
		then
			BUS=$(cat /sys/bus/usb/devices/$line/uevent | grep "BUSNUM" | cut -d = -f2)
			DEV=$(cat /sys/bus/usb/devices/$line/uevent | grep "DEVNUM" | cut -d = -f2)
			VENDORID=$(cat /sys/bus/usb/devices/$line/idVendor) 2>/dev/null
			PRODUCTID=$(cat /sys/bus/usb/devices/$line/idProduct) 2>/dev/null
			if [ -f $die/usb.ids ];
			then
				TVENDOR=$(cat $die/usb.ids | grep "$VENDORID" | grep -v $'\t')
				if [ $? -eq 0 ];
				then
					VENDORNAME=$TVENDOR
				fi
				VENLINE=$(cat $die/usb.ids | grep -n "$VENDORID" | grep -v $'\t' | cut -d: -f1)
				VENLINE=$((VENLINE+1))
				P="p"
				VENVAR=$(sed -n "$VENLINE$P" $die/usb.ids | grep $'\t')
				while [ $? -eq 0 ];
				do
					PRODVAR=$(sed -n "$VENLINE$P" $die/usb.ids | grep $'\t' | cut -d ' ' -f1 | awk '{ print $1 }')
					if [[ "$PRODVAR" == "$PRODUCTID" ]];
					then
						PRODUCTNAME=$VENVAR
					fi
					VENLINE=$((VENLINE+1))
					VENVAR=$(sed -n "$VENLINE$P" "$die"/usb.ids | grep $'\t')
				done
			fi
			echo -e "Bus:$BUS\t Device:$DEV\t Vendor:$VENDORNAME\t  Product:$PRODUCTNAME" >> $TFILE1
			PRODUCTNAME=" "
		fi
	done < "$TFILE2"		

}

usb_list
