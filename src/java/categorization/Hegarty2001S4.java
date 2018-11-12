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
public class Hegarty2001S4 implements Categorization {

    String description = 
            "1     |  S4 >= 0.9               |    high\n"
            + "    2     |  0.6 <= S4 < 0.9      |    medium\n"
            + "    3     |  0.4 <= S4 < 0.6      |    low\n"
            + "    4     |  S4 < 0.4                 |    very low";

    @Override
    public double calculateLabel(double s4Value) {
        if (s4Value >= 0.9) {
            return 1.0;
        } else {
            if (0.6 <= s4Value && s4Value < 0.9) {
                return 2.0;
            } else {
                if (0.4 <= s4Value && s4Value < 0.6) {
                    return 3.0;
                } else {
                    return 4.0;
                }
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
        listClasses.add(4.0);
        return listClasses;
    }

}
