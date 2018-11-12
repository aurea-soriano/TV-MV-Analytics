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
public class Tiwari2011S4 implements Categorization {

    String description = 
            "1     |  S4 >= 1.0               |    high\n"
            + "    2     |  0.5 <= S4 < 1.0      |    medium\n"
            + "    3     |  S4 < 0.5                 |    low\n";
 
    @Override
    public double calculateLabel(double s4Value) {
        if (s4Value >= 1.0) {
            return 1.0;
        } else {
            if (0.5 <= s4Value && s4Value < 1.0) {
                return 2.0;
            } else {
                return 3.0;
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
