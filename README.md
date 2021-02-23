# SDO
Hospitalization data in Italy

resources:  

- http://www.salute.gov.it/portale/temi/p2_6.jsp?lingua=italiano&id=4362&area=ricoveriOspedalieri&menu=acc#:~:text=Gli%20ACC%20(aggregati%20clinici%20di,ed%20analisti%20di%20politica%20sanitaria.
- https://www.istat.it/it/files//2011/03/glossario1.pdf
- http://www.quotidianosanita.it/allegati/allegato9532784.pdf
- http://www.quadernidellasalute.it/portale/temi/p2_6.jsp?lingua=italiano&id=1349&area=ricoveriOspedalieri&menu=vuoto
- https://www.trovanorme.salute.gov.it/norme/renderPdf.spring?seriegu=SG&datagu=28/01/2013&redaz=13A00528&artp=1&art=1&subart=1&subart1=10&vers=1&prog=001


objective n1: 

we analyze first the task "Acuti in regime ordinario" 
for each SDO excel file:  

    1- select only sheet related to the task (2.2.6)
    2- read sheets from row 4  
    3- discard empty rows in column B  
    4- rename columns A and B  
    5- transform MDC class as new column group  
    6- create new column with name task
    7- create a tibble

for each SDO excel file:

    1- create a test to check data collected in R and overall summary in 2.2.5
    
for each SDO excel file:

    1- enrich data collected in R from 2.2.6 with data in 2.2.7
    

objective n2:
repeat the algo in n1 for all type of tasks remaining:  

    1- Acuti in regime diurno (2.2.12: 2.2.12(17)) and for test 2.2.11
    2- Riabilitazione  2.3.6 and 2.3.7
    3- Lungodegenze 2.3.8
    
objective n3:
read tables of hospedalization rates (5.1, 5.10:5.21)
read italian population table
try to match rates from SDO with rates calculated

objective n4:
read distribution by age and gender (6.7:11)
read discharge by regions 8.1pie:8.1sar


