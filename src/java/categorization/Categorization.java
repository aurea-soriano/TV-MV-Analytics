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
public interface  Categorization {

    public double calculateLabel(double value);
    public String getDescription();
    public ArrayList<Double> getListClasses();

}


