#!/bin/sh
while getopts p:c:o: flag
do
    case "${flag}" in
        p) gps_sdr_sim_path=${OPTARG};;
        c) coordinates=${OPTARG};;
	o) output_file_name=${OPTARG};;
    esac
done

if [[ -z "$gps_sdr_sim_path" ]]
then
	echo "[!] Please define gps-sdr-sim binary path. (Example: -p '/users/admin/gps-sd-sim/gps-sdr-sim')"
	exit 1

elif [[ -z "$coordinates" ]]
then 
	echo "[!] Please define coordinates. (Example: -c '55.749105,37.534647')"
	exit 1

elif [[ -z "$output_file_name" ]]
then
        echo "[!] Please define output filename. (Example: -o 'MINSK')"
	exit 1

else
	echo "########################################"
	echo "---"
	echo "GPS-SDR-PATH set to: $gps_sdr_sim_path";
	echo "SPOOF COORDINATES set to: $coordinates";
        echo "OUTPUT FILE NAME set to: $output_file_name";
	echo "---"
	echo "########################################"
fi

#gps_sdr_sim_path="/Users/p_slizh/Documents/tools/gps-sdr-sim"
#coordinates="55.749105,37.534647"


day=$(date +%j)
year=$(date +%Y)
yr=$(date +%y)
dir=$(pwd)
sample_rate="1250000"

echo ""
echo "########################################"
echo "Downloading NASA brdc data.."
if [ -s $dir/.netrc ]
   then
	curl -c /tmp/cookie --netrc-file $dir/.netrc -L -O "https://cddis.nasa.gov/archive/gnss/data/daily/$year""/brdc/brdc""$day""0.$yr""n.Z"
    echo "Uncompessing downlaoded brdc file.."
    uncompress -f "brdc""$day""0.$yr""n.Z" "brdc""$day""0.$yr""n"
    echo "file 'brdc""$day""0.$yr""n.Z' was downlaoded and uncompessed"
    echo "########################################"

else
   echo "[!] .netrc  file doesn't exists.. Exit."
   exit 1

fi

echo ""
echo "########################################"
echo "Generating Simulation data.."

if [ -s $gps_sdr_sim_path ]
   then
   echo "[+] gps-sdr-sim binary exists.. continue.."
   $gps_sdr_sim_path -b 8 -s $sample_rate -e "brdc""$day""0.$yr""n" -l $coordinates -o $output_file_name".C8"
   echo "sample_rate=1250000\ncenter_frequency=1575420000" > $output_file_name".TXT"

else
   echo "[!] gps-sdr-sim binary file doesn't exists.. Exit."
   exit 1
fi

if [ -s $output_file_name.C8 ] || [ -s $output_file_name.TXT ]
   then
   echo "[+] $output_file_name.C8, $output_file_name.TXT  were successful created."
else
   echo "[!] needed files does not created."
   exit 1
fi

echo "########################################"
echo ""

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "[!! DONE !!] Now, copy $output_file_name.C8, $output_file_name.TXT to the HackRF SD card. Folder - 'GPS'"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
