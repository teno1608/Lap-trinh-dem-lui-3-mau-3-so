

// Define seg a >>> g PORTD

int seg_array[11]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x00};

void seg_display(char var7seg)
    {
    switch (var7seg)
        {
        case 0: PORTD=seg_array[0];
                break;
        case 1: PORTD=seg_array[1];
                break;
        case 2: PORTD=seg_array[2];
                break;
        case 3: PORTD=seg_array[3];
                break;
        case 4: PORTD=seg_array[4];
                break;
        case 5: PORTD=seg_array[5];
                break;
        case 6: PORTD=seg_array[6];
                break;
        case 7: PORTD=seg_array[7];
                break;
        case 8: PORTD=seg_array[8];
                break;
        case 9: PORTD=seg_array[9];
                break;
        case 10: PORTD=seg_array[10];
                break; 
        }        
	}                  

void dislay7seg()
    { 
    ledvdv=1; 
    ledxdv=1; ledxch=1; ledxtr=1;
    ledddv = 1; leddch = 1; leddtr = 1;
    seg_display(10);

    switch (d_type)
        {
        case 1: 
        {
        if (d_anod > 9) d_anod=1;
        if (d_anod <= 2)
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 0;
            leddch = 1;
            leddtr = 1;
            seg_display(donvi);            
            }
        if ((d_anod > 2)&&(d_anod <= 3))
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 1;
            leddch = 1;
            leddtr = 1;
            seg_display(10);                                        
            }
        if ((d_anod > 3)&&(d_anod <= 5))
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 1;
            leddch = 0;
            leddtr = 1;
            seg_display(chuc);    
            }
        if ((d_anod > 5)&&(d_anod <= 6))
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 1;
            leddch = 1;
            leddtr = 1;
            seg_display(10);                                        
            }
        if ((d_anod > 6)&&(d_anod <= 8))
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 1;
            leddch = 1;
            leddtr = 0;
            seg_display(tram);    
            }
        if ((d_anod > 8)&&(d_anod <= 9))
            {
            ledvdv=1; ledxdv=1; ledxch=1; ledxtr=1;
            ledddv = 1;
            leddch = 1;
            leddtr = 1;
            seg_display(10);                                        
            }       
        break;
        }
        case 2: 
        {
        if (d_anod > 9) d_anod=1;
        if (d_anod <= 2)
            {
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=0; 
            ledxch=1;
            ledxtr=1;
            seg_display(donvi);            
            }
        if ((d_anod > 2)&&(d_anod <= 3))
            { 
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=1; 
            ledxch=1;
            ledxtr=1;
            seg_display(10);
            }
        if ((d_anod > 3)&&(d_anod <= 5))
            {
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=1; 
            ledxch=0;
            ledxtr=1;
            seg_display(chuc);    
            }
        if ((d_anod > 5)&&(d_anod <= 6))
            { 
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=1; 
            ledxch=1;
            ledxtr=1;
            seg_display(10);
            }
        if ((d_anod > 6)&&(d_anod <= 8))
            { 
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=1; 
            ledxch=1;
            ledxtr=0;
            seg_display(tram);
            }
        if ((d_anod > 8)&&(d_anod <= 9))
            { 
            ledvdv=1; ledddv = 1; leddch = 1; leddtr = 1;
            ledxdv=1; 
            ledxch=1;
            ledxtr=1;
            seg_display(10);
            }       
        break;
        }
        case 3:
        {
        if (d_anod > 9) d_anod=1;
        if (d_anod <= 2)
            {
            ledddv = 1; leddch = 1; leddtr = 1; ledxdv=1; ledxch=1; ledxtr=1;
            ledvdv=0;
            seg_display(donvi);            
            }
        if ((d_anod > 2)&&(d_anod <= 9))
            {
            ledddv = 1; leddch = 1; leddtr = 1; ledxdv=1; ledxch=1; ledxtr=1;
            ledvdv=1;
            seg_display(10);
            }
        break;
        }
        }
    }