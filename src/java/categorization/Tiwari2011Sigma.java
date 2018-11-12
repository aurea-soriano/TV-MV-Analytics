/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package categorization;

import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class Tiwari2011Sigma implements Categorization {

    String description = 
              "1     |  &#963;&#966;>= 0.8               |    high\n"
            + "    2     |  0.4 <= &#963;&#966; < 0.8     |    medium\n"
            + "    3     |  &#963;&#966; < 0.4                |   low\n";

    @Override
    public double calculateLabel(double sigmaValue) {
        if (sigmaValue >= 0.8) {
            return 1.f;
        } else {
            if (0.4 <= sigmaValue && sigmaValue < 0.8) {
                return 2.f;
            } else {
                return 3.f;
            }
        }
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public ArrayList<Double> getListClasses() {
        ArrayList<Double> listClasses = new ArrayList<>();
        listClasses.add(1.0);
        listClasses.add(2.0);
        listClasses.add(3.0);
        return listClasses;
    }
}
