

void calculate()
    {                    
          if (d_type ==1) 
            { 
            cou_1s=0;
            cou_r_pre--;
            donvi = cou_r_pre&0xf;
            chuc  = (cou_r_pre/10)&0xf;
            tram  = (cou_r_pre/100)&0xf;
            if (chuc == 0) chuc=10;
            if (tram == 0) tram=10;
            while(d_type ==1)
                {
                if (cou_1s >=40)                 
                    { 
                    if ((li_r ==1)&&(li_g ==1)) d_type=3;
                    cou_1s =0;
                    cou_r_pre--; 
                    donvi = cou_r_pre&0xf;
                    chuc  = (cou_r_pre/10)&0xf;
                    tram  = (cou_r_pre/100)&0xf;
                    if (chuc == 0) chuc=10;
                    if (tram == 0) chuc=10;
                    if (cou_r_pre <=-1) 
                        {
                        cou_r_pre =-1;
                        donvi=10;
                        chuc=10;
                        tram=10;
                        }
                    }
                }
            }
 /////////////////////////////////////////////////////////////////////
        if (d_type ==2)
            {
            cou_1s=0;
            cou_g_pre--;
            donvi = cou_g_pre&0xf;
            chuc  = (cou_g_pre/10)&0xf;
            tram  = (cou_g_pre/100)&0xf;
            if (chuc == 0) chuc=10;
            if (tram == 0) tram=10;
            while(d_type ==2)
                {
                if (cou_1s >=40) 
                    { 
                    cou_1s =0;
                    cou_g_pre--; 
                    donvi = cou_g_pre&0xf;
                    chuc  = (cou_g_pre/10)&0xf;
                    tram  = (cou_g_pre/100)&0xf;
                    if (chuc == 0) chuc=10;
                    if (tram == 0) tram=10;
                    if (cou_g_pre <=-1) 
                        {
                        cou_g_pre =-1;
                        donvi=10;
                        chuc=10;
                        tram=10;
                        }
                    }
                }
            }
 /////////////////////////////////////////////////////////////////////
        if (d_type ==3)
            {
            cou_1s=0;
            cou_y_pre--;
            donvi = cou_y_pre&0xf;
            chuc=10; 
            tram=10;
            while(d_type ==3)
                {
                if (cou_y >440)
                    {
                    reset_interupt01();
                    cou_r =0; cou_g =0; cou_y =0;
                    cou_dr =0;
                    cou_dg =0;
                    cou_dy =0;
                    cou_1s=0;
                    d_type =0;
                    kds_cv =3; 
                    f_cv =1;  
                    }
                if (cou_1s >=39) 
                    { 
                    cou_1s =0;
                    cou_y_pre--; 
                    donvi = cou_y_pre&0xf;
                    chuc=10;
                    tram=10;
                    if (cou_y_pre <=-1) 
                        {
                        cou_y_pre =-1;
                        donvi=10;
                        chuc=10;
                        tram=10;
                        }
                    }
                }    
            }
    }