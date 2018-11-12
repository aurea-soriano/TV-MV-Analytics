/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataMaker;

import java.util.Comparator;

/**
 *
 * @author aurea
 */
public class TimeIntervalComparatorSource1 implements Comparator<TimeInterval> {

    @Override
    public int compare(TimeInterval t1, TimeInterval t2) {
        // Assume no nulls, and simple ordinal comparisons

        // Next by source1
        int source1 = t1.getValueSource().compareTo(t2.getValueSource());
        if (source1 != 0) {
            return source1;
        }

        // First by name Attribute - stop if this gives a result.
        int nameAttribute = t1.getNameAttribute().compareTo(t2.getNameAttribute());
        //if (nameAttribute != 0)
        //{
        return nameAttribute;
        //}

        // Finally by building
        // return t1.getBuilding().compareTo(t2.getBuilding());
    }
}
