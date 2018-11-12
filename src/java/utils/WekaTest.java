/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;

/**
 *
 * @author aurea
 */
public class WekaTest {

    public static void main(String[] args) throws Exception {
        FastVector atts;
        FastVector attVals;
        Instances data;
        double[] vals;
        int i;

        // 1. set up attributes
        atts = new FastVector();
        // - numeric
        atts.addElement(new Attribute("att1"));
        // - nominal
        attVals = new FastVector();
        for (i = 0; i < 3; i++) {
            double val= (i + 1)*1.0;
            attVals.addElement(String.valueOf(val));
        }
        atts.addElement(new Attribute("att2", attVals));
        // - string
        atts.addElement(new Attribute("att3", attVals));
       

        // 2. create Instances object
        data = new Instances("MyRelation", atts, 0);

        // 3. fill with data
        // first instance
        vals = new double[data.numAttributes()];
        // - numeric
        vals[0] = Math.PI;
        // - nominal
        vals[1] = attVals.indexOf("3.0");
        // - string
        vals[2] =  attVals.indexOf("2.0");
 
        
        // add
        data.add(new Instance(1.0, vals));

        // second instance
        vals = new double[data.numAttributes()];  // important: needs NEW array!
        // - numeric
        vals[0] = Math.E;
        // - nominal
        vals[1] = attVals.indexOf("1.0");
        // - string
        vals[2] =  attVals.indexOf("2.0");

       
        // add
        data.add(new Instance(1.0, vals));

        // 4. output data
        System.out.println(data);
    }
}
