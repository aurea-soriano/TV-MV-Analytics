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
public class Hegarty2001Sigma implements Categorization {

    String description = 
            "1     |  &#963;&#966; >= 0.6               |    high\n"
            + "    2     |  0.3<= &#963;&#966; < 0.6       |    medium\n"
            + "    3     |  0.2 <= &#963;&#966; < 0.3      |    low\n"
            + "    4     |  &#963;&#966; < 0.2                 |   very low";

    @Override
    public double calculateLabel(double sigmaValue) {
        if (sigmaValue >= 0.6) {
            return 1.0;
        } else {
            if (0.3 <= sigmaValue && sigmaValue < 0.6) {
                return 2.0;
            } else {
                if (0.2 <= sigmaValue && sigmaValue < 0.3) {
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

    public static void main(String[] args) {
        Hegarty2001Sigma hegarty = new Hegarty2001Sigma();
        System.out.println(hegarty.getDescription());

    }
}
