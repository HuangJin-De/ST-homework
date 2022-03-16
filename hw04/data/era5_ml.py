import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-complete',
    {
    'date'    : '2022-03-03',            
    'levelist': '1',          
    'levtype' : 'ml',
    'param'   : '129',                   
                                        
    'stream'  : 'oper',                
    'time'    : '00',       
    'type'    : 'an',
    'area'    : '90/-180/-90/180',      
    'grid'    : '0.25/0.25',         
    'format'  : 'netcdf'
    },
    'hw04.nc')

