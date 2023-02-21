# Replication instructions



## Using pre-nudges to super charge a nudge

By [Tabaré Capitán](http://tabarecapitan.com), Linda Thunström, Klaas van ‘t Veld, Jonas Nordström, and Jason Shogren_

### Instructions ###

-	To replicate the experiment, you can find our experimental instructions in the folder experimental instructions. For each experiment, lab and online, we have included both a PDF with the instructions and a Qualtrics file (.QSF). Do note that the lab experiment was divided into two surveys.
-	To replicate the analysis using our experimental data, it is only necessary to run the file run.do. This file will create the necessary folders for results and intermediate outputs. Before running this file, you should change the global macro `RUTA`, in line 25, to point to the directory containing this `README` file in your computer. 
-	The file `run.do` calls `code/main.do`, which calls the necessary files for data management and analyses. 
-	The raw data for the analysis is contained in the folder `rawData`, which contains one folder for the lab experiment and one folder for the online experiment. The folder from the laboratory experiment contains two .CSV files with the answers from the two Qualtrics surveys that compose the experiment and one .XLSX with data on body and leftover weights. The folder from the online experiment contains one .CSV file from the Qualtrics survey.

### Software requirements
Stata version 14.2 or higher. Add-on packages are included in `code/libraries/stata` and do not need to be installed. The names, installation sources, and installation dates of these packages are available in `code/libraries/stata/stata.trk`.
For the results shown in the paper, we ran the master script on **XXX**. The analysis required minimal memory and processing resources. It was last run on a Windows 10 Desktop with 16 gigabytes of RAM and an i7-6600 CPU 2.60 GHz processor. The runtime was **XXXX**.

### License
The data are licensed under a Creative Commons Attribution 4.0 International Public License. The code is licensed under a Modified BSD License. See LICENSE.txt for details.

### Data availability statement
We certify that the authors of the manuscript have legitimate access and permission to use the data employed in this manuscript.

### Citation
This paper is not yet published.
