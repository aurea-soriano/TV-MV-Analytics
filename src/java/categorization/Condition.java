/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package categorization;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author aurea
 */
interface Operator {

    boolean compare(float a, float b);
}

public class Condition {

    String symbol1 = "";
    String value1 = "";
    String symbol2 = "";
    String value2 = "";
    String classValue = "";

    Map<String, Operator> operatorMap = new HashMap<String, Operator>();

    public Condition(String symbol1, String value1, String symbol2, String value2, String classValue) {
        this.symbol1 = symbol1;
        this.value1 = value1;
        this.symbol2 = symbol2;
        this.value2 = value2;
        this.classValue = classValue;

        operatorMap.put("greater", new Operator() {
            @Override
            public boolean compare(float a, float b) {
                return a > b;
            }
        });
        operatorMap.put("greaterequal", new Operator() {
            @Override
            public boolean compare(float a, float b) {
                return a >= b;
            }
        });
        operatorMap.put("less", new Operator() {
            @Override
            public boolean compare(float a, float b) {
                return a < b;
            }
        });
        operatorMap.put("lessequal", new Operator() {
            @Override
            public boolean compare(float a, float b) {
                return a <= b;
            }
        });
        operatorMap.put("equal", new Operator() {
            @Override
            public boolean compare(float a, float b) {
                return a == b;
            }
        });
    }

    public String getSymbol1() {
        return symbol1;
    }

    public void setSymbol1(String symbol1) {
        this.symbol1 = symbol1;
    }

    public String getValue1() {
        return value1;
    }

    public void setValue1(String value1) {
        this.value1 = value1;
    }

    public String getSymbol2() {
        return symbol2;
    }

    public void setSymbol2(String symbol2) {
        this.symbol2 = symbol2;
    }

    public String getValue2() {
        return value2;
    }

    public void setValue2(String value2) {
        this.value2 = value2;
    }

    public String getClassValue() {
        return classValue;
    }

    public void setClassValue(String classValue) {
        this.classValue = classValue;
    }

    public float calculateClass(Float value) {
        boolean test1 = true, test2 = true;
        //System.out.println(" sy1 "+symbol1+" "+" va1 "+value1+" "+" sy2 "+symbol2+" "+" va1 "+value2+" "+" val "+value);
        if (symbol1 != null && symbol1 != "" && value1 != null && value1 != "") {
            test1 = operatorMap.get(symbol1).compare(value, Float.valueOf(value1));
            if (symbol2 != null && symbol2 != "" && value2 != null && value2 != "") {
                test2 = operatorMap.get(symbol2).compare(value, Float.valueOf(value2));
            }
        }
        if (test1 == true && test2 == true) {
            return Float.valueOf(classValue);
        }
        return -1;

    }

    public String getDescription(String nameAttribute) {
        String description = nameAttribute + " " + symbol1 + " " + value1;
        if (symbol2 != null && symbol2 != "" && value2 != null && value2 != "") {
            description += "\n && " + nameAttribute + " " + symbol2 + " " + value2;
        }
        return description;
    }

    public static void main(String[] args) {

        String description = "    1 | S4 >= 0.6 | high\n - 2 | 0.3 < S4 < 0.6 | medium\\n - 3 | S4 <= 0.3 | low\\n";
        System.out.println(description);
    }

}
