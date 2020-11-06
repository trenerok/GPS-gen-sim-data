Fast generating fake GPS data.
 
Auto download last RINEX navigation file for GPS ephemerides from 'https://cddis.nasa.gov/archive/gnss/data/daily' and generating simulation GPS data with GPS-SDR-SIM for using it with HackrfOne Portapack Mayhem.

How to use:
1) Register on site https://urs.earthdata.nasa.gov (for access to the NASA brdc files)
2) Put credentials to the '.netrc' file. (from first step). More info - https://cddis.nasa.gov/Data_and_Derived_Products/CreateNetrcFile.html
3) Go to the script folder. Run:
./gen_sim_data.sh -p '/Users/admin/tools/gps-sdr-sim/gps-sdr-sim' -c '62.393907,17.332739' -o 'MINSK'

where:
 -p  - path to your gps-sdr-sim binaty file.
 -c  - spoofed coordinates.
 -o  - result file name.


gps-sdr-sim - https://github.com/osqzss/gps-sdr-sim
portapack mayhem - https://github.com/eried/portapack-mayhem/wiki/GPS-Sim 