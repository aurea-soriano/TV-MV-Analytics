/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package distance;

import matrix.pointsmatrix.AbstractVector;

/**
 *
 * @author LAURA
 */
public class HistogLog implements AbstractDissimilarity {
       
  public float calculate(AbstractVector v1, AbstractVector v2) {
    
        float [] q = v1.toArray();
        float [] d = v2.toArray();

        int sum=0;
        int nf = q.length;
        int qi, di;
        for(int i=0;i < nf;i++)
        {
            qi = (int) q[i];
            di = (int) d[i];
            sum= sum + (int)Math.abs( funcionLlog (qi) - funcionLlog (di));
        }
        return (float) sum;
    }

    double funcionLlog (int valor)
    {
        double result=0;
        if(valor==0)
        {
            result =0;
        }
        else
        {
            if((valor>0)&&(valor <=1))
            {
                result =1;
            }
            else
            {
                result = log2(valor);
                result= Math.ceil(result)+ 1;
            }
        }
        return result;
    }

    double log2(double num)
    {
        return (Math.log(num)/Math.log(2));
    }


  }


